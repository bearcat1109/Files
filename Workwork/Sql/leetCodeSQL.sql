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

-- 1193 Monthly Transactions I
SELECT 
    TO_CHAR(trans_date, 'YYYY-MM') AS month,
    country AS,
    COUNT(*) AS trans_count,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount 
FROM transactions
GROUP BY TO_CHAR(trans_date, 'YYYY-MM'), country

-- 1211 Query Qualities and Percentage
SELECT DISTINCT 
    query_name, 
    ROUND(AVG((rating) / position), 2) AS quality,
    ROUND(AVG(CASE WHEN rating < 3 THEN 1 ELSE 0 END) * 100, 2)AS poor_query_percentage
FROM queries
GROUP BY query_name

--1757 Recyclable and Low Fat Products
SELECT product_id
FROM Products 
WHERE low_fats = 'Y' AND recyclable = 'Y';

-- 1633 Percentage of Users Attended a Contest
SELECT contest_id, ROUND(COUNT(r.contest_id) * 100 / (SELECT COUNT(*)
FROM users), 2) percentage
FROM register r GROUP BY contest_id
ORDER BY percentage DESC, contest_id

-- 1075 Project Employees I 
SELECT project_id, ROUND(SUM(experience_years)/COUNT(*),2) AS average_years
FROM project p JOIN employee e ON p.employee_id = e.employee_id
GROUP BY project_id

-- 1251 Average Selling Price
SELECT p.product_id, IFNULL(round(SUM(p.price*u.units)/sum(u.units),2),0) as average_price
FROM Prices p 
LEFT JOIN UnitsSold u
ON p.product_id = u.product_id AND 
u.purchase_date BETWEEN p.Start_date and p.end_date
GROUP BY p.product_id

-- 620 Not Boring Movies
SELECT id, movie, description, rating FROM cinema 
WHERE description != 'boring' AND MOD(id, 2) = 1
ORDER BY rating DESC;

-- 1934 Confirmation Rate
SELECT s.user_id, 
ROUND(AVG(CASE WHEN (c.action = 'confirmed') THEN 1 ELSE 0 END), 2) AS confirmation_rate
FROM signups s LEFT OUTER JOIN confirmations c ON s.user_id = c.user_id 
GROUP BY s.user_id;

-- 570 Managers with at Least Two Reports
SELECT e1.name 
FROM Employee e1 INNER JOIN (SELECT managerId FROM Employee GROUP BY managerId HAVING COUNT(managerId) >= 5) e2 ON e1.id = e2.managerId 

-- 550 Game Play Analysis IV
SELECT ROUND(COUNT(a2.player_id) / COUNT(a1.player_id), 2) AS fraction
FROM Activity a1 LEFT OUTER JOIN Activity a2
   ON a2.player_id = a1.player_id AND a2.event_date = a1.event_date + 1
WHERE (a1.player_id, a1.event_date) IN (SELECT player_id, MIN(event_date)
  FROM Activity GROUP BY player_id);

-- 2356 Number of Unique Subjects Taught by Each Teacher
SELECT teacher_id, 
       COUNT(DISTINCT subject_id) cnt 
FROM teacher
GROUP BY teacher_id;

-- 1141 User Activity for the Past 30 Days I 
SELECT TO_CHAR(activity_date, 'YYYY-MM-DD') AS day,
       COUNT(DISTINCT user_id) AS active_users
FROM activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date

-- 1070 Product Sales Analysis III
SELECT s.product_id,
       s.year first_year,
       s.quantity,
       s.price
FROM sales s JOIN (SELECT product_id, MIN(year) AS year from sales GROUP BY product_id) s2
ON s.product_id = s2.product_id AND s.year = s2.year;

-- 596 Classes more than 5 students
SELECT class
FROM courses
GROUP BY class HAVING COUNT(student) >= 5;


