; Intel 8086 Interrupt Handlers
; 中断处理程序

[BITS 16]

; 0x60中断处理程序（96号中断）
; 用于处理自定义硬件设备的中断信号
int60_handler:
    ; 保存寄存器
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push ds
    push es

    ; 读取设备状态寄存器（假设端口地址为0x60）
    in al, 0x60

    ; 检查中断类型
    test al, 0x01           ; 检查读完成位
    jnz int60_read_complete

    test al, 0x02           ; 检查写完成位
    jnz int60_write_complete

    ; 未知中断类型
    jmp int60_done

int60_read_complete:
    ; 读操作完成处理
    call handle_read_complete
    jmp int60_done

int60_write_complete:
    ; 写操作完成处理
    call handle_write_complete
    jmp int60_done

int60_done:
    ; 发送EOI（End of Interrupt）信号
    mov al, 0x20
    out 0x20, al            ; 主8259A

    ; 恢复寄存器
    pop es
    pop ds
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax

    iret                    ; 中断返回

; 处理读操作完成
handle_read_complete:
    ; 读取数据（假设数据端口为0x61）
    in al, 0x61
    mov [read_buffer], al

    ; 显示读完成消息
    mov si, read_complete_msg
    call print_string

    ; 显示读取的数据
    mov al, [read_buffer]
    call print_hex
    mov si, newline
    call print_string

    ret

; 处理写操作完成
handle_write_complete:
    ; 显示写完成消息
    mov si, write_complete_msg
    call print_string

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

; 数据
read_complete_msg  db 'Read operation complete, data: 0x', 0
write_complete_msg db 'Write operation complete', 0x0D, 0x0A, 0
newline           db 0x0D, 0x0A, 0
read_buffer       db 0
