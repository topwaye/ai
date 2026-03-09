# 快速入门指南

## 5 分钟快速开始

### 第 1 步：安装 NASM

下载并安装 NASM 汇编器：
- Windows: https://www.nasm.us/
- Linux: `sudo apt-get install nasm`

验证安装：
```cmd
nasm -v
```

### 第 2 步：编译操作系统

**Windows 用户：**
```cmd
build.bat
```

**Linux 用户：**
```bash
make all
```

### 第 3 步：运行操作系统

**使用 QEMU：**
```cmd
qemu-system-x86_64 -fda os.img
```

如果没有 QEMU，可以查看 `INSTALL.md` 了解安装方法。

## 项目结构

```
i8086/
├── boot.asm              # 引导程序（512字节）
├── kernel.asm            # 操作系统内核
├── interrupts.asm        # 中断处理程序
├── device_driver.asm     # 设备驱动
├── test.asm              # 测试程序
├── device_simulator.py   # 设备模拟器
└── *.md                  # 文档文件
```

## 核心功能

### 1. 引导加载程序
- 从软盘启动
- 加载内核到 0x8000

### 2. 操作系统内核
- 设置中断向量表
- 初始化设备驱动
- 主事件循环

### 3. 中断处理
- 0x60 中断（自定义硬件设备）
- 处理读写操作完成
- 发送 EOI 信号

### 4. 设备驱动
- 设备初始化
- 读操作
- 写操作
- 状态查询

## 设备端口

| 端口 | 功能 | 方向 |
|------|------|------|
| 0x60 | 状态寄存器 | 输入 |
| 0x61 | 数据端口 | 双向 |
| 0x62 | 控制寄存器 | 输出 |

## 常用命令

### 编译命令
```cmd
# Windows
build.bat          # 编译操作系统
build_test.bat     # 编译测试程序
clean.bat          # 清理文件

# Linux
make all           # 编译所有
make test          # 编译测试
make clean         # 清理文件
```

### 运行命令
```cmd
# 运行操作系统
qemu-system-x86_64 -fda os.img

# 运行测试程序
qemu-system-x86_64 -fda test.img

# 运行设备模拟器
python3 device_simulator.py
```

## 测试设备驱动

运行测试程序会执行以下操作：
1. 读取设备状态
2. 写入数据 0xAA 到设备
3. 从设备读取数据
4. 显示结果

## 中断处理流程

```
设备操作完成
    ↓
触发 0x60 中断
    ↓
CPU 保存上下文
    ↓
执行中断处理程序
    ↓
处理读/写完成
    ↓
发送 EOI
    ↓
恢复上下文
    ↓
返回主程序
```

## 故障排除

### 问题：NASM 未找到
**解决**：确保 NASM 已安装并添加到 PATH

### 问题：无法运行 QEMU
**解决**：安装 QEMU 模拟器或使用其他模拟器

### 问题：编译错误
**解决**：检查 NASM 版本和语法

## 下一步

1. 阅读 `README.md` 了解详细功能
2. 查看 `PROJECT_SUMMARY.md` 了解技术细节
3. 参考 `INSTALL.md` 了解完整安装过程
4. 修改代码并重新编译测试

## 示例代码

### 读取设备数据
```assembly
call device_read
; AL = 读取的数据
```

### 写入设备数据
```assembly
mov al, 0xAA
call device_write
```

### 获取设备状态
```assembly
call device_get_status
; AL = 设备状态
```

## 技术支持

如有问题，请查看：
- `README.md` - 项目文档
- `INSTALL.md` - 安装指南
- `PROJECT_SUMMARY.md` - 技术总结

## 许可证

本项目仅供学习和研究使用。
