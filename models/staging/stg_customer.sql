select * from {{ source("ecommerce_raw", "customers") }}
