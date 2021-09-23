# Ejercicios en preparación para el examen

### Obtener un reporte de edades de los empleados para checar su elegibilidad para seguro de gastos médicos menores.

### Cuál es la orden más reciente por cliente?

```sql
# contributed by Francisco Cordero
select max(o.order_date), o.order_id , o.customer_id 
from orders o
group by o.customer_id;
```

### De nuestros clientes, qué función desempeñan y cuántos son?

```sql
select c.contact_title , count(c.contact_title) conteo
from customers c
group by c.contact_title
order by conteo desc;
```

### Cuántos productos tenemos de cada categoría?

```sql
# Contributed by Ana Arrieta (conteo de items in stock en lugar de productos :heart:)
select c.category_name , sum(p.units_in_stock)
from categories c left join products p
on c.category_id = p.category_id  
group by c.category_id ;
```

```sql
# Contributed by Fer M (conteo de productos)
select c.category_name, count(c.category_name) 
from categories c join products p on c.category_id =p.category_id 
group by c.category_name;
```

### Cómo podemos generar el reporte de reorder?

```sql
# Contributed by Ainé F
select product_id, product_name, units_in_stock, reorder_level 
from products p 
where (units_in_stock<reorder_level);
```

### A donde va nuestro envío más voluminoso?

```sql
# Semi-contributed by Héctor T
SELECT 
	o.ship_country, 
	max(od.quantity) AS units 
FROM order_details od
JOIN orders o ON o.order_id  = od.order_id 
	GROUP BY(o.ship_country)
	ORDER BY(units) desc limit 2 -- Verificar si si es el máximo;
```

### Cómo creamos una columna en `customers` que nos diga si un cliente es bueno, regular, o malo?

```sql
# Contributed by Fer Lango
select t.company_name, t.total,
	case 
		when t.total < 10000 then 'malo'
		when t.total >= 10000 and t.total <100000 then 'regular'
		else 'bueno'
	end as categoria
from (
	select c.company_name,  
		sum(od.unit_price*od.quantity*(1-od.discount))as total  
	from customers c 
		join orders o using (customer_id)
		join order_details od using (order_id)
	group by c.company_name
	order by total
) as t;
```

### Qué colaboradores chambearon durante las fiestas de navidad?

```sql
# Contributed by Diego Arellano
select e.first_name, e.last_name 
from orders o join employees e on (o.employee_id = e.employee_id)
where (extract(month from o.shipped_date) = 12 and extract(day from o.shipped_date) = 25)
or (extract(month from o.order_date) = 12 and extract(day from o.order_date) = 25);
```

### Qué productos mandamos en navidad?

```sql
# Contributed by Emilio Ramírez
select p.product_name 
from products p join order_details od on p.product_id =od.product_id 
join orders o on od.order_id = o.order_id
where extract(month from o.shipped_date) = 12 and extract(day from o.shipped_date) = 25;
```

### Qué país recibe el mayor volumen de producto?
```sql
# Contributed by Alex
select o.ship_country , sum(od.quantity) as suma_productos
from orders o join order_details od on o.order_id  = od.order_id 
group by o.ship_country
order by suma_productos desc;
```

Esto es para responder la orden más voluminosa por país
Caso para la araña: por qué si agrupamos por país o por order_id tenemos el mismo resultado?
```sql
# Contributed by Alex + Rebe
select o.ship_country , sum(od.quantity) as suma_productos
from orders o join order_details od on o.order_id  = od.order_id 
group by o.order_id
order by suma_productos desc;
```
