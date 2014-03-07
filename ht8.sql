--Рекурсивный обход вширь, для каждого сотрудника выводится ранг
WITH RECURSIVE rank_rec(id, chief, rank) AS (
	SELECT id, chief, 1 FROM emps WHERE chief IS NULL
  UNION 
	SELECT emps.id, emps.chief, f.rank+1 FROM emps, rank_rec f
	WHERE f.id = emps.chief
	)
SELECT id, rank FROM rank_rec
