pub fn main() void {
    Rcc.ahb1en.periph.gpioa = true;
    Gpio.A.mode.pins.pin5 = .output;

    while (true) {
        const delay = if (builtin.mode == .Debug) 500000 else 1500000;
        for (0..delay) |_| {
            asm volatile ("nop");
        }

        Gpio.A.odr.pins.pin5 = !Gpio.A.odr.pins.pin5;
    }
}

const builtin = @import("builtin");
const Peripherals = @import("Peripherals.zig");
const Gpio = Peripherals.Gpio;
const Rcc = Peripherals.Rcc;
