select
    s.date_date,
    s.orders_id,
    s.product_id,
    s.quantity,
    s.revenue,
    p.purchase_price,
    s.quantity * p.purchase_price as purchase_cost,
    s.revenue - (s.quantity * p.purchase_price) as margin
from {{ source('stg_gz_raw_data', 'sales') }} s
left join {{ source('stg_gz_raw_data', 'product') }} p
    on s.product_id = p.products_id




