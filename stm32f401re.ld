ENTRY(reset)

FLASH_SIZE = 0x80000; /* 512k flash */
SRAM_SIZE = 0x17000; /* 92k sram */

STACK_SIZE = 0x800; /* 2k stack */

MEMORY
{
    flash (rx) : ORIGIN = 0x00000000, LENGTH = FLASH_SIZE
    sram (rwx) : ORIGIN = 0x20000000, LENGTH = SRAM_SIZE
}

SECTIONS
{
    .text :
    {
        . = ALIGN(4);
        LONG(_sp)
        KEEP(*(.vectors))
        *(.text)
        *(.text.*)
        *(.rodata)
        *(.rodata.*)
        . = ALIGN(4);
        _etext = .;
    } > flash

    .ARM.extab :
    {
        *(.ARM.extab* .gnu.linkonce.armextab.*)
    } > flash

    .ARM.exidx :
    {
        PROVIDE (__exidx_start = .);
        *(.ARM.exidx* .gnu.linkonce.armexidx.*)
        PROVIDE (__exidx_end = .);
    } > flash

    .stack (NOLOAD) :
    {
        . = ALIGN(8);
        _sstack = .;
        . = . + STACK_SIZE;
        . = ALIGN(8);
        _estack = .;
    } > sram

    _sp = _estack;

    .data :
    {
        . = ALIGN(4);
        _sdata = .;
        *(.data)
        *(.data.*)
        . = ALIGN(4);
        _edata = .;
    } > sram AT> flash

    .bss (NOLOAD) :
    {
        . = ALIGN(4);
        _szero = .;
        *(.bss)
        *(.bss.*)
        . = ALIGN(4);
        _ezero = .;
    } > sram

    _load_data = LOADADDR(.data);
}
