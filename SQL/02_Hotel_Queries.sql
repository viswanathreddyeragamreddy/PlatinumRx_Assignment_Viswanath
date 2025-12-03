-- Q1: Last booked room

SELECT 
    b.user_id,
    b.room_no,
    b.booking_date
FROM bookings b
JOIN (
    SELECT user_id, MAX(booking_date) AS last_booking
    FROM bookings
    GROUP BY user_id
) lb 
    ON b.user_id = lb.user_id
   AND b.booking_date = lb.last_booking;


-- Q2: Billing in Nov 2021

SELECT 
    bc.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_billing
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE DATE(bc.bill_date) BETWEEN '2021-11-01' AND '2021-11-30'
GROUP BY bc.booking_id;


-- Q3: Bills > 1000

SELECT 
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE DATE(bc.bill_date) BETWEEN '2021-10-01' AND '2021-10-31'
GROUP BY bc.bill_id
HAVING bill_amount > 1000;


-- Q4: Most / Least ordered

WITH monthly_totals AS (
    SELECT 
        DATE_FORMAT(bc.bill_date, '%Y-%m') AS month,
        bc.item_id,
        SUM(bc.item_quantity) AS total_qty
    FROM booking_commercials bc
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY month, bc.item_id
),
ranked AS (
    SELECT 
        month,
        item_id,
        total_qty,
        RANK() OVER (PARTITION BY month ORDER BY total_qty DESC) AS most_rank,
        RANK() OVER (PARTITION BY month ORDER BY total_qty ASC) AS least_rank
    FROM monthly_totals
)
SELECT 
    month,
    item_id,
    total_qty,
    CASE 
        WHEN most_rank = 1 THEN 'Most Ordered'
        WHEN least_rank = 1 THEN 'Least Ordered'
    END AS category
FROM ranked
WHERE most_rank = 1 OR least_rank = 1
ORDER BY month;


-- Q5: 2nd highest bill amount

WITH bill_totals AS (
    SELECT
        bc.bill_id,
        b.user_id,
        DATE_FORMAT(bc.bill_date, '%Y-%m') AS month,
        SUM(bc.item_quantity * i.item_rate) AS bill_amount
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    JOIN bookings b ON bc.booking_id = b.booking_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY bc.bill_id, month, b.user_id
),
ranked AS (
    SELECT 
        month,
        bill_id,
        user_id,
        bill_amount,
        DENSE_RANK() OVER (PARTITION BY month ORDER BY bill_amount DESC) AS bill_rank
    FROM bill_totals
)
SELECT 
    month,
    bill_id,
    user_id,
    bill_amount
FROM ranked
WHERE bill_rank = 2
ORDER BY month;
