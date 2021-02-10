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

## De qué trata la BD Northwind?

Es una BD ficticia de una empresa importadora y exportadora de alimentos. Una vista rápida a los primeros 100 registros al catálogo de `products` nos revela la naturaleza de esta BD:

`select * from products p limit 10;`\

El `*` en el comando `select` nos indica que vamos a seleccionar _todos_ los atributos o columnas.

La cláusula `limit 10` nos permite seleccionar los primeros 10 registros de la tabla. Si queremos seleccionar los _últimos 10_, entonces debemos de usar el truco de voltear la tabla y seleccionar los primeros 10:

`select * from products p order by ProductID desc limit 10;`

La cláusula `order by ProductID desc` es, literal, _ordena por el campo ProductID de forma descendente_. El campo por el cual vamos a ordenar debe estar incluído en los atributos que vamos a seleccionar con el comando `select`.

