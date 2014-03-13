-- При добавлении сотрудника под него создается новый отдел
CREATE OR REPLACE FUNCTION ins_emp(e_name varchar(80))
RETURNS varchar(80) AS
$$
DECLARE
var varchar(80);
_id integer;
cur CURSOR for
	INSERT INTO emps(emp_name, dept) VALUES(e_name, (SELECT MAX(dept) FROM emps)+1)
	RETURNING id;
BEGIN
OPEN cur;
FETCH NEXT from cur INTO _id;
CLOSE cur;
var = 'Добавлен новый сотрудник, id = ' || _id;
RETURN var;
END
$$
LANGUAGE 'plpgsql' VOLATILE;

-- Сотрудник распределяется в подчинение другому
CREATE OR REPLACE FUNCTION ins_emp(e_name varchar(80), e_chief int)
RETURNS varchar(80) AS
$$
DECLARE
var varchar(80);
_id integer;
cur CURSOR for
	INSERT INTO emps(emp_name, dept, chief) 
	VALUES(e_name, (SELECT dept FROM emps WHERE id = e_chief), e_chief)
	RETURNING id;
BEGIN
IF (select count(*) from emps where id = e_chief)=0 THEN
	var = 'Неуспех: Нет сотрудника'; 
ELSE
	OPEN cur;
	FETCH NEXT from cur INTO _id;
	CLOSE cur;
	var = 'Добавлен новый сотрудник, id = ' || _id;
END IF;
RETURN var;
END
$$
LANGUAGE 'plpgsql' VOLATILE;

SELECT ins_emp('66', 79) AS tab;
