#!/usr/bin/env python3
"""
Intel 8086 自定义硬件设备模拟器
用于模拟自定义硬件设备的行为，测试操作系统的中断处理功能
"""

import time
import random
import sys

class DeviceSimulator:
    """自定义硬件设备模拟器"""

    # 端口定义
    STATUS_PORT = 0x60
    DATA_PORT = 0x61
    CONTROL_PORT = 0x62

    # 状态寄存器位定义
    STATUS_BUSY = 0x80
    STATUS_READ_READY = 0x01
    STATUS_WRITE_READY = 0x02
    STATUS_ERROR = 0x40

    # 控制命令
    CMD_READ = 0x01
    CMD_WRITE = 0x02
    CMD_RESET = 0xFF

    def __init__(self):
        """初始化设备模拟器"""
        self.status_reg = 0x00
        self.data_reg = 0x00
        self.control_reg = 0x00
        self.is_busy = False
        self.data_buffer = []
        self.interrupt_enabled = True

        print("[Device Simulator] Initialized")
        print(f"[Device Simulator] Status Port: 0x{self.STATUS_PORT:02X}")
        print(f"[Device Simulator] Data Port: 0x{self.DATA_PORT:02X}")
        print(f"[Device Simulator] Control Port: 0x{self.CONTROL_PORT:02X}")

    def reset(self):
        """复位设备"""
        print("[Device Simulator] Resetting device...")
        self.status_reg = self.STATUS_BUSY
        self.data_reg = 0x00
        self.control_reg = 0x00
        self.is_busy = True
        self.data_buffer = []

        # 模拟设备初始化时间
        time.sleep(0.1)

        self.is_busy = False
        self.status_reg = 0x00
        print("[Device Simulator] Device ready")

    def write_control(self, data):
        """写入控制命令"""
        self.control_reg = data
        print(f"[Device Simulator] Control command: 0x{data:02X}")

        if data == self.CMD_RESET:
            self.reset()
        elif data == self.CMD_READ:
            self.handle_read_command()
        elif data == self.CMD_WRITE:
            self.handle_write_command()
        else:
            print(f"[Device Simulator] Unknown command: 0x{data:02X}")

    def write_data(self, data):
        """写入数据"""
        self.data_reg = data
        print(f"[Device Simulator] Data written: 0x{data:02X}")

    def read_status(self):
        """读取状态寄存器"""
        return self.status_reg

    def read_data(self):
        """读取数据"""
        data = self.data_reg
        print(f"[Device Simulator] Data read: 0x{data:02X}")
        return data

    def handle_read_command(self):
        """处理读命令"""
        print("[Device Simulator] Processing read command...")
        self.is_busy = True
        self.status_reg = self.STATUS_BUSY

        # 模拟设备读取延迟
        time.sleep(0.05)

        # 生成随机数据
        data = random.randint(0x00, 0xFF)
        self.data_reg = data
        self.data_buffer.append(data)

        self.is_busy = False
        self.status_reg = self.STATUS_READ_READY

        print(f"[Device Simulator] Read complete, data: 0x{data:02X}")
        self.trigger_interrupt()

    def handle_write_command(self):
        """处理写命令"""
        print("[Device Simulator] Processing write command...")
        self.is_busy = True
        self.status_reg = self.STATUS_BUSY

        # 模拟设备写入延迟
        time.sleep(0.05)

        self.is_busy = False
        self.status_reg = self.STATUS_WRITE_READY

        print(f"[Device Simulator] Write complete, data: 0x{self.data_reg:02X}")
        self.trigger_interrupt()

    def trigger_interrupt(self):
        """触发中断"""
        if self.interrupt_enabled:
            print("[Device Simulator] Triggering interrupt 0x60")
            # 在实际硬件中，这将向 CPU 发送中断信号
            # 在模拟器中，我们只是打印消息
        else:
            print("[Device Simulator] Interrupt disabled, not triggering")

    def simulate_io(self, port, operation, data=None):
        """模拟 I/O 操作"""
        if port == self.CONTROL_PORT and operation == 'out':
            self.write_control(data)
        elif port == self.DATA_PORT and operation == 'out':
            self.write_data(data)
        elif port == self.STATUS_PORT and operation == 'in':
            return self.read_status()
        elif port == self.DATA_PORT and operation == 'in':
            return self.read_data()
        else:
            print(f"[Device Simulator] Unknown I/O operation: port=0x{port:02X}, op={operation}")

    def run_test_sequence(self):
        """运行测试序列"""
        print("\n" + "="*50)
        print("Running test sequence...")
        print("="*50 + "\n")

        # 测试 1: 复位设备
        print("Test 1: Reset device")
        self.simulate_io(self.CONTROL_PORT, 'out', self.CMD_RESET)
        time.sleep(0.5)

        # 测试 2: 读取状态
        print("\nTest 2: Read status")
        status = self.simulate_io(self.STATUS_PORT, 'in')
        print(f"Status: 0x{status:02X}")
        time.sleep(0.5)

        # 测试 3: 写入数据
        print("\nTest 3: Write data 0xAA")
        self.simulate_io(self.DATA_PORT, 'out', 0xAA)
        self.simulate_io(self.CONTROL_PORT, 'out', self.CMD_WRITE)
        time.sleep(0.5)

        # 测试 4: 读取数据
        print("\nTest 4: Read data")
        self.simulate_io(self.CONTROL_PORT, 'out', self.CMD_READ)
        time.sleep(0.5)

        # 测试 5: 多次读取
        print("\nTest 5: Multiple reads")
        for i in range(3):
            print(f"  Read {i+1}:")
            self.simulate_io(self.CONTROL_PORT, 'out', self.CMD_READ)
            time.sleep(0.3)

        print("\n" + "="*50)
        print("Test sequence completed!")
        print("="*50 + "\n")


def main():
    """主函数"""
    print("Intel 8086 自定义硬件设备模拟器")
    print("="*60)

    # 创建设备模拟器
    device = DeviceSimulator()

    # 运行测试序列
    device.run_test_sequence()

    print("\nSimulation completed successfully!")


if __name__ == "__main__":
    main()
