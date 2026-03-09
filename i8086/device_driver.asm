; Intel 8086 Custom Device Driver
; 自定义硬件设备驱动程序

[BITS 16]

; 设备端口定义
DEVICE_STATUS_PORT  equ 0x60   ; 设备状态寄存器端口
DEVICE_DATA_PORT    equ 0x61   ; 设备数据端口
DEVICE_CONTROL_PORT equ 0x62   ; 设备控制寄存器端口

; 状态寄存器位定义
STATUS_BUSY         equ 0x80   ; 设备忙标志
STATUS_READ_READY   equ 0x01   ; 读数据就绪
STATUS_WRITE_READY  equ 0x02   ; 写数据就绪
STATUS_ERROR        equ 0x40   ; 错误标志

; 控制寄存器命令定义
CMD_READ            equ 0x01   ; 读命令
CMD_WRITE           equ 0x02   ; 写命令
CMD_RESET           equ 0xFF   ; 复位命令

; 全局变量
device_initialized  db 0
operation_pending   db 0

; 设备初始化
device_init:
    ; 显示设备初始化消息
    push si
    mov si, init_msg
    call print_string
    pop si

    ; 复位设备
    mov al, CMD_RESET
    out DEVICE_CONTROL_PORT, al

    ; 等待设备就绪
    call wait_device_ready

    ; 标记设备已初始化
    mov byte [device_initialized], 1

    ; 显示初始化完成消息
    push si
    mov si, init_done_msg
    call print_string
    pop si

    ret

; 读设备数据
; 输入: 无
; 输出: AL = 读取的数据
device_read:
    push si

    ; 检查设备是否初始化
    cmp byte [device_initialized], 1
    jne device_not_init

    ; 显示读操作消息
    mov si, read_msg
    call print_string

    ; 发送读命令
    mov al, CMD_READ
    out DEVICE_CONTROL_PORT, al

    ; 标记操作挂起
    mov byte [operation_pending], 1

    ; 等待设备完成操作（或中断）
    call wait_operation_complete

    ; 读取数据
    in al, DEVICE_DATA_PORT

    ; 清除操作挂起标志
    mov byte [operation_pending], 0

    pop si
    ret

device_not_init:
    mov si, not_init_msg
    call print_string
    mov al, 0
    pop si
    ret

; 写设备数据
; 输入: AL = 要写入的数据
device_write:
    push si
    push ax

    ; 检查设备是否初始化
    cmp byte [device_initialized], 1
    jne device_not_init_write

    ; 显示写操作消息
    mov si, write_msg
    call print_string

    ; 写入数据到数据端口
    pop ax
    push ax
    out DEVICE_DATA_PORT, al

    ; 发送写命令
    mov al, CMD_WRITE
    out DEVICE_CONTROL_PORT, al

    ; 标记操作挂起
    mov byte [operation_pending], 1

    ; 等待设备完成操作（或中断）
    call wait_operation_complete

    ; 清除操作挂起标志
    mov byte [operation_pending], 0

    pop ax
    pop si
    ret

device_not_init_write:
    pop ax
    mov si, not_init_msg
    call print_string
    pop si
    ret

; 等待设备就绪
wait_device_ready:
    push cx
    mov cx, 0xFFFF          ; 超时计数
wait_ready_loop:
    in al, DEVICE_STATUS_PORT
    test al, STATUS_BUSY
    jz wait_ready_done      ; 如果不忙则继续
    loop wait_ready_loop
    ; 超时处理
wait_ready_done:
    pop cx
    ret

; 等待操作完成
wait_operation_complete:
    push cx
    mov cx, 0xFFFF          ; 超时计数
wait_op_loop:
    in al, DEVICE_STATUS_PORT
    test al, STATUS_READ_READY
    jnz wait_op_done
    test al, STATUS_WRITE_READY
    jnz wait_op_done
    test al, STATUS_ERROR
    jnz wait_op_error
    loop wait_op_loop
    ; 超时处理
wait_op_done:
    pop cx
    ret

wait_op_error:
    ; 错误处理
    push si
    mov si, error_msg
    call print_string
    pop si
    pop cx
    ret

; 获取设备状态
; 输出: AL = 设备状态
device_get_status:
    in al, DEVICE_STATUS_PORT
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

; 数据
init_msg        db 'Initializing custom device...', 0x0D, 0x0A, 0
init_done_msg   db 'Device initialized successfully', 0x0D, 0x0A, 0
read_msg        db 'Reading from device...', 0x0D, 0x0A, 0
write_msg       db 'Writing to device...', 0x0D, 0x0A, 0
not_init_msg    db 'Error: Device not initialized', 0x0D, 0x0A, 0
error_msg       db 'Error: Device operation failed', 0x0D, 0x0A, 0
