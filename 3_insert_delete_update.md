# Creando, borrando y actualizando datos
En nuestra BD de doctores, en el esquema `hospital`, vamos a comenzar a insertar datos, borrar datos, y actualizar datos de acuerdo al siguiente script.

## `insert`
Veamos el siguiente comando [`insert`](https://www.postgresql.org/docs/current/sql-insert.html) a nuestra tabla `doctor`:

```
INSERT INTO hospital.doctor
(nombres, apellidos, fecha_contratacion, sueldo, id_especializacion)
VALUES('Gregorio', 'Casas', '2006-07-23', 823371.24, 2);
```
Antes de explicar este comando línea por línea, debemos hacer un apunte sobre esquemas, bases de datos y visibilidad.

### Jerarquía `Database Server -> Database -> Schema`

La jerarquía de _contenedores_ o _folders_ de PostgreSQL es `Database Server -> Database -> Schema`

Tablas dentro del mismo esquema son visibles entre ellas sin referirse explíticamente al esquema al que pertenecen.

Tablas en diferentes esquemas, pero dentro de la misma base, son visibles solo con el prefijo `[esquema].[tabla]`, de modo que si tenemos un esquema `hospital` y otro esquema `laboratorio`, y desde la tabla `hospital.estudio` queremos tener acceso a `laboratorio.reactivos`, entonces debemos referirnos a una y a otra tabla como aparecen en el ejemplo, con sus esquemas como prefijos.

Tablas en bases de datos diferentes (y obviamente en esquemas diferentes) no pueden verse, a menos que instalemos la extensión [Foreign Data Wrapper](https://www.postgresql.org/docs/current/postgres-fdw.html). Esto está totalmente fuera de este curso.

![](https://imgur.com/ZflCCJJ.png)

Esto significa que para que un query a la tabla `film` del esquema `public` donde está la BD Sakila pueda ver la tabla `doctor` en el esquema `hospital`, solo tiene que hacer refrencia a ella con la notación `doctor.hospital`.

Mientras tanto, si queremos que nuestra BD `postgres` pueda ver otra BD `northwind`, tendremos que instalar el Foreign Data Wrapper y hacer otras cosas propias del rol [Databas Administrator](https://en.wikipedia.org/wiki/Database_administrator).

### Ahora, si, `insert`
Ahora si, expliquemos este comando línea por línea:

1. `INSERT INTO hospital.doctor`: insertar en la tabla `hospital.doctor`. Si estamos usando el esquema `hospital`, entonces dejamos fuera el prefijo.
2. `(nombres, apellidos, fecha_contratacion, sueldo, id_especializacion)`: nombramos las columnas a las que vamos a insertarles datos. No tienen que estar en orden, ni tienen que ser todas, pero si dejamos fuera alguna que tenga un `NOT NULL`, entonces el comando insert arrojará un error. Igual debemos recordar que el campo `id_especializacion` es una _llave foránea_ y debe cumplir con constraints de _integridad referencial_.
3. `VALUES('Gregorio', 'Casas', '2006-07-23', 823371.24, 2);`: `VALUES` declara una lista de datos que serán insertados en este comando. **Es obligatorio** que los valores coincidan sintácticamente con los tipos de datos declarados para las columnas declaradas en el punto anterior. Esto es: podemos insertar `'12345678'` en el campo `nombres varchar(50)` por ser una cadena de caracteres (ver las comillas), pero no `12345678` porque es un entero, sin comillas. Ya si nos equivocamos e insertamos un número en el nombre, o el nombre en el apellido, ya es tema nuestro. Ni PostgreSQL ni ningún RDBMS va corregirnos y arrojar un error _"hey! 99999 no es un código postal válido en MX! Y además Pérez no es un nombre!"

### Ejercicio

Vamos a insertar a los siguientes doctores famosos en nuestra tabla de doctores:

| nombres  | apellidos | fecha_contratacion | sueldo | Especializacion         |
|----------|-----------|--------------------|--------|-------------------------|
| Meredith | Grey      | 2005-05-27         | 225000 | Cirugía                 |
| Gregory  | House     | 2004-11-16         | 192000 | Diagnóstico Diferencial |
| Sephen   | Strange   | 2016-12-13         | 320000 | Cirugía                 |
| Helen    | Cho       | 2015-04-13         | 250000 | Medicina genética       |

Si se fijan bien, no estamos declarando en el insert la PK `id_doctor`. Esto es porque, si recuerdan, cuando creamos la tabla, entramos el comando `ALTER TABLE doctor ALTER COLUMN id_doctor SET DEFAULT nextval('id_doctor_doctor_seq')`, lo que significa que cuando insertemos un registro, **automáticamente** se va a asignar un consecutivo, salido de esta secuencia, como valor de la PK.

Finalmente, como seguramente recordarán, la tabla `doctor` tiene un **constraint de integridad referencial** con la tabla `especialidad`, significa que no podremos insertar ninguno de estos doctores sin antes crear la tabla de especializaciones. Aquí se las dejo:

| nombre                  |
|-------------------------|
| Pediatría               |
| Cardiología             |
| Cirugía                 |
| Diagnóstico Diferencial |
| Genética                |
| Ocultismo               |
| Santería                |

Listo, a darle al DBeaver...

#### Multiple insert

Lo que no sabían es que podían hacer esto...

```
INSERT INTO hospital.doctor
(nombres, apellidos, fecha_contratacion, sueldo, id_especializacion)
VALUES
('Gregorio', 'Casas', '2006-07-23', 823371.24, 2),
('Otto', 'Octavius', '2016-11-04', 523371.24, 4),
('Dr', 'Who', '2008-04-19', 723371.24, 5);
```

E insertar varios registros con un solo comando. Disculpen el no haberles dicho esto antes xD

### Completando el ejercicio

Vamos ahora a insertar varios pacientes para probar las relaciones N a N:

| nombres    | apellidos | tipo_sangre | factor_rh | peso | estatura |
|------------|-----------|-------------|-----------|------|----------|
| Roger      | Waters    | O           | 1         | 78   | 190      |
| Alejandro  | Mejía     | O           | 0         | 70   | 175      |
| Raúl       | Fernández | AB          | 1         | 79   | 180      |
| Sebastián  | Dulong    | B           | 0         | 68   | 172      |
| Ulises     | Quevedo   | A           | 1         | 78   | 188      |

No puse a las mujeres de nuestro grupo porque no quiero suponer nada sobre su peso porque creo que es considerado una grosería, no?

Un apunte sobre el campo `paciente.factor_rh`: lo hemos declarado como `bool`, que significa que solo puede tomar valores **`1`** o **`0`**, o **`true`** o **`false`**, o **`t`** o **`f`**, o **`y`** o **`n`**, o **`yes`** o **`no`**. Todos estos tipos son aceptables para este campo, y en el diseño del sistema que alimente esta BD, debe haber esta _traducción_ entre 1 y 0, y **positivo** y **negativo** para el factor RH.

[Aquí](https://www.postgresqltutorial.com/postgresql-data-types/) un resumen muy concreto de los data types que podemos asignarle a columnas en PostgreSQL.

Ahora vamos a rellenar la tabla intermedia `paciente_doctor` para completar el ejercicio y pasar a cosas más interesantes con estos datos:

| id_paciente | id_doctor |
|-------------|-----------|
| 1           | 3         |
| 1           | 4         |
| 2           | 1         |
| 3           | 1         |
| 3           | 4         |
| 4           | 2         |
| 4           | 3         |
| 4           | 4         |
| 5           | 2         |
| 5           | 4         |

## El comando [`delete`](https://www.postgresql.org/docs/current/sql-delete.html)

Vamos ahora a simular la baja de algún paciente, borrando su registro, con el siguiente comando:

```
DELETE FROM hospital.paciente
WHERE nombres = 'Ulises' and apellidos = 'Quevedo';
```

Y como ya es costumbre, lo explicaremos línea por línea:

1. `DELETE FROM hospital.paciente`: `DELETE` borra registros, pero debemos especificar de dónde. `hospital.paciente` nos dice de qué tabla vamos a borrar.
2. `WHERE nombres = 'Ulises' and apellidos = 'Quevedo';`: con `WHERE` indicamos qué registro vamos a borrar. Lo que sigue después de esta keyword son **condiciones**, y tienen la misma forma en otros comandos como `insert` o `select`. Son condiciones booleanas similares a los usados en otros lenguajes de programación. En este ejemplo, vamos a borrar l registro donde `nombres = 'Ulises'` **Y ADEMÁS** que `apellidos = 'Quevedo'`.

>**PREGUNTA VIOLENTA:** Qué creen que suceda si no ponemos la cláusula `WHERE` en un comando `DELETE`?

Entremos el comando en DBever.

Acabamos de dar de baja (o quizá 'dar de alta') a Ulises. Ojalá no haya estado en el hospital con síntomas respiratorios. Comprobémoslo con un comando `select`:

`select * from paciente where nombres = 'Ulises' and apellidos = 'Quevedo';`

El comando `select` es vasto, **vaaaaasto**, y lo cubriremos en 2 clases, pero por el momento, solamente validamos si efectivamente dimos de alta/baja a Ulises. 

### `delete` y las operaciones en cascada

Recuerdan que la tabla `paciente_doctor` tiene una _llave compuesta_ por las 2 _llaves foráneas_ de las 2 tablas, `paciente` y `doctor` cuya relación **N a M** soporta?

Qué habrá pasado, entonces? Si son _llaves foráneas_ y el registro de Ulises ya no está, qué le pasó a sus registros en esta tabla? Veamos...

`select * from paciente_doctor pd, paciente p where p.nombres = 'Ulises' and p.apellidos = 'Quevedo' and p.id_paciente = pd.id_paciente;`

Como podemos ver, no solo eliminamos a Ulises de la tabla de pacientes, sino también todos los registros de los doctores que lo trataron en la tabla **N a M**. No borramos a los doctores, sino solo al registro de que alguna vez lo trataron.

Cómo se logra esto? Recuerdan cómo creamos la tabla `paciente_doctor`?

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

Lo que nos permite esta funcionalidad son las cláusulas `ON DELETE CASCADE` de la cláusula `references`. Lo que está diciendo esta cláusula es _"en caso de que se borre una llave `id_paciente` de la tabla `paciente`, bórrate también, en cascada, lo que tengamos en esta tabla con ese mismo `id_paciente`"

Esto es un arma de doble filo:
- PRO: mantenemos consistencia si borramos un registro en la tabla padre.
- CON: si borramos algo por error, los constrains de integridad referencial no estarán ahí para advertirnos

Alteremos ahora la tabla para que no haga borrado en cascada:

`ALTER TABLE hospital.paciente_doctor DROP CONSTRAINT paciente_doctor_id_paciente_fkey;`

Con esto estamos modificando la tabla `paciente_doctor` y eliminando del todo el _constraint de llave foránea_ llamado `paciente_doctor_id_paciente_fkey`, que fue creado _inline_  con el comando `CREATE TABLE`.

Luego vamos a volver a crear el constraint pero sin las cláusulas `ON DELETE CASCADE`:

`ALTER TABLE hospital.paciente_doctor ADD CONSTRAINT paciente_doctor_id_paciente_fkey FOREIGN KEY (id_paciente) REFERENCES hospital.paciente(id_paciente);`

E intentemos ahora borrar a Sebastián:

```
DELETE FROM hospital.paciente
WHERE nombres = 'Sebastián' and apellidos = 'Dulong';
```
El resultado:

![](https://imgur.com/q07QJBP.png)

Sin el borrado en cascada, eliminar un registro de la tabla padre (del lado del **1** en una relación **1 a N**, es decir, del lado de la llave primaria), no borra los mismos registros en la tabla hija (hacia donde se copia la llave y cae como llave foránea), y entonces ahí si los constraints de integridad referencial nos protegen de hacer estupideces.

### El `delete` IRL

#### Se usa IRL el comando `delete`?

Sí, generalmente en usos estructurales:

1. Migraciones de bases de datos: "Oracle ya nos sale muy caro, vamos a mandarlos a la jodida y cambiar por MySQL o PostgreSQL". Usualmente borramos las tablas viejas.
2. Cambios estructurales: "Debido a la pandemia, y al alto número de ingresos hospitalarios de mútliples miembros de la misma familia, Médica sur ha permitido que un `visitante` pase a ver a más de 1 `paciente`, y nuestra base de datos actual no lo soporta". Debemos borrar la tabla vieja de visitantes, crear una tabla intermedia N a M, volver a crearla en una versión reducida, pasar algunos campos a la tabla intermedia, y volver a vaciar los datos.
3. Destrucción de datos debido a GDPR o LFPDP: "Nos llamó un cliente solicitando que eliminemos todos los datos que tenemos de él. Deberemos borrarlo de la tabla `cliente` y afortunadamente la operación en cascada se encargará del resto".
4. Construcción de BDs históricas: "Nuestra tabla de 'pagos' ya tiene millones de registros, y aún con índices las consultas se alentan mucho. Es tiempo de mover el histórico profundo de más de 2 años a un Datawarehouse". Aquí tendríamos que construir un proceso para que periódicamente se moviera el histórico profundo **de todas nuestras tablas transaccionales** a una base de datos analítica, buena para leer, maletona para escribir, y que borre los registros de la BD origen, y además recalcule los índices. Estos programas se llaman **ETL (Extraction, Transformation & Loading)**, y los veremos más tarde.

#### Cuándo **no se usa** delete?
1. Cuando un cliente abandona nuestro negocio: es preferible agregar un atributo/campo/columna de `id_status`, un catálogo de `status_cliente`, un renglón de status inactivo o suspendido, y cambiar las reglas de negocio en código de nuestro sistema para no operar clientes con este tipo de status.
2. Cuando queremos desactivar o dejar de usar una entidad: "la película de 'Mirreyes VS Godínez' ha sido prohibida por la 4T, y debemos sacarla del catálogo". En este caso, agregar un catálogo de status, agregar el campo status en `inventory` (no en `film`, porque es un atributo de la película en mi inventario, no de la película en sí) en la BD de Sakila, y modificar nuestro sistema para ahora no permitir rentar películas cuyo registro en el inventario tenga un status `no disponible`.

## El comando `update`

Si borrar es muy extremo para uds, entonces podemos solamente "actualizar".

Supongamos que durante su tratamiento, Ulises es diagnosticado por Dr. House con una rara afección que solo la Dra. Grey puede atender. Ulises, puestísimo, acepta el tratamiento. Lo que nuestro sistema de control hospitalario es insertar un registro en `paciente_doctor` indicando esta nueva relación.

`insert into paciente_doctor (id_paciente, id_doctor) values ((select id_paciente from paciente where nombres = 'Ulises' and apellidos = 'Quevedo'), (select id_doctor from doctor where nombres = 'Meredith' and apellidos = 'Gray'));`

Pero eventualmente, el tratamiento de Ulises le provoca desorden de personalidad múltiple, lo cual lo hace, sin razón alguna, creer que ahora es Djin Darin a.k.a. The Mandalorian, y ahora todas sus frases las termina con "this is the way". Para reflejar este nuevo comportamiento, legalmente debemos cambiar su nombre en nuestro registro de pacientes:

`update paciente set nombres = 'Djinn', apellidos = 'Darin' where nombres = 'Ulises' and apellidos = 'Quevedo';`

Dado eso, el hospital cambia sus reglas de negocio para que, en lugar de que **1** paciente sea atendido por **N** doctores, ahora habrá 1 doctor en este grupo que será el responsable del paciente. Para ello, debemos crear la columna `principal` de tipo `bool` en la tabla `paciente_doctor`.

`ALTER TABLE paciente_doctor ADD COLUMN principal bool DEFAULT false;`

