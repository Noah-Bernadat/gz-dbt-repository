select
    s.date_date,
    s.orders_id,
    s.product_id,
    s.quantity,
    s.revenue,
    p.purchase_price,
    s.quantity * p.purchase_price as purchase_cost,
    s.revenue - (s.quantity * p.purchase_price) as margin
from {{ ('stg_gz_raw_data__sales') }} As s
left join {{ ('stg_gz_raw_data__product') }} As p
    on s.product_id = p.products_id;




