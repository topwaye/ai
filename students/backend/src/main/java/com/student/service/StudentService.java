package com.student.service;

import com.student.entity.Student;
import com.student.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class StudentService {

    @Autowired
    private StudentRepository studentRepository;

    // 获取所有学生
    public List<Student> getAllStudents() {
        return studentRepository.findAll();
    }

    // 根据ID获取学生
    public Optional<Student> getStudentById(Long id) {
        return studentRepository.findById(id);
    }

    // 根据学号获取学生
    public Optional<Student> getStudentByStudentId(String studentId) {
        return studentRepository.findByStudentId(studentId);
    }

    // 创建新学生
    public Student createStudent(Student student) {
        // 检查学号是否已存在
        if (studentRepository.existsByStudentId(student.getStudentId())) {
            throw new RuntimeException("学号 " + student.getStudentId() + " 已存在");
        }
        return studentRepository.save(student);
    }

    // 更新学生信息
    public Student updateStudent(Long id, Student studentDetails) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("学生不存在，ID: " + id));

        // 如果学号发生变化，检查新学号是否已存在
        if (!student.getStudentId().equals(studentDetails.getStudentId())) {
            if (studentRepository.existsByStudentId(studentDetails.getStudentId())) {
                throw new RuntimeException("学号 " + studentDetails.getStudentId() + " 已存在");
            }
            student.setStudentId(studentDetails.getStudentId());
        }

        student.setName(studentDetails.getName());
        student.setEmail(studentDetails.getEmail());
        student.setPhone(studentDetails.getPhone());
        student.setGender(studentDetails.getGender());
        student.setAge(studentDetails.getAge());
        student.setMajor(studentDetails.getMajor());
        student.setAddress(studentDetails.getAddress());
        student.setEnrollmentDate(studentDetails.getEnrollmentDate());

        return studentRepository.save(student);
    }

    // 删除学生
    public void deleteStudent(Long id) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("学生不存在，ID: " + id));
        studentRepository.delete(student);
    }

    // 根据姓名模糊查询
    public List<Student> searchByName(String name) {
        return studentRepository.findByNameContainingIgnoreCase(name);
    }

    // 根据专业查询
    public List<Student> searchByMajor(String major) {
        return studentRepository.findByMajor(major);
    }

    // 根据性别查询
    public List<Student> searchByGender(String gender) {
        return studentRepository.findByGender(gender);
    }

    // 根据年龄范围查询
    public List<Student> searchByAgeRange(Integer minAge, Integer maxAge) {
        return studentRepository.findByAgeBetween(minAge, maxAge);
    }

    // 根据关键词查询（学号或姓名）
    public List<Student> searchByKeyword(String keyword) {
        return studentRepository.searchByKeyword(keyword);
    }
}
