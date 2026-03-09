# 安装和使用指南

## 环境要求

### 1. 安装 NASM 汇编器

#### Windows 系统
1. 访问 NASM 官网：https://www.nasm.us/
2. 下载最新的 Windows 版本（nasm-x.xx-installer-x64.exe）
3. 运行安装程序，按照提示完成安装
4. 将 NASM 添加到系统 PATH 环境变量（安装程序通常会自动完成）

验证安装：
```cmd
nasm -v
```

应该显示类似：`NASM version 2.16.01`

#### Linux 系统
```bash
# Ubuntu/Debian
sudo apt-get install nasm

# Fedora/RHEL
sudo dnf install nasm

# Arch Linux
sudo pacman -S nasm
```

验证安装：
```bash
nasm -v
```

### 2. 安装 QEMU 模拟器（可选）

#### Windows 系统
1. 访问 QEMU 官网：https://www.qemu.org/download/#windows
2. 下载最新的 Windows 版本
3. 解压到指定目录
4. 将 QEMU 的 bin 目录添加到系统 PATH 环境变量

验证安装：
```cmd
qemu-system-x86_64 --version
```

#### Linux 系统
```bash
# Ubuntu/Debian
sudo apt-get install qemu-system-x86

# Fedora/RHEL
sudo dnf install qemu-system-x86

# Arch Linux
sudo pacman -S qemu-system-x86
```

验证安装：
```bash
qemu-system-x86_64 --version
```

## 编译步骤

### 方法 1：使用批处理脚本（Windows）

#### 编译完整操作系统
```cmd
build.bat
```

这将编译引导程序和内核，并创建 `os.img` 文件。

#### 编译测试程序
```cmd
build_test.bat
```

这将编译引导程序和测试程序，创建 `test.img` 文件。

#### 清理编译文件
```cmd
clean.bat
```

### 方法 2：手动编译

#### 编译引导程序
```cmd
nasm -f bin boot.asm -o boot.bin
```

#### 编译内核
```cmd
nasm -f bin kernel.asm -o kernel.bin
```

#### 编译测试程序
```cmd
nasm -f bin test.asm -o test.bin
```

#### 创建操作系统镜像
```cmd
copy /b boot.bin + kernel.bin os.img
```

#### 创建测试镜像
```cmd
copy /b boot.bin + test.bin test.img
```

### 方法 3：使用 Makefile（Linux/Unix）

```bash
# 编译所有文件
make all

# 编译测试程序
make test

# 清理编译文件
make clean

# 运行操作系统
make run

# 运行测试程序
make run-test
```

## 运行操作系统

### 使用 QEMU 运行

#### 运行完整操作系统
```cmd
qemu-system-x86_64 -fda os.img
```

#### 运行测试程序
```cmd
qemu-system-x86_64 -fda test.img
```

### 使用其他模拟器

#### Bochs
```cmd
bochs -f bochsrc.txt
```

需要先创建 `bochsrc.txt` 配置文件。

#### DOSBox
```cmd
dosbox
```

在 DOSBox 中：
```
mount c c:\ai-workspace\i8086
c:
boot os.img
```

## 硬件设备模拟

由于这是一个模拟的自定义硬件设备，在实际硬件上运行时需要：

1. **修改端口地址**：根据实际硬件设备调整端口地址定义
2. **实现硬件设备**：创建实际的硬件设备或使用 FPGA 模拟
3. **连接中断信号**：将设备的中断信号连接到 CPU 的中断请求线

### 模拟硬件设备的行为

在测试环境中，可以通过以下方式模拟硬件设备：

1. **使用 QEMU 的自定义设备支持**
2. **编写 QEMU 设备模型**
3. **使用虚拟机监控程序（VMM）**

## 故障排除

### 编译错误

#### 错误："nasm: command not found"
**原因**：NASM 未安装或未添加到 PATH

**解决方案**：
- 检查 NASM 是否正确安装
- 确保 NASM 的安装目录在 PATH 环境变量中
- 重新启动命令提示符或终端

#### 错误："error: invalid combination of opcode and operands"
**原因**：汇编语法错误

**解决方案**：
- 检查汇编代码的语法
- 确保使用正确的指令格式
- 参考 NASM 文档

### 运行时错误

#### 错误："Could not open 'os.img'"
**原因**：镜像文件不存在

**解决方案**：
- 确保已成功编译操作系统
- 检查文件路径是否正确
- 重新编译操作系统

#### 错误："No bootable device found"
**原因**：引导程序未正确编译或镜像文件损坏

**解决方案**：
- 重新编译引导程序
- 检查引导签名（0xAA55）是否正确
- 重新创建镜像文件

### 中断处理问题

#### 中断未触发
**原因**：
- 中断向量表未正确设置
- 硬件设备未正确连接
- 中断被禁用

**解决方案**：
- 检查中断向量表设置（kernel.asm:setup_ivt）
- 确保硬件设备正确连接到中断线
- 检查 CLI/STI 指令的使用

## 开发建议

### 调试技巧

1. **使用 QEMU 的调试功能**
   ```cmd
   qemu-system-x86_64 -fda os.img -s -S
   ```
   然后使用 GDB 连接：
   ```cmd
   gdb
   (gdb) target remote localhost:1234
   (gdb) break *0x8000
   (gdb) continue
   ```

2. **添加调试输出**
   - 在关键位置添加字符串输出
   - 使用 BIOS 中断 0x10 进行显示

3. **逐步测试**
   - 先测试引导程序
   - 再测试内核初始化
   - 最后测试设备驱动和中断

### 扩展功能

1. **添加更多中断处理程序**
2. **实现简单的文件系统**
3. **添加命令行界面**
4. **支持多个设备驱动**
5. **实现内存管理**

## 参考资源

- [Intel 8086 手册](https://www.intel.com/content/dam/www/public/us/en/documents/manuals/8086-8088-users-manual.pdf)
- [NASM 文档](https://www.nasm.us/docs.php)
- [QEMU 文档](https://www.qemu.org/documentation/)
- [x86 汇编语言教程](https://cs.lmu.edu/~ray/notes/x86assembly/)

## 许可证

本项目仅供学习和研究使用。
