{{ 
  config(
    materialized='table'
  ) 
}}

WITH orders_with_revenue AS (
    SELECT
        io.date_date,
        io.orders_id,
        io.operational_margin,
        io.purchase_cost,
        io.quantity,
        SUM(COALESCE(s.revenue, 0)) AS total_revenue
    FROM {{ ref('int_orders_operational') }} AS io
    LEFT JOIN {{ ref('int_sales_margin') }} AS s
      ON io.orders_id = s.orders_id
    GROUP BY io.date_date, io.orders_id, io.operational_margin, io.purchase_cost, io.quantity
),

orders_with_shipping AS (
    SELECT
        owr.*,
        SUM(COALESCE(ship.shipping_fee, 0)) AS total_shipping_fees,
        SUM(COALESCE(ship.logcost, 0)) AS total_log_costs
    FROM orders_with_revenue AS owr
    LEFT JOIN {{ ref('stg_gz_raw_data__ship') }} AS ship
      ON owr.orders_id = ship.orders_id
    GROUP BY owr.date_date, owr.orders_id, owr.operational_margin, owr.purchase_cost, owr.quantity, owr.total_revenue
),

daily_aggregation AS (
    SELECT
        date_date AS date,
        COUNT(DISTINCT orders_id) AS total_transactions,
        ROUND(SUM(total_revenue),2) AS total_revenue,
        ROUND(SUM(total_revenue) / NULLIF(COUNT(DISTINCT orders_id),0),2) AS average_basket,
        ROUND(SUM(COALESCE(operational_margin,0)),2) AS operational_margin,
        ROUND(SUM(COALESCE(purchase_cost,0)),2) AS total_purchase_cost,
        ROUND(SUM(total_shipping_fees),2) AS total_shipping_fees,
        ROUND(SUM(total_log_costs),2) AS total_log_costs,
        ROUND(SUM(COALESCE(quantity,0)),2) AS total_quantity_sold
    FROM orders_with_shipping
    GROUP BY date_date
)

SELECT *
FROM daily_aggregation
ORDER BY date




