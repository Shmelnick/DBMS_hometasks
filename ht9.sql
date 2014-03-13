--Возвращает таблицу (id, глубина) для поддерева
CREATE OR REPLACE FUNCTION fun13(IN integer, IN integer)
RETURNS TABLE(id integer, dep integer) AS
$$ 
DECLARE
input_id ALIAS FOR $1;--на вход - корень поддерева
input_dep ALIAS FOR $2;-- глубина корня
rec RECORD;
BEGIN
IF input_dep = 0 THEN
FOR rec IN select emps.id from emps WHERE chief IS NULL
	LOOP
	id = rec.id;
	dep = 1;
	return next;--возврат корня
	return query select * from fun13(id, dep);--рекурсивный обход поддерева
	END LOOP;
ELSE
FOR rec IN (select emps.id from emps WHERE chief = input_id)
	LOOP
	id = rec.id;
	dep = input_dep + 1;
	return next;
	return query select * from fun13(id, dep); 
	END LOOP;
END IF;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;
  
--По таблице (id, глубина) рисует иерархию
CREATE OR REPLACE FUNCTION drawTree()
RETURNS table(inf varchar(80)) AS
$$
DECLARE
rec RECORD;
cur1 CURSOR for select * from fun13(-1, 0);
id integer;
dep integer;
BEGIN
FOR rec IN cur1
	LOOP
	inf = '';
	FOR i IN 1..rec.dep
		LOOP
		inf = inf || ' ';
		END LOOP;
	inf = inf || rec.id;
	RETURN next;
	END LOOP;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

select * from drawTree()