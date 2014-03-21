--Добавлена процедура check_tree() для проверки цикличности

--Возможная аномалия - несколько руководителей отделов
--(Ситуация: при переводе сотрудника в другой отдел всё поддерево добавляется в его корень)
--Выводится таблица ошибок
CREATE OR REPLACE FUNCTION check_anomaly()
RETURNS table(str varchar(80)) AS
$$ 
DECLARE 
	rec RECORD;
BEGIN
FOR rec IN 
	(SELECT emps.dept FROM emps WHERE chief IS NULL GROUP BY emps.dept HAVING count(*)>1)
LOOP
	str = 'Ошибка в отделе ' || rec.dept;
	RETURN next;
END LOOP;

END
$$
LANGUAGE 'plpgsql' IMMUTABLE;

--рекурсивный проход по дереву
--Вершины, не задействованные в проходе, и только они участвуют в сторонних циклах
--Вывод - такие вершины
CREATE OR REPLACE FUNCTION check_tree()
RETURNS table(ids_in_cycles int) AS
$$
BEGIN
RETURN query
WITH RECURSIVE collect_main_tree_ids(id) AS (
	SELECT id FROM emps WHERE chief IS NULL
  UNION 
	SELECT emps.id FROM emps, collect_main_tree_ids f
	WHERE f.id = emps.chief
	)
SELECT id FROM emps EXCEPT (SELECT id FROM collect_main_tree_ids);
END
$$
LANGUAGE 'plpgsql' IMMUTABLE;

--select * from check_anomaly();
select * from check_tree(); 