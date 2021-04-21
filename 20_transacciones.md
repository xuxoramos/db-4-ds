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

1. **`begin`** para iniciar la transacción; posterior a esto usualmente incluimos el paquete comandos de escritura como `insert`, `update` y `delete`.
2. **`commit`** para escribir la transacción (y su paquete de comandos) a PostgreSQL
3. **`rollback`** para _reversar_ las operaciones que están incluídas en el paquete de transacciones que aparecen después del `begin`

Dependiendo como nos estemos conectando a la BD, usualmente las transacciones son controladas por:

1. El DBeaver
2. Nuestro application code
3. Manualmente con los comandos de arriba

Para esta sesión vamos a mostrar como lo hacemos con comandos y como lo hace DBeaver.

### Transacciones con DBeaver

Fíjense arriba en su toolbar de DBeaver y verán esto:

![image](https://user-images.githubusercontent.com/1316464/115487955-4d547a80-a21f-11eb-9906-702b13e33bc6.png)

Esto significa que DBeaver está en modo **Auto-Commit**, que significa que cada comando(s) que ejecutamos, en automático nuestro cliente los encerrará en `begin` y `commit`.

Para ilustrar como funcionan las transacciones, debemos ponerlo en **Manual Commit**, que significa que DBeaver va a guardar un _transaction log_ de todos los comandos que meteremos, agregándole un `begin` al inicio, pero sin ningún `commit` al final.

![image](https://user-images.githubusercontent.com/1316464/115488280-de2b5600-a21f-11eb-9872-38015a422903.png)

No se fijen de momento en las opciones de abajo. Son las opciones de aislamiento, y las veremos más abajo.

### Ejercicio

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



Tiene el bloque de transacciones 

⚠️Qué estamos haciendo aquí?

1. `do $do$`: el 1er `do` marca el inicio de un bloque de código, el `$do$` "bautiza" este bloque de código con el nombre de `do`
2. `begin` actúa como corchete de apertura **{** para agrupar código
3. `for counter in 1..10 loop`: inicia un ciclo que irá del 1 al 10
4. `insert into random_data(valor, fecha)` prepara un insert en la tabla que creamos al inicio
5. `select substr(md5(random()::text), 1, 10) as valor, current_timestamp - (((random() * 365) || ' days')::interval) as fecha;`: genera 1 renglón con datos random para insertar en la tabla que creamos
6. `perform pg_sleep(30);` suspende la ejecución del ciclo `for` durante **30 segundos**
7. `end loop;` cierra el ciclo for - todo lo que esté entre `for loop` y `end loop` se va a ejecutar el num de vueltas que de el ciclo
8. `end;` actúa como corchete de cierre **}** para agrupar código
9. `$do$;` finaliza el bloque de código llamado `do`



## Propiedades ACID

### Atomicity

### Consistency

### Isolation

### Durability

### Propiedades BASE

## Temas avanzados

### Transacciones anidadas
