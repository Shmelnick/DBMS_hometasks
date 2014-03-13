--Выводит листовые вершины
CREATE OR REPLACE FUNCTION leaves()
RETURNS table (id int) AS
$$
SELECT id from emps EXCEPT (SELECT chief FROM emps)
$$
LANGUAGE 'sql' IMMUTABLE;

SELECT * from leaves();


