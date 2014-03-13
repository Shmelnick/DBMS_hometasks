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

select check_anomaly(); 