# Transacciones

Una transacción es una estructura que permite empaquetar varios comandos de BD en una sola operación tipo _all or nothing_, es decir o se ejecutan todos los comandos dentro del paquete, o no se ejecuta ninguno.

Usaremos una tabla de ejemplo y la poblaremos con 1M de registros:

```sql
create table random_data (
	id serial primary key, -- el tipo SERIAL reemplaza todo el merequetengue de crear una sequence y ponerle como default el nextval para esta columna :)
	valor text,
	fecha timestamp
);

insert into random_data (valor, fecha)
select substr(md5(random()::text), 1, 10) as valor,                     -- la función md5() cifra justo con el algoritmo md5 una cadena
current_timestamp - (((random() * 365) || ' days')::interval) as fecha  -- crea fechas de hoy a un num de días random hasta 1 año atrás
from generate_series(1, 1000000);					-- ejecuta las 2 líneas anteriores 1M de veces
```

Igual para esto debemos usar `pgAdmin` en lugar de DBeaver. Lo pueden encontrar en Windows así:

![image](https://user-images.githubusercontent.com/1316464/115486475-57c14500-a21c-11eb-88f2-311f1ed65810.png)

O en Mac así:

![](https://www.linode.com/docs/guides/securely-manage-remote-postgresql-servers-with-pgadmin-on-macos-x/pg-admin-open-new-window_hud9f4df0c614323b68e9919c449ea7406_51182_694x0_resize_q71_bgfafafc_catmullrom_2.jpg)

## Cómo se demarca una transacción en SQL?

Demarcamos las transacciones con 3 comandos:

1. **`start transaction`** para iniciar la transacción; posterior a esto usualmente incluimos el paquete comandos de escritura como `insert`, `update` y `delete`. Algunas BDs agregan el alias `begin transaction` a este comando.
2. **`commit`** para escribir la transacción (y su paquete de comandos) a PostgreSQL
3. **`rollback`** para _reversar_ las operaciones que están incluídas en el paquete de transacciones que aparecen después del `start transaction`

Dependiendo como nos estemos conectando a la BD, usualmente las transacciones son controladas por:

1. El DBeaver
2. Nuestro application code
3. Manualmente con los comandos de arriba

Para esta sesión vamos a mostrar como lo hacemos con comandos y como lo hace DBeaver.

### Transacciones con DBeaver

Fíjense arriba en su toolbar de DBeaver y verán esto:

![image](https://user-images.githubusercontent.com/1316464/115487955-4d547a80-a21f-11eb-9906-702b13e33bc6.png)

Esto significa que DBeaver está en modo **Auto-Commit**, que significa que cada comando(s) que ejecutamos, en automático nuestro cliente los encerrará en `start transaction` y `commit`.

Para ilustrar como funcionan las transacciones, debemos ponerlo en **Manual Commit**, que significa que DBeaver va a guardar un _transaction log_ de todos los comandos que meteremos, agregándole un `start transaction` al inicio, pero sin ningún `commit` al final.

![image](https://user-images.githubusercontent.com/1316464/115488280-de2b5600-a21f-11eb-9872-38015a422903.png)

No se fijen de momento en las opciones de abajo. Son las opciones de aislamiento, y las veremos más abajo.

#### Ejercicio

Primero, examinemos cuantos registros tenemos:

```sql
select count(*) from random_data;
```

![image](https://user-images.githubusercontent.com/1316464/115492151-d7eca800-a226-11eb-90e6-73ecc78b821f.png)

Si tengo más de 1M, es porque justo estoy ejecutando varias inserciones al desarrollar este apunte. 🤣

Vamos a insertar 5 registros en la tabla `random_data` en modo **Manual Commit** usando el comando con el que insertamos la data inicial y **ejecutándolo 5 veces**:

```sql
insert into random_data (valor, fecha)
select substr(md5(random()::text), 1, 10) as valor,
current_timestamp - (((random() * 365) || ' days')::interval) as fecha;
```

Vemos que el contador de transacciones tiene 5 statement en el _transaction_log_:

![image](https://user-images.githubusercontent.com/1316464/115492241-08344680-a227-11eb-9514-04f70cf05483.png)

Examinémoslo dándole click:

![image](https://user-images.githubusercontent.com/1316464/115492261-16826280-a227-11eb-91be-942c172d93f0.png)

Vemos que tenemos 5 statements. Cuales son? Demos doble click en la columna `Text`:

![image](https://user-images.githubusercontent.com/1316464/115494583-8f83b900-a22b-11eb-9e0a-24f8cdfdf318.png)

Qué hacemos ahora con estos 5 statements?

Los bajamos a la BD?

![image](https://user-images.githubusercontent.com/1316464/115494868-189af000-a22c-11eb-820f-e388e9887702.png)

Y nos quedamos con 5 registros más?

![image](https://user-images.githubusercontent.com/1316464/115495064-73344c00-a22c-11eb-9d5e-edd074595d83.png)

O los reversamos?

![image](https://user-images.githubusercontent.com/1316464/115494949-3cf6cc80-a22c-11eb-9dc6-865a1c793bb4.png)

Y nos quedamos con lo que teníamos?

![image](https://user-images.githubusercontent.com/1316464/115492151-d7eca800-a226-11eb-90e6-73ecc78b821f.png)

#### Por qué no insertamos con un `for`?

El `for` no existe en SQL estándar, por lo que cada BD tiene que implementarlo ellos mismos. En el caso de PostgreSQL, todo lo que no sea SQL estándar debe estar dentro de un bloque `do`, como el siguiente:

```sql
do $do$
	begin
		for counter in 1..10 loop
			insert into random_data(valor, fecha)
			select substr(md5(random()::text), 1, 10) as valor,
			current_timestamp - (((random() * 365) || ' days')::interval) as fecha;
			perform pg_sleep(10);
		end loop;
	end;
$do$;
```

⚠️Qué estamos haciendo aquí?

1. `do $do$`: el 1er `do` marca el inicio de un bloque de código, el `$do$` "bautiza" este bloque de código con el nombre de `do`
2. `begin` actúa como corchete de apertura **{** para agrupar código
3. `for counter in 1..10 loop`: inicia un ciclo que irá del 1 al 10
4. `insert into random_data(valor, fecha)` prepara un insert en la tabla que creamos al inicio
5. `select substr(md5(random()::text), 1, 10) as valor, current_timestamp - (((random() * 365) || ' days')::interval) as fecha;`: genera 1 renglón con datos random para insertar en la tabla que creamos
6. `perform pg_sleep(10);` suspende la ejecución del ciclo `for` durante **30 segundos**. OJO: el `perform` hace lo mismo que el `select` PERO sin regresar ningún resultado al DBeaver
7. `end loop;` cierra el ciclo for - todo lo que esté entre `for loop` y `end loop` se va a ejecutar el num de vueltas que de el ciclo
8. `end;` actúa como corchete de cierre **}** para agrupar código
9. `$do$;` finaliza el bloque de código llamado `do`

Cuantos registros tenemos si ejecutamos este código en modo **Manual Commit**?

```sql
select count(*) from random_data;
```

![image](https://user-images.githubusercontent.com/1316464/115497097-9e209f00-a230-11eb-8d2f-9c297db19931.png)

Esperen, tenemos 10 más, no? 

**Por qué se escribieron si no dimos click en `Commit`?**

PostgreSQL **por default** mete cualqier bloque de código `do` en **su propia transacción**, por lo que ignora los settings que tengamos en el DBeaver y en la misma conexión abre **una transacción nueva** para meter la ejecución del bloque.

De hecho, si intentamos **abrir transacción en el codeblock**:

```sql
Vemos que no está soportado iniciar transacciones dentro de bloques de código de PostgreSQL.
do $do$
	begin
		start transaction;
			for counter in 1..10 loop
				insert into random_data(valor, fecha)
				select substr(md5(random()::text), 1, 10) as valor,
				current_timestamp - (((random() * 365) || ' days')::interval) as fecha;
				perform pg_sleep(10);
			end loop;
		commit;
	end;
$do$;
```

![image](https://user-images.githubusercontent.com/1316464/115497749-e096ab80-a231-11eb-8914-712be3b6cedb.png)

Vemos que no está soportado iniciar transacciones dentro de bloques de código de PostgreSQL.

### Transacciones manuales

Supongamos que estamos en la chamba, que la tabla `random_data` tiene el histórico de casos COVID19 registrados por el INER y ejecutamos esto:

```sql
delete from random_data;
```

Qué tiene de malo este delete?

**NO TIENE WHERE!**

![](https://pbs.twimg.com/media/CteZaLNUAAAg45R.jpg)

Este error es muy frecuente, pero estoy seguro que solo les pasará 1 sola vez en toda su vida profesional, sobre todo cuando la furia de TODA la oficina del CTO: desarrollo, infraestructura, datos, vicepresidencia de arquitectura y del CTO mismo se cierna sobre ustedes.

![](https://res.feednews.com/assets/v2/6a293a7846f87027090633b4fab5c73c?width=1280&height=720&quality=hq&category=us_News_Entertainment)

Por qué no les va a volver a pasar?

Transacciones!

Las operaciones de `delete` y `update` tienen el potencial de destruir información, por lo que es recomendable que si vamos a ejecutar cualquiera de ambas, o activemos **Manual Commit** en DBeaver, o comencemos nuestro trabajo corriendo un `start transaction`:

Vayamos a pgAdmin y pongamos:

```sql
start transaction;
delete from northwind.random_data;
```

Hemos abierto una transacción de manera manual, y hemos borrado toda la tabla.

Pero no hemos cerrado la transacción.

Si contamos los registros de la tabla, tendremos 0. Por qué?

![image](https://user-images.githubusercontent.com/1316464/115501830-839ef380-a239-11eb-8a49-e0980958ac48.png)

Porque este `count(*)` está sucediendo **en la misma transacción** que aún tenemos abierta.

Ok, enough fooling around. Vamos a regresar las cosas como estaban en su lugar:

```sql
rollback;
```

Cuántos registros tenemos ahora?

![image](https://user-images.githubusercontent.com/1316464/115502018-e0021300-a239-11eb-9562-9957cf9123db.png)

![image](https://user-images.githubusercontent.com/1316464/115502089-f5773d00-a239-11eb-9ff4-13fdef2224d7.png)

## Propiedades ACID

### Atomicity

### Consistency

### Isolation

### Durability

### Propiedades BASE

## Temas avanzados

### Transacciones anidadas
