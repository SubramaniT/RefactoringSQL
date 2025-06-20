with b as (

select Orders.ID as order_id,
    Orders.USER_ID	as customer_id,
    Orders.ORDER_DATE AS order_placed_at,
        Orders.STATUS AS order_status,
    p.total_amount_paid,
    p.payment_finalized_date,
    C.FIRST_NAME    as customer_first_name,
        C.LAST_NAME as customer_last_name
FROM {{ ref('stg_jaffleshop__orders') }} as Orders
left join (select ORDERID as order_id, max(CREATED) as payment_finalized_date, sum(AMOUNT) / 100.0 as total_amount_paid
        from {{ ref('stg_stripe__payment') }}
        where STATUS <> 'fail'
        group by 1) p ON orders.ID = p.order_id
left join {{ ref('stg_jaffleshop__customers') }} C on orders.USER_ID = C.ID
)

select * from b 