# Overview 
-- total rows
select 'orders' table_name, count(*) total_rows from `E_Commerce_DQLab.orders`
union all
select 'order_details' table_name, count(*) total_rows from `E_Commerce_DQLab.order_details`
union all
select 'products' table_name, count(*) total_rows from `E_Commerce_DQLab.products`
union all
select 'users' table_name, count(*) total_rows from `E_Commerce_DQLab.users`
order by 1 asc;

-- Missing Values (MV)
select 'orders' table_name,count(*) MV from `E_Commerce_DQLab.orders`
where 'orders' = 'NA'

union all

select 'order_details' table_name, count(*) MV from `E_Commerce_DQLab.order_details`
where 'order_details' = 'NA'

union all

select 'products' table_name, count(*) MV from `E_Commerce_DQLab.products`
where 'products' ='NA'

union all

select 'users'table_name, count(*) MV from `E_Commerce_DQLab.users`
where 'users' = 'NA'
order by 1 asc;

#Unique variable
-- table products
select distinct category from `E_Commerce_DQLab.products` 
order by 1 asc;
select count(distinct category) count_cat from `E_Commerce_DQLab.products`;

-- table users
select count(distinct user_id) count_user_id from `E_Commerce_DQLab.users`;

#Project Task
-- 1. Transaksi Bulanan
select substr(format_date("%Y-%m", created_at),1,7) years_month, count(1) count_transaction 
from `E_Commerce_DQLab.orders`
group by 1
order by 1 asc;

-- 2.Status Transaksi
-- transaksi tidak dibayar
select count(paid_at) count_cancel_transaction from `E_Commerce_DQLab.orders`
where paid_at = 'NA';
-- transaksi sudah dibayar dengan product yang belum terkirim 
select count(delivery_at) Processing from `E_Commerce_DQLab.orders`
where paid_at != 'NA' and delivery_at ='NA';
-- total produk belum terkirim dengan semua kondisi
select count(delivery_at) Total_not_delivery from `E_Commerce_DQLab.orders`
where delivery_at = 'NA';
-- transaksi yang dikirim hari yang sama dengan pembayaran
select count(delivery_at) fast_delivery_service_case from `E_Commerce_DQLab.orders`
where paid_at =delivery_at;

-- 3.Pengguna bertransaksi
-- total pengguna
select count(distinct user_id) total_users from `E_Commerce_DQLab.users`;
-- pengguna yang pernah bertransaksi sebagai pembeli
select count(distinct buyer_id) count_buyer from `E_Commerce_DQLab.orders`;
-- pengguna yang pernah bertransaksi sebagai penjual
select count(distinct seller_id) count_seller from `E_Commerce_DQLab.orders`;
-- pengguna yang pernah bertransaksi sebagai pembeli dan pernah sebagai penjual
select count(distinct seller_id) user_as_seller_buyer from `E_Commerce_DQLab.orders`
where seller_id in (
  select buyer_id from `E_Commerce_DQLab.orders`);
-- pengguna yang tidak pernah bertransaksi sebagai pembeli dan penjual
select count(a.user_id) non_active_user from `E_Commerce_DQLab.users` a
join `E_Commerce_DQLab.orders` b on a.user_id = b.buyer_id 
where a.user_id != b.seller_id and a.user_id != b.buyer_id;

-- 4.Top buyer all time
select
  a.user_id,
  a.nama_user
from (
  select 
    a.user_id,
    a.nama_user,
    sum(b.total)
  from `E_Commerce_DQLab.users` a
  join `E_Commerce_DQLab.orders` b on a.user_id = b.buyer_id
  group by 1,2
  order by 3 desc
) a limit 5;

-- 5. Frequent Buyer
select
  a.user_id,
  a.nama_user
from (
  select 
    a.user_id,
    a.nama_user,
    count(b.order_id)
  from `E_Commerce_DQLab.users` a
  join `E_Commerce_DQLab.orders` b on a.user_id = b.buyer_id
  where subtotal = total
  group by 1,2
  order by 3 desc
) a limit 5;

--6.Big Frequent Buyer 2020

select a.user_id, a.email
from (
    select a.user_id, a.email, count(distinct extract(MONTH from b.created_at))  total_monthly_transactions, avg(b.total) avg_amount
    from `E_Commerce_DQLab.users` a
    join `E_Commerce_DQLab.orders` b on a.user_id = b.buyer_id
    where extract(YEAR from b.created_at) = 2020
    group by 1, 2
    having total_monthly_transactions >= 5 and avg_amount > 1000000
    order by 4 desc
) a
limit 5;

-- 7.Domain email dari penjual
select
  distinct substr(email, instr(a.email, '@') + 1) domain
from `E_Commerce_DQLab.users`a
join `E_Commerce_DQLab.orders`b on a.user_id = b.seller_id
where a.user_id in (select b.seller_id from `E_Commerce_DQLab.orders`b)
order by 1 asc;

-- 8. Top 5 product desember 2019
select 
  c.desc_product,
  sum(b.quantity) total_quantity
from `E_Commerce_DQLab.orders`a
join `E_Commerce_DQLab.order_details`b on a.order_id = b.order_id
join `E_Commerce_DQLab.products`c on b.product_id = c.product_id
where created_at between '2019-01-01' and '2019-12-31'
group by 1
order by 2 desc
limit 5;

-- 9. Top 10 transaksi user 12476
select seller_id, buyer_id, total as total_amount, created_at 
from `E_Commerce_DQLab.orders`
where buyer_id = 12476
order by 3 desc
limit 10;

-- 10.Transaksi per bulan
select substr(format_date('%Y-%m', created_at),0,7) as year_month, count(1) as jumlah_transaksi, sum(total) as total_nilai_transaksi
from `E_Commerce_DQLab.orders`
where created_at >= '2020-01-01'
group by 1
order by 1;

-- 11.Pengguna dengan rata-rata transaksi terbesar di Januari 2020
select buyer_id, count(1) as total_transaction, avg(total) as avg_transaction
from `E_Commerce_DQLab.orders`
where created_at>='2020-01-01' and created_at<'2020-02-01'
group by 1
having count(1)>= 2 
order by 3 desc
limit 10;

-- 12. Kategori produk terlaris 2020
select category, sum(quantity) as total_quantity, sum(price) as total_price
from `E_Commerce_DQLab.orders`
inner join `E_Commerce_DQLab.order_details` using(order_id)
inner join `E_Commerce_DQLab.products` using(product_id)
where created_at>='2020-01-01'
and delivery_at is not null
group by 1
order by 2 desc
limit 5;

-- 13. Transaksi besar di Desember 2019
select nama_user as buyer_name, total as total_trasaction, created_at
from `E_Commerce_DQLab.orders`a
inner join `E_Commerce_DQLab.users`b on a.buyer_id = b.user_id
where created_at>='2019-12-01' and created_at<'2020-01-01'
and total >=20000000
order by 1;

-- 14.Mencari pembeli high value
select 
  nama_user,
  count(1) count_trasaction,
  sum(total) total_trasaction,
  min(total) min_trasaction
from `E_Commerce_DQLab.orders` a
inner join `E_Commerce_DQLab.users`b on b.user_id = a.buyer_id
group by user_id,nama_user
having count(1) > 5 and min(total) > 2000000
order by 3 desc;

-- 15.Mencari dropshiper
select 
	b.nama_user,
	count(1) count_trasaction,
	count(distinct a.kodepos) as distinct_kodepos,
	sum(total) as total_transaksi,
	avg(total) as avg_transaksi		
from `E_Commerce_DQLab.orders`a
inner join `E_Commerce_DQLab.users`b on buyer_id=user_id
group by user_id, nama_user
having count(1) >= 10 and count(1) = count(distinct a.kodepos)
order by 2 desc;

-- 16. Mencari reseller offline
select
	b.nama_user,
	count(1) as count_transaksi,
	sum(a.total) as total_transaksi,
	avg(a.total) as avg_transaksi,
	avg(total_quantity) as avg_quantity_per_transaksi
from `E_Commerce_DQLab.orders`a
inner join `E_Commerce_DQLab.users`b
on buyer_id = user_id
inner join (select c.order_id, 
			sum(c.quantity) as total_quantity 
			from `E_Commerce_DQLab.order_details` c
			group by 1
		   ) as summary_order
using(order_id)
where b.kodepos = a.kodepos
group by b.nama_user,b.user_id
having count(1)>= 8 and avg(total_quantity)> 10
order by 3 desc;
