# Indices

Un índice en una BD es como un índice en un libro: nos ayuda a encontrar registros más rápido. Si quisieramos encontrar un tema sin un índice o un table of contents, tendríamos que "escanear" página por página buscando el término o tema que queremos checar.

## Qué forma tienen los índices?

### Índices B-tree para columnas numéricas

Supongamos una tabla como esta:

order_id|freight|
--------|-------|
   10248|  32.38|
   10249|  11.61|
   10250|  65.83|
   10251|  41.34|
   10252|   51.3|
   10253|  58.17|
   10254|  22.98|
   10255| 148.33|
   10256|  13.97|
   10257|  81.91|
   10258| 140.51|
   10259|   3.25|
   10260|  55.09|
   10261|   3.05|
   
Si queremos buscar el `order_id` con flete `3.25`, tenemos que al menos recorrer 12 registros uno por uno hasta encontrar el `order_id` **10259**. Para los que estudian compu, el tiempo de ejecución de esto es O(n), osea, complejidad lineal con el num de elementos que vayamos a recorrer.

Si creamos un índice sobre el campo `freight`, debemos seguir esta sintaxis:

```sql
create index [nombre_del_índice] on [tabla] [using method] (
	columna [asc|desc] [nulls {first|last}]
);
```

Crearemos un índice llamado `freight_index` en la tabla `orders`:

```sql
create index freight_index on orders (
	freight asc
);
```

El método para crear índices en la mayoría de las bases de datos es el método B-tree (complejidad `O(log(n)`), que resulta (roughly) en lo siguientes:

1. Seleccionamos un punto intermedio de la serie de valores. Supongamos que encontramos uno que se acerca al promedio de `52.12`

![](https://i.imgur.com/JTW0urM.png)

2. Partimos la lista de valores en `order_id.freight <= 52.12` y `order_id.freight > 52.12`

![](https://i.imgur.com/D52sUvh.png)

3. Hacemos lo mismo con esas 2 partes.

![](https://i.imgur.com/jNp8HsA.png)

4. Seguimos partiendo recursivamente hasta que lleguemos a los registros individuales.

![](https://i.imgur.com/NlRM8cw.png)

![](https://i.imgur.com/hmMQ9vR.png)

5. Una vez con los registros individuales, hacemos una lista con el orden logrado. Este es nuestro índice.

![](https://i.imgur.com/EQTtFm7.png)

### Índices bitmap para datos categóricos

Supongamos la siguiente tabla llamada `Employees`:

![image](https://user-images.githubusercontent.com/1316464/144183209-4c82797b-405c-440b-b4e9-c63f18a3df2f.png)

Tomemos la columna `New_Emp` con valores `Yes` y `No` y vamos a codificarla en un bitmap. Cómo lo hacemos?

1. Definir una columna `New_Emp` donde vamos a poner 2 renglones: `Yes` y `No`.
2. Vamos a definir otra columna `Bitmap`.
3. Para el valor de `Bitmap` en el renglón que corresponde a `Yes`, vamos a recorrer la tabla original, y vamos a generar un string de 1s y 0s, escribiendo un **`1`** cuando el renglón de la tabla original tenga el valor `Yes` en la columna `New_Emp`, y **`0`** cuando el renglon de la tabla original tenga cualquier otro valor.
   - El resultado: **`1001`**.
5. Del mismo modo, para el renglón que corresponde a `No`, vamos a hacer algo similar, escribiendo un **`1`** cuando el renglón de la tabla original tenga el valor `No` en la columna `New_Emp`, y **`0`** cuando el renglon de la tabla original tenga cualquier otro valor.
   - El resultado: **`0110`**

Lo que tenemos como resultado es esto:

![image](https://user-images.githubusercontent.com/1316464/144184572-e1577212-5e3e-4bf1-8080-fd0c911174cc.png)

Qué pasa cuando la columna categórica tiene más de 2 valores posibles?

Mismo procedimiento, solo que la tabla que representa el bitmap index va a tener más renglones.

Intentémoslo con la columna `Job`:

1. Definimos la columna `Job` con los renglones `Analyst`, `Salesperson`, `Clerk`, `Manager`, que son los valores posibles de toda la columna en todos sus registros.
2. Recorremos la tabla original para el valor `Analyst` y vemos que solo el 1er registro lo tiene, por lo que el _bit sequence_ para ese valor es `1000`.
3. Volvemos a recorrer la tabla original para el valor `Salesperson` y vemos que solo el 2o registro lo tiene, por lo que el _bit sequence_ es `0100`.
4. Volvemos a recorrer la tabla original para `Clerk` y generamos el _bit sequence_ `0010`
5. Para `Manager`, el _bit sequence_ será `0001`.

El resultado es el siguiente índice:

![image](https://user-images.githubusercontent.com/1316464/144185625-c74fba74-a0bd-4a45-bda7-d27cad2b6910.png)

Cómo funcionan en un `SELECT`?

Supongamos que ejecutamos el siguiente query:

```sql
select *
from Employees
where New_Emp = 'No' and Job = 'Salesperson'
```

1. Vamos a nuestros bitmap indices por el registro correspondientes a `New_Emp = 'No'` y obtenemos el _bit sequence_ `0110`.
2. Luego vamos por el registro correspondiente a `Job = 'Salesperson'` y obtenemos `0100`.
3. Y aplicamos la operación `and` como lo indica el query original: `0110 AND 0100 = 0100`
4. El resultado es que solo el 2o registro, como lo indica el resultado del `and`, es el que cumple con ambos criterios.

Realizar estas operaciones con bits es muchísimo más barato y eficiente que, nuevamente, buscar registro por registro y haciendo N comparaciones entre datos `varchar`.

## Cómo mejora el performance el índice sobre `orders.freight`?

Veamos

```sql
explain select o.freight
from orders o
where o.freight = 148.33 
```

![](https://i.imgur.com/j0KV65p.png)

Podemos ver que el query planner nos dice que para ejecutar este query está haciendo un `Sequential Scan`, lo que significa que se está yendo **registro por registro** buscando aquel que cumpla con la condición en `where`. Dada la velocidad de mi máquina, y lo pequeño de la BD, la diferencia en tiempo de correr este query con índice y sin él no será muy significativa. Sin índice está tardando `0.106ms`. Y con índice?

![](https://i.imgur.com/Rb3OCYx.png)

Vemos que el tipo de ejecución ha cambiado a `Index-Only Scan`, lo que significa que está precisamente recorriendo el árbol del índice. Dicha búsqueda resulta en mucho menos comparaciones que hacer 1 por cada registro en la tabla. No solamente eso, sino que el tiempo de ejecución ha disminuído dramáticamente, a `0.019ms`.


## Índices creados por default

Cuando creamos un constraint de `primary key` en una tabla, dicho campo se indexa en automático, por lo que las búsquedas por el ID de la tabla deben ser rápidas.

:warning: Muchos suponemos que si las BDs crean índices para las llaves primarias en automático, entonces las llaves foráneas igual van a tener su índice creado en automático. Esto no es así, por lo que **es buena práctica poner índices a las llaves foráneas**, siempre y cuando no sean compuestas, o sean parte de una tabla intermedia.

## Tradeoffs de índices

Los índices aceleran las consultas, PERO imponen un penalty en `insert`, `delete` y `update`, debido a que al haber un nuevo dato, el árbol que representa nuestro índice debe **rebalancearse**, de modo que el nuevo registro pueda acomodarse en el orden que debe ir.

## Ejemplo con una tablotototota

Para esto necesitamos tener una tabla ENORME.

```sql
create table ecobici_historico (
	id numeric constraint pk_historico_ecobici primary key,
	genero_usuario varchar(200),
	edad_usuario numeric,
	bici varchar(200),
	fecha_retiro date,
	hora_retiro_copy varchar(200),
	fecha_retiro_completa timestamp,
	anio_retiro numeric,
	mes_retiro numeric,
	dia_semana_retiro varchar(200),
	hora_retiro numeric,
	minuto_retiro numeric,
	segundo_retiro numeric,
	ciclo_estacion_retiro varchar(200),
	nombre_estacion_retiro varchar(200),
	direccion_estacion_retiro varchar(200),
	cp_retiro varchar(200),
	colonia_retiro varchar(200),
	codigo_colonia_retiro varchar(200),
	delegacion_retiro varchar(200),
	delegacion_retiro_num varchar(200),
	fecha_arribo date,
	hora_arribo_copy varchar(200),
	fecha_arribo_completa timestamp,
	anio_arribo numeric,
	mes_arribo numeric,
	dia_semana_arribo varchar(200),
	hora_arribo numeric,
	minuto_arribo numeric,
	segundo_arribo numeric,
	ciclo_estacion_arribo varchar(200),
	nombre_estacion_arribo varchar(200),
	direccion_estacion_arribo varchar(200),
	cp_arribo varchar(200),
	colonia_arribo varchar(200),
	codigo_colonia_arribo varchar(200),
	delegacion_arribo varchar(200),
	delegacion_arribo_num varchar(200),
	duracion_viaje varchar(200),
	duracion_viaje_horas numeric,
	duracion_viaje_minutos numeric
);
create sequence seq_id_ecobici_historico start 1 increment 1;
alter table ecobici_historico alter column id set default nextval('seq_id_ecobici_historico');
```

Importaremos datos con el mismo mecanismo que vimos [la clase anterior](https://github.com/xuxoramos/db-4-ds/blob/gh-pages/18_window_functions.md#first_value-y-last_value) para poder insertar [este archivo (2GB zippeado, 19GB expandido)](https://drive.google.com/file/d/1WDl_U59ihAql7PS0XZ4uRU6AVaKxM6ZF/view?usp=sharing)

Cuántos registros tenemos?

```sql
select count(*) from ecobici_historico;
```

Suena a que todo lo que hagamos con esta tabla va a ser tardado.

Cuánto tardó en ejecutar este conteo?

![](https://i.imgur.com/ttLH31Q.png)

Como pueden ver, tardó 2.7 segundos, pero para realizar el agregado del `count()` pudo usar un `Parallel Index-Only Scan`, que significa que está usando el índice asociado a la llave primaria que le creamos a la tabla.

Qué pasa con una consulta a una columna sin índice?

```sql
explain analyze select * 
from ecobici_historico 
where anio_arribo = 2017 and 
mes_arribo = 12 and genero_usuario = 'M';
```

![](https://i.imgur.com/Yr8LmXi.png)

168 mil milisegundos?!?!?!

![](https://www.meme-arsenal.com/memes/79f825bb34adef7ef49e623d2d96f74a.jpg)

Terrible el desempeño, no?

Qué pasa si agregamos un índice que contenga `anio_arribo`, `mes_arribo` y `genero_usuario`?

```sql
create index ecobici_anio_mes_genero_index on ecobici_historico (
	genero_usuario, anio_arribo, mes_arribo asc
);
```

![](https://i.imgur.com/9JuELQH.png)

Aún la creación del índice se tardó `5.5 minutos`!!! 😵

Volvamos a correr el query:

![](https://i.imgur.com/rA4XFND.png)

Ahora tardamos `0.131 milisegundos`!

Es una mejoría del **128244275%**!!!

![](https://media.wired.com/photos/5e3246cd56bcac00087f0a1e/1:1/w_1329,h_1329,c_limit/Culture-Success-Meme-Kid.jpg)

## Índices compuestos VS índices simples

Un índice compuesto construye un árbol con múltiples columnas, y uno simple lo hace con una sola columna.

Ya hemos visto que un índice compuesto optimiza muy bien un query donde el `where` tiene condiciones sobre las columnas que aparecen en este mismo índice.

### Qué sucede si usamos este índice compuesto con un solo filtro?

```sql
explain analyze
select * 
from ecobici_historico
where mes_arribo = 12;
```

![](https://i.imgur.com/T4wdoFF.png)

Como podemos ver con un runtime de `1.11 mins`, los índices compuestos **no pueden optimizar** sobre queries que usen 1 de las columnas individuales que lo componen, optando por un `Sequential Scan` sobre usar parcialmente el índice.

### Qué pasa con un query con múltiples filtros e índices individuales?

Eliminemos el índice multicolumna que creamos:

```sql
drop index ecobici_anio_mes_genero_index;
```

Y ahora vamos a crear un índice individual para cada columna. OJO! Esto tardará **11 mins**!

```sql
create index ecobici_genero_index on ecobici_historico (
	genero_usuario asc
);
create index ecobici_anio_index on ecobici_historico (
	anio_arribo asc
);
create index ecobici_mes_index on ecobici_historico (
	mes_arribo asc
);
```

Una vez creados esos índices, ejecutemos de nuevo el query que usa estos 3 campos en su `where`:

```sql
explain analyze select * 
from ecobici_historico 
where anio_arribo = 2017 and 
mes_arribo = 12 and genero_usuario = 'M';
```

El resultado es el siguiente:

![](https://i.imgur.com/KKLQkWN.png)

Como podemos ver, de los 3 índices simples que hemos creado, el query planner solo está usando 1, el índice de `ecobici_anio_index`. Por qué?

**PostgreSQL SIEMPRE usará los filtros más óptimos para el query que se está ejecutando.**

No importa como pongamos las condiciones en el `where`, **PostgreSQL siempre reordenará los filtros** para ese query que estamos corriendo. PostgreSQL sabe que a veces no escribimos los queries más óptimos, y pone por delante el filtro que tiene el índice que separa mejor los registros.

Al aplicar este índice, quedan demasiado pocos registros para filtrar y terminar el query como para aplicar índices subsecuentes, por lo que PostgreSQL decide no usarlos, so pena de entrar **optimización prematura** el cual es [la raíz de todos los males en software.](https://stackify.com/premature-optimization-evil/)

## Cuándo y cuando no debo usar índices?

### Cuándo sí

1. En Llaves primarias (checar que mi BD la puso por default)
2. En Llaves foráneas (excepto tablas intermedias)
3. En Columnas con constraint de tipo `unique`
4. Cuando la tabla vaya a ser consultada frecuentemente para propósitos analíticos usando varias columnas (índcices multi-columna)
5. Cuando tengamos tablas con > ~500K registros y +20 columnas (aquí funcionan bien los índices clusterizados)
6. Columnas que usemos frecuentemente con `order by` y `group by`
7. En columnas de fechas usadas en tablas históricas (probablemente tarde mucho el índice en construirse)

### Cuándo no

1. Tablas con muchísima actividad I/O, como transaccionales (ventas, high frequency trading, etc)
2. Columnas cuyo tipo sea caracter con longitudes mayores a 25 posiciones
3. Cuando ya tengas muchos índices 🤣

## Final thoughts

Un índice es costoso, en memoria, en tiempo, en espacio. Índices bien diseñados nos pueden ayudar a acelerar algunas consultas, pero sobreuso de índices pueden empantanar las escrituras y actualizaciones a una BD hasta volvera inoperable y al punto de tener que destruirla, y volverla a construir, y esto implica regresar el estado del negocio a un punto anterio, y quizá perder días de operatividad, lo cual es fatal para el problem domain.
