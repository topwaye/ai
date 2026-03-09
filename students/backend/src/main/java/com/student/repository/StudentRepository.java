package com.student.repository;

import com.student.entity.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {

    // 根据学号查找学生
    Optional<Student> findByStudentId(String studentId);

    // 根据姓名模糊查询
    List<Student> findByNameContainingIgnoreCase(String name);

    // 根据专业查询
    List<Student> findByMajor(String major);

    // 根据性别查询
    List<Student> findByGender(String gender);

    // 根据年龄范围查询
    List<Student> findByAgeBetween(Integer minAge, Integer maxAge);

    // 根据学号或姓名模糊查询
    @Query("SELECT s FROM Student s WHERE s.studentId LIKE %:keyword% OR s.name LIKE %:keyword%")
    List<Student> searchByKeyword(@Param("keyword") String keyword);

    // 检查学号是否存在
    boolean existsByStudentId(String studentId);
}
