-- 学生管理系统数据库脚本
-- MySQL 8.0

-- 创建数据库
CREATE DATABASE IF NOT EXISTS student_management
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE student_management;

-- 注意：Spring Boot JPA 会根据实体类自动创建表结构
-- 如果需要手动创建表，可以使用以下 SQL：

-- 创建学生表
CREATE TABLE IF NOT EXISTS students (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
    name VARCHAR(50) NOT NULL COMMENT '学生姓名',
    student_id VARCHAR(20) NOT NULL UNIQUE COMMENT '学号',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '电话',
    gender VARCHAR(10) NOT NULL COMMENT '性别',
    age INT NOT NULL COMMENT '年龄',
    major VARCHAR(100) COMMENT '专业',
    address VARCHAR(200) COMMENT '地址',
    enrollment_date DATE COMMENT '入学日期',
    created_at DATE COMMENT '创建时间',
    updated_at DATE COMMENT '更新时间',
    INDEX idx_student_id (student_id),
    INDEX idx_name (name),
    INDEX idx_major (major),
    INDEX idx_gender (gender)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学生信息表';

-- 插入示例数据（可选）
INSERT INTO students (name, student_id, email, phone, gender, age, major, address, enrollment_date, created_at, updated_at)
VALUES
    ('张三', '2024001', 'zhangsan@example.com', '13800138001', '男', 20, '计算机科学', '北京市海淀区', '2024-09-01', CURDATE(), CURDATE()),
    ('李四', '2024002', 'lisi@example.com', '13800138002', '女', 19, '软件工程', '上海市浦东新区', '2024-09-01', CURDATE(), CURDATE()),
    ('王五', '2024003', 'wangwu@example.com', '13800138003', '男', 21, '人工智能', '广州市天河区', '2024-09-01', CURDATE(), CURDATE()),
    ('赵六', '2024004', 'zhaoliu@example.com', '13800138004', '女', 20, '数据科学', '深圳市南山区', '2024-09-01', CURDATE(), CURDATE()),
    ('钱七', '2024005', 'qianqi@example.com', '13800138005', '男', 22, '网络安全', '杭州市西湖区', '2024-09-01', CURDATE(), CURDATE());

-- 查询所有学生
SELECT * FROM students;

-- 按姓名搜索
SELECT * FROM students WHERE name LIKE '%张%';

-- 按专业搜索
SELECT * FROM students WHERE major LIKE '%计算机%';

-- 按性别搜索
SELECT * FROM students WHERE gender = '男';

-- 按年龄范围搜索
SELECT * FROM students WHERE age BETWEEN 18 AND 22;
