WITH RECURSIVE fun(id, chief) AS (
	SELECT id, chief FROM emps WHERE chief IS NULL
  UNION 
	SELECT emps.id, emps.chief FROM emps, fun f
	WHERE f.id = emps.chief
	)
SELECT * from fun
