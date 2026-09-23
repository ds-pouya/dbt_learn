WITH ORDERS AS (
    SELECT order_id AS ORDERID, customer_id
    FROM {{ ref('stg_jaffle_shop__orders') }}
),
PAYMENTS AS (
    SELECT ORDERID, AMOUNT
    FROM {{ ref('stg_stripe__payments') }}
)
SELECT
    ORDERID AS order_id,
    customer_id,
    AMOUNT as amount
FROM PAYMENTS
LEFT JOIN ORDERS USING (ORDERID)