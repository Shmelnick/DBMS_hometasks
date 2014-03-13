DROP FUNCTION change_dept(integer,integer);

--Результат - сотрудники в подчинении у данного сотрудника
CREATE OR REPLACE FUNCTION find_str(root_id int)
RETURNS table (id int) AS
$$
WITH RECURSIVE find_subtree(id) AS (
	SELECT id FROM emps WHERE id = root_id
  UNION 
	SELECT emps.id FROM emps, find_subtree f
	WHERE f.id = emps.chief
	)
SELECT * from find_subtree
$$
LANGUAGE 'sql' IMMUTABLE;

--Переброс сотрудника со всеми подчиненными в корень другого отдела
--Выполняется даже если отдела не существует
CREATE OR REPLACE FUNCTION change_dept(emp_id int, new_dept int) 
RETURNS varchar(80) AS
$$
DECLARE
var varchar(80);
BEGIN
IF (select count(*) from emps where id = emp_id)=0 THEN
	var = 'Неуспех: Нет сотрудника с id = ' || emp_id; 
ELSE
	UPDATE emps SET chief = NULL WHERE emps.id = emp_id;
	UPDATE emps SET dept = new_dept WHERE id IN (SELECT id FROM find_str(emp_id));
	var = 'Успех';
END IF;
RETURN var;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

--change_dept(номер сотрудника, номер отдела)
SELECT * from change_dept(665, 787);

--SELECT * from emps