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
6. `perform pg_sleep(10);` suspende la ejecución del ciclo `for` durante **10 segundos**. OJO: el `perform` hace lo mismo que el `select` PERO sin regresar ningún resultado al DBeaver y solo se puede usar dentro de bloques de código `do`
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

![image](https://user-images.githubusercontent.com/1316464/115502089-f5773d00-a239-11eb-9ff4-13fdef2224d7.png)

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

## Tarea

Cuando uds compran instrumentos financieros en mercados regulados, como acciones, papel de deuda guber, divisas, metales, futuros, commodities, etc, la instrucción que giran ustedes a su institución financiera se conoce como "postura de compra". Para que su compra se de, alguien tiene que poner una postura de venta con las características suficientemente similares para poder hacerle MATCH.

El mercado es como un tanque gigante de posturas de compra y posturas de venta y un motor de matching que siempre está buscando el mejor match para una postura cualquiera.

Una vez que hay un match, entonces esa orden pasa a ejecución, pero no pasa inmediatamente. Si pasara inmediatamente, tendríamos algo como esto:

```
# pseudocódigo
start transaction;
ejecutar orden mercado capitales de Julieta;
commit;
start transaction;
ejecutar orden mercado divisas de Javier;
commit;
start transaction;
ejecutar orden mercado deuda de Sebas 1;
commit;
start transaction;
ejecutar orden mercado deuda de Sebas 2;
commit;
```

Y sabemos que esto no es muy eficiente.

Es más eficiente tener:

```
start transaction;
ejecutar orden mercado capitales 1;
ejecutar orden mercado capitales 2;
ejecutar orden mercado capitales 3;
commit;
start transaction;
ejecutar orden mercado deuda 1;
ejecutar orden mercado deuda 2;
ejecutar orden mercado deuda 3;
ejecutar orden mercado deuda 4;
commit;
start transaction;
ejecutar orden mercado divisas 1;
ejecutar orden mercado divisas 2;
commit;
```

Aún cuando dicha ejecución de ordenes esté fuera de nuestra BD

No solamente eso, sino que toda transacción de instrumentos financieros debe ir acompañado de cash. Tu institución financiera entrega tus títulos o tus CETES, y tu institución financiera debe recibir de la institución financiera contraparte una suma de cash. Solo que este cash viene de Banxico, por lo que es otro sistema externo con el que es difícil coordinar transacciones.

Suponiendo que tenemos los siguientes instrumentos:
1. capitales
2. deuda
3. divisas

Y suponiendo que los 3 mercados los tenemos en diferentes sistemas, y que para cada sistema tenemos los siguientes verbos/funciones:
1. transferir_capitales(origen, destino, monto)
2. transferir_deuda(origan, destino, monto)
3. transferir_divisas(origen, destino, monto)
4. transferir_efectivo(origen, destino, monto)

Y que como control de flujo de nuestro programa, podemos usar las siguientes funciones de pseudocódigo:
1. `if error then` para verificar errores
2. `if success then` para verificar éxito

Y que el único que **NO SOPORTA TRANSACCIONES** es el de Banxico, donde se liquida la parte de cash de todas las transacciones.

Y suponiendo que en caso de error de cualquiera de estas funciones, se hace `rollback` de la transacción, qué secuencia de funciones hipotéticas, de control, `start transaction`, `commit` y `rollback` se necesitan para asegurar la ejecución _all or nothing_ de los siguientes escenarios?

1. Ulises con cuenta en GBM compra a Julieta con cuenta en Santander 400 títulos de AMZ (Amazon) a 66048.20 MXM pagaderos con cash.
2. Sebas Dulong con cuenta en Citi vende a Javier Orcazas 1200 títulos de GME (GameStop) a 3714.88 pagaderos 100 títulos de deuda gubernamental con valor de 2998.12 y el restante con cash
3. DJ Delgado con cuenta en Scotia vende 20000 USD a un exchange rate de 25.2 MXN y 300 títulos de deuda corporativa a un precio de 40032.71 a Frida Kaori con cuenta en Inbursa pagaderos enteramente con cash.

Valor: 2 puntos sobre final
Deadline: 30 de Abril de 2020
Formato de entrega: documento Markdown en su repo de Github

## Propiedades ACID

Las propiedades ACID son exclusivas de bases de datos relacionales, y son una serie de atributos no funcionales que las vuelven confiables y una gran opción para balancear entre rapidez de escritura y de lectura.

### Atomicity

> Todas las operaciones en la transacción son tratadas como una unidad, y como unidad, o procede, o falla completamente.

Qué feature de la BD nos permite "atomicidad"?

![image](https://user-images.githubusercontent.com/1316464/115502089-f5773d00-a239-11eb-9ff4-13fdef2224d7.png)

### Consistency

> De una transacción a otra, la BD queda en estados consistentes, sin corrupción. Si la transacción falla, el `rollback` regresa la BD a su estado anterior, sin corrupción.

Ya vimos que cuando hemos hecho rollback, no reversamos parcialmente la transacción, así como cuando hacemos commit, no escribimos parcialmente la transacción.

### Isolation

En esto nos vamos a enfocar hoy. Este atributo determina cómo y cuándo los resultados de una transacción son visibles a otra.

### Durability

> El resultado de una transacción exitosa persiste en el tiempo, aún después de una interrupción total de energía.

Ya hemos visto que cuando hacemos `commit`, todo se queda en la BD, y aunque apaguemos la máquina y la volvamos a prender, nuestros datos _commiteados_ permanecerán en la BD.

## Isolation a fondo

El aislamiento de una transacción controla la concurrencia. La concurrencia es como controlamos múltiples accesos de diferentes compus (o procesos de CPU) a un mismo recurso. En este caso es la BD, pero puede ser un archivo en disco, la memoria, la tarjeta gráfica, el bus USB, etc.

No controlar los accesos concurrentes puede resultar en bloopers muy chistositos que nos pueden costar muchos dolores de cabeza y desvelos, ya sea debuggeando código, o enderezando bases de datos batidas.

### Concurrencia VS Paralelismo

**Concurrencia** es que el CPU esté atendiendo 2 tareas al mismo tiempo, dedicando todos sus recursos a una y a otra alternativamente.

**Acceso concurrente** es que un único recurso sea accedido por 2 o más procesos del CPU al mismo tiempo.

![](http://tutorials.jenkov.com/images/java-concurrency/concurrency-vs-parallelism-1.png)

**Paralelismo** es que el CPU esté atendiendo 2 tareas al mismo tiempo, dedicando una fracción de recursos por completo a una, y otra fracción de recursos por completo a otra.

![](http://tutorials.jenkov.com/images/java-concurrency/concurrency-vs-parallelism-2.png)

### Qué errores tenemos si no controlamos concurrencia?

Usemos nuestra tabla `random_data`

#### Dirty reads

1. TX1: actualiza `X.value` de 50 a 100 donde `X.id = 1`
2. TX2: consulta `X.value` donde `X.id = 1` y obtiene 100
3. TX1: rollback
4. TX2 se queda con `X.value = 100` a pesar de que TX1 _rollbackeó_ y dejó `X.value` en 50

![](https://backendless.com/docs/images/data/read-uncommitted.png)

Afortunadamente, PostgreSQL implementa un tipo de aislamiento de transacciones que **por default** evitan lecturas sucias, por lo que no podremos simularlas.

|t| **TX1** | **TX2** |
|-|-----|-----|
|_t1_| `start transaction isolation level read uncommitted`<br/>`select valor from northwind.random_data where id = 2000096;` <br/> _`Result: '087ea30915'`_ | |
|_t2_| |`start transaction;`<br/>`update northwind.random_data set valor = '0000000000' where id = 2000096;`<br/>_`Result: 1 row updated`_|
|_t3_| `select valor from northwind.random_data where id = 2000096;` <br/> _`Result: '087ea30915'`_ | |
|_t4_| A pesar de que haber usado `read uncommitted`, estamos leyendo solo lo que está _commiteado_||

**Qué tipos de isolation levels tenemos?**

1. `READ COMMITTED`: los `select` en la TX1 solo pueden ver registros _commiteados_ por la TX2 antes de que la TX1 comenzara a ejecutarse. Este es el comportamiento de PostgreSQL por default.
2. `REPEATABLE READ`: los `select` en la TX1 que accedan datos que están siendo alterados en una TX2 no verán las alteraciones hasta que TX1 termine y se vuelvan a acceder en una TX3.
3. `SERIALIZABLE`: es el mayor nivel de bloqueo. Si una TX1 ejecuta cualquier operación en un registro, una TX2 no va a poder hacer uso de ese registro hasta que TX1 termine.

![](https://miro.medium.com/max/2416/1*NppBgUymDiDLwBJjAvqbEQ.png)

Dado que, como vimos arriba, `READ UNCOMMITTED` (el nivel más débil de aislamiento) en PostgreSQL no está soportado, por nuestra propia seguridad, entonces la 1a columna y el 1er renglón no aplican.

Vamos a ver ahora cada anomalía de asilamiento que queda:

#### Non-repeatable Reads

1. TX1: consulta `X.value` donde `X.id = 1` y obtenemos 50
2. TX2: actualiza `X.value` de 50 a 100 donde `X.id = 1`
3. TX2: commit
4. TX1: consulta `X.value` donde `X.id = 1` y obtenemos 100
5. TX1 leyó 2 veces el registro y tuvo valores diferentes

![](https://backendless.com/docs/images/data/read-committed.png)

Este escenario si lo podemos simular. Lo haremos con la tabla `random_data` que creamos:

|t| **TX1** | **TX2** |
|-|-----|-----|
|_t1_| `start transaction isolation level read committed;`<br>`select valor from northwind.random_data where id = 2000096;` <br/> _**`Result: '087ea30915'`**_ | |
|_t2_| |`start transaction;`<br/>`update northwind.random_data set valor = '0000000000' where id = 2000096;`<br/>_`Result: 1 row updated`_|
|_t3_| |`commit;`|
|_t4_| `select valor from northwind.random_data where id = 2000096;` <br/> _**`Result: '0000000000'`**_ | |
|_t5_| `087ea30915 != 0000000000` 😞| |

Como podemos ver, tenemos 2 valores diferentes para 1 misma lectura **DENTRO DE LA MISMA TRANSACCIÓN**.

Cómo evitamos las non-repeatable reads?

Con nivel de aislamiento **`REPEATABLE READ`**:

|t| **TX1** | **TX2** |
|-|-----|-----|
|_t1_| `start transaction isolation level repeatable read;`<br>`select valor from northwind.random_data where id = 2000096;` <br/> _`Result: '087ea30915'`_ | |
|_t2_| |`start transaction;`<br/>`update northwind.random_data set valor = '0000000000' where id = 2000096;`<br/>_`Result: 1 row updated`_|
|_t3_| |`commit;`|
|_t4_| `select valor from northwind.random_data where id = 2000096;` <br/> _**`Result: '087ea30915'`**_ | |
|_t5_| `087ea30915 == 087ea30915` 👍| |

Con esto logramos CONSISTENCIA, aún cuando otras transacciones escriban en la misma tabla o modifiquen el mismo registro.

#### Phantom Reads

Esta anomalía solo sucede cuando estamos tratando con un grupo de resultados (i.e. condiciones donde el `where` nos regresa un resultset de varios registros)

Es similar al **Repeatable Read** de arriba, pero en lugar de que nos suceda con 1 registro, nos sucede con una colección de ellos.



### Propiedades BASE

## Temas avanzados

### Transacciones anidadas
