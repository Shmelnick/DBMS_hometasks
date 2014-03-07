CREATE TABLE emps
(
  id		serial		PRIMARY KEY 	CHECK (id > 0),
  emp_name	varchar(80)	NOT NULL,
  dept 		integer 	NOT NULL 	CHECK (dept > 0),
  chief 	integer 	REFERENCES emps(id)
)