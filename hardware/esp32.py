"""
hardware/esp32.py

Complete ESP32 implementation for future hardware deployment, covering both
Serial (USB) and Wi-Fi (HTTP) communication paths. COMMENTED OUT because no
ESP32 is connected during development - uncommenting requires the `pyserial`
and/or `requests` libraries and an actual ESP32 reachable at the configured
port/IP.

To activate: uncomment the relevant section AND set hardware_mode: esp32
in config.yaml (choosing serial or wifi as your communication path).
"""

import logging

logging.basicConfig(level=logging.INFO, format="%(asctime)s | %(message)s")
logger = logging.getLogger("ESP32")


class ESP32Controller:
    """
    Real ESP32 implementation. Mirrors HardwareSimulator's method signatures
    exactly, so HardwareManager can call either interchangeably based on config.
    """

    def __init__(
        self,
        serial_port: str = "/dev/ttyUSB0",
        baudrate: int = 115200,
        wifi_ip: str = "192.168.1.50",
        wifi_endpoint: str = "/trigger",
    ) -> None:
        self.serial_port = serial_port
        self.baudrate = baudrate
        self.wifi_ip = wifi_ip
        self.wifi_endpoint = wifi_endpoint
        self._serial_connection = None

        # ============================
        # ESP32 Serial Communication
        # ============================
        # import serial
        # self._serial_connection = serial.Serial(
        #     port=self.serial_port,
        #     baudrate=self.baudrate,
        #     timeout=1,
        # )

        logger.info(
            "ESP32Controller initialized (STUB - serial/wifi code commented out). "
            "Uncomment hardware/esp32.py to activate on real hardware."
        )

    def simulate_laser(self, state: bool = True) -> bool:
        command = b"LASER_ON" if state else b"LASER_OFF"
        # self._serial_connection.write(command)
        logger.info("[ESP32 - STUB] Serial command: %s", command)
        return True

    def simulate_buzzer(self, duration_seconds: float = 1.0) -> bool:
        # self._serial_connection.write(f"BUZZER_{duration_seconds}".encode())
        logger.info("[ESP32 - STUB] Buzzer command sent (%.1fs)", duration_seconds)
        return True

    def send_level1(self) -> bool:
        return self._send_wifi_trigger(level=1)

    def send_level2(self) -> bool:
        return self._send_wifi_trigger(level=2)

    def send_level3(self) -> bool:
        return self._send_wifi_trigger(level=3)

    def _send_wifi_trigger(self, level: int) -> bool:
        # ============================
        # ESP32 Wi-Fi Communication
        # ============================
        # import requests
        # response = requests.post(
        #     f"http://{self.wifi_ip}{self.wifi_endpoint}",
        #     json={"level": level},
        #     timeout=3,
        # )
        # return response.status_code == 200
        logger.info("[ESP32 - STUB] Wi-Fi trigger LEVEL_%d to %s%s", level, self.wifi_ip, self.wifi_endpoint)
        return True

    def simulate_sensor(self, sensor_name: str = "generic") -> float:
        # self._serial_connection.write(b"READ_SENSOR")
        # response = self._serial_connection.readline().decode().strip()
        # return float(response)
        logger.info("[ESP32 - STUB] Requesting sensor '%s' reading over serial", sensor_name)
        return 0.0

    def stop_all_devices(self) -> bool:
        # self._serial_connection.write(b"STOP_ALL")
        logger.info("[ESP32 - STUB] STOP_ALL command sent")
        return True
