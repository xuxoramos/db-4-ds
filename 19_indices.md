# Indices

Un índice en una BD es como un índice en un libro. Si quisieramos encontrar un tema sin un índice o un table of contents, tendríamos que "escanear" página por página buscando el término o tema que queremos checar.

## Qué forma tienen los índices?

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

El método para crear índices en la mayoría de las bases de datos es el método B-tree (o binary tree), que resulta (roughly) en lo siguientes:

1. Seleccionamos un punto intermedio de la serie de valores 

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
