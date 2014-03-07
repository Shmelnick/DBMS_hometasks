-- При добавлении сотрудника под него создается новый отдел
CREATE OR REPLACE FUNCTION ins_emp(e_name varchar(80))
RETURNS integer AS
$$
INSERT INTO emps(emp_name, dept) VALUES(e_name, (SELECT MAX(dept) FROM emps)+1)
RETURNING id;
$$
LANGUAGE 'sql' VOLATILE;

-- Сотрудник распределяется в подчинение другому
CREATE OR REPLACE FUNCTION ins_emp(e_name varchar(80), e_chief int)
RETURNS integer AS
$$
INSERT INTO emps(emp_name, dept, chief) 
	VALUES(e_name, (SELECT dept FROM emps WHERE id = e_chief), e_chief)
RETURNING id;
$$
LANGUAGE 'sql' VOLATILE;

SELECT ins_emp('66',5) AS tab;
