 
 --case study

	select *
	from order_details

	select *
	from pizza_types

	select *
	from pizzas
	
	select *
	from [orders(1)]

	-- Retrieve the total number of orders placed 
	
	select count(distinct Order_id) as total_number
	from order_details


    --Calculate the total revenue generated from pizza sales
	
	select name , sum(quantity *price)
	from pizza_types
	join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
	join order_details on order_details.pizza_id = pizzas.pizza_id
	group by name

   --Identify the highest-priced pizza  
   
   select top 1 name as pizza_name,sum (price)as price
   from pizza_types
   join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
   group by name
   
   --Identify the most common pizza size ordered

   select  size , count( distinct order_id )as orders , sum (cast (quantity as int )) as quantity
   from order_details
      join pizzas on pizzas.pizza_id = order_details.pizza_id
	 group by size 
	 order by orders

--List the top 5 most ordered pizza size along with their quantities

  select top 5  size , count(quantity) as number_orders
   from pizza_types
   join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
   join order_details on order_details.pizza_id = pizzas.pizza_id
   group by size
   order by number_orders desc

   --List the top 5 most ordered pizza type along with their quantities

    select name , sum (cast(quantity as int)) as quantity
	from pizza_types
   join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
   join order_details on order_details.pizza_id = pizzas.pizza_id
   group by name 
   order by quantity desc

	--   Find the total quantity of each pizza category ordered (this will help us to understand the category which customers prefer the most).
	
	select category , count (distinct order_id) as orders ,sum (cast(quantity as int)) as quantity 
	from order_details
	join pizzas on order_details.pizza_id = pizzas.pizza_id
	join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
	group by category
	order by quantity desc
	
	--Determine the distribution of orders by hour of the day (at which time the orders are maximum (for inventory management and resource allocation).
	
	select DATEPART(hour , time) as hours , count(distinct order_id) as orders
	from [orders(1)]
	group by DATEPART(hour , time)
	order by orders desc
	
	--Find the category-wise distribution of pizzas (to understand customer behaviour).
	
  select category , count (distinct order_id) as orders ,sum (cast(quantity as int)) as quantity 
	from order_details
	join pizzas on order_details.pizza_id = pizzas.pizza_id
	join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
	group by category
	order by quantity desc
	
	
	--Group the orders by date and calculate the average number of pizzas ordered per day.
	
	with cte as (
	select date , sum(cast(quantity as int )) as quantity , count( distinct order_details.order_id) as orders  
	from [orders(1)]
	join order_details on  order_details.order_id = [orders(1)].order_id
	group by date
	)

	select date , avg(quantity) as average_of_orders
	from cte
	group by date

	--Determine the top 3 most ordered pizza types based on revenue (let's see the revenue wise pizza orders to understand from sales perspective which pizza is the best selling)

	select top 3 category , sum (cast(quantity * price as int)) as total_revenue , count( distinct order_id) as orders
	 from pizza_types
   join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
   join order_details on order_details.pizza_id = pizzas.pizza_id
	group by category
	order by total_revenue desc
	
	--	Calculate the percentage contribution of each pizza type to total revenue (to understand % of contribution of each pizza in the total revenue)
	
	with cte2 as (
	select  category, sum (cast(quantity * price as int)) as total_revenue  , count( distinct order_id) as orders
	 from pizza_types
   join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
   join order_details on order_details.pizza_id = pizzas.pizza_id
   group by category  )

	select  category , total_revenue  ,(total_revenue )/sum(cte2.total_revenue ) AS TOTAl_revenue_all
	from cte2
	group by category,total_revenue           
	
	--Determine the top 3 most ordered pizza types based on revenue for each pizza category (In each category which pizza is the most selling)

	select top 3 category ,name, sum(cast(quantity * price as int )) as price
     from pizza_types
   join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
   join order_details on order_details.pizza_id = pizzas.pizza_id
	group  by category ,name
	order by price desc

	-- Anathor way 

		with ctee as (
	select category, name, cast(sum(quantity*price) as decimal(10,2)) as Revenue
	from order_details 
	join pizzas on pizzas.pizza_id = order_details.pizza_id
	join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
	group by category, name
	-- order by category, name, Revenue desc
	)
	, cte3 as (
	select category, name, Revenue,
	rank() over (partition by category order by Revenue desc) as rnk
	from ctee
	)
	select category, name, Revenue
	from cte3
	where rnk in (1,2,3)
	order by category, name, Revenue


