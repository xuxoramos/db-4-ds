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

`select * from products p order by ProductID desc limit 10;`

La cláusula `order by ProductID desc` es, literal, _ordena por el campo ProductID de forma descendente_. El campo por el cual vamos a ordenar debe estar incluído en los atributos que vamos a seleccionar con el comando `select`. La cláusula `desc` significa _descending_.

 > **IMPORTANTE:** el propósito del comando `select` y de las consultas en general es _responder preguntas_, de modo que haremos estos ejercicios a manera de pregunta.

## Queries de ejemplo

Primero vamos a ejecutar algunos ejemplos para que se familiaricen con las variantes de `select`.

### Obtener nombre de producto y cantidad de producto por unidad

### Obtener nombre de producto y su id
### Obtener nombre de producto y su id de productos descontinuados
### Obtener el nombre y precio unitario del producto más caro y del más barato
### Obtener el id, el nombre y el precio unitario para productos de menos de $20 en precio unitario
### Obtener el id, el nombre y el precio unitario para productos que cuesten entre $15 y $25
### Obtener nombre y precio unitario de productos por arriba del precio promedio de todo nuestro catálogo
### Nombres y precios unitarios de 10 productos más caros
### Conteo de los productos descontinuados y los que aún se tiene en inventario
### Obtener el nombre, la cantidad de unidades en órdenes y la cantidad en stock de productos cuya cantidad en órdenes sea mayor a la cantidad en stock

## Elementos de un `select`

Un select tiene los siguientes elementos:

| nombre de la cláusula | Propósito |  
|-|-|
| `select` | Determina las columnas que incluiremos en este espacio de ejecución |  
| `from` | Determina las tablas a las que pertenecen las columnas que _seleccionamos_ arriba |  
| `where` | Filtra renglones no deseados para efectos de la consulta y nos permite hacer `join`s para hacer que nuestra consulta trascienda más de 1 tabla |  
| `group by` | Agrupa y agrega valores utilizando columnas que tengan la misma data |
| `having` |  Filtra grupos no deseados para el objetivo de nuestra consulta |
| `order by` |  Ordena de forma `asc` y `desc` los resultados de la consulta |




