# Intel 8086 操作系统

这是一个基于 Intel 8086 CPU 的简单操作系统，包含自定义硬件设备驱动和中断处理功能。

## 项目结构

```
i8086/
├── boot.asm           # 引导加载程序
├── kernel.asm         # 操作系统内核
├── interrupts.asm     # 中断处理程序
├── device_driver.asm  # 自定义硬件设备驱动
├── test.asm           # 设备驱动测试程序
├── Makefile          # 编译配置
└── README.md         # 项目文档
```

## 功能特性

### 1. 引导加载程序 (boot.asm)
- 从软盘启动
- 加载内核到内存地址 0x8000
- 显示启动信息

### 2. 操作系统内核 (kernel.asm)
- 初始化段寄存器和栈
- 设置中断向量表（IVT）
- 初始化设备驱动
- 主事件循环

### 3. 中断处理 (interrupts.asm)
- 实现 0x60 中断处理程序（96号中断）
- 处理自定义硬件设备的中断信号
- 支持读操作完成和写操作完成中断
- 读取设备状态并显示结果

### 4. 设备驱动 (device_driver.asm)
- 设备初始化和复位
- 设备读操作
- 设备写操作
- 设备状态查询
- 错误处理

### 5. 硬件设备接口

#### 端口定义
- `0x60` - 设备状态寄存器
- `0x61` - 设备数据端口
- `0x62` - 设备控制寄存器

#### 状态寄存器位定义
- `bit 0` - 读数据就绪
- `bit 1` - 写数据就绪
- `bit 6` - 错误标志
- `bit 7` - 设备忙标志

#### 控制命令
- `0x01` - 读命令
- `0x02` - 写命令
- `0xFF` - 复位命令

## 编译和运行

### 前置要求
- NASM 汇编器
- QEMU 模拟器（可选，用于测试）

### 编译步骤

1. **编译引导程序和内核**：
   ```bash
   nasm -f bin boot.asm -o boot.bin
   nasm -f bin kernel.asm -o kernel.bin
   ```

2. **创建操作系统镜像**：
   ```bash
   copy /b boot.bin + kernel.bin os.img
   ```

3. **使用 Makefile（推荐）**：
   ```bash
   make all        # 编译所有文件
   make clean      # 清理编译文件
   make run        # 运行操作系统（需要QEMU）
   ```

### 运行测试程序

1. **编译测试程序**：
   ```bash
   nasm -f bin test.asm -o test.bin
   ```

2. **创建测试镜像**：
   ```bash
   copy /b boot.bin + test.bin test.img
   ```

3. **运行测试**：
   ```bash
   make test       # 编译测试程序
   make run-test   # 运行测试程序
   ```

## 中断处理机制

### 0x60 中断处理流程

1. **中断触发**：自定义硬件设备在读写操作完成后触发 0x60 中断
2. **中断响应**：CPU 保存上下文并跳转到中断处理程序
3. **状态检查**：读取设备状态寄存器，确定中断类型
4. **数据处理**：根据中断类型执行相应的处理逻辑
   - 读完成：读取数据并显示
   - 写完成：显示完成消息
5. **发送 EOI**：向 8259A 可编程中断控制器发送结束中断信号
6. **中断返回**：恢复上下文并返回被中断的程序

### 中断向量表设置

中断向量表位于内存地址 0x0000，每个中断向量占用 4 字节（2 字节偏移地址 + 2 字节段地址）。

0x60 中断的向量地址：`0x0000:0x0180`（0x60 * 4 = 0x180）

## 设备驱动 API

### device_init
初始化设备驱动程序

```assembly
call device_init
```

### device_read
从设备读取数据

```assembly
call device_read
; AL = 读取的数据
```

### device_write
向设备写入数据

```assembly
mov al, <data>
call device_write
```

### device_get_status
获取设备状态

```assembly
call device_get_status
; AL = 设备状态
```

## 自定义硬件设备设计

### 设备行为规范

1. **初始化**：设备上电后处于忙状态，需要发送复位命令
2. **读操作**：
   - CPU 发送读命令到控制端口
   - 设备准备数据
   - 数据就绪后触发 0x60 中断
   - CPU 从数据端口读取数据

3. **写操作**：
   - CPU 将数据写入数据端口
   - CPU 发送写命令到控制端口
   - 设备处理数据
   - 处理完成后触发 0x60 中断

### 中断信号生成

设备应在以下情况触发 0x60 中断：
- 读操作完成：状态寄存器 bit 0 置位
- 写操作完成：状态寄存器 bit 1 置位
- 操作错误：状态寄存器 bit 6 置位

## 示例输出

```
i8086 OS Booting...
i8086 OS v1.0
Custom Device Driver Loaded
Initializing custom device...
Device initialized successfully
Waiting for interrupts...
Read operation complete, data: 0xAA
Write operation complete
```

## 扩展建议

1. **添加更多中断处理程序**：支持其他硬件设备的中断
2. **实现文件系统**：添加简单的文件系统支持
3. **增强设备驱动**：支持更多设备操作和错误处理
4. **添加用户程序**：实现简单的命令行界面
5. **内存管理**：实现基本的内存分配和管理

## 注意事项

1. 确保使用正确的汇编器（NASM）和编译选项
2. 在实际硬件上运行时，需要根据实际硬件调整端口地址
3. 中断处理程序需要快速执行，避免长时间阻塞
4. 在多中断环境下，需要正确处理中断优先级和嵌套

## 许可证

本项目仅供学习和研究使用。
