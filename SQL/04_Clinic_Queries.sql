-- Q1: Revenue by Channel

SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel;


-- Q2: Repeat customers

SELECT 
    cs.uid,
    c.name,
    SUM(cs.amount) AS total_spent
FROM clinic_sales cs
JOIN customer c ON cs.uid = c.uid
WHERE YEAR(cs.datetime) = 2021
GROUP BY cs.uid, c.name
ORDER BY total_spent DESC
LIMIT 10;


-- Q3: Profit/Loss by month

WITH rev AS (
    SELECT 
        DATE_FORMAT(datetime, '%Y-%m') AS month,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY month
),
exp AS (
    SELECT 
        DATE_FORMAT(datetime, '%Y-%m') AS month,
        SUM(amount) AS expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY month
)
SELECT 
    r.month,
    r.revenue,
    e.expense,
    (r.revenue - e.expense) AS profit,
    CASE 
        WHEN (r.revenue - e.expense) > 0 THEN 'Profitable'
        ELSE 'Not-Profitable'
    END AS status
FROM rev r
LEFT JOIN exp e ON r.month = e.month
ORDER BY r.month;


-- Q4 For each city, find the most profitable clinic for a given month

WITH rev AS (
    SELECT 
        cid,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE DATE_FORMAT(datetime, '%Y-%m') = '2021-09'
    GROUP BY cid
),
exp AS (
    SELECT 
        cid,
        SUM(amount) AS expense
    FROM expenses
    WHERE DATE_FORMAT(datetime, '%Y-%m') = '2021-09'
    GROUP BY cid
),
profit AS (
    SELECT 
        c.cid,
        c.clinic_name,
        c.city,
        COALESCE(r.revenue, 0) AS revenue,
        COALESCE(e.expense, 0) AS expense,
        COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit
    FROM clinics c
    LEFT JOIN rev r ON c.cid = r.cid
    LEFT JOIN exp e ON c.cid = e.cid
),
ranked AS (
    SELECT 
        *,
        RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rank_in_city
    FROM profit
)
SELECT 
    city,
    cid,
    clinic_name,
    profit
FROM ranked
WHERE rank_in_city = 1;

-- Q5: For each state, find the second least profitable clinic for a given month

WITH rev AS (
    SELECT 
        cid,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE DATE_FORMAT(datetime, '%Y-%m') = '2021-09'
    GROUP BY cid
),
exp AS (
    SELECT 
        cid,
        SUM(amount) AS expense
    FROM expenses
    WHERE DATE_FORMAT(datetime, '%Y-%m') = '2021-09'
    GROUP BY cid
),
profit AS (
    SELECT 
        c.cid,
        c.clinic_name,
        c.state,
        COALESCE(r.revenue, 0) AS revenue,
        COALESCE(e.expense, 0) AS expense,
        COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit
    FROM clinics c
    LEFT JOIN rev r ON c.cid = r.cid
    LEFT JOIN exp e ON c.cid = e.cid
),
ranked AS (
    SELECT 
        *,
        DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS rank_in_state
    FROM profit
)

SELECT 
    state,
    cid,
    clinic_name,
    profit
FROM ranked
WHERE rank_in_state = 2;
