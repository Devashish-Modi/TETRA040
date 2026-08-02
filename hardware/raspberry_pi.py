"""
hardware/raspberry_pi.py

Complete Raspberry Pi GPIO implementation for future hardware deployment.
COMMENTED OUT because no Raspberry Pi is connected during development -
uncommenting this requires the RPi.GPIO library, which only installs/works
on actual Raspberry Pi hardware and would raise ImportError anywhere else.

To activate: uncomment the code below AND set hardware_mode: raspberry_pi
in config.yaml. No other code changes needed anywhere else in the project -
HardwareManager already knows how to route to this class once uncommented.
"""

import logging

logging.basicConfig(level=logging.INFO, format="%(asctime)s | %(message)s")
logger = logging.getLogger("RaspberryPi")


class RaspberryPiController:
    """
    Real Raspberry Pi GPIO implementation. Mirrors HardwareSimulator's
    method signatures exactly, so HardwareManager can call either
    interchangeably based on config.
    """

    def __init__(self, laser_pin: int = 18, buzzer_pin: int = 23) -> None:
        self.laser_pin = laser_pin
        self.buzzer_pin = buzzer_pin

        # ============================
        # Raspberry Pi GPIO Setup
        # ============================
        # import RPi.GPIO as GPIO
        # self.GPIO = GPIO
        # GPIO.setmode(GPIO.BCM)
        # GPIO.setup(self.laser_pin, GPIO.OUT)
        # GPIO.setup(self.buzzer_pin, GPIO.OUT)
        # GPIO.output(self.laser_pin, GPIO.LOW)
        # GPIO.output(self.buzzer_pin, GPIO.LOW)

        logger.info(
            "RaspberryPiController initialized (STUB - GPIO code commented out). "
            "Uncomment hardware/raspberry_pi.py to activate on real hardware."
        )

    def simulate_laser(self, state: bool = True) -> bool:
        # GPIO.output(self.laser_pin, GPIO.HIGH if state else GPIO.LOW)
        logger.info("[RASPBERRY PI - STUB] Laser %s (pin %d)", "ON" if state else "OFF", self.laser_pin)
        return True

    def simulate_buzzer(self, duration_seconds: float = 1.0) -> bool:
        # GPIO.output(self.buzzer_pin, GPIO.HIGH)
        # time.sleep(duration_seconds)
        # GPIO.output(self.buzzer_pin, GPIO.LOW)
        logger.info("[RASPBERRY PI - STUB] Buzzer for %.1fs (pin %d)", duration_seconds, self.buzzer_pin)
        return True

    def simulate_gpio_output(self, pin: int, state: bool) -> bool:
        # GPIO.setup(pin, GPIO.OUT)
        # GPIO.output(pin, GPIO.HIGH if state else GPIO.LOW)
        logger.info("[RASPBERRY PI - STUB] GPIO pin %d -> %s", pin, "HIGH" if state else "LOW")
        return True

    def simulate_sensor(self, sensor_name: str = "generic") -> float:
        # Real sensor reading would come from a GPIO input pin or I2C/SPI
        # device read here, e.g.:
        # GPIO.setup(SENSOR_PIN, GPIO.IN)
        # reading = GPIO.input(SENSOR_PIN)
        logger.info("[RASPBERRY PI - STUB] Reading sensor '%s'", sensor_name)
        return 0.0

    def stop_all_devices(self) -> bool:
        # GPIO.output(self.laser_pin, GPIO.LOW)
        # GPIO.output(self.buzzer_pin, GPIO.LOW)
        # GPIO.cleanup()
        logger.info("[RASPBERRY PI - STUB] All devices stopped, GPIO cleaned up")
        return True
