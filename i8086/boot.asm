; Intel 8086 Bootloader
; 加载内核并跳转到内核入口点

[BITS 16]
[ORG 0x7C00]

start:
    ; 初始化段寄存器
    cli                     ; 禁用中断
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00          ; 设置栈指针

    ; 保存驱动器号
    mov [drive_number], dl

    ; 显示启动消息
    mov si, boot_msg
    call print_string

    ; 加载内核
    call load_kernel

    ; 跳转到内核
    jmp 0x0000:0x8000

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

; 加载内核
load_kernel:
    mov ax, 0x8000          ; 加载到0x8000段
    mov es, ax
    xor bx, bx              ; 偏移0

    mov ah, 0x02            ; 读取扇区
    mov al, 0x10            ; 读取16个扇区（8KB）
    mov ch, 0               ; 柱面0
    mov cl, 2               ; 从第2个扇区开始
    mov dh, 0               ; 磁头0
    mov dl, [drive_number]  ; 驱动器号
    int 0x13

    jc load_error           ; 如果出错则跳转

    ret

load_error:
    mov si, error_msg
    call print_string
    jmp $

; 数据
boot_msg      db 'i8086 OS Booting...', 0x0D, 0x0A, 0
error_msg     db 'Error loading kernel!', 0x0D, 0x0A, 0
drive_number  db 0

; 填充到512字节
times 510-($-$$) db 0
dw 0xAA55                  ; 启动签名
