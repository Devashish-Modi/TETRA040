"""Hardware abstraction layer package. Always import HardwareManager - never
the individual backend classes (simulator, raspberry_pi, esp32) directly."""

from hardware.hardware_manager import HardwareManager

__all__ = ["HardwareManager"]
