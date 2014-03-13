--Вывод пути между сотрудниками
CREATE OR REPLACE FUNCTION path(IN integer, IN integer)
RETURNS TABLE(id integer) AS
$$ 
DECLARE
input_id1 ALIAS FOR $1;--от
input_id2 ALIAS FOR $2;--до
rec RECORD;
id1 int;
id2 int;
b boolean;
temp int;--здесь хранится последний общий для деревьев узел 
cur1 SCROLL CURSOR for select * from hierarchy(input_id1);
cur2 SCROLL CURSOR for select * from hierarchy(input_id2);
BEGIN
OPEN cur1;
OPEN cur2;
--Строим пути от сотрудника к вершине иерархии
MOVE LAST from cur1;
MOVE LAST from cur2;
--Будем спускаться по обоим деревьям вниз до первого расхождения
id1 = 0;--условно 0 = id корня 
b = TRUE;
WHILE b = TRUE
	LOOP
	temp = id1;
	FETCH PRIOR FROM cur1 INTO id1;
	FETCH PRIOR FROM cur2 INTO id2;
	IF (id1!=id2 OR id1 IS NULL) THEN b = FALSE; END IF;
	END LOOP;
--Теперь выписываем путь от 1го сотрудника до места расхождения
MOVE absolute 0 from cur1;
b = TRUE;
WHILE b = TRUE
	LOOP
	FETCH NEXT FROM cur1 INTO id;
	IF id = temp THEN b = FALSE; END IF;--включая точку расхождения
	RETURN next;
	END LOOP;
--Дописываем путь от места расхождения до 2го сотрудника
id = id2;
WHILE id IS NOT NULL --для этого пометили курсор SCROLL
	LOOP
	RETURN next;
	FETCH PRIOR FROM cur2 INTO id;
	END LOOP;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

--Немножно модифицированная ф-ция из задания5, дописывающая в вершину иерархии 0
CREATE OR REPLACE FUNCTION hierarchy(e_id int)
RETURNS table (_id int) AS
$$
BEGIN
RETURN query
WITH RECURSIVE h_rec(id, chief) AS (
	SELECT id, chief FROM emps WHERE id = e_id
  UNION 
	SELECT emps.id, emps.chief FROM emps, h_rec f
	WHERE emps.id = f.chief)
SELECT id from h_rec;
_id = 0;
RETURN next;
END
$$
LANGUAGE 'plpgsql' VOLATILE;

SELECT * from path(1, 5);