SELECT
    order_id,
    customer_id,
    product_id,
    CAST(order_date AS DATE) AS order_date,
    CAST(quantity AS INT64) AS quantity,
    CAST(amount AS NUMERIC) AS amount,
    TRIM(status) AS status

FROM {{ source("ecommerce_raw", "orders") }}