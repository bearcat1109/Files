-- 1280 Students and Examinations
SELECT st.student_id, st.student_name, su.subject_name, COUNT(e.subject_name) AS attended_exams
FROM students st CROSS JOIN subjects su LEFT OUTER JOIN Examinations e 
ON st.student_id = e.student_id AND su.subject_name = e.subject_name
GROUP BY st.student_id, st.student_name, su.subject_name 
ORDER BY st.student_id, su.subject_name;

-- 577 Employee bonus
SELECT e.name, b.bonus FROM Employee e LEFT OUTER JOIN Bonus b ON e.empId = b.empId WHERE b.bonus < 1000 OR b.bonus IS NULL;

-- 1661 Average Time of Process per Machine
SELECT DISTINCT a1.machine_id,
ROUND(AVG(a2.timestamp - a1.timestamp), 3) as processing_time
FROM activity a1 JOIN activity a2 ON a1.process_id = a2.process_id
AND a1.machine_id = a2.machine_id AND a1.timestamp < a2.timestamp
GROUP BY a1.machine_id; 

--197 Rising Temperature
SELECT id FROM 
(SELECT id, temperature, recordDate, 
lag(recordDate) OVER (ORDER BY recordDate) as prevDate,
lag(temperature) OVER (ORDER BY recordDate) as prevTemp 
FROM weather)
WHERE temperature>prevTemp and recordDate-prevDate = 1; 

--1581 Customers who Visited but had no Transations
SELECT customer_id, count(*) AS count_no_trans FROM Visits WHERE visit_id NOT IN (SELECT visit_id FROM Transactions) GROUP BY customer_id

--1068 Product Sales Analysis 1
SELECT DISTINCT product_name, year, price FROM Sales JOIN Product USING(product_id) 

-- 1378 Replace Employee ID with Unique Identifier
SELECT unique_id, name FROM Employees LEFT OUTER JOIN EmployeeUNI USING (id)

-- 1683 Invalid Tweets
SELECT tweet_id FROM Tweets WHERE length(content) > 15;

-- 1148 Article Views I
SELECT DISTINCT author_id id
FROM Views
WHERE author_id = viewer_id
ORDER BY author_id ASC;

-- 595 Big Countries
SELECT 
    world.name name, 
    world.population population,
    world.area area
FROM world
WHERE area >= 3000000 OR population >= 25000000;

-- 584 Find Customer Referree
SELECT name
FROM Customer
WHERE referee_id != 2 OR referee_id IS NULL;

-- 1174 Immediate Food Delivery II  
SELECT ROUND(AVG(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) * 100 , 2) AS immediate_percentage
FROM delivery
WHERE (customer_id, order_date) IN (SELECT customer_id, min(order_date)
FROM delivery GROUP BY customer_id);

--1757 Recyclable and Low Fat Products
SELECT product_id
FROM Products 
WHERE low_fats = 'Y' AND recyclable = 'Y';
