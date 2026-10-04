SELECT
    o.order_id,
    o.order_date,

    o.customer_id,
    c.customer_name,
    c.country,
    c.region,

    o.product_id,
    p.product_name,
    p.category,

    o.quantity,
    o.amount,

    CASE
        WHEN o.status = 'Completed'
            THEN o.amount
        ELSE 0
    END AS completed_amount,

    o.status

FROM {{ ref('stg_orders') }} o

LEFT JOIN {{ ref('dim_customers') }} c
    ON o.customer_id = c.customer_id

LEFT JOIN {{ ref('dim_products') }} p
    ON o.product_id = p.product_id

WHERE o.order_id IS NOT NULL