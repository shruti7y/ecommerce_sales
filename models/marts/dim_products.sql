SELECT
    product_id,
    product_name,
    category,
    price,

    CASE
        WHEN price >= 50000 THEN 'Premium'
        WHEN price >= 10000 THEN 'Mid-Range'
        ELSE 'Budget'
    END AS price_category,

    CASE
        WHEN category = 'Electronics' THEN 'Technology'
        WHEN category = 'Furniture' THEN 'Home & Office'
        ELSE 'Other'
    END AS category_group

FROM {{ ref('stg_products') }}

WHERE product_id IS NOT NULL