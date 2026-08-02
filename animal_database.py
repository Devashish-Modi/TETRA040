"""
animal_database.py

Deterrent Priority Database Manager — used by Model 2 (DecisionEngine) as
a lookup step BEFORE the alert/decision logic runs.

Flow per detection:
    Model 1 output -> DatabaseManager.lookup_species() -> DecisionEngine rules

Backend: PostgreSQL (Supabase) - READ ONLY
    Table (as confirmed from the actual dataset): deterrent_priority
        columns:
            id      - bigint, auto-increment primary key
            animal  - species name, e.g. 'Cow', 'Buffalo', 'Goat', 'Wild Pig'
            weather - weather condition, e.g. 'Clear'
            period  - time of day, 'Day' or 'Night'
            lvl1    - deterrent device to trigger at escalation level 1 (e.g. 'Laser')
            lvl2    - deterrent device to trigger at escalation level 2 (e.g. 'Speaker')
            lvl3    - deterrent device to trigger at escalation level 3 (e.g. 'Water Sprinkler')

    lvl1/lvl2/lvl3 here are DEVICE NAMES, not distance thresholds - the
    actual distance thresholds that decide WHICH level to escalate to
    still come from config.yaml (decision_engine section). This table only
    answers "once we've decided to escalate to level N, which physical
    deterrent should fire for this species/weather/time-of-day?"

    Since Model 1 doesn't currently report weather or day/night, this
    defaults to weather='Clear' and computes period from the system clock
    (06:00-18:00 = Day, else Night). If no exact match exists for that
    weather/period combo, falls back to any row for that animal instead
    of returning nothing.

    Connection string is read from an environment variable, NEVER hardcoded
    here or in config.yaml:
        ANIMAL_DB_URL=postgresql://user:password@host:5432/dbname
    Loaded automatically from a .env file in the working directory via
    python-dotenv, so it only needs to be set once instead of re-typing
    $env:ANIMAL_DB_URL every terminal session.

Caching:
    Every (animal, weather, period) combination already looked up this
    session is cached in memory. A repeat lookup does NOT hit the database
    again. A print notice appears only the FIRST time each combination is
    resolved (either freshly queried or reused from cache) - not on every
    repeat call - since untracked Model 1 sources can call this thousands
    of times per session (once per frame).
"""

from __future__ import annotations

import logging
import os
from datetime import datetime
from typing import Dict, Optional

from dotenv import load_dotenv
import psycopg2
import psycopg2.extras

# Loads variables from a .env file in the current directory (if present)
# into the environment. This means ANIMAL_DB_URL only needs to be set
# ONCE in a .env file, instead of re-typing $env:ANIMAL_DB_URL in every
# new PowerShell/terminal session.
load_dotenv()

logger = logging.getLogger("AnimalDatabase")


def current_period() -> str:
    """Returns 'Day' (06:00-18:00) or 'Night' based on the system clock."""
    hour = datetime.now().hour
    return "Day" if 6 <= hour < 18 else "Night"


class DatabaseManager:
    """
    Read-only access to the deterrent_priority table, with an in-memory
    cache of lookups already performed this session.
    """

    def __init__(self, url_env_var: str = "ANIMAL_DB_URL",
                 connection_string: Optional[str] = None,
                 table_name: str = "deterrent_priority",
                 default_weather: str = "Clear"):
        """
        Parameters
        ----------
        url_env_var : str
            Name of the environment variable holding the Postgres connection
            string. config.yaml points to this NAME only - the value itself
            is never stored in config or in code.
        connection_string : str, optional
            Escape hatch for tests/scripts that want to pass a connection
            string directly instead of via env var.
        table_name : str
            Name of the table holding deterrent priorities. Defaults to
            "deterrent_priority" per the existing dataset.
        default_weather : str
            Weather condition to assume since Model 1 doesn't currently
            report live weather. Defaults to "Clear".
        """
        self.connection_string = connection_string or os.environ.get(url_env_var)
        if not self.connection_string:
            raise RuntimeError(
                f"No database connection string found. Set the {url_env_var} "
                f"environment variable (directly or via a .env file) to your "
                f"Postgres/Supabase connection URL."
            )
        self.table_name = table_name
        self.default_weather = default_weather

        # (animal, weather, period) -> row dict, populated the first time
        # each combination is looked up. Prevents a repeat database hit for
        # a combination already resolved this session.
        self._cache: Dict[tuple, dict] = {}

        # Combinations we've already PRINTED a notice for. Model 1 sources
        # with no tracking can call lookup_species() thousands of times for
        # the same animal (once per frame) - without this, the terminal
        # would flood with thousands of identical lines. Each combination
        # gets exactly one printed notice per run.
        self._notice_printed: set = set()

        # Sanity-check the connection/table on startup rather than waiting
        # for the first live detection to discover a typo'd table name.
        self._verify_connection()

    def _connect(self):
        return psycopg2.connect(self.connection_string)

    def _verify_connection(self) -> None:
        conn = self._connect()
        try:
            with conn.cursor() as cur:
                cur.execute(f"SELECT COUNT(*) FROM {self.table_name}")
                count = cur.fetchone()[0]
            logger.info("Connected to '%s' table - %d rows currently present.",
                         self.table_name, count)
        finally:
            conn.close()

    def lookup_species(self, species_name: str, weather: Optional[str] = None,
                        period: Optional[str] = None) -> Optional[dict]:
        """
        Returns the deterrent_priority row for this animal, matched against
        weather and period (time of day). If weather/period aren't given,
        defaults to self.default_weather and the current system-clock
        period. If no exact match exists for that combination, falls back
        to any row for this animal (best-effort) rather than returning
        nothing.

        If this exact (animal, weather, period) combination was already
        looked up earlier in this session, the cached result is reused. A
        print notice appears only the FIRST time this combination is
        resolved, not on every repeat call.
        """
        weather = weather or self.default_weather
        period = period or current_period()
        animal_key = species_name.strip().lower()
        cache_key = (animal_key, weather.lower(), period.lower())

        if cache_key in self._cache:
            if cache_key not in self._notice_printed:
                print(f"[Database] '{species_name}' ({weather}/{period}) already searched "
                      f"earlier this session - using cached result:")
                self._print_result(species_name, self._cache[cache_key])
                self._notice_printed.add(cache_key)
                logger.info(
                    "Database search already performed for '%s' (%s/%s) earlier - "
                    "using cached result, skipping query.",
                    species_name, weather, period,
                )
            return self._cache[cache_key]

        print(f"[Database] Searching '{self.table_name}' for '{species_name}' "
              f"(weather={weather}, period={period}) ...")
        logger.info("Searching '%s' for '%s' (weather=%s, period=%s) ...",
                     self.table_name, species_name, weather, period)

        conn = self._connect()
        try:
            with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
                # Exact match first: same animal, weather, and time of day.
                cur.execute(
                    f"SELECT animal, weather, period, lvl1, lvl2, lvl3 "
                    f"FROM {self.table_name} "
                    f"WHERE LOWER(animal) = LOWER(%s) AND LOWER(weather) = LOWER(%s) "
                    f"AND LOWER(period) = LOWER(%s) LIMIT 1",
                    (animal_key, weather, period),
                )
                row = cur.fetchone()

                if row is None:
                    # Fallback: any row for this animal, regardless of
                    # weather/period, rather than returning nothing.
                    cur.execute(
                        f"SELECT animal, weather, period, lvl1, lvl2, lvl3 "
                        f"FROM {self.table_name} WHERE LOWER(animal) = LOWER(%s) LIMIT 1",
                        (animal_key,),
                    )
                    row = cur.fetchone()
                    if row is not None:
                        logger.warning(
                            "No exact match for '%s' at weather=%s/period=%s - "
                            "using fallback row (weather=%s/period=%s) instead.",
                            species_name, weather, period, row["weather"], row["period"],
                        )
        finally:
            conn.close()

        if row is None:
            print(f"[Database] No entry found for '{species_name}' in any weather/period.")
            logger.warning("No row found in '%s' for '%s' (any weather/period).",
                            self.table_name, species_name)
            info = None
        else:
            info = dict(row)
            self._print_result(species_name, info)
            logger.info(
                "Found deterrent priority for '%s': lvl1=%s lvl2=%s lvl3=%s (weather=%s, period=%s)",
                species_name, info.get("lvl1"), info.get("lvl2"), info.get("lvl3"),
                info.get("weather"), info.get("period"),
            )

        self._cache[cache_key] = info
        self._notice_printed.add(cache_key)
        return info

    @staticmethod
    def _print_result(species_name: str, info: Optional[dict]) -> None:
        """Prints the deterrent priority row for a species in a clean, readable line."""
        if info is None:
            print(f"[Database] '{species_name}': no record found.")
            return
        print(
            f"[Database] '{species_name}' ({info.get('weather')}/{info.get('period')}) -> "
            f"lvl1={info.get('lvl1')}, lvl2={info.get('lvl2')}, lvl3={info.get('lvl3')}"
        )

    def clear_cache(self) -> None:
        """Forces the next lookup of every combination to hit the database again."""
        self._cache.clear()
        self._notice_printed.clear()
        logger.info("Database lookup cache cleared.")



