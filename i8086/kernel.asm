; Intel 8086 OS Kernel
; 操作系统内核主程序

[BITS 16]
[ORG 0x8000]

start:
    ; 初始化段寄存器
    cli                     ; 禁用中断
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00          ; 设置栈指针

    ; 初始化中断向量表
    call setup_ivt

    ; 初始化设备驱动
    call init_device_driver

    ; 启用中断
    sti

    ; 显示欢迎消息
    mov si, welcome_msg
    call print_string

    ; 主循环
main_loop:
    hlt                     ; 等待中断
    jmp main_loop

; 设置中断向量表（IVT）
setup_ivt:
    ; 设置0x60中断向量（96号中断）
    cli                     ; 确保中断被禁用

    ; 设置中断处理程序地址
    mov ax, 0
    mov es, ax
    mov word [es:0x60*4], int60_handler     ; 偏移地址
    mov word [es:0x60*4+2], 0x0000          ; 段地址

    sti
    ret

; 打印字符串函数
print_string:
    lodsb
    cmp al, 0
    je print_done
    mov ah, 0x0E            ; BIOS视频服务
    int 0x10
    jmp print_string
print_done:
    ret

; 打印十六进制数
print_hex:
    push bx
    push cx
    mov bx, ax
    mov cx, 4
print_hex_loop:
    rol bx, 4
    mov al, bl
    and al, 0x0F
    add al, '0'
    cmp al, '9'
    jle print_hex_digit
    add al, 7               ; 转换为A-F
print_hex_digit:
    mov ah, 0x0E
    int 0x10
    loop print_hex_loop
    pop cx
    pop bx
    ret

; 初始化设备驱动
init_device_driver:
    ; 设备初始化代码由device_driver.asm提供
    extern device_init
    call device_init
    ret

; 数据
welcome_msg  db 'i8086 OS v1.0', 0x0D, 0x0A
            db 'Custom Device Driver Loaded', 0x0D, 0x0A
            db 'Waiting for interrupts...', 0x0D, 0x0A, 0

; 包含中断处理程序
%include "interrupts.asm"

; 包含设备驱动
%include "device_driver.asm"

; 内核结束标记
times 8192-($-$$) db 0
