# Queries

Las consultas, el comando `select`, es la verdadera razón por la que estamos aquí. Todo lo demás fue una probadita de labores administrativas, de diseño y de desarrollo de bases de datos y los sistemas que lo soportan.

Para poder trabajar en toda esta unidad, vamos a requerir la BD Northwind, que es la que usa Microsoft para demo de sus productos. Igual usaremos durante las siguientes sesiones la BD de Sakila.

Es importante que la BD Northwind se instale en un esquema llamado `northwind`, para no batir nuestra base Sakila previamente instalada.

## Instalando la BD Northwind

1. Descarguen el archivo [`northwind/northwind.postgre.sql`](https://github.com/xuxoramos/db-4-ds/blob/gh-pages/northwind/northwind.postgre.sql).
2. Creen el esquema `northwind` en su BD `postgres`.
3. Carguen el archivo `northwind/northwind.postgre.sql` en DBeaver.
4. Seleccionen el esquema `northwind` para ejecutar el script.
5. Ejecuten el script con `Alt+X`.

Su base de datos debe quedar así:

![](https://imgur.com/auNft2z.png)

## De qué trata la BD Northwind?

Es una BD ficticia de una empresa importadora y exportadora de alimentos. Una vista rápida a los primeros 100 registros al catálogo de `products` nos revela la naturaleza de esta BD:

`select * from products p limit 10;`

Jarabe de anís, sazonador cajún, peras deshidratadas, salsa de arándano. Parecen ultramarinos, no?

![](https://imgur.com/qR1icRT.png)

Ahora un recap dela funcionalidad básica de los queries.

El `*` en el comando `select` nos indica que vamos a seleccionar _todos_ los atributos o columnas.

La cláusula `limit 10` nos permite seleccionar los primeros 10 registros de la tabla. Si queremos seleccionar los _últimos 10_, entonces debemos de usar el truco de voltear la tabla y seleccionar los primeros 10:

`select * from products p order by product_id desc limit 10;`

La cláusula `order by ProductID desc` es, literal, _ordena por el campo ProductID de forma descendente_. El campo por el cual vamos a ordenar debe estar incluído en los atributos que vamos a seleccionar con el comando `select`. La cláusula `desc` significa _descending_.

 > **IMPORTANTE:** el propósito del comando `select` y de las consultas en general es _responder preguntas_, de modo que haremos estos ejercicios a manera de pregunta.

## Queries de ejemplo

Primero vamos a ejecutar algunos ejemplos para que se familiaricen con las variantes de `select`.

1. Obtener nombre de producto y cantidad de producto por unidad

`select p.product_name , p.quantity_per_unit from products p;`

2. Obtener nombre de producto y su id

_"Se deja como ejercicio al lector" xD_

3. Obtener nombre de producto y su id de productos descontinuados

`select p.product_id , p.product_name , p.discontinued from products p where p.discontinued = 1;`

4. Obtener el nombre y precio unitario del producto más caro y del más barato

`select p.product_name , p.unit_price from products p order by p.unit_price desc limit 1;` y
`select p.product_name , p.unit_price from products p order by p.unit_price limit 1;`

5. Obtener el id, el nombre y el precio unitario para productos de menos de $20 en precio unitario

`select p.product_id , p.product_name , p.unit_price from products p where p.unit_price < 20;`

6. Obtener el id, el nombre y el precio unitario para productos que cuesten entre $15 y $25

`select p.product_id , p.product_name , p.unit_price from products p where p.unit_price >= 15 and p.unit_price <= 25;`

7. Obtener nombre y precio unitario de productos por arriba del precio promedio de todo nuestro catálogo

`select p.product_name , p.unit_price from products p where p.unit_price > (select avg(p2.unit_price) from products p2);`

8. Nombres y precios unitarios de 10 productos más caros

`select p.product_name , p.unit_price from products p order by p.unit_price desc limit 10;`

9. Conteo de los productos descontinuados y los que aún se tiene en inventario

`select count(p.product_id) from products p where p.discontinued = 1 and p.units_in_stock != 0;`

10. Obtener el nombre, la cantidad de unidades en órdenes y la cantidad en stock de productos cuya cantidad en órdenes sea mayor a la cantidad en stock

`select p.product_name , p.units_in_stock ,p.units_on_order from products p where p.units_on_order > p.units_in_stock;`

Si agregamos el campo `p.discontinued` a ésta última consulta, podríamos contar la historia de _"tenemos una órden de 40 de un producto que tenemos en inventario solo 17 y este producto ha sido descontinuado, por lo que tendremos problemas para hacerle fulfillment a esa orden y tendremos que poner nuestra cara de idiotas y ofrecer reemplazo de producto"_.

## Elementos de un `select`

Un select tiene los siguientes elementos:

| nombre de la cláusula | Propósito |  
|-|-|
| `select` _columna1, columna2,...,columna_n_ | Determina las columnas que incluiremos en este espacio de ejecución |  
| `from` _tabla1 [join tabla2 on (llave copiada)]_| Determina las tablas a las que pertenecen las columnas que _seleccionamos_ arriba |  
| `where` _condición booleana_ | Filtra renglones no deseados para efectos de la consulta |  
| `group by` _campo a agrupar_| Agrupa y agrega valores utilizando columnas que tengan la misma data |
| `having` _condición booleana_ |  Filtra grupos no deseados para el objetivo de nuestra consulta |
| `order by` _campo de ordenamiento [asc/desc]_ |  Ordena de forma `asc` y `desc` los resultados de la consulta |

No todos son obligatorios, pero esta es la base para un query útil que puede responder preguntas.

## Ejercicios

1. Qué contactos de proveedores tienen la posición de sales representative?


2. Qué contactos de proveedores no son marketing managers?



3. Cuales órdenes no vienen de clientes en Estados Unidos?


Podemos comprobar que ambos enfoques son los mismos con este query:

4. Qué productos de los que transportamos son quesos?


5. Qué ordenes van a Bélgica o Francia?


6. Qué órdenes van a LATAM?


7. Qué órdenes no van a LATAM?


9. Necesitamos los nombres completos de los empleados, nombres y apellidos unidos en un mismo registro


10. Cuánta lana tenemos en inventario?


11. Cuantos clientes tenemos de cada país?
