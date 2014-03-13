--Вывод списка подчинения
CREATE OR REPLACE FUNCTION emp_hierarchy(e_id int)
RETURNS table (id int, chief int) AS
$$
WITH RECURSIVE h_rec(id, chief) AS (
	SELECT id, chief FROM emps WHERE id = e_id
  UNION 
	SELECT emps.id, emps.chief FROM emps, h_rec f
	WHERE emps.id = f.chief
	)
SELECT * from h_rec;
$$
LANGUAGE 'sql' VOLATILE;

SELECT * from emp_hierarchy(6);
