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

```
select o.order_id , o.order_date, c.company_name
from orders o join customers c on o.customer_id = c.customer_id 
join (
	select c.company_name, max(o.order_date) as max_order_date
	from orders o join customers c on o.customer_id = c.customer_id
	group by c.company_name 
) t on o.order_date = t.max_date and c.company_name = t.company_name
```

En este ejercicio, hacemos join entre una tabla existente y una _tabla dinámica_ creada al vuelo con un _subselect_ que llamaremos `t`. Lo que estamos haciendo es lo siguiente:

Primero seleccionamos los `company_name` de la tabla `customers` mediante un join con `orders`, y seleccionamos también el `max(o.order_date) as max_order_date`. Y todo ello lo asignamos a un alias que llamaremos `t`:

![](https://i.imgur.com/tcTALu9.png)

Y luego hacemos un `select` de las columnas `order_id`, `order_date` y `company_name` del `join` de la tabla `orders` con `customers`. Este select es natural, **sin `group by`**.

![](https://i.imgur.com/aiX5jiL.png)

Luego hacemos un join de los dos selects de arriba tal que el `orders.order_date = t.max_order_date` Y ADEMÁS que `customers.company_name = t.company_name`.

Y LISTO!

### De nuestros clientes, qué función desempeñan y cuántos son?
```
select c.contact_title, count(c.customer_id)
from customers c 
group by c.contact_title
```

### Cuántos productos tenemos de cada categoría?
```
select c2.category_name , count(c2.category_id) 
from products p 
join categories c2 
on p.category_id = c2.category_id 
group by c2.category_name;
```

### Cómo podemos generar el reporte de reorder?
El reporte de reorder es la lista de todos los productos cuyo nivel de inventario es igual o mayor al nivel que tenemos definido para disparar una orden de ese producto del cual tenemos poquito.

```
select p.product_name, p.reorder_level , p.units_in_stock, p.discontinued 
from products p
where p.units_in_stock <= p.reorder_level
```

### A donde va nuestro envío más voluminoso?
Tenemos de 3 sopas:

```
select o.freight, o.ship_country 
from orders o 
where o.freight = (select max(o.freight) from orders o);
```

O bien:

```
select max(o.freight) as "MaxFreight", o.ship_country 
from orders o 
group by o.ship_country order by "MaxFreight" desc limit 1;
```

Y finalmente:

```
select o.freight , o.ship_country
from orders o
order by o.freight desc limit 1;
```

### Cómo creamos una columna en `customers` que nos diga si un cliente es bueno, regular, o malo?
```
select t.company_name , 
t.customer_value , 
case 
	when t.customer_value > 100000 then 'buenérrimo' 
	when t.customer_value <= 100000 and t.customer_value > 70000 then 'bueno' 
	when t.customer_value <= 70000 and t.customer_value > 30000 then 'regular' 
	when t.customer_value <= 30000 then 'malo' 
end tipo_cliente
from (
	select c.company_name , sum(od.quantity * od.unit_price) as customer_value
	from order_details od
	join orders o on od.order_id = o.order_id 
	join customers c on o.customer_id = c.customer_id 
	group by c.company_name
) t
order by customer_value desc;
```

Aquí estamos usando de nuevo una _tabla dinámica_, una tabla creada al vuelo con base en un `select`. En el `select` interior, tenemos lo siguiente:

![](https://i.imgur.com/EpBLUOt.png)

Con esto tenemos el valor total de las órdenes procesadas por cada cliente. **No olviden asignar el alias a este subselect para poder referirnos a esta tabla dinámica.** En este caso la bautizamos como `t`.

Ahora ponemos un select exterior para etiquetar los rangos de estos clientes de acuerdo al monto total de orden que tienen con nosotros.

![](https://i.imgur.com/svf8ufK.png)

Esta maroma la necesitamos hacer porque el select exterior solo puede tener conocimiento del alias **`customer_value`** que asignamos a `sum(order_details.quantity * order_details.unit_price)` si ha sido definido en un subselect, y por tanto ya se tiene en memoria.

Si hubieramos agregado la cláusula `case` como parte del select externo, no hubiera sido posible tener esta lógica sobre `customer_value` porque aún no se hubiera tenido en memoria.

### Qué colaboradores chambearon durante las fiestas de navidad?
```
select distinct e.first_name, e.last_name , o.order_date
from orders o join employees e on o.employee_id  = e.employee_id 
where extract('month' from o.order_date) = 12 and extract('day' from o.order_date) in (24,25); 
```

Aquí usamos la cláusula `extract(['month'|'day'|'year'] from o.order_date)` para obtener solamente el cacho del mes y el día de un campo de fecha, y una vez extraído, ya podemos hacer comparaciones.

### Qué productos mandamos en navidad?
Misma técnica que el query anterior:
```
select o.order_id , o.shipped_date 
from orders o
where extract('month' from o.shipped_date) = 12 and extract('day' from o.shipped_date) in (24,25); 
```

### Qué país recibe el mayor volumen de producto?
```
select sum(o.freight) as sumfreight, c.country 
from orders o join customers c on o.customer_id = c.customer_id 
group by c.country order by sumfreight desc limit 1;
```
