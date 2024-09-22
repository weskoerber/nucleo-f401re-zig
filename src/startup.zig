extern var _szero: u32;
extern var _ezero: u32;
extern var _sdata: u32;
extern var _edata: u32;
extern var _load_data: u32;

export fn reset() callconv(.C) noreturn {
    initMemory();
    _start();

    while (true) {
        asm volatile ("nop");
    }
}

export fn _start() callconv(.C) void {
    main.main();
}

fn initMemory() void {
    @branchHint(.cold);
    {
        const start: [*]u8 = @ptrCast(&_szero);
        const end: [*]u8 = @ptrCast(&_ezero);
        const len = @intFromPtr(end) - @intFromPtr(start);

        if (len > 0) {
            @memset(start[0..len], 0);
        }
    }

    {
        const start: [*]u32 = @ptrCast(&_sdata);
        const end: [*]u32 = @ptrCast(&_edata);

        const len = @intFromPtr(end) - @intFromPtr(start);
        const src: [*]u32 = @ptrCast(&_load_data);

        if (len > 0) {
            @memcpy(start[0..len], src[0..len]);
        }
    }
}

export const intvecs linksection(".vectors") = [_]?*const fn () callconv(.C) void{
    reset,
    reset, // nmi,
    reset, // hard_fault,
    reset, // mem_manage,
    reset, // bus_fault,
    reset, // usage_fault,
    null,
    null,
    null,
    null,
    reset, // sv_call,
    reset, // debug_mon,
    null,
    reset, //pend_sv,
    reset, //systick,
    reset, //wwdg,
    reset, //exti16,
    reset, //exti21,
    reset, //exti22,
    reset, //flash,
    reset, //rcc,
    reset, //exti0,
    reset, //exti1,
    reset, //exti2,
    reset, //exti3,
    reset, //exti4,
    reset, //dma00,
    reset, //dma01,
    reset, //dma02,
    reset, //dma03,
    reset, //dma04,
    reset, //dma05,
    reset, //dma06,
    reset, //adc,
    null,
    null,
    null,
    null,
    reset, // exti9,
    reset, // tim9,
    reset, // tim10,
    reset, // tim11,
    reset, // tim1,
    reset, // tim2,
    reset, // tim3,
    reset, // tim4,
    reset, // i2c1ev,
    reset, // i2c1er,
    reset, // i2c2ev,
    reset, // i2c2er,
    reset, // spi1,
    reset, // spi2,
    reset, // usart1,
    reset, // usart2,
    null,
    reset, // exti15,
    reset, // exti17,
    reset, // exti18,
    null,
    null,
    null,
    null,
    reset, // dma07,
    null,
    reset, // sdio,
    reset, // tim5,
    reset, // spi3,
    null,
    null,
    null,
    null,
    reset, // dma10,
    reset, // dma11,
    reset, // dma12,
    reset, // dma13,
    reset, // dma14,
    null,
    null,
    null,
    null,
    null,
    null,
    reset, // otg,
    reset, // dma15,
    reset, // dma16,
    reset, // dma17,
    reset, // usart6,
    reset, // i2c3ev,
    reset, // i2c3er,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    reset, // fpu,
    null,
    null,
    reset, // spi4,
};

const main = @import("main.zig");
