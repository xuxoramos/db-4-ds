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

| id_especialidad | nombre                  |
|-----------------|-------------------------|
| 1               | Pediatría               |
| 2               | Cardiología             |
| 3               | Cirugía                 |
| 4               | Diagnóstico Diferencial |
| 5               | Genética                |
| 6               | Ocultismo               |
| 7               | Santería                |

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

No puse a las mujeres de nuestro grupo porque no quiero suponer nada sobre el peso

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
| 4           | 5         |
| 5           | 2         |
| 5           | 5         |

## `delete`

Vamos ahora a 


