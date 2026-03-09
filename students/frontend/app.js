// API基础URL
const API_BASE_URL = 'http://localhost:8080/api/students';

// 页面加载完成后初始化
document.addEventListener('DOMContentLoaded', function() {
    loadAllStudents();
    setupFormSubmit();
    setupNextPageButton();
});

// 加载所有学生数据
async function loadAllStudents() {
    showLoading(true);
    hideMessage();
    try {
        const response = await fetch(API_BASE_URL);
        const students = await response.json();
        renderStudents(students);
        updateStudentCount(students.length);
    } catch (error) {
        console.error('加载学生数据失败:', error);
        showMessage('加载学生数据失败，请检查后端服务是否启动', 'error');
    } finally {
        showLoading(false);
    }
}

// 搜索学生
async function searchStudents() {
    const searchInput = document.getElementById('searchInput').value.trim();
    const searchType = document.getElementById('searchType').value;

    if (!searchInput) {
        showMessage('请输入搜索关键词', 'error');
        return;
    }

    showLoading(true);
    hideMessage();

    try {
        let url = '';
        switch (searchType) {
            case 'name':
                url = `${API_BASE_URL}/search/name?name=${encodeURIComponent(searchInput)}`;
                break;
            case 'major':
                url = `${API_BASE_URL}/search/major?major=${encodeURIComponent(searchInput)}`;
                break;
            case 'gender':
                url = `${API_BASE_URL}/search/gender?gender=${encodeURIComponent(searchInput)}`;
                break;
            default:
                url = `${API_BASE_URL}/search?keyword=${encodeURIComponent(searchInput)}`;
        }

        const response = await fetch(url);
        const students = await response.json();
        renderStudents(students);
        updateStudentCount(students.length, `搜索结果`);
    } catch (error) {
        console.error('搜索失败:', error);
        showMessage('搜索失败，请检查网络连接', 'error');
    } finally {
        showLoading(false);
    }
}

// 渲染学生表格
function renderStudents(students) {
    const tbody = document.getElementById('studentTableBody');
    const noDataDiv = document.getElementById('noData');

    if (!students || students.length === 0) {
        tbody.innerHTML = '';
        noDataDiv.style.display = 'block';
        return;
    }

    noDataDiv.style.display = 'none';
    tbody.innerHTML = students.map(student => `
        <tr>
            <td>${student.id}</td>
            <td>${escapeHtml(student.studentId)}</td>
            <td>${escapeHtml(student.name)}</td>
            <td>${escapeHtml(student.gender)}</td>
            <td>${student.age}</td>
            <td>${escapeHtml(student.major || '-')}</td>
            <td>${escapeHtml(student.email || '-')}</td>
            <td>${escapeHtml(student.phone || '-')}</td>
            <td>${student.enrollmentDate ? escapeHtml(student.enrollmentDate) : '-'}</td>
            <td>
                <button class="btn btn-primary btn-small" onclick="showEditModal(${student.id})">编辑</button>
                <button class="btn btn-danger btn-small" onclick="deleteStudent(${student.id})">删除</button>
            </td>
        </tr>
    `).join('');
}

// 更新学生数量显示
function updateStudentCount(count, prefix = '共') {
    document.getElementById('studentCount').textContent = `${prefix} ${count} 名学生`;
}

// 显示加载状态
function showLoading(show) {
    document.getElementById('loading').style.display = show ? 'block' : 'none';
}

// 显示消息提示
function showMessage(message, type) {
    const messageDiv = document.getElementById('message');
    messageDiv.textContent = message;
    messageDiv.className = `message ${type}`;
    messageDiv.style.display = 'block';

    // 3秒后自动隐藏
    setTimeout(() => {
        hideMessage();
    }, 3000);
}

// 隐藏消息提示
function hideMessage() {
    const messageDiv = document.getElementById('message');
    messageDiv.style.display = 'none';
}

// HTML转义，防止XSS攻击
function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// 显示添加学生模态框
function showAddModal() {
    document.getElementById('modalTitle').textContent = '添加学生';
    document.getElementById('studentForm').reset();
    document.getElementById('studentId').value = '';
    document.getElementById('studentModal').style.display = 'block';
    // 重置到第一页
    showPage(1);
}

// 显示编辑学生模态框
async function showEditModal(id) {
    showLoading(true);
    try {
        const response = await fetch(`${API_BASE_URL}/${id}`);
        const student = await response.json();

        document.getElementById('modalTitle').textContent = '编辑学生';
        document.getElementById('studentId').value = student.id;
        document.getElementById('name').value = student.name;
        document.getElementById('studentIdNumber').value = student.studentId;
        document.getElementById('gender').value = student.gender;
        document.getElementById('age').value = student.age;
        document.getElementById('major').value = student.major || '';
        document.getElementById('email').value = student.email || '';
        document.getElementById('phone').value = student.phone || '';
        document.getElementById('address').value = student.address || '';
        document.getElementById('enrollmentDate').value = student.enrollmentDate || '';

        document.getElementById('studentModal').style.display = 'block';
        // 编辑时显示第一页（基本信息）
        showPage(1);
    } catch (error) {
        console.error('加载学生信息失败:', error);
        showMessage('加载学生信息失败', 'error');
    } finally {
        showLoading(false);
    }
}

// 关闭模态框
function closeModal() {
    document.getElementById('studentModal').style.display = 'none';
}

// 显示指定页
function showPage(pageNumber) {
    console.log('切换到页面:', pageNumber);

    // 隐藏所有页面
    document.querySelectorAll('.form-page').forEach(page => {
        page.classList.remove('active');
    });

    // 显示指定页面
    const targetPage = document.getElementById(`formPage${pageNumber}`);
    if (targetPage) {
        targetPage.classList.add('active');
        console.log('页面切换成功');
    } else {
        console.error('找不到页面:', `formPage${pageNumber}`);
    }
}

// 下一页
function nextPage() {
    // 验证第一页的必填字段
    const name = document.getElementById('name').value.trim();
    const studentIdNumber = document.getElementById('studentIdNumber').value.trim();
    const gender = document.getElementById('gender').value;
    const age = document.getElementById('age').value;

    console.log('nextPage 被调用，验证字段:', { name, studentIdNumber, gender, age });

    if (!name) {
        showMessage('请输入学生姓名', 'error');
        return;
    }
    if (!studentIdNumber) {
        showMessage('请输入学号', 'error');
        return;
    }
    if (!gender) {
        showMessage('请选择性别', 'error');
        return;
    }
    if (!age) {
        showMessage('请输入年龄', 'error');
        return;
    }

    console.log('验证通过，切换到第二页');
    // 切换到第二页
    showPage(2);
}

// 上一页
function prevPage() {
    // 切换到第一页
    showPage(1);
}

// 设置下一步按钮事件
function setupNextPageButton() {
    // 使用ID直接查找按钮
    const nextButton = document.getElementById('nextPageBtn');
    if (nextButton) {
        console.log('找到下一步按钮，添加事件监听器');
        nextButton.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            console.log('下一步按钮被点击（通过ID）');
            nextPage();
        });
    } else {
        console.error('找不到下一步按钮');
    }

    // 添加一个事件委托监听器作为备用
    document.getElementById('formPage1').addEventListener('click', function(e) {
        if (e.target.classList.contains('btn-primary') && e.target.textContent === '下一步') {
            e.preventDefault();
            e.stopPropagation();
            console.log('下一步按钮被点击（事件委托）');
            nextPage();
        }
    });
}

// 设置表单提交处理
function setupFormSubmit() {
    document.getElementById('studentForm').addEventListener('submit', async function(e) {
        e.preventDefault();

        const studentId = document.getElementById('studentId').value;
        const studentData = {
            name: document.getElementById('name').value.trim(),
            studentId: document.getElementById('studentIdNumber').value.trim(),
            gender: document.getElementById('gender').value,
            age: parseInt(document.getElementById('age').value),
            major: document.getElementById('major').value.trim(),
            email: document.getElementById('email').value.trim(),
            phone: document.getElementById('phone').value.trim(),
            address: document.getElementById('address').value.trim(),
            enrollmentDate: document.getElementById('enrollmentDate').value || null
        };

        showLoading(true);

        try {
            let response;
            if (studentId) {
                // 更新学生
                response = await fetch(`${API_BASE_URL}/${studentId}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(studentData)
                });
            } else {
                // 添加新学生
                response = await fetch(API_BASE_URL, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(studentData)
                });
            }

            const result = await response.json();

            if (response.ok) {
                closeModal();
                showMessage(studentId ? '学生信息更新成功' : '学生添加成功', 'success');
                loadAllStudents();
            } else {
                showMessage(result.error || '操作失败', 'error');
            }
        } catch (error) {
            console.error('操作失败:', error);
            showMessage('操作失败，请检查网络连接', 'error');
        } finally {
            showLoading(false);
        }
    });
}

// 删除学生
async function deleteStudent(id) {
    if (!confirm('确定要删除这名学生吗？此操作不可恢复。')) {
        return;
    }

    showLoading(true);

    try {
        const response = await fetch(`${API_BASE_URL}/${id}`, {
            method: 'DELETE'
        });

        const result = await response.json();

        if (response.ok) {
            showMessage('学生删除成功', 'success');
            loadAllStudents();
        } else {
            showMessage(result.error || '删除失败', 'error');
        }
    } catch (error) {
        console.error('删除失败:', error);
        showMessage('删除失败，请检查网络连接', 'error');
    } finally {
        showLoading(false);
    }
}

// 点击模态框外部关闭
window.onclick = function(event) {
    const modal = document.getElementById('studentModal');
    if (event.target === modal) {
        closeModal();
    }
}
