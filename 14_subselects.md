# Subselects

A lo largo de la clase nuestro uso más común del subselect ha sido para hacer match entre un query externo que obtiene datos, y un query interno que llega al registro del cual necesitamos esos datos, como este ejemplo:

```
select p.amount , concat(c.first_name, ' ', c.last_name) as cliente, concat(s.first_name, ' ', s.last_name) as staff 
from payment p join customer c using (customer_id)
join staff s using (staff_id)
where p.amount  = (select max(p.amount) from payment p);
```

Y aunque hemos dicho que hay que evitarlos, debemos cubrirlos para poder ver después la mejor alternativa a ellos.

## Error común en uso de subselects

Consideremos el siguiente query:

```
select ci.city 
from city ci 
where ci.country_id = (select co.country_id from country co where co.country = 'India');
```

Primero se evalúa el query interior, luego el exterior, lo que significa que primero obtenemos la llave del país que se llame 'India', y luego hacemos match de esa llave con los demás registros de los nombres de `city`. Lo que resulta es esto:

![](https://i.imgur.com/IQtjdiU.png)

Esto es posible porque el subquery **solo regresa 1 registro**. Un subquery usado de esta forma, con una expresión de igualdad `=` debe regresar 1 solo registro. Veamos qué sucede si lo cambiamos para que regrese varios:

```
select ci.city 
from city ci 
where ci.country_id = (select co.country_id from country co where co.country <> 'India');
```

![](https://i.imgur.com/cQdsuGP.png)

Sabemos cómo solucionamos esto, no? Con la cláusula **`IN`**.


```
select ci.city 
from city ci 
where ci.country_id in (select co.country_id from country co where co.country <> 'India');
```

 ## La cláusula `all`
 
 Sabemos que la cláusula **`in`** hace una comparación del elemento de la izq VS cada uno de los elementos de la lista de la derecha, parecido a comparaciones con operadores booleanos **`or`** encadenados:
 
 `...where country_id in ('India', 'Pakistan', 'Afghanistan')` **es igual a** `...where country_id = 'India' or country_id = 'Pakistan' or country_id = 'Afghanistan'`
 
 Sabemos también que el operador **`not`** convierte los **`or`** en **`and`**, y los **`=`** en **`<>`**, de forma que un `not in` es lo mismo que:
 
 `...where country_id not in ('India', 'Pakistan', 'Afghanistan')` **es igual a** `...where country_id <> 'India' and country_id <> 'Pakistan' and country_id <> 'Afghanistan'`
 
 Es cuestión de estilos, pero los queries con `not in` pueden refrasearse como:
 
 ```
 select c.first_name, c.last_name
 from customer c
 where c.customer_id <> all (
 select customer_id from payment where amount = 0
 );
 ```
 
 El operador `all` toma el operador de igualdad de su izq y lo compara **uno a uno** con la lista de valores que resulte del query de la derecha.
 
 El subquery interior regresa todos los identificadores de los clientes cuyos pagos son 0, mientras que el query exterior regresa los nombres de dichos clientes.
 
**IMPORTANTE:** cuando usemos `not in` o `<> all`, debemos asegurarnos que la lista de valores no vaya a traer un `null`, porque recordemos que estos operadores hacen por debajo un `=` o un `<>`, y sabemos que para comparar `null` no debemos usar igualdades, sino los operadores `is null` o `is not null`.

Por ejemplo:

```
select c.first_name, c.last_name
 from customer c
 where c.customer_id not in (122, 452, null)
```

No va a tronar, pero no va a regresar nada, y claramente no es lo que queremos.

### El `all` en el `having`

Un uso poco ortodoxo del `all` es ponerlo en el `having`. Veamos el siguiente query:

```
select r.customer_id , count(*)
from rental r
group by r.customer_id 
having count(*) > all (
	select count(*)
 	from rental r2 join customer c2 using (customer_id)
 	join address a2 using (address_id)
 	join city c3 using (city_id)
 	join country c4 using (country_id)
 	where c4.country in ('United States', 'Mexico', 'Canada')
 	group by c2.customer_id 
 );
 ```
 
Aquí el subquery interior obtiene todas las rentas por cliente de aquellos que residen en la zona TMEC, mientras que el query exterior obtiene el conteo de las rentas para todos nuestros clientes, **filtrando los grupos con clientes cuyas rentas son mayores a todas las de nuestros clientes en la zona TMEC**.
 
El resultado es:

![](https://i.imgur.com/Fi07GeV.png)

Solo tenemos un cliente cuya cantidad de rentas supera a todos nuestros clientes de la zona TMEC, de un país raro que se llama Runion.

## El operador `any`/`some`

Estos operadores arrojan resultados similares al operador `or` encadenado, de forma que:

`...where payment.amount > any (7.99, 8.99, 9.99)` **es igual a** `...where payment.amount > 7.99 or payment.amount > 8.99 or payment.amount > 9.99`




