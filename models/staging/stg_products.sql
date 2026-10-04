SELECT
    product_id,
    TRIM(product_name) AS product_name,
    TRIM(category) AS category,
    CAST(price AS NUMERIC) AS price
FROM {{ source("ecommerce_raw", "products") }}