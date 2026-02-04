select
    s.orders_id,
    s.product_id,
    s.quantity,
    s.revenue,
    p.purchase_price,
    s.quantity * p.purchase_price as purchase_cost,
    s.revenue - (s.quantity * p.purchase_price) as margin

from {{ ref('stg_raw__sales') }} s
left join {{ ref('stg_raw__product') }} p
    on s.product_id = p.product_id
