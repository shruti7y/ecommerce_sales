SELECT
    customer_id,
    TRIM(customer_name) AS customer_name,
    LOWER(TRIM(email)) AS email,
    TRIM(city) AS city,
    CASE
        WHEN UPPER(TRIM(country)) = 'UK'
            THEN 'United Kingdom'
        WHEN UPPER(TRIM(country)) = 'USA'
            THEN 'United States'
        WHEN UPPER(TRIM(country)) = 'INDIA'
            THEN 'India'
        ELSE TRIM(country)
    END AS country,
    CAST(signup_date AS DATE) AS signup_date,

    EXTRACT(YEAR FROM signup_date) AS signup_year,

    EXTRACT(MONTH FROM signup_date) AS signup_month,

    CASE
        WHEN UPPER(TRIM(country)) = 'INDIA'
            THEN 'ASIA'
        WHEN UPPER(TRIM(country)) = 'UK'
            THEN 'Europe'
        WHEN UPPER(TRIM(country)) = 'USA'
            THEN 'North America'
        ELSE 'Other'
    END AS region,

    DATE_DIFF(
        CURRENT_DATE(),
        CAST(signup_date AS DATE),
        MONTH
    ) AS customer_tenure_months

FROM {{ ref('stg_customers') }}

WHERE customer_id IS NOT NULL