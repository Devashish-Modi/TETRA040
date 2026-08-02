"""
hardware/simulator.py

Simulation Mode implementation of every hardware action the project will
eventually perform on real Raspberry Pi/ESP32 hardware. This is what runs
by default during development - no physical device required, no import
errors, nothing to configure.

Every function here mirrors a real hardware action 1:1, so HardwareManager
can call the same method name regardless of which mode is active.
"""

from __future__ import annotations

import logging
import time

logging.basicConfig(level=logging.INFO, format="%(asctime)s | %(message)s")
logger = logging.getLogger("Simulator")


class HardwareSimulator:
    """
    Drop-in stand-in for real hardware. Every method logs what WOULD have
    happened on real hardware, and returns a success flag - this lets
    calling code (HardwareManager, Model 2) treat simulation and real
    hardware identically.
    """

    def __init__(self) -> None:
        self._devices_active = False
        logger.info("HardwareSimulator initialized - no physical hardware required.")

    def simulate_laser(self, state: bool = True) -> bool:
        logger.info("[SIMULATION] Laser %s", "ON" if state else "OFF")
        self._devices_active = state
        return True

    def simulate_buzzer(self, duration_seconds: float = 1.0) -> bool:
        logger.info("[SIMULATION] Buzzer sounding for %.1fs", duration_seconds)
        return True

    def simulate_gpio_output(self, pin: int, state: bool) -> bool:
        logger.info("[SIMULATION] GPIO pin %d set to %s", pin, "HIGH" if state else "LOW")
        return True

    def simulate_sensor(self, sensor_name: str = "generic") -> float:
        """
        Returns a plausible fake sensor reading. In simulation, this is a
        fixed safe value rather than random noise, so decision logic behaves
        predictably during development/testing.
        """
        fake_reading = 15.0  # e.g. meters, for a distance sensor
        logger.info("[SIMULATION] Sensor '%s' reading: %.1f", sensor_name, fake_reading)
        return fake_reading

    def simulate_serial_response(self, command: str) -> str:
        logger.info("[SIMULATION] Serial command sent: %s", command)
        return "OK"

    def simulate_wifi_response(self, endpoint: str, payload: dict) -> dict:
        logger.info("[SIMULATION] Wi-Fi POST to %s with payload %s", endpoint, payload)
        return {"status": "ok", "simulated": True}

    def simulate_camera_trigger(self) -> bool:
        logger.info("[SIMULATION] Camera trigger fired")
        return True

    def stop_all_devices(self) -> bool:
        logger.info("[SIMULATION] All devices stopped (laser off, buzzer off)")
        self._devices_active = False
        return True
