CREATE VIEW vw_fato_pedidos AS
SELECT
    o.order_id,
    o.order_status,
    TRY_CONVERT(DATETIME, o.order_purchase_timestamp) AS order_purchase_date,
    TRY_CONVERT(DATETIME, o.order_delivered_customer_date) AS order_delivered_date,
    TRY_CONVERT(DATETIME, o.order_estimated_delivery_date) AS order_estimated_date,

    c.customer_state,
    c.customer_city,

    i.product_id,
    i.price,
    i.freight_value,

    p.payment_type,
    p.payment_installments,
    p.payment_value,

    TRY_CONVERT(INT, r.review_score) AS review_score,

    CASE 
        WHEN TRY_CONVERT(DATETIME, o.order_delivered_customer_date) >
             TRY_CONVERT(DATETIME, o.order_estimated_delivery_date)
        THEN 1 ELSE 0
    END AS atraso
FROM olist_orders o
LEFT JOIN olist_customers c
    ON o.customer_id = c.customer_id
LEFT JOIN olist_order_items i
    ON o.order_id = i.order_id
LEFT JOIN olist_order_payments p
    ON o.order_id = p.order_id
LEFT JOIN olist_order_reviews r
    ON o.order_id = r.order_id;

    SELECT TOP 10 * FROM vw_fato_pedidos;
    SELECT COUNT(*) FROM vw_fato_pedidos;

SELECT SUM(price) AS faturamento_total
FROM vw_fato_pedidos;

SELECT SUM(price) / COUNT(DISTINCT order_id) AS ticket_medio
FROM vw_fato_pedidos;

SELECT AVG(freight_value) AS frete_medio
FROM vw_fato_pedidos;

SELECT 100.0 * SUM(atraso) / COUNT(DISTINCT order_id) AS percentual_atraso
FROM vw_fato_pedidos;

SELECT AVG(review_score) AS avaliacao_media
FROM vw_fato_pedidos;


