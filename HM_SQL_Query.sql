USE hospital_management;


-- PATIENT TABLE
ALTER TABLE `patient` 
ADD CONSTRAINT `fk_patient_pcp` FOREIGN KEY (`pcp`) REFERENCES `physician` (`employeeid`);

-- DEPARTMENT TABLE
ALTER TABLE `department` 
ADD CONSTRAINT `fk_department_head` FOREIGN KEY (`head`) REFERENCES `physician` (`employeeid`);

-- STAY TABLE
ALTER TABLE `stay` 
ADD CONSTRAINT `fk_stay_patient` FOREIGN KEY (`patient`) REFERENCES `patient` (`ssn`),
ADD CONSTRAINT `fk_stay_room` FOREIGN KEY (`room`) REFERENCES `room` (`roomnumber`);

-- UNDERGOES TABLE
ALTER TABLE `undergoes` 
ADD CONSTRAINT `fk_undergoes_patient` FOREIGN KEY (`patient`) REFERENCES `patient` (`ssn`),
ADD CONSTRAINT `fk_undergoes_procedure` FOREIGN KEY (`procedure`) REFERENCES `procedure` (`code`),
ADD CONSTRAINT `fk_undergoes_stay` FOREIGN KEY (`stay`) REFERENCES `stay` (`stayid`),
ADD CONSTRAINT `fk_undergoes_physician` FOREIGN KEY (`physician`) REFERENCES `physician` (`employeeid`),
ADD CONSTRAINT `fk_undergoes_nurse` FOREIGN KEY (`assistingnurse`) REFERENCES `nurse` (`employeeid`);

-- APPOINTMENT TABLE
ALTER TABLE `appointment` 
ADD CONSTRAINT `fk_appointment_patient` FOREIGN KEY (`patient`) REFERENCES `patient` (`ssn`),
ADD CONSTRAINT `fk_appointment_prepnurse` FOREIGN KEY (`prepnurse`) REFERENCES `nurse` (`employeeid`),
ADD CONSTRAINT `fk_appointment_physician` FOREIGN KEY (`physician`) REFERENCES `physician` (`employeeid`);

-- TRAINED_IN TABLE
ALTER TABLE `trained_in` 
ADD CONSTRAINT `fk_trained_in_physician` FOREIGN KEY (`physician`) REFERENCES `physician` (`employeeid`),
ADD CONSTRAINT `fk_trained_in_procedure` FOREIGN KEY (`treatment`) REFERENCES `procedure` (`code`);

-- AFFILIATED_WITH TABLE
ALTER TABLE `affiliated_with` 
ADD CONSTRAINT `fk_affiliated_physician` FOREIGN KEY (`physician`) REFERENCES `physician` (`employeeid`),
ADD CONSTRAINT `fk_affiliated_department` FOREIGN KEY (`department`) REFERENCES `department` (`departmentid`);

-- ON_CALL TABLE
ALTER TABLE `on_call` 
ADD CONSTRAINT `fk_oncall_nurse` FOREIGN KEY (`nurse`) REFERENCES `nurse` (`employeeid`);

-- PRESCRIBES TABLE
ALTER TABLE `prescribes` 
ADD CONSTRAINT `fk_prescribes_physician` FOREIGN KEY (`physician`) REFERENCES `physician` (`employeeid`),
ADD CONSTRAINT `fk_prescribes_patient` FOREIGN KEY (`patient`) REFERENCES `patient` (`ssn`),
ADD CONSTRAINT `fk_prescribes_medication` FOREIGN KEY (`medication`) REFERENCES `medication` (`code`),
ADD CONSTRAINT `fk_prescribes_appointment` FOREIGN KEY (`appointment`) REFERENCES `appointment` (`appointmentid`);
  
  
  
  
-- Question-1

SELECT p.name AS physician_name, d.name AS department_name
FROM physician p
JOIN department d ON p.employeeid = d.head; 


-- Question-2

SELECT blockfloor AS floor, blockcode AS block 
FROM room 
WHERE roomnumber = 212;


-- Question-3

SELECT COUNT(*) AS "Number of unavailable rooms"
FROM room 
WHERE unavailable = 't' or unavailable = 'TRUE';


-- Question-4

SELECT p.name AS physician, d.name AS department
FROM physician p
JOIN affiliated_with a ON p.employeeid = a.physician
JOIN department d ON a.department = d.departmentid;

-- Question-5

SELECT DISTINCT p.employeeid, p.name
FROM physician p
JOIN trained_in t ON p.employeeid = t.physician;


-- Question-6

SELECT a.patient, COUNT(DISTINCT a.physician) AS physician_count
FROM appointment a
GROUP BY a.patient;

-- Question-7

SELECT COUNT(DISTINCT patient) AS patient_count
FROM appointment
WHERE examinationroom = 'C';


-- Question-8

SELECT blockfloor, blockcode, COUNT(*) AS available_rooms 
FROM room 
WHERE unavailable = FALSE 
GROUP BY blockfloor, blockcode 
ORDER BY blockfloor, blockcode 
LIMIT 0, 1000;





-- Question-9

CREATE VIEW patient_room_assignments AS
SELECT p.name AS patient, r.blockfloor, r.blockcode, r.roomnumber
FROM patient p
JOIN stay s ON p.ssn = s.patient
JOIN room r ON s.room = r.roomnumber;

SELECT * FROM patient_room_assignments;


-- Question-10

SELECT 
    pa.name AS patient, 
    pr.name AS procedure_name, 
    pr.cost, 
    ph.name AS primary_physician
FROM patient pa 
JOIN undergoes u ON pa.ssn = u.patient 
JOIN `procedure` pr ON u.procedure = pr.code 
JOIN physician ph ON pa.pcp = ph.employeeid 
WHERE pr.cost > 5000;


-- Question-11

SELECT pa.name AS patient, ph.name AS physician
FROM patient pa
JOIN physician ph ON pa.pcp = ph.employeeid
LEFT JOIN department d ON ph.employeeid = d.head
WHERE d.head IS NULL;



-- Question-12

SELECT DISTINCT p.name AS patient
FROM patient p
JOIN prescribes pr ON p.ssn = pr.patient
JOIN physician ph ON pr.physician = ph.employeeid
JOIN affiliated_with a ON ph.employeeid = a.physician
JOIN department d ON a.department = d.departmentid
WHERE d.name = 'Psychiatry';


-- Question-13

DELIMITER //
CREATE TRIGGER validate_physician_affiliation
BEFORE INSERT ON appointment
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM affiliated_with 
        WHERE physician = NEW.physician AND primaryaffiliation = 't'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Physician must have primary department affiliation';
    END IF;
END//
DELIMITER ;

describe appointment;
-- Try to check does delimiter work
INSERT INTO appointment (appointmentid, patient, prepnurse, physician, starttime, endtime, examinationroom)
VALUES (99999999, 100000001, 101, 3, '2023-01-01 10:00', '2023-01-01 11:00', 'A');


-- Question-14

UPDATE patient
SET insuranceid = '99999999'
WHERE pcp = (SELECT employeeid FROM physician WHERE name = 'John Dorian');

select * from patient;

-- Question-15

SELECT p.name AS physician, 
       COUNT(a.appointmentid) AS appointment_count,
       RANK() OVER (ORDER BY COUNT(a.appointmentid) DESC)AS ranking
FROM physician p
LEFT JOIN appointment a ON p.employeeid = a.physician
GROUP BY p.name
ORDER BY appointment_count DESC;

-- Question-16
SELECT examinationroom, COUNT(*) AS appointment_count
FROM appointment
GROUP BY examinationroom
ORDER BY appointment_count DESC;


-- Question-17

SELECT 
    MONTH(date) AS month,
    COUNT(*) AS total_procedures
FROM undergoes
GROUP BY MONTH(date)
ORDER BY month;

-- Question-18

SELECT r.roomnumber
FROM room r
LEFT JOIN stay s ON r.roomnumber = s.room
WHERE s.room IS NULL;