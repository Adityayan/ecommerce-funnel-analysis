-- Data Validation--

-- 1) STRUCTURE — "What does my data look like?"--
-- What columns exist?
-- What data types do they have?
-- What does one row represent?
-- What are the possible event types? 

SELECT *
FROM `sql-learning-505318.user_event.user_event`
LIMIT 10;
--or 
SELECT DISTINCT event_type
FROM `sql-learning-505318.user_event.user_event`
ORDER BY event_type;

-- 2) COMPLETENESS — "Are important values missing?"--
-- Are there NULLs where they shouldn't be?
SELECT
    COUNT(*) AS total_rows,
    COUNTIF(user_id IS NULL) AS null_user_id,
    COUNTIF(event_type IS NULL) AS null_event_type,
    COUNTIF(event_date IS NULL) AS null_event_date,
    COUNTIF(product_id IS NULL) AS null_product_id,
    COUNTIF(amount IS NULL) AS null_amount
FROM `sql-learning-505318.user_event.user_event`;

-- 3) UNIQUENESS — "Are things that should be unique actually unique?"
-- For example, is event_id unique?
SELECT
    event_id,
    COUNT(*) AS occurrences
FROM `sql-learning-505318.user_event.user_event`
GROUP BY event_id
HAVING COUNT(*) > 1;

-- 4) VALIDITY — "Are values actually allowed?"
SELECT DISTINCT event_type
FROM `sql-learning-505318.user_event.user_event`
WHERE event_type NOT IN (
    'page_view',
    'add_to_cart',
    'checkout_start',
    'payment_info',
    'purchase'
);

-- 5) CONSISTENCY — "Are similar things represented consistently?"
SELECT
    LOWER(TRIM(event_type)) AS normalized_event_type,
    COUNT(*) AS events
FROM `sql-learning-505318.user_event.user_event`
GROUP BY normalized_event_type
ORDER BY events DESC;

-- RELATIONSHIPS / BUSINESS RULES
--Non-purchase events shouldn't have an amount.
SELECT *
FROM `sql-learning-505318.user_event.user_event`
WHERE event_type = 'purchase'
  AND (amount IS NULL OR amount <= 0);



-- True funnel mean
-- A user can only reach Stage N if they completed Stage N−1 before it.
WITH user_stages AS (

    SELECT
        user_id,

        MIN(CASE
            WHEN event_type = 'page_view'
            THEN event_date
        END) AS view_time,

        MIN(CASE
            WHEN event_type = 'add_to_cart'
            THEN event_date
        END) AS cart_time,

        MIN(CASE
            WHEN event_type = 'checkout_start'
            THEN event_date
        END) AS checkout_time,

        MIN(CASE
            WHEN event_type = 'payment_info'
            THEN event_date
        END) AS payment_time,

        MIN(CASE
            WHEN event_type = 'purchase'
            THEN event_date
        END) AS purchase_time

    FROM `sql-learning-505318.user_event.user_event`

    GROUP BY user_id
),

sequential_funnel AS (

    SELECT
        user_id,

        view_time,

        CASE
            WHEN cart_time > view_time
            THEN cart_time
        END AS cart_time,

        CASE
            WHEN cart_time > view_time
             AND checkout_time > cart_time
            THEN checkout_time
        END AS checkout_time,

        CASE
            WHEN cart_time > view_time
             AND checkout_time > cart_time
             AND payment_time > checkout_time
            THEN payment_time
        END AS payment_time,

        CASE
            WHEN cart_time > view_time
             AND checkout_time > cart_time
             AND payment_time > checkout_time
             AND purchase_time > payment_time
            THEN purchase_time
        END AS purchase_time

    FROM user_stages
)
SELECT

    COUNTIF(view_time IS NOT NULL) AS stage_1_views,

    COUNTIF(cart_time IS NOT NULL) AS stage_2_cart,

    COUNTIF(checkout_time IS NOT NULL) AS stage_3_checkout,

    COUNTIF(payment_time IS NOT NULL) AS stage_4_payment,

    COUNTIF(purchase_time IS NOT NULL) AS stage_5_purchase

FROM sequential_funnel;

--- Conversion rate 
