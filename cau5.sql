--cau 1
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
INSERT INTO STUDENT (StudentID, FirstName, LastName)
VALUES (1, 'Thanh', 'Trung');
ALTER TABLE STUDENT ADD (
    created_by VARCHAR2(30),
    created_date DATE,
    modified_by VARCHAR2(30),
    modified_date DATE
);
SELECT created_by, created_date, modified_by, modified_date
FROM STUDENT
WHERE StudentID = 1;

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
SELECT created_by, created_date, modified_by, modified_date
FROM COURSE
WHERE CourseNo = 1;

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