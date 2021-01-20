# Construyendo una BD
Veremos ahora como crear una BD con SQL (Structured Query Language). El tipo de SQL que se usa para crear tablas o definir _estructuralmente_ una BD le llamamos **DDL** (Data Definition Language). Son un set de comandos diferentes a los que usamos para _consultar_ datos.

## Creando la BD de Ingresos Hospitalarios

Supongamos el siguiente modelo ER:

![](https://imgur.com/jSJufNt.png)

Vamos a crearlo con comandos DDL de SQL:

## `create table`
El comando [`create table`](https://www.postgresql.org/docs/9.1/sql-createtable.html), como su nombre lo dice, nos ayuda a crear una tabla.

A continuación, el comando para crear la tabla `doctor`:

```
--
-- TABLE: doctor
-- 
--  
create table doctor (
  id_doctor numeric(4,0) constraint pk_doctor primary key,
  nombres varchar(50) NOT NULL ,
  apellidos varchar(50) NOT NULL ,
  fecha_contratacion date NOT NULL ,
  sueldo numeric(8,2) NOT NULL ,
  id_especializacion numeric(4) NOT NULL 
);
--
CREATE SEQUENCE doctor_id_doctor_seq START 1 INCREMENT 1 ;
ALTER TABLE doctor ALTER COLUMN id_doctor SET NOT 0;
ALTER TABLE doctor ALTER COLUMN id_doctor SET DEFAULT nextval('doctor_id_doctor_seq');
--
```

Vamos a desmenuzar este comando línea por línea:

1. `create table doctor (`: crea la tabla `doctor`. Ojo que el PostgreSQL todos los comandos son **case-insensitive**.
2. `id_doctor numeric(4) constraint pk_doctor primary key,`: asigna el 1er atributo, llamado `id_doctor`, de tipo [`numeric`](https://www.postgresql.org/docs/9.1/datatype-numeric.html), de máximo `(4,` posiciones, sin punto decimal `0)`, y le asigna un [constraint](https://www.postgresql.org/docs/9.4/ddl-constraints.html) de tipo `primary key`, lo cual en automático asigna las restricciones de 1) no poder tener valores repetidos, 2) no poder ser nulo. Adicionalmente, le crea un índice (lo veremos más delante). Por buena práctica, las llaves primarias llevan la sintaxis `id_[tabla]`.
3. `nombres varchar(50) NOT NULL ,`: creamos el atributo `nombres` de tipo `varchar` (i.e. variable-length character string, osea, string) con `(50)` posiciones de longitud máxima y con una restricción `NOT NULL` para evitar registros con esta columna vacía. La columna o atributo `apellidos` sigue la misma estructura.
4. `fecha_contratacion date NOT NULL,`: columna o atributo de tipo `date`.
5. `sueldo numeric(8,2) NOT NULL,`: columna o atributo `sueldo` de `(8,` posiciones, de las cuales `2)` son decimales, y con un constraint de tipo `NOT NULL`.
6. `id_especializacion numeric(4) NOT NULL`: campo, atributo o columna de tipo `numeric` de `(4)` posiciones que representará una relación de **1 a 1** con la tabla `especializacion`. Es importante mencionar que en este punto, este campo **aún es un atributo, y aún no representa ninguna relación**.
7. `);`: con esto terminan los comandos SQL en PostgreSQL siempre, y el paréntesis cierra el comando `create table`, **pero** aún no terminamos de definir la tabla.
8. `--`: separador de línea o comentario. Las líneas que comiencen con `--` no serán procesadas por el compilador de SQL.
9. `CREATE SEQUENCE doctor_id_doctor_seq START 1 INCREMENT 1 ;`: Esta línea crea una secuencia, un objeto de PostgreSQL que representa una serie de números consecutivos y que nos permite implementar la buena práctica de que las llaves primarias sean un _entero secuencial_. Esta secuencia la llamaremos `doctor_id_doctor_seq`, y su comienzo está definido en 1 por el argumento `START 1` y su incremento también en 1 por el argumento `INCREMENT 1`. La buena práctica sugiere que los nombres de las secuencias sea `[tabla]_[campo de llave primaria]_seq`.


