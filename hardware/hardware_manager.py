"""
hardware/hardware_manager.py

Single entry point for ALL hardware actions across the project. Nothing else
in the codebase should ever import RPi.GPIO, pyserial, or requests directly -
everything goes through this manager, which decides whether to route to
Simulation Mode, Raspberry Pi, or ESP32 based on config.yaml.

Graceful fallback: if hardware_mode is set to raspberry_pi or esp32 but the
required library/device isn't actually available (e.g. running on a laptop
with no RPi.GPIO installed), this automatically falls back to Simulation
Mode instead of crashing with an ImportError.
"""

from __future__ import annotations

import logging
from typing import Optional

import yaml

from hardware.simulator import HardwareSimulator

logging.basicConfig(level=logging.INFO, format="%(asctime)s | %(message)s")
logger = logging.getLogger("HardwareManager")


class HardwareManager:
    """
    The ONLY hardware interface the rest of the project should ever call.
    Usage elsewhere in the codebase:

        hardware = HardwareManager(config_path="config.yaml")
        hardware.trigger_laser()
        hardware.activate_buzzer()
        hardware.send_level1()
        hardware.read_sensor()
        hardware.stop_all_devices()
    """

    def __init__(self, config_path: str = "config.yaml") -> None:
        self.config = self._load_config(config_path)
        self.mode = self.config.get("hardware_mode", "simulation")
        self._backend = self._initialize_backend()
        logger.info("HardwareManager active in '%s' mode.", self.mode)

    def _load_config(self, config_path: str) -> dict:
        try:
            with open(config_path, "r") as f:
                config = yaml.safe_load(f)
            logger.info("Configuration loaded from %s", config_path)
            return config or {}
        except FileNotFoundError:
            logger.warning("Config file not found at %s - defaulting to simulation mode.", config_path)
            return {"hardware_mode": "simulation"}
        except Exception as exc:  # noqa: BLE001
            logger.error("Failed to parse config (%s) - defaulting to simulation mode.", exc)
            return {"hardware_mode": "simulation"}

    def _initialize_backend(self):
        """
        Attempts to initialize the configured hardware backend. Falls back
        to Simulation Mode if the requested backend's dependencies or
        physical device aren't actually available - this is what makes
        "no import errors because Raspberry Pi libraries are unavailable"
        (per the project requirement) actually true.
        """
        if self.mode == "raspberry_pi":
            try:
                from hardware.raspberry_pi import RaspberryPiController
                pi_config = self.config.get("raspberry_pi", {})
                return RaspberryPiController(
                    laser_pin=pi_config.get("laser_pin", 18),
                    buzzer_pin=pi_config.get("buzzer_pin", 23),
                )
            except ImportError as exc:
                logger.warning(
                    "Raspberry Pi mode requested but RPi.GPIO unavailable (%s). "
                    "Falling back to Simulation Mode.", exc,
                )
                self.mode = "simulation"
                return HardwareSimulator()

        elif self.mode == "esp32":
            try:
                from hardware.esp32 import ESP32Controller
                esp32_config = self.config.get("esp32", {})
                wifi_config = self.config.get("esp32_wifi", {})
                return ESP32Controller(
                    serial_port=esp32_config.get("port", "/dev/ttyUSB0"),
                    baudrate=esp32_config.get("baudrate", 115200),
                    wifi_ip=wifi_config.get("ip_address", "192.168.1.50"),
                    wifi_endpoint=wifi_config.get("endpoint", "/trigger"),
                )
            except ImportError as exc:
                logger.warning(
                    "ESP32 mode requested but required library unavailable (%s). "
                    "Falling back to Simulation Mode.", exc,
                )
                self.mode = "simulation"
                return HardwareSimulator()

        # Default: simulation
        return HardwareSimulator()

    # ------------------------------------------------------------------
    # Public API - this is what the rest of the project calls
    # ------------------------------------------------------------------
    def trigger_laser(self, state: bool = True) -> bool:
        return self._backend.simulate_laser(state)

    def activate_buzzer(self, duration_seconds: float = 1.0) -> bool:
        return self._backend.simulate_buzzer(duration_seconds)

    def read_sensor(self, sensor_name: str = "generic") -> float:
        return self._backend.simulate_sensor(sensor_name)

    def send_level1(self) -> bool:
        if hasattr(self._backend, "send_level1"):
            return self._backend.send_level1()
        logger.info("send_level1() called (mode='%s') - treated as a generic alert trigger.", self.mode)
        return self._backend.simulate_buzzer(duration_seconds=0.5)

    def send_level2(self) -> bool:
        if hasattr(self._backend, "send_level2"):
            return self._backend.send_level2()
        logger.info("send_level2() called (mode='%s') - treated as a generic alert trigger.", self.mode)
        return self._backend.simulate_buzzer(duration_seconds=1.5)

    def send_level3(self) -> bool:
        if hasattr(self._backend, "send_level3"):
            return self._backend.send_level3()
        logger.info("send_level3() called (mode='%s') - treated as a generic alert trigger.", self.mode)
        self._backend.simulate_laser(True)
        return self._backend.simulate_buzzer(duration_seconds=3.0)

    def stop_all_devices(self) -> bool:
        return self._backend.stop_all_devices()

    def is_simulation_mode(self) -> bool:
        return self.mode == "simulation"
