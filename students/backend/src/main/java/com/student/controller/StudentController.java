package com.student.controller;

import com.student.entity.Student;
import com.student.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/students")
@CrossOrigin(origins = "*")
public class StudentController {

    @Autowired
    private StudentService studentService;

    // 获取所有学生
    @GetMapping
    public ResponseEntity<List<Student>> getAllStudents() {
        List<Student> students = studentService.getAllStudents();
        return ResponseEntity.ok(students);
    }

    // 根据ID获取学生
    @GetMapping("/{id}")
    public ResponseEntity<Student> getStudentById(@PathVariable Long id) {
        Optional<Student> student = studentService.getStudentById(id);
        return student.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // 根据学号获取学生
    @GetMapping("/studentId/{studentId}")
    public ResponseEntity<Student> getStudentByStudentId(@PathVariable String studentId) {
        Optional<Student> student = studentService.getStudentByStudentId(studentId);
        return student.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // 创建新学生
    @PostMapping
    public ResponseEntity<?> createStudent(@RequestBody Student student) {
        try {
            Student createdStudent = studentService.createStudent(student);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdStudent);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
        }
    }

    // 更新学生信息
    @PutMapping("/{id}")
    public ResponseEntity<?> updateStudent(@PathVariable Long id, @RequestBody Student studentDetails) {
        try {
            Student updatedStudent = studentService.updateStudent(id, studentDetails);
            return ResponseEntity.ok(updatedStudent);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
        }
    }

    // 删除学生
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteStudent(@PathVariable Long id) {
        try {
            studentService.deleteStudent(id);
            Map<String, String> response = new HashMap<>();
            response.put("message", "学生删除成功");
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
        }
    }

    // 根据姓名模糊查询
    @GetMapping("/search/name")
    public ResponseEntity<List<Student>> searchByName(@RequestParam String name) {
        List<Student> students = studentService.searchByName(name);
        return ResponseEntity.ok(students);
    }

    // 根据专业查询
    @GetMapping("/search/major")
    public ResponseEntity<List<Student>> searchByMajor(@RequestParam String major) {
        List<Student> students = studentService.searchByMajor(major);
        return ResponseEntity.ok(students);
    }

    // 根据性别查询
    @GetMapping("/search/gender")
    public ResponseEntity<List<Student>> searchByGender(@RequestParam String gender) {
        List<Student> students = studentService.searchByGender(gender);
        return ResponseEntity.ok(students);
    }

    // 根据年龄范围查询
    @GetMapping("/search/age")
    public ResponseEntity<List<Student>> searchByAgeRange(
            @RequestParam Integer minAge,
            @RequestParam Integer maxAge) {
        List<Student> students = studentService.searchByAgeRange(minAge, maxAge);
        return ResponseEntity.ok(students);
    }

    // 根据关键词查询（学号或姓名）
    @GetMapping("/search")
    public ResponseEntity<List<Student>> searchByKeyword(@RequestParam String keyword) {
        List<Student> students = studentService.searchByKeyword(keyword);
        return ResponseEntity.ok(students);
    }
}
