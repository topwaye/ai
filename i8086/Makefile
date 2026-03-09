# Intel 8086 OS Makefile
# 用于编译和链接操作系统组件

AS = nasm
ASFLAGS = -f bin

# 源文件
BOOT = boot.asm
KERNEL = kernel.asm
TEST = test.asm

# 输出文件
BOOT_BIN = boot.bin
KERNEL_BIN = kernel.bin
TEST_BIN = test.bin
OS_IMAGE = os.img

# 默认目标
all: $(OS_IMAGE)

# 编译引导程序
$(BOOT_BIN): $(BOOT)
	$(AS) $(ASFLAGS) $< -o $@

# 编译内核
$(KERNEL_BIN): $(KERNEL)
	$(AS) $(ASFLAGS) $< -o $@

# 编译测试程序
$(TEST_BIN): $(TEST)
	$(AS) $(ASFLAGS) $< -o $@

# 创建操作系统镜像
$(OS_IMAGE): $(BOOT_BIN) $(KERNEL_BIN)
	copy /b $(BOOT_BIN) + $(KERNEL_BIN) $(OS_IMAGE)

# 创建测试镜像
test: $(BOOT_BIN) $(TEST_BIN)
	copy /b $(BOOT_BIN) + $(TEST_BIN) test.img

# 清理编译文件
clean:
	del /Q *.bin *.img

# 运行操作系统（需要QEMU）
run: $(OS_IMAGE)
	qemu-system-x86_64 -fda $(OS_IMAGE)

# 运行测试
run-test: test
	qemu-system-x86_64 -fda test.img

.PHONY: all clean run run-test test
