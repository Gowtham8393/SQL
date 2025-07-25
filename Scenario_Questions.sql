-- Create Table Statement for tbl_employee
CREATE TABLE tgt.tbl_employee (
    employee_id INT PRIMARY KEY,
    name VARCHAR(255),
    salary INT,
    department_id INT,
    manager_id INT
);

-- Insert Statements for tbl_employee
INSERT INTO tgt.tbl_employee (employee_id, name, salary, department_id, manager_id) VALUES
(1, 'Ketan', 10000, 1, 5),
(2, 'Mitesh', 20000, 1, 5),
(3, 'Pankaj', 30000, 1, 5),
(4, 'Kaushik', 40000, 1, 5),
(5, 'Manoj', 60000, 1, NULL),
(6, 'Bhavik', 80000, 1, 5),
(7, 'Sachin', 11000, 2, 10),
(8, 'Vijay', 21000, 2, 10),
(9, 'Sandeep', 31000, 2, 10),
(10, 'Vinay', 41000, 2, NULL),
(11, 'Kirit', 51000, 2, 10),
(12, 'Karthik', 5000, 4, NULL),
(13, 'Bhargav', 5000, 4, NULL);

-- Create Table Statement for tbl_department
CREATE TABLE tgt.tbl_department (
    department_id INT PRIMARY KEY,
    name VARCHAR(255)
);

-- Insert Statements for tbl_department
INSERT INTO tgt.tbl_department (department_id, name) VALUES
(1, 'HOME_LOAN'),
(2, 'COMMERCIAL_LOAN'),
(3, 'GOLD_LOAN'),
(4, 'INDUSTRIAL_LOAN');

--Bucket employee into salary range
SELECT 
    CASE 
        WHEN salary < 30000 THEN 'Below 20,000'
        WHEN salary BETWEEN 20000 AND 50000 THEN 'Between 20,000-50,000'
        ELSE 'Above 50,000'
    END AS salary_range,
    COUNT(*) AS employee_count
FROM tbl_employee
GROUP BY salary_range;

--Number of employees in each department
SELECT d.name AS department_name, COUNT(e.employee_id) AS employee_count
FROM tbl_department d
LEFT JOIN tbl_employee e ON d.department_id = e.department_id
GROUP BY d.name;

--List department with no employee
SELECT d.department_id, d.name AS department_name
FROM tbl_department d
LEFT JOIN tbl_employee e ON d.department_id = e.department_id
WHERE e.department_id IS NULL;

--Find all employees whose salary is greater than the average salary.
SELECT name, salary
FROM tbl_employee
WHERE salary > (SELECT AVG(salary) FROM tbl_employee);

--What is second highest salary
SELECT MAX(salary) AS second_highest_salary
FROM tbl_employee
WHERE salary < (SELECT MAX(salary) FROM tbl_employee);

--Find name of employee who is having second highest salary
SELECT 
    name,
    salary
FROM (
    SELECT 
        name,
        salary,
        RANK() OVER (ORDER BY salary DESC) AS salary_rank
    FROM 
        tbl_employee
) AS ranked_salaries
WHERE 
    salary_rank = 2;

--Find employees who earn more than their manager
SELECT e.name AS employee_name, e.salary AS employee_salary, m.name AS manager_name, m.salary AS manager_salary
FROM tbl_employee e
JOIN tbl_employee m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;

--Deleting duplicate record by employee name
DELETE t1
FROM tbl_employee t1
JOIN tbl_employee t2
ON t1.name = t2.name 
   AND t1.id > t2.id;

--Percentage of salary paid to each employee over the total salary paid in their department
SELECT 
    employee_id,
    name,
    department_id,
    salary,
    (salary / SUM(salary) OVER (PARTITION BY department_id)) * 100 AS salary_percentage
FROM 
    tbl_employee;

--Find pairs of employees in the same department who have the same salary.
SELECT e1.name AS employee_1, e2.name AS employee_2, e1.salary
FROM tbl_employee e1
JOIN tbl_employee e2 ON e1.salary = e2.salary AND e1.department_id = e2.department_id
WHERE e1.employee_id < e2.employee_id;

--Find the employee with the highest salary in each department
SELECT 
    department_id,
    employee_id,
    name,
    salary
FROM (
    SELECT 
        department_id,
        employee_id,
        name,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
    FROM 
        tbl_employee
) AS ranked_salaries
WHERE 
    rn = 1;

--Rank employees within each department by their salary from highest to lowest.
SELECT 
    department_id,
    employee_id,
    name,
    salary,
    RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM 
    tbl_employee;
