# Construyendo una BD
Veremos ahora como crear una BD con SQL (Structured Query Language). El tipo de SQL que se usa para crear tablas o definir _estructuralmente_ una BD le llamamos **DDL** (Data Definition Language). Son un set de comandos diferentes a los que usamos para _consultar_ datos.

## Creando la BD de Ingresos Hospitalarios

Supongamos el siguiente modelo ER:

![](https://imgur.com/jSJufNt.png)

Vamos a crearlo con comandos DDL de SQL:

## `create table` y `alter table`
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

## Tablas transaccionales y tablas de catálogos
Antes de crear **en orden** las tablas para que no nos salgan estos errores, debemos de explicar la diferencia entre algunos tipos de tablas para tener claro nuestro diseño de BD.

Ya hemos cubierto las tablas históricas cuando explicamos las [llaves compuestas](https://github.com/xuxoramos/db-4-ds/blob/gh-pages/1_database_design_and_creation.md#lave-primaria-compuesta). Ahora vamos a explicar la diferencia entre las tablas transaccionales y las tablas de catálogo. 

### Tablas transaccionales
Son tablas donde guardamos eventos y transacciones del problem domain: un ingreso hospitalario, una verificación de coche, una venta, una compra, un check-in en un hotel, un login a un sistema, un ticket de soporte, etc.

Como tal, estas tablas transaccionales tienen 2 atributos importantes, su _llave primaria_, y una _fecha transacción_.

Adicionalmente, la **frecuencia** con la que escribimos en esas tablas nos da un indicio de la velocidad de nuestro negocio. Pensemos en una tabla hipotética `VENTA` en diferentes escenarios:
1. En una tiendita de la esquina:
2. En un Oxxo (en su única caja abierta):
3. En Liverpool:
4. En un concesionario Tesla:
5. En Amazon.com: 
6. En Netflix:

Esto también nos debe introducir concerns de volumetría (espacio en disco), en desempeño de lectura (índices, que veremos más tarde) y, más basicote (como Kim Kardashian), si la longitud de nuestra _llave primaria_ y su respectiva _secuencia_ dan lo suficiente como para sostener el ritmo de inserción en esta tabla. Si nuestra llave primaria está definida como `integer(5)`, es decir, _entera de 5 posiciones_, esperaríamos que el máximo número que insertaremos es el `99999`. Esto no es así, debido a que el máximo número representable por el tipo `integer` es `32767`, y entonces vamos a tener errores de inserción y por tanto pérdida de datos mucho antes que lleguemos a la capacidad máxima de la longitud de nuestra llave primaria.

En la BD de Sakila, podemos identificar 2 tablas de este tipo:

![](https://imgur.com/KevyBa2.png)

Las tablas de `rental` y `payment` registran transacciones, y es sensato suponer que tenemos 1 inserción cada 2 horas. Por tanto, son tablas que debemos monitorear de cerca para que tanto espacio, como longitud de campos, como tipo de datos, no nos vayan a sabotear.

Ahora, qué tal, la tabla `customer`? Podemos considerarla transaccional? En qué escenarios si? En qué escenarios no?

![](https://imgur.com/0uBNW9w.png)

Y la de `film`?

Pero qué hay de los demás atributos? Como podemos ver, en el caso de `rental` y `payment` la mayoría son _llaves foráneas_, y aunque en el caso de `film` y `customer` hay otros atributos que le dan contexto, si las consideramos transaccionales, vale la pena ver qué _llaves foráneas_ tenemos copiadas ahí, y por tanto, de qué relaciones **1 a N** son parte.

Es muy probable que las otras tablas con las que estas _tablas transaccionales_ tienen relación sean _catálogos_.

### Tablas de catálogos
Estas tablas se caracterizan por tener una frecuencia de actualización lenta o nula, y casi siempre describen _tipos_ de algo relevante al problem domain. Por ejemplo:

1. elementos geográficos: `estado`, `municipio`, `codigo_postal`, `colonia`, `pais`. **OJO:** no se vayan con la finta de que no cambian. Si cambian. Cuando el DF se convirtió en CDMX muchos grupos y áreas de ingeniería de software sufrieron la gota gorda por no tener catálogos que pudieran cambiar fácilmente.
2. status de algún objeto del problem domain: `status_cliente`, `status_envio`, `status_transaccion`.
3. tipos o clases de algún objeto del problem domain: `tipo_estudio`, `tipo_especialidad`, `tipo_medicamento`.

**Pueden existir relaciones entre catálogos**, no es necesario que sean _self-contained_, si esto agrega contexto al problem domain. Por ejemplo:

![](https://imgur.com/R631tpv.png)

Sin considerar las tablas de `staff` y `address`, que podemos considerarlas como transaccionales, `city` y `country` son 2 catálogos **que tienen relación entre sí**. 

En la BD de Sakila podemos encontrar los siguientes catálogos:

![](https://imgur.com/byTAuIr.png)

Pero qué tal estos? Son catálogos?

![](https://imgur.com/nKBJvdl.png)

Como buena práctica, si se actualizan o se agregan registros 2 veces al año o menos, serán catálogos.

## Ejercicio

Entonces, con los conocimientos adquiridos, podemos decir que en el pequeño modelo E-R de ingreso hospitalario que imaginamos, el orden de creación puede ser:

1. `tipo_especializacion`
2. `tipo_estudio`
3. `paciente`
4. `estudio`
5. `doctor`
6. `paciente_doctor`

## Creación de tablas intermedias para relaciones N a M

En particular para la tabla `paciente_doctor`, que describe la relación N a M entre `paciente` y `doctor`, el comando SQL para su creación es un poco diferente porque las _2 llaves foráneas_ **COMPONEN** _una sola llave primaria_. El comando es:

```
--
-- TABLE: paciente_doctor
--  
CREATE TABLE paciente_doctor (
  id_paciente numeric(4) references paciente (id_paciente) ON UPDATE CASCADE ON DELETE CASCADE,
  id_doctor numeric(4) references doctor (id_doctor) ON UPDATE cascade,
  constraint pk_paciente_doctor primary key (id_paciente, id_doctor)
);
-- 
```

Las diferencias que encontramos con lo visto hasta ahorita son:
1. `ON UPDATE CASCADE ON DELETE CASCADE`: esto se agrega al declarar una _llave foránea_ para indicar qué hacer con el registro de `paciente_doctor` cuando sucede un `update` o `delete` en la tabla `paciente`. Es decir, si actualizamos algún atributo del paciente, se debe actualizar también la relación, y si **borramos (DELETE)** el registro en `paciente`, automáticamente la BD borrará el registro en `paciente_doctor`.
2. `constraint pk_paciente_doctor primary key (id_paciente, id_doctor)`: con esto estamos definiendo que la _llave primaria_ se compone de ambos campos que fueron definidos como _llaves foráneas_  en los comandos anteriores. Esta línea la pudimos haber ejecutado, en lugar de _in_line_, con un `ALTER TABLE ADD CONSTRAINT`.

Pueden encontrar el archivo completo para este ejercicio aquí: https://github.com/xuxoramos/db-4-ds/blob/gh-pages/doctor.sql
