; Intel 8086 Device Driver Test Program
; 测试设备驱动和中断处理功能

[BITS 16]
[ORG 0x9000]

start:
    ; 初始化段寄存器
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; 显示测试开始消息
    mov si, test_start_msg
    call print_string

    ; 测试1: 读取设备状态
    mov si, test1_msg
    call print_string
    call device_get_status
    push ax
    mov si, status_msg
    call print_string
    pop ax
    call print_hex
    mov si, newline
    call print_string

    ; 测试2: 写入数据到设备
    mov si, test2_msg
    call print_string
    mov al, 0xAA           ; 测试数据
    push ax
    mov si, write_data_msg
    call print_string
    pop ax
    call print_hex
    mov si, newline
    call print_string
    call device_write

    ; 等待一段时间
    call delay

    ; 测试3: 从设备读取数据
    mov si, test3_msg
    call print_string
    call device_read
    push ax
    mov si, read_data_msg
    call print_string
    pop ax
    call print_hex
    mov si, newline
    call print_string

    ; 测试完成
    mov si, test_done_msg
    call print_string

    ; 无限循环
hang:
    hlt
    jmp hang

; 延时函数
delay:
    push cx
    push dx
    mov cx, 0xFFFF
delay_outer:
    mov dx, 0xFFFF
delay_inner:
    nop
    dec dx
    jnz delay_inner
    loop delay_outer
    pop dx
    pop cx
    ret

; 打印字符串函数
print_string:
    push si
print_string_loop:
    lodsb
    cmp al, 0
    je print_string_done
    mov ah, 0x0E
    int 0x10
    jmp print_string_loop
print_string_done:
    pop si
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
    add al, 7
print_hex_digit:
    mov ah, 0x0E
    int 0x10
    loop print_hex_loop
    pop cx
    pop bx
    ret

; 包含设备驱动函数
%include "device_driver.asm"

; 数据
test_start_msg  db '=== Device Driver Test ===', 0x0D, 0x0A, 0
test1_msg      db 'Test 1: Get device status', 0x0D, 0x0A, 0
test2_msg      db 'Test 2: Write data to device', 0x0D, 0x0A, 0
test3_msg      db 'Test 3: Read data from device', 0x0D, 0x0A, 0
test_done_msg  db '=== All tests completed ===', 0x0D, 0x0A, 0
status_msg     db 'Status: 0x', 0
write_data_msg db 'Writing data: 0x', 0
read_data_msg  db 'Read data: 0x', 0
newline        db 0x0D, 0x0A, 0

; 填充到512字节
times 512-($-$$) db 0
