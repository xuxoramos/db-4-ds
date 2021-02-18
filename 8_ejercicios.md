# Ejercicios en preparación para el examen

### Obtener un reporte de edades de los empleados para checar su elegibilidad para seguro de gastos médicos menores.

`select e.employee_id , ((now() - e.birth_date)/365) as "age" from employees e;`

otro enfoque puede ser usando el comando `age(date)`, que ya nos ayuda a realizar esta aritmética simple:

`select e.employee_id , age(e.birth_date) as "Age" from employees e;`

**Nota sobre [fechas en SQL](https://www.postgresql.org/docs/current/datatype-datetime.html):** las fechas en SQL, a muy bajo nivel, "viven" en la BD en forma numérica, y gracias a eso pueden responder a operadores aritméticos simples, como el de arriba, donde `now()` nos regresa la fecha y hora de este instante, y podemos restarle el campo `birth_date` de la tabla `employee` para obtener edades.

**Nota sobre representaciones de fechas:** Dado que las fechas son, finalmente, a nivel de BD,  valores numéricos, pero que acá en la realidad las representamos en un formato de texto (i.e. "12-10-1998" es 12 de Octubre de 1998, o Diciembre 10 de 1998?), entonces al insertar o extraer campos de fecha, es conveniente _**formatear**_ esta fecha para quitar ambigüedad de lo que significa el formato, y que la BD sepa dónde buscar el día, mes y año. A continuación ejemplos de transformación de formatos de fecha:

```
select to_date('1-9-2011', 'DD-MM-YYYY'); -- 1 de Sep de 2011
select to_date('1-9-2011', 'MM-DD-YYYY'); -- 9 de Enero de 2011
```

### Cuál es la orden más reciente por cliente?

```
select c3.company_name as "Company Name", 
max(o.order_date) as "Most Recent Order" 
from orders o join customers c3 on o.customer_id = c3.customer_id 
group by c3.company_name;
```

O si queremos también el ID de la orden:




5. De nuestros clientes, qué función desempeñan y cuántos son?
6. Cuántos productos tenemos de cada categoría?
7. Cómo podemos generar el reporte de reorder?
8. A donde va nuestro envío más voluminoso?
9. Cómo creamos una columna en `customers` que nos diga si un cliente es bueno, regular, o malo?
10. Qué colaboradores chambearon durante las fiestas de navidad?
11. Qué productos mandamos en navidad?
12. Qué país recibe el mayor volumen de producto?





--------------------------------------------------------


select c.customer_id , o.order_id from customers c inner join orders o on (o.customer_id = c.customer_id);



select s.company_name , o.order_id from shippers s left join orders o on s.shipper_id = o.ship_via;

select	* from orders o where ship_via is null

select s.company_name , o.order_id from shippers s left join orders o on (s.shipper_id = o.ship_via) where o.ship_via is null or s.shipper_id is null;

select c.contact_name, c.city, s.contact_name, s.city from customers c full outer join suppliers s on (c.contact_name = s.contact_name) where c.contact_name is null or s.contact_name is null

select c.contact_name, c.city, s.contact_name, s.city from customers c full outer join suppliers s on (c.contact_name = s.contact_name)


select c.city from customers c intersect select s.city from suppliers s;

select c.city, s.city from customers c join suppliers s on c.city = s.city;

select c.contact_name, c.city from customers c UNION select s.contact_name, s.city from suppliers s;

select c.contact_name as customer_name, c.city as customer_city, s.contact_name as supplier_name, s.city as  supplier_city from customers c full outer join suppliers s on (c.contact_name = s.contact_name);

select s.company_name , o.order_id from shippers s left join orders o on (s.shipper_id = o.ship_via);

select s.company_name , o.order_id from shippers s full outer join orders o on (s.shipper_id = o.ship_via);

select s.company_name , o.order_id from shippers s left join orders o on (s.shipper_id = o.ship_via) where o.ship_via is nul	l;

select contact_title from customers c 



-- Ejercicios 2021-02-17
-- Qué ordenes van a Bélgica o Francia?

select * from orders o where ship_country in ('Belgium', 'France')

-- Qué órdenes van a LATAM?
select order_id , ship_country from orders o 
where ship_country in ('Mexico', 'Venezuela', 'Brazil', 'Argentina')

-- Qué órdenes no van a LATAM?
select order_id , ship_country from orders o 
where ship_country not in ('Mexico', 'Venezuela', 'Brazil', 'Argentina')


-- Necesitamos los nombres completos de los empleados, nombres y apellidos unidos en un mismo registro
select concat(e.first_name , ' ' , e.last_name) as "Full Name" from employees e
--alter table employees add column nombre_completo varchar(100);
--update employees set nombre_completo = (select concat(e.first_name , ' ' , e.last_name) from employees e)

-- Cuánta lana tenemos en inventario?
select sum((p.unit_price * p.units_in_stock)) from products p

-- Cuantos clientes tenemos de cada país?
select c.country , count(c.customer_id) from customers c group by c.country

-- Obtener un reporte de edades de los empleados para checar su elegibilidad para seguro de gastos médicos menores.
select e.employee_id , ((now() - e.birth_date)/365) as "age" from employees e

-- Cuál es la orden más reciente por cliente?
-- ** Pregunta: si queremos tener TAMBIÉN el order ID de la orden más reciente, cómo le hacemos? **
select c3.company_name as "Company Name", 
max(o.order_date) as "Most Recent Order" 
from orders o join customers c3 on o.customer_id = c3.customer_id 
group by c3.company_name;

select t.order_id, o.order_date, o.customer_id 
from (
	select o.order_id, max(o.order_date) as ordenreciente, o.customer_id
	from orders o
	group by o.customer_id 
) t join orders o2 on t.order_id = o2.order_id and o.order_date = t.ordenreciente;

select distinct on (o.customer_id) o.order_id , max(o.order_date) 
from orders o 
group by o.customer_id 


-- De nuestros clientes, qué función desempeñan y cuántos son?
select c.contact_title, count(c.customer_id) from customers c group by c.contact_title

-- Cuántos productos tenemos de cada categoría?
select c2.category_name , count(c2.category_id) 
from products p 
join categories c2 
on p.category_id = c2.category_id 
group by c2.category_name;

-- Cómo podemos generar el reporte de reorder?
select p.product_name, p.reorder_level , p.units_in_stock, p.discontinued from products p where p.units_in_stock < p.reorder_level 

-- A donde va nuestro envío más voluminoso?
select o.freight, o.ship_country 
from orders o 
where o.freight = (select max(o.freight) from orders o);

select max(o.freight) as "MaxFreight", o.ship_country 
from orders o 
group by o.ship_country order by "MaxFreight" desc limit 1;

select o.freight , o.ship_country from orders o order by  o.freight desc limit 1;

-- Cómo creamos una columna en customers que nos diga si un cliente es bueno, regular, o malo?
select c.company_name ,  sum(od.quantity * od.unit_price) as "Customer Value" , case if "Customer Value" > 100 then "buenérrimo" end tipo_cliente,
from order_details od 
join orders o on od.order_id = o.order_id 
join customers c on o.customer_id = c.customer_id 
group by c.company_name 
order by "Customer Value" desc;

-- Qué colaboradores chambearon durante las fiestas de navidad?
select distinct e.first_name, e.last_name , o.order_date
from orders o join employees e on o.employee_id  = e.employee_id 
where o.order_date in (date('1996-12-24'),date('1997-12-24'),date('1998-12-24'),date('1996-12-25'),date('1997-12-25'),date('1998-12-25'));  

-- Qué productos mandamos en navidad?
select o.order_id , o.shipped_date 
from orders o 
where o.shipped_date in (date('1996-12-24'),date('1997-12-24'),date('1998-12-24'),date('1996-12-25'),date('1997-12-25'),date('1998-12-25'));

-- Qué país recibe el mayor volumen de producto?
select sum(o.freight) as sumfreight, c.country from orders o join customers c on o.customer_id = c.customer_id group by c.country order by sumfreight desc limit 1;


select c.category_name, count (c.category_id) from products p
	join categories c on (c.category_id = p.category_id)
	group by c.category_id ;

