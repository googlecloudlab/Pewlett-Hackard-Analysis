-- create a Retirement Titles table for employees 
-- who are born between January 1, 1952 and December 31, 1955
SELECT e.emp_no, 
       e.first_name, 
	   e.last_name, 
	   t.title, 
	   t.from_date, 
	   t.to_date
INTO retirement_titles
FROM employees as e
LEFT JOIN titles as t
ON e.emp_no = t.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31');

-- create a Unique Titles table that contains 
-- the employee number, first and last name, 
-- and most recent title.
SELECT DISTINCT ON (emp_no) emp_no, 
                   first_name, 
				   last_name, 
				   title
INTO unique_titles
FROM retirement_titles
WHERE to_date = ('9999-01-01')
ORDER BY emp_no ASC, to_date DESC;

-- create a Retiring Titles table that contains the number 
-- of titles filled by employees who are retiring
SELECT COUNT (title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC

-- create a Mentorship Eligibility table for current employees 
-- who were born between January 1, 1965 and December 31, 1965
SELECT DISTINCT ON (e.emp_no) e.emp_no, 
                   e.first_name, 
				   e.last_name, 
				   e. birth_date,
				   de.from_date,
				   de.to_date,
				   t.title
INTO mentorship_eligibility
FROM employees as e
LEFT JOIN dept_employee AS de
ON e.emp_no = de.emp_no
LEFT JOIN titles as t
ON e.emp_no = t.emp_no
WHERE (de.to_date = '9999-01-01')
AND (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no ASC; 

SELECT COUNT(*) FROM unique_titles;
SELECT COUNT(*) FROM mentorship_eligibility;

-- create a Titles of mentorship eligible employees table 
-- that contains the number of title of employees 
-- who are eligible for mentorship
SELECT COUNT (title), title
FROM mentorship_eligibility
GROUP BY title
ORDER BY count DESC


-- Mentorship Eligible Employee count by department
SELECT COUNT(me.emp_no), d.dept_name
FROM mentorship_eligibility as me
LEFT JOIN dept_employee as de
ON me.emp_no = de.emp_no
LEFT JOIN departments as d
ON de.dept_no = d.dept_no
GROUP BY d.dept_name
ORDER BY count DESC;