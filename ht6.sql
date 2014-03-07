CREATE OR REPLACE FUNCTION emps_amt(d integer)
RETURNS bigint AS
$$
SELECT COUNT(*) FROM emps WHERE dept = d;
$$
LANGUAGE 'sql' IMMUTABLE;

select emps_amt(1) AS tab; 