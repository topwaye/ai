# 学生管理系统

一个基于 Spring Boot + MySQL + JavaScript 的学生管理系统，提供完整的 CRUD 功能和搜索功能。

## 技术栈

### 后端
- Spring Boot 4.0.0
- JDK 17
- Spring Data JPA
- MySQL Connector 8.0
- Maven

### 前端
- 原生 JavaScript
- HTML5
- CSS3

### 数据库
- MySQL 8.0

## 功能特性

### 学生管理
- 添加学生信息
- 编辑学生信息
- 删除学生信息
- 查看学生列表

### 搜索功能
- 按学号搜索
- 按姓名搜索（模糊查询）
- 按专业搜索
- 按性别搜索
- 关键词搜索（学号或姓名）

### 学生字段
- ID（自动生成）
- 学号（唯一）
- 姓名
- 性别
- 年龄
- 专业
- 邮箱
- 电话
- 地址
- 入学日期
- 创建时间（自动）
- 更新时间（自动）

## 数据库配置

### 数据库信息
- 数据库名：`student_management`
- 用户名：`root`
- 密码：`123456`
- 端口：`3306`
- 主机：`localhost`

### 创建数据库（可选）
系统会自动创建数据库，但也可以手动创建：
```sql
CREATE DATABASE student_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

## 项目结构

```
students/
├── backend/                    # 后端项目
│   ├── pom.xml                # Maven配置文件
│   └── src/
│       └── main/
│           ├── java/
│           │   └── com/
│           │       └── student/
│           │           ├── StudentManagementApplication.java  # 主应用类
│           │           ├── config/
│           │           │   └── CorsConfig.java                # CORS配置
│           │           ├── controller/
│           │           │   └── StudentController.java         # 控制器
│           │           ├── entity/
│           │           │   └── Student.java                   # 实体类
│           │           ├── repository/
│           │           │   └── StudentRepository.java         # 数据访问层
│           │           └── service/
│           │               └── StudentService.java            # 服务层
│           └── resources/
│               └── application.properties                     # 配置文件
└── frontend/                   # 前端项目
    ├── index.html             # 主页面
    └── app.js                 # JavaScript逻辑
```

## 快速开始

### Windows 用户
双击运行 `start.bat` 脚本即可自动启动后端和前端服务。

### Linux/Mac 用户
```bash
chmod +x start.sh
./start.sh
```

## 详细安装和运行

### 前置要求
1. JDK 17
2. Maven 3.6+
3. MySQL 8.0
4. 现代浏览器（Chrome、Firefox、Edge等）

### 1. 启动 MySQL 数据库
确保 MySQL 服务正在运行，并且用户名和密码配置正确。

### 2. 配置数据库连接
后端配置文件位于：`backend/src/main/resources/application.properties`

默认配置：
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/student_management?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=123456
```

如果需要修改数据库配置，请编辑此文件。

### 3. 运行后端服务

#### 方式一：使用 Maven
```bash
cd backend
mvn clean install
mvn spring-boot:run
```

#### 方式二：使用 IDE
1. 在 IDE 中导入 `backend` 目录作为 Maven 项目
2. 运行 `StudentManagementApplication.java` 主类

后端服务将在 `http://localhost:8080` 启动。

### 4. 运行前端

#### 方式一：直接打开
直接在浏览器中打开 `frontend/index.html` 文件。

#### 方式二：使用 HTTP 服务器（推荐）
```bash
cd frontend
# 使用 Python
python -m http.server 8000

# 或使用 Node.js
npx http-server -p 8000
```

然后在浏览器中访问 `http://localhost:8000`

### 5. 初始化示例数据（可选）
如果想预填充一些示例数据，可以运行：
```bash
mysql -u root -p123456 < database.sql
```

## API 接口文档

### 基础路径
`http://localhost:8080/api/students`

### 接口列表

#### 1. 获取所有学生
```
GET /api/students
```

#### 2. 根据 ID 获取学生
```
GET /api/students/{id}
```

#### 3. 根据学号获取学生
```
GET /api/students/studentId/{studentId}
```

#### 4. 创建学生
```
POST /api/students
Content-Type: application/json

{
  "name": "张三",
  "studentId": "2024001",
  "gender": "男",
  "age": 20,
  "major": "计算机科学",
  "email": "zhangsan@example.com",
  "phone": "13800138000",
  "address": "北京市",
  "enrollmentDate": "2024-09-01"
}
```

#### 5. 更新学生
```
PUT /api/students/{id}
Content-Type: application/json

{
  "name": "张三",
  "studentId": "2024001",
  "gender": "男",
  "age": 21,
  "major": "软件工程",
  "email": "zhangsan@example.com",
  "phone": "13800138000",
  "address": "北京市",
  "enrollmentDate": "2024-09-01"
}
```

#### 6. 删除学生
```
DELETE /api/students/{id}
```

#### 7. 按姓名搜索
```
GET /api/students/search/name?name=张
```

#### 8. 按专业搜索
```
GET /api/students/search/major?major=计算机
```

#### 9. 按性别搜索
```
GET /api/students/search/gender?gender=男
```

#### 10. 按年龄范围搜索
```
GET /api/students/search/age?minAge=18&maxAge=22
```

#### 11. 关键词搜索
```
GET /api/students/search?keyword=张
```

## 使用说明

### 添加学生
1. 点击"添加学生"按钮
2. 填写学生信息（带 * 的为必填项）
3. 点击"保存"按钮

### 编辑学生
1. 在学生列表中找到要编辑的学生
2. 点击"编辑"按钮
3. 修改学生信息
4. 点击"保存"按钮

### 删除学生
1. 在学生列表中找到要删除的学生
2. 点击"删除"按钮
3. 确认删除操作

### 搜索学生
1. 在搜索框中输入关键词
2. 选择搜索类型（关键词、姓名、专业、性别）
3. 点击"搜索"按钮
4. 点击"显示全部"按钮可以查看所有学生

## 注意事项

1. 学号必须唯一，系统会自动检查
2. 必填字段包括：姓名、学号、性别、年龄
3. 邮箱格式必须正确
4. 删除操作不可恢复，请谨慎操作
5. 确保后端服务正常运行才能使用前端功能

## 故障排除

### 后端无法启动
- 检查 JDK 版本是否为 17
- 检查 MySQL 服务是否运行
- 检查数据库连接配置是否正确
- 查看控制台错误日志

### 前端无法连接后端
- 确保后端服务正在运行
- 检查后端端口（默认 8080）是否被占用
- 检查 CORS 配置
- 查看浏览器控制台错误信息

### 数据库连接失败
- 确保 MySQL 服务正在运行
- 检查用户名和密码是否正确
- 检查数据库是否存在（系统会自动创建）

## 开发说明

### 添加新功能
1. 在 `entity` 包中添加或修改实体类
2. 在 `repository` 包中添加数据访问接口
3. 在 `service` 包中实现业务逻辑
4. 在 `controller` 包中添加 REST API
5. 在前端 `app.js` 中调用新的 API

### 修改数据库配置
编辑 `backend/src/main/resources/application.properties` 文件。

## 许可证
MIT License
