DELIMITER $$

CREATE PROCEDURE get_all_students()
BEGIN
	DECLARE total_students INT DEFAULT 0;
    
	SELECT 
		COUNT(*)
	INTO total_students FROM
		students;
    
	SELECT totalOrder;
END$$

DELIMITER ;