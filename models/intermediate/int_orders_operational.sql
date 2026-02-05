SELECT
    om.orders_id,
    om.date_date,
    om.quantity,
    om.purchase_cost,
    om.margin,
    ROUND(
        om.margin
        + s.shipping_fee
        - s.logcost
        - s.ship_cost,
        2
    ) AS operational_margin
FROM {{ ref('int_orders_margin') }} AS om
LEFT JOIN {{ ref('stg_gz_raw_data__ship') }} AS s
    ON om.orders_id = s.orders_id



