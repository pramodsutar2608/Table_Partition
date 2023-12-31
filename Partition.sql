================================================================================

                                    PARTITION

================================================================================

Types of Partition:

i)  Range Partition	:  										
ii) List Partition	: 										
iii)Hash partition	: 

-----------------------------
i)  Range Partition	:  

If you have data in specific range, you can use range partition.
For Ex:

EMP:-- partition will be on only table:

1000 to 5000 -- P1
5001 to 10000 -- P2
10001 to 20000 -- P3

If you have data of Salary of 1000 employee & salary from 1000 to 3000,
then you can use range of less than 1000, Less than 2000,less than 3000.

E.g.

CREATE TABLE part (
    empno NUMBER(10),
    ename VARCHAR2(20),
    job VARCHAR2(10),
    mgr NUMBER(10),
    hiredate DATE,
    sal NUMBER(10),
    comm NUMBER(10),
    deptno NUMBER(10),
    email VARCHAR2(20)
)
PARTITION BY RANGE (sal)
--INTERVAL (5000) -- optional
(
    PARTITION P1 VALUES LESS THAN (5000),
    PARTITION P2 VALUES LESS THAN (10000),
    PARTITION P3 VALUES LESS THAN (15000),
    PARTITION P4 VALUES LESS THAN (20000)
)
ENABLE ROW MOVEMENT; -- optional

ALTER TABLE part
ADD PARTITION P5 VALUES LESS THAN (25000);

--When you are using Interval in query, you are not allowed to add partition after
--creation of table.

-- Inserting 10 records into the "part" table
BEGIN
  INSERT INTO part (empno, ename, job, mgr, hiredate, sal, comm, deptno, email)
  VALUES (1, 'John', 'Manager', 101, TO_DATE('2023-01-01', 'YYYY-MM-DD'), 4500, 500, 10, 'john@example.com');

  INSERT INTO part (empno, ename, job, mgr, hiredate, sal, comm, deptno, email)
  VALUES (2, 'Jane', 'Analyst', 102, TO_DATE('2023-02-15', 'YYYY-MM-DD'), 8000, 600, 20, 'jane@example.com');

  INSERT INTO part (empno, ename, job, mgr, hiredate, sal, comm, deptno, email)
  VALUES (3, 'Bob', 'Developer', 103, TO_DATE('2023-03-20', 'YYYY-MM-DD'), 12000, 700, 30, 'bob@example.com');

  INSERT INTO part (empno, ename, job, mgr, hiredate, sal, comm, deptno, email)
  VALUES (4, 'Alice', 'Manager', 104, TO_DATE('2023-04-10', 'YYYY-MM-DD'), 16000, 800, 10, 'alice@example.com');

  INSERT INTO part (empno, ename, job, mgr, hiredate, sal, comm, deptno, email)
  VALUES (5, 'Charlie', 'Analyst', 105, TO_DATE('2023-05-05', 'YYYY-MM-DD'), 20000, 900, 20, 'charlie@example.com');

  INSERT INTO part (empno, ename, job, mgr, hiredate, sal, comm, deptno, email)
  VALUES (6, 'David', 'Developer', 106, TO_DATE('2023-06-15', 'YYYY-MM-DD'), 2500, 550, 30, 'david@example.com');

  INSERT INTO part (empno, ename, job, mgr, hiredate, sal, comm, deptno, email)
  VALUES (7, 'Eva', 'Manager', 107, TO_DATE('2023-07-25', 'YYYY-MM-DD'), 6000, 650, 10, 'eva@example.com');

  INSERT INTO part (empno, ename, job, mgr, hiredate, sal, comm, deptno, email)
  VALUES (8, 'Frank', 'Analyst', 108, TO_DATE('2023-08-30', 'YYYY-MM-DD'), 10000, 750, 20, 'frank@example.com');

  INSERT INTO part (empno, ename, job, mgr, hiredate, sal, comm, deptno, email)
  VALUES (9, 'Grace', 'Developer', 109, TO_DATE('2023-09-05', 'YYYY-MM-DD'), 14000, 850, 30, 'grace@example.com');

  INSERT INTO part (empno, ename, job, mgr, hiredate, sal, comm, deptno, email)
  VALUES (10, 'Henry', 'Manager', 110, TO_DATE('2023-10-10', 'YYYY-MM-DD'), 18000, 950, 10, 'henry@example.com');

  COMMIT;
END;


select * from part order by sal;

--------------------------------------------------------------------------------
Retrieve data from specific Paartition

select * from part
partition(P1);

select * from part
partition(P2);

select * from part
partition(P5);

--------------------------------------------------------------------------------
Spliting Partition

alter table part
split partition P1 at (2500)
into (partition P1a,partition P1b);

select * from part
partition (P1a);

select * from part
partition (P1b);

-------------------------------------------------------------------------------

Merging the Partition

Alter table part
merge partitions P1a,P1b
into partition P1;

select * from part
partition (P1);

-------------------------------------------------------------------------------

Rename Partition

Alter table part
rename partition P3 to P3a;

select * from part
partition (P3);
-------------------------------------------------------------------------------

Delete/Truncate/Drop records from Partition

delete from part
partition(P5);

select * from part
partition(P5);

Alter table part
truncate partition (P1);

select * from part
partition(P1);


================================================================================

2) List Partition :

If you have data in specific List, you can use List partition. 
For ex If you have data of 1000 employee of different dept no then you can use List partition dept wise.

e.g.

CREATE TABLE part1 (
    empno  NUMBER(10),
    ename  VARCHAR2(20),
    deptno NUMBER(10)
)
PARTITION BY LIST ( deptno ) 
( PARTITION p1 VALUES ( 10 ),
PARTITION p2 VALUES ( 20 ),
PARTITION p3 VALUES ( 30 )
        )
    ENABLE ROW MOVEMENT;
    


CREATE TABLE part2(empno Number(10),ename Varchar2(20),Deptno Number(10),month varchar2(10)) 
                 PARTITION BY LIST (month)
		(Partition p1 Values ('JAN','FEB','MAR'),
         Partition p2 Values ('APR','MAY','JUN'),						  	
  		 Partition p3 Values ('JUL','AUG','SEP'),
         Partition p4 Values ('OCT','NOV','DEC')
		)			
		ENABLE ROW MOVEMENT;	


================================================================================

3) Hash Partition : 

We have to specify no of partitions we want to create for the available data then 
oracle will divide data into that no of partition.

CREATE TABLE part3 (empno Number(10),ename Varchar2(20),Deptno Number(10)) 
                  PARTITION BY HASH (empno)							
                  PARTITIONS 5 
            ENABLE ROW MOVEMENT;

================================================================================





















--Delete Duplicate Records

create table delDup
as select * from emp1;

insert into delDup
select * from emp1;

select * from delDup
order by empno; 

select empno,rowid from delDup
group by empno,rowid;

select empno,max(rowid) from delDup
                    group by empno;

delete from delDup
where rowid not in (select max(rowid) from delDup
                    group by empno); 

--------------------------------------------------------------------------------