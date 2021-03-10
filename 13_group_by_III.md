# Agrupaciones y agregaciones III

Es vaaaasto el tema, eh?

## Filtrando grupos con `having`

Como hemos visto empíricamente, las reglas del `having` son las siguientes:

1. Mientras que `where` **filtra rows**, el `having` **filtra grupos**.
2. El `having` se ejecuta después del `group by` y antes del `select`.
3. Al usar el `group by`, frecuentemente usaremos una función de agregación en el `select` como `avg`, `sum`, etc, y frecuentemente le asignaremos un alias a esa función.
4. Pero **no podemos usar este alias** en el having, sino que **tenemos que repetir la función** y además agregarle una condición para que sea una evaluación booleana.
5. La sintaxis de estas condiciones están gobernadas por los mismos operadores de igualdad (`<`, `>`, `=`, etc) que como si los usáramos en el `where`.

Pues resulta que no tan vaaaaaasto, no?

## Ejercicios con la BD Sakila

### Cuantos actores comparten apellido con al menos otro actor?
Si queremos solo listar los apellidos repetidos (apellidos que pertenecen a >=2 actores):
```
select a.last_name, count(a.actor_id) actores_apellido_repetido 
from actor a
group by a.last_name 
having count(a.actor_id) > 1
```

Si queremos CONTAR los apellidos repetidos:
```
select count(t.last_name) from (
	select a.last_name, count(a.actor_id) actores_apellido_repetido  from actor a
	group by a.last_name 
	having count(a.actor_id) > 1
	) as t;
```

Si queremos contar LOS ACTORES con apellidos repetidos:
```
select sum(actores_apellido_repetido) from (
	select a.last_name, count(a.actor_id) actores_apellido_repetido  from actor a
	group by a.last_name 
	having count(a.actor_id) > 1
	) as t;
```
### De nuestros empleados, cuál es el que más negocio trajo a nuestro store en 2005?
```
```
### Cuantos películas tienen un ensemble cast (5 o más actores 5⭐)?
```
```
### Cuál ha sido nuestro cliente más redituable cada año?
```
```
### Cuales películas cuyo título comiencen con la letra Q o K están en idioma inglés?
```
```
### Cómo obtenemos todos los nombres y correos de nuestros clientes canadienses para una campaña?
```
```
### Qué cliente ha rentado más de nuestra sección de adultos?
```
```
### Qué películas son las más rentadas en todas nuestras stores?
```
```
### Cuál es nuestro revenue por store?
```
```
