CREATE TABLE COURSE (
    CourseNo NUMBER(8) PRIMARY KEY,
    Description VARCHAR2(50),
    Cost NUMBER(9,2),
    Prerequisite NUMBER(8),
    CreatedBy VARCHAR2(30) NOT NULL,
    CreatedDate DATE NOT NULL,
    ModifiedBy VARCHAR2(30) NOT NULL,
    ModifiedDate DATE NOT NULL
);
CREATE TABLE INSTRUCTOR (
    InstructorID NUMBER(8) PRIMARY KEY,
    Salutation VARCHAR2(5),
    FirstName VARCHAR2(25),
    LastName VARCHAR2(25),
    Address VARCHAR2(50),
    Phone VARCHAR2(15),
    CreatedBy VARCHAR2(30) NOT NULL,
    CreatedDate DATE NOT NULL,
    ModifiedBy VARCHAR2(30) NOT NULL,
    ModifiedDate DATE NOT NULL
);
CREATE TABLE STUDENT (
    StudentID NUMBER(8) PRIMARY KEY,
    Salutation VARCHAR2(5),
    FirstName VARCHAR2(25),
    LastName VARCHAR2(25) NOT NULL,
    Address VARCHAR2(50),
    Phone VARCHAR2(15),
    Employer VARCHAR2(50),
    RegistrationDate DATE NOT NULL,
    CreatedBy VARCHAR2(30) NOT NULL,
    CreatedDate DATE NOT NULL,
    ModifiedBy VARCHAR2(30) NOT NULL,
    ModifiedDate DATE NOT NULL
);
CREATE TABLE CLASS (
    ClassID NUMBER(8) PRIMARY KEY,
    CourseNo NUMBER(8) NOT NULL,
    ClassNo NUMBER(3),
    StartDateTime DATE,
    Location VARCHAR2(50),
    InstructorID NUMBER(8),
    Capacity NUMBER(3),
    CreatedBy VARCHAR2(30) NOT NULL,
    CreatedDate DATE NOT NULL,
    ModifiedBy VARCHAR2(30) NOT NULL,
    ModifiedDate DATE NOT NULL
);
CREATE TABLE ENROLLMENT (
    StudentID NUMBER(8),
    ClassID NUMBER(8),
    EnrollDate DATE,
    FinalGrade NUMBER(3),
    CreatedBy VARCHAR2(30) NOT NULL,
    CreatedDate DATE NOT NULL,
    ModifiedBy VARCHAR2(30) NOT NULL,
    ModifiedDate DATE NOT NULL,
    PRIMARY KEY (StudentID, ClassID)
);
CREATE TABLE GRADE (
    StudentID NUMBER(8),
    ClassID NUMBER(8),
    Grade NUMBER(3),
    Comments VARCHAR2(2000),
    CreatedBy VARCHAR2(30) NOT NULL,
    CreatedDate DATE NOT NULL,
    ModifiedBy VARCHAR2(30) NOT NULL,
    ModifiedDate DATE NOT NULL,
    PRIMARY KEY (StudentID, ClassID)
);
-- COURSE
INSERT INTO COURSE VALUES (10,'DP Overview',100,NULL,USER,SYSDATE,USER,SYSDATE);
INSERT INTO COURSE VALUES (20,'Intro to Computers',150,NULL,USER,SYSDATE,USER,SYSDATE);

-- INSTRUCTOR
INSERT INTO INSTRUCTOR VALUES (1,'Mr','An','Nguyen','HCM','0901',USER,SYSDATE,USER,SYSDATE);
INSERT INTO INSTRUCTOR VALUES (2,'Ms','Lan','Tran','HCM','0902',USER,SYSDATE,USER,SYSDATE);

-- STUDENT
INSERT INTO STUDENT VALUES (1,'Mr','Nam','Le','HCM','111','ABC',SYSDATE,USER,SYSDATE,USER,SYSDATE);
INSERT INTO STUDENT VALUES (2,'Ms','Hoa','Pham','HCM','222','XYZ',SYSDATE,USER,SYSDATE,USER,SYSDATE);
INSERT INTO STUDENT VALUES (3,'Mr','Minh','Vo','HCM','333','DEF',SYSDATE,USER,SYSDATE,USER,SYSDATE);

-- CLASS
INSERT INTO CLASS VALUES (1,10,1,SYSDATE,'Room1',1,30,USER,SYSDATE,USER,SYSDATE);
INSERT INTO CLASS VALUES (2,20,1,SYSDATE,'Room2',2,30,USER,SYSDATE,USER,SYSDATE);

-- ENROLLMENT
INSERT INTO ENROLLMENT VALUES (1,1,SYSDATE,90,USER,SYSDATE,USER,SYSDATE);
INSERT INTO ENROLLMENT VALUES (1,2,SYSDATE,85,USER,SYSDATE,USER,SYSDATE);
INSERT INTO ENROLLMENT VALUES (2,2,SYSDATE,80,USER,SYSDATE,USER,SYSDATE);
INSERT INTO ENROLLMENT VALUES (3,2,SYSDATE,70,USER,SYSDATE,USER,SYSDATE);

COMMIT;
--cau a
CREATE TABLE Cau1 (
    ID NUMBER,
    NAME VARCHAR2(50)
);
--cau b

CREATE SEQUENCE Cau1Seq
START WITH 1
INCREMENT BY 5;

--cau c

DECLARE
    v_name VARCHAR2(50);
    v_id   NUMBER;
BEGIN
    NULL;
END;
/
-- cau d
DECLARE
    v_name VARCHAR2(50);
    v_id   NUMBER;
BEGIN
    SELECT s.FirstName || ' ' || s.LastName
    INTO v_name
    FROM STUDENT s
    JOIN ENROLLMENT e ON s.StudentID = e.StudentID
    GROUP BY s.StudentID, s.FirstName, s.LastName
    ORDER BY COUNT(*) DESC
    FETCH FIRST 1 ROWS ONLY;

    v_id := Cau1Seq.NEXTVAL;

    INSERT INTO Cau1 (ID, NAME)
    VALUES (v_id, v_name);

    SAVEPOINT A;

    DBMS_OUTPUT.PUT_LINE('Da them: ' || v_name);
END;
/
SELECT * FROM Cau1;
--cau e
DECLARE
    v_name VARCHAR2(50);
    v_id   NUMBER;
BEGIN
    SELECT s.FirstName || ' ' || s.LastName
    INTO v_name
    FROM STUDENT s
    JOIN ENROLLMENT e ON s.StudentID = e.StudentID
    GROUP BY s.StudentID, s.FirstName, s.LastName
    ORDER BY COUNT(*) ASC
    FETCH FIRST 1 ROWS ONLY;

    v_id := Cau1Seq.NEXTVAL;

    INSERT INTO Cau1 (ID, NAME)
    VALUES (v_id, v_name);

    SAVEPOINT B;

    DBMS_OUTPUT.PUT_LINE('Da them (it nhat): ' || v_name);
END;
/
SELECT * FROM Cau1;

--cau f

DECLARE
    v_name VARCHAR2(50);
    v_id   NUMBER;
BEGIN
    SELECT i.FirstName || ' ' || i.LastName
    INTO v_name
    FROM INSTRUCTOR i
    JOIN CLASS c ON i.InstructorID = c.InstructorID
    GROUP BY i.InstructorID, i.FirstName, i.LastName
    ORDER BY COUNT(*) DESC
    FETCH FIRST 1 ROWS ONLY;

    v_id := Cau1Seq.NEXTVAL;

    INSERT INTO Cau1 (ID, NAME)
    VALUES (v_id, v_name);

    SAVEPOINT C;

    DBMS_OUTPUT.PUT_LINE('GV nhieu lop nhat: ' || v_name);
END;
/
SELECT * FROM Cau1;

--cau g
SET SERVEROUTPUT ON;
DECLARE
    v_name VARCHAR2(50) := 'An Nguyen'; 
    v_id   NUMBER;
BEGIN
    SELECT InstructorID
    INTO v_id
    FROM INSTRUCTOR
    WHERE FirstName || ' ' || LastName = v_name;

    DBMS_OUTPUT.PUT_LINE('ID tim duoc: ' || v_id);
END;
/

--cau h
BEGIN
    ROLLBACK TO C;
    DBMS_OUTPUT.PUT_LINE('Da rollback ve savepoint C');
END;
/

--cau i
SET SERVEROUTPUT ON;

DECLARE
    v_name VARCHAR2(50);
    v_id   NUMBER := 11; 
BEGIN
    SELECT i.FirstName || ' ' || i.LastName
    INTO v_name
    FROM INSTRUCTOR i
    JOIN CLASS c ON i.InstructorID = c.InstructorID
    GROUP BY i.InstructorID, i.FirstName, i.LastName
    ORDER BY COUNT(*) ASC
    FETCH FIRST 1 ROWS ONLY;

    INSERT INTO Cau1 (ID, NAME)
    VALUES (v_id, v_name);

    DBMS_OUTPUT.PUT_LINE('Da them: ' || v_name);
END;
/

--cai j
DECLARE
    v_name VARCHAR2(50);
    v_id   NUMBER;
BEGIN
    SELECT i.FirstName || ' ' || i.LastName
    INTO v_name
    FROM INSTRUCTOR i
    JOIN CLASS c ON i.InstructorID = c.InstructorID
    GROUP BY i.InstructorID, i.FirstName, i.LastName
    ORDER BY COUNT(*) DESC
    FETCH FIRST 1 ROWS ONLY;

    v_id := Cau1Seq.NEXTVAL;

    INSERT INTO Cau1 VALUES (v_id, v_name);

    DBMS_OUTPUT.PUT_LINE('Da them lai GV nhieu lop nhat: ' || v_name);
END;
/

--bai 2
--cau 1
DECLARE
    v_id NUMBER := &Nhap_Ma_GV;
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM CLASS
    WHERE InstructorID = v_id;

    IF v_count >= 5 THEN
        DBMS_OUTPUT.PUT_LINE('Giao vien nay nen nghi ngoi!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('So lop dang day: ' || v_count);
    END IF;

END;
/
--cau 2

DECLARE
    v_student_id NUMBER := &Nhap_Ma_SV;
    v_class_id   NUMBER := &Nhap_Ma_Lop;
    v_grade      NUMBER;
    v_count      NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM STUDENT
    WHERE StudentID = v_student_id;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Khong ton tai sinh vien');
        RETURN;
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM CLASS
    WHERE ClassID = v_class_id;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Khong ton tai lop');
        RETURN;
    END IF;

    SELECT Grade INTO v_grade
    FROM GRADE
    WHERE StudentID = v_student_id
      AND ClassID = v_class_id;

    CASE
        WHEN v_grade >= 90 THEN
            DBMS_OUTPUT.PUT_LINE('Diem chu: A');
        WHEN v_grade >= 80 THEN
            DBMS_OUTPUT.PUT_LINE('Diem chu: B');
        WHEN v_grade >= 70 THEN
            DBMS_OUTPUT.PUT_LINE('Diem chu: C');
        WHEN v_grade >= 50 THEN
            DBMS_OUTPUT.PUT_LINE('Diem chu: D');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Diem chu: F');
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Khong co diem cho sinh vien nay');
END;
/
--BAI 3

DECLARE
    CURSOR c_course IS
        SELECT CourseNo, Description
        FROM COURSE;

    CURSOR c_class(p_courseNo NUMBER) IS
        SELECT ClassID
        FROM CLASS
        WHERE CourseNo = p_courseNo;

    v_count NUMBER;

BEGIN
    FOR course_rec IN c_course LOOP

        DBMS_OUTPUT.PUT_LINE(course_rec.CourseNo || ' ' || course_rec.Description);

        FOR class_rec IN c_class(course_rec.CourseNo) LOOP

            SELECT COUNT(*)
            INTO v_count
            FROM ENROLLMENT
            WHERE ClassID = class_rec.ClassID;

            DBMS_OUTPUT.PUT_LINE('    Lop: ' || class_rec.ClassID ||
                                 ' co so luong sinh vien dang ki: ' || v_count);
        END LOOP;

    END LOOP;
END;
/

--BAI 4
--cau 1
--a
CREATE OR REPLACE PROCEDURE find_sname (
    i_student_id   IN  STUDENT.StudentID%TYPE,
    o_first_name   OUT STUDENT.FirstName%TYPE,
    o_last_name    OUT STUDENT.LastName%TYPE
)
IS
BEGIN
    SELECT FirstName, LastName
    INTO o_first_name, o_last_name
    FROM STUDENT
    WHERE StudentID = i_student_id;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        o_first_name := NULL;
        o_last_name  := NULL;
END;
/
--cau b

CREATE OR REPLACE PROCEDURE print_student_name (
    i_student_id IN STUDENT.StudentID%TYPE
)
IS
    v_fname STUDENT.FirstName%TYPE;
    v_lname STUDENT.LastName%TYPE;
BEGIN
    SELECT FirstName, LastName
    INTO v_fname, v_lname
    FROM STUDENT
    WHERE StudentID = i_student_id;

    DBMS_OUTPUT.PUT_LINE('Ten sinh vien: ' || v_fname || ' ' || v_lname);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Khong tim thay sinh vien');
END;
/

BEGIN
    print_student_name(1);
END;
/

--cau 2

CREATE OR REPLACE PROCEDURE Discount
IS
BEGIN
    FOR rec IN (
        SELECT c.CourseNo, c.Description
        FROM COURSE c
        JOIN CLASS cl ON c.CourseNo = cl.CourseNo
        JOIN ENROLLMENT e ON cl.ClassID = e.ClassID
        GROUP BY c.CourseNo, c.Description
        HAVING COUNT(e.StudentID) > 15
    )
    LOOP
        -- giảm giá 5%
        UPDATE COURSE
        SET Cost = Cost * 0.95
        WHERE CourseNo = rec.CourseNo;

        -- in ra môn học
        DBMS_OUTPUT.PUT_LINE('Da giam gia mon: ' || rec.Description);
    END LOOP;

    COMMIT;
END;
/

SELECT CourseNo, Description, Cost FROM COURSE;

--cau 3

CREATE OR REPLACE FUNCTION Total_cost_for_student (
    i_student_id IN STUDENT.StudentID%TYPE
)
RETURN NUMBER
IS
    v_total NUMBER;
    v_check NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_check
    FROM STUDENT
    WHERE StudentID = i_student_id;

    IF v_check = 0 THEN
        RETURN NULL;
    END IF;

    SELECT SUM(c.Cost)
    INTO v_total
    FROM ENROLLMENT e
    JOIN CLASS cl ON e.ClassID = cl.ClassID
    JOIN COURSE c ON cl.CourseNo = c.CourseNo
    WHERE e.StudentID = i_student_id;

    RETURN v_total;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/
SET SERVEROUTPUT ON;

DECLARE
    v_total NUMBER;
BEGIN
    v_total := Total_cost_for_student(1);

    DBMS_OUTPUT.PUT_LINE('Tong hoc phi: ' || v_total);
END;
/

--BAI 5

CREATE OR REPLACE TRIGGER trg_student_audit
BEFORE INSERT OR UPDATE ON STUDENT
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.created_by   := USER;
        :NEW.created_date := SYSDATE;
        :NEW.modified_by  := USER;
        :NEW.modified_date := SYSDATE;
    ELSE
        :NEW.modified_by  := USER;
        :NEW.modified_date := SYSDATE;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_course_audit
BEFORE INSERT OR UPDATE ON COURSE
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.created_by    := USER;
        :NEW.created_date  := SYSDATE;
        :NEW.modified_by   := USER;
        :NEW.modified_date := SYSDATE;
    ELSE
        :NEW.modified_by   := USER;
        :NEW.modified_date := SYSDATE;
    END IF;
END;
/
--cau 2
CREATE OR REPLACE TRIGGER trg_limit_subjects
BEFORE INSERT ON ENROLLMENT
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM ENROLLMENT
    WHERE StudentID = :NEW.StudentID;

    IF v_count >= 3 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Sinh vien khong duoc dang ky qua 3 mon hoc');
    END IF;
END;
/
