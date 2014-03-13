--Вывод начальника отдела и НЕПОСРЕДСТВЕННЫХ подчиненных
CREATE OR REPLACE FUNCTION dept_view(_dept int)
RETURNS table (id int, name varchar, dept int, chief int) AS
$$
SELECT * FROM emps WHERE dept = _dept AND chief IS NULL
	UNION
SELECT * FROM emps WHERE chief IN
	(SELECT emps.id FROM emps WHERE dept = _dept AND chief IS NULL)	
$$
LANGUAGE 'sql' VOLATILE;

SELECT * from dept_view(1);