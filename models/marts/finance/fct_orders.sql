WITH ORDERS AS (
    SELECT *
    FROM {{ ref('stg_jaffle_shop__orders') }}
),
PAYMENTS AS (
    SELECT * FROM {{ ref('stg_stripe__payments') }}
),
ORDER_PAYMENTS AS (
    SELECT order_id, SUM(CASE WHEN payment_status = 'success' then payment_amount end) as amount
    FROM PAYMENTS
    GROUP BY 1
)
SELECT
    ORDERS.order_id,
    ORDERS.customer_id,
    ORDERS.order_date,
    coalesce(ORDER_PAYMENTS.amount, 0) as amount
FROM ORDERS
LEFT JOIN ORDER_PAYMENTS USING (order_id)