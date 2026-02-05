SELECT
    s.product_id,
    s.date_date,
    s.orders_id,
    s.revenue,
    s.quantity,
    p.purchase_price,
    ROUND(s.quantity * p.purchase_price, 2) AS purchase_cost,
    ROUND(s.revenue - (s.quantity * p.purchase_price), 2) AS margin
FROM {{ ref('stg_gz_raw_data__sales') }} AS s
LEFT JOIN {{ ref('stg_gz_raw_data__product') }} AS p
    ON p.products_id = s.product_id





