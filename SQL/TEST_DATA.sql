USE SCHOOL;

-- ============================================================
-- 1. 基础架构 (学院 -> 系 -> 班级 -> 学期)
-- ============================================================

-- 1.1 学院
INSERT INTO college (college_id, college_name, college_code) VALUES 
(1, '计算机科学与技术学院', 'CS_COLLEGE');

-- 1.2 系 (隶属学院 1)
INSERT INTO department (dprt_id, college_id, dprt_name, dprt_code) VALUES 
(101, 1, '软件工程系', 'SE_DEPT'),
(102, 1, '人工智能系', 'AI_DEPT');

-- 1.3 行政班级 (隶属系 101, 102)
INSERT INTO administrative_class (admin_class_id, dprt_id, admin_class_name, admin_class_code) VALUES 
(1001, 101, '软件2501班', 'SW2501'),
(1002, 102, '智科2501班', 'AI2501');

-- 1.4 学期 (重点：设置2025-2026秋季)
-- Term ID 建议设置大一点，或者确保你的 C++ 代码能读到最新的
INSERT INTO semester (term_id, academic_year, semester_type, comment) VALUES 
(1, '2024', '2', '2024-2025 春季 (旧)'),
(2, '2025', '1', '2025-2026 秋季 (当前测试学期)');

-- ============================================================
-- 2. 人员数据 (学生 & 教师)
-- ============================================================

-- 2.1 学生 (学号 7位：年份 + 序号)
INSERT INTO student (stu_id, admin_class_id, stu_name, stu_number) VALUES 
(1, 1001, '张三', '2025001'),
(2, 1001, '李四', '2025002'),
(3, 1002, '王五', '2025003');

-- 2.2 教师
INSERT INTO teacher (teacher_id, dprt_id, teacher_name, teacher_number, title) VALUES 
(201, 101, '王建国', 'T202501', '副教授'),
(202, 102, '李思思', 'T202502', '讲师');

-- ============================================================
-- 3. 课程与开课 (科目 -> 课程班 -> 学分)
-- ============================================================

-- 3.1 科目
INSERT INTO subject (subject_id, dprt_id, subject_name, subject_code, status) VALUES 
(501, 101, 'C++程序设计', 'CS_CPP', 'Active'),
(502, 101, '数据库原理', 'CS_DB', 'Active'),
(503, 102, '高等数学', 'MATH_01', 'Active');

-- 3.2 开课班级 (Course Section) - 对应 Term 2 (2025秋)
-- 注意：这里手动指定 section_id 方便后面插课表
INSERT INTO course_section (section_id, term_id, teacher_id, subject_id, max_student, comment) VALUES 
(601, 2, 201, 501, 60, '教七-101'), -- C++ (王老师)
(602, 2, 201, 502, 60, '教七-203'), -- 数据库 (王老师)
(603, 2, 202, 503, 45, '基教-305'); -- 高数 (李老师)

-- 3.3 学分配置 (必须有，否则选课中心不显示学分)
INSERT INTO course_credits (credits_id, subject_id, term_id, credits) VALUES 
(701, 501, 2, 4.0), -- C++ 4学分
(702, 502, 2, 3.5), -- 数据库 3.5学分
(703, 503, 2, 5.0); -- 高数 5学分

-- ============================================================
-- 4. 课表安排 (Section Schedule) - 重点调试区域
-- ============================================================
-- 假设 2025年9月1日 是周一
-- 注意：使用新表结构 period_start, period_end

-- 4.1 C++ (section_id 601): 第一周 周一 1-2节
INSERT INTO section_schedule (section_id, class_day, period_start, period_end, start_time, end_time, comment) VALUES 
(601, '2026-01-01', 1, 2, '08:00:00', '09:40:00', '教七-101');

-- 4.2 C++ (section_id 601): 第二周 周一 3-4节 (用于测试翻页)
INSERT INTO section_schedule (section_id, class_day, period_start, period_end, start_time, end_time, comment) VALUES 
(601, '2026-01-08', 3, 4, '08:00:00', '09:40:00', '教七-101');

-- 4.3 数据库 (section_id 602): 第一周 周二 3-4节
INSERT INTO section_schedule (section_id, class_day, period_start, period_end, start_time, end_time, comment) VALUES 
(602, '2026-01-02', 3, 4, '10:00:00', '11:40:00', '教七-203');

-- 4.4 数据库 (section_id 602): 第二周 周二 1-2节
INSERT INTO section_schedule (section_id, class_day, period_start, period_end, start_time, end_time, comment) VALUES 
(602, '2026-01-09', 1, 2, '10:00:00', '11:40:00', '教七-203');

-- 4.5 高数 (section_id 603): 第一周 周三 1-2节
INSERT INTO section_schedule (section_id, class_day, period_start, period_end, start_time, end_time, comment) VALUES 
(603, '2026-01-03', 1, 2, '08:00:00', '09:40:00', '基教-305');

-- ============================================================
-- 5. 选课记录 (模拟“我的课程”和“成绩”)
-- ============================================================

-- 张三 (stu_id 1) 选了 C++ (已出分)
INSERT INTO student_course_choice (stu_id, session_id, score) VALUES (1, 601, 88.5);

-- 张三 (stu_id 1) 选了 数据库 (未出分 -1或NULL)
INSERT INTO student_course_choice (stu_id, session_id, score) VALUES (1, 602, NULL);

-- 李四 (stu_id 2) 选了 C++ (挂科测试)
INSERT INTO student_course_choice (stu_id, session_id, score) VALUES (2, 601, 55.0);

-- ============================================================
-- 6. 密码表 (Password Table) - 登录用
-- ============================================================
-- 0:学生, 1:教师, 2:管理员

-- 清空旧数据防止冲突
TRUNCATE TABLE password_t;

-- 管理员
INSERT INTO password_t (account, psw, role) VALUES ('admin', 'admin', 2);

-- 学生账号 (默认密码同账号)
INSERT INTO password_t (account, psw, role) VALUES ('2025001', '2025001', 0); -- 张三
INSERT INTO password_t (account, psw, role) VALUES ('2025002', '2025002', 0); -- 李四
INSERT INTO password_t (account, psw, role) VALUES ('2025003', '2025003', 0); -- 王五

-- 教师账号 (默认密码同账号)
INSERT INTO password_t (account, psw, role) VALUES ('T202501', 'T202501', 1); -- 王老师
INSERT INTO password_t (account, psw, role) VALUES ('T202502', 'T202502', 1); -- 李老师
