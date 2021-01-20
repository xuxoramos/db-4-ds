# Construyendo una BD
Veremos ahora como crear una BD con SQL (Structured Query Language). El tipo de SQL que se usa para crear tablas o definir _estructuralmente_ una BD le llamamos **DDL** (Data Definition Language). Son un set de comandos diferentes a los que usamos para _consultar_ datos.

## Creando la BD de Ingresos Hospitalarios

Supongamos el siguiente modelo ER:

![](https://imgur.com/jSJufNt.png)

Vamos a crearlo con comandos DDL de SQL:

## `create table`
El comando [`create table`](https://www.postgresql.org/docs/current/sql-createtable.html), como su nombre lo dice, nos ayuda a crear una tabla.

A continuación, el comando para crear la tabla `doctor`:

```
--
-- TABLE: doctor
--  
create table doctor (
  id_doctor numeric(4,0) constraint pk_doctor primary key,
  nombres varchar(50) NOT NULL ,
  apellidos varchar(50) NOT NULL ,
  fecha_contratacion date NOT NULL ,
  sueldo numeric(8,2) NOT NULL ,
  id_especializacion numeric(4) REFERENCES especializacion (id_especializacion) 
);
--
CREATE SEQUENCE doctor_id_doctor_seq START 1 INCREMENT 1 ;
ALTER TABLE doctor ALTER COLUMN id_doctor SET NOT 0;
ALTER TABLE doctor ALTER COLUMN id_doctor SET DEFAULT nextval('doctor_id_doctor_seq');
--
```

Vamos a desmenuzar este comando línea por línea:

1. `create table doctor (`: crea la tabla `doctor`. Ojo que el PostgreSQL todos los comandos son **case-insensitive**.
2. `id_doctor numeric(4) constraint pk_doctor primary key,`: asigna el 1er atributo, llamado `id_doctor`, de tipo [`numeric`](https://www.postgresql.org/docs/current/datatype-numeric.html), de máximo `(4,` posiciones, sin punto decimal `0)`, y le asigna un [constraint](https://www.postgresql.org/docs/current/ddl-constraints.html) de tipo `primary key`, lo cual en automático asigna las restricciones de 1) no poder tener valores repetidos, 2) no poder ser nulo. Adicionalmente, le crea un índice (lo veremos más delante). Por buena práctica, las llaves primarias llevan la sintaxis `id_[tabla]`.
3. `nombres varchar(50) NOT NULL ,`: creamos el atributo `nombres` de tipo [`varchar`](https://www.postgresql.org/docs/current/datatype-character.html) (i.e. variable-length character string, osea, string) con `(50)` posiciones de longitud máxima y con una restricción `NOT NULL` para evitar registros con esta columna vacía. La columna o atributo `apellidos` sigue la misma estructura.
4. `fecha_contratacion date NOT NULL,`: columna o atributo de tipo [`date`](https://www.postgresql.org/docs/current/datatype-datetime.html).
5. `sueldo numeric(8,2) NOT NULL,`: columna o atributo `sueldo` de `(8,` posiciones, de las cuales `2)` son decimales, y con un constraint de tipo `NOT NULL`.
6. `id_especializacion numeric(4) REFERENCES especializacion (id_especializacion)`: campo, atributo o columna de tipo `numeric` de `(4)` posiciones que representará una relación de **1 a 1** con la tabla `especializacion`. Esta relación está dada por el argumento `REFERENCES [tabla] ([llave primaria de tabla a relacionar])`, la cual en automático impone un constraint de tipo [`foreign key`](https://www.postgresql.org/docs/current/tutorial-fk.html). A partir de este momento será imposible crear un registro de un `doctor` sin asignarle forzosamente una especialidad que ya exista en la tabla `especializacion`.
7. `);`: con esto terminan los comandos SQL en PostgreSQL siempre, y el paréntesis cierra el comando `create table`, **pero** aún no terminamos de definir la tabla.
8. `--`: separador de línea o comentario. Las líneas que comiencen con `--` no serán procesadas por el compilador de SQL.
9. `CREATE SEQUENCE doctor_id_doctor_seq START 1 INCREMENT 1 ;`: Esta línea crea una [secuencia](https://www.postgresql.org/docs/13/sql-createsequence.html), un objeto de PostgreSQL que representa una serie de números consecutivos y que nos permite implementar la buena práctica de que las llaves primarias sean un _entero secuencial_. Esta secuencia la llamaremos `doctor_id_doctor_seq`, y su comienzo está definido en 1 por el argumento `START 1` y su incremento también en 1 por el argumento `INCREMENT 1`. La buena práctica sugiere que los nombres de las secuencias sea `[tabla]_[campo de llave primaria]_seq`.
10. `ALTER TABLE doctor ALTER COLUMN id_doctor SET NOT 0;`: el comando [`ALTER TABLE`](https://www.postgresql.org/docs/13/sql-altertable.html) nos permite modificar una tabla después de haber sido creada con `create table`. Después de especificar que estaremos modificando la tabla `doctor`, agregamos un 2o nivel de modificación con `ALTER COLUMN` y después especificamos la columna que vamos a modificar. `SET NOT 0;` define una regla para que la llave primaria nunca sea 0.
11. `ALTER TABLE doctor ALTER COLUMN id_doctor SET DEFAULT nextval('doctor_id_doctor_seq');`: similar a la línea anterior, ésta nos ayuda a definir un valor por default **para nuevos registros** mediante el argumento `SET DEFAULT`. Dicho valor por default es una llamada a la función `nextval`, que obtiene el siguiente valor de una secuencia, en este caso, la que creamos en [9] con nombre `doctor_id_doctor_seq`.

Intentemos correr estos comandos en DBeaver.

![](https://imgur.com/kCihnRB.png)

Dado que estamos creando una tabla que tiene un _constraint de llave foránea_  con la tabla `especializacion`, y dado que ésta aún no se encuentra creada, PostgreSQL arrojará un error. La forma de tratarlo es creando primero las tablas que no tengan relaciones (que usualmente están en la periferia del problem domain), y poco a poco ir creando más hasta dejar al final la tabla con mayor número de relaciones.

## Tablas transaccionales y catálogos


