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

La jerarquía de _contenedores_ o _folders_ de PostgreSQL es la siguiente

![](https://imgur.com/ZflCCJJ.png)

**`Database Server -> Database -> Schema`**

Tablas dentro del mismo esquema son visibles entre ellas sin referirse explíticamente al esquema al que pertenecen.

Tablas en diferentes esquemas, pero dentro de la misma base, son visibles solo con el prefijo `[esquema].[tabla]`, de modo que si tenemos un esquema `hospital` y otro esquema `laboratorio`, y desde la tabla `hospital.estudio` queremos tener acceso a `laboratorio.reactivos`, entonces debemos referirnos a una y a otra tabla como aparecen en el ejemplo, con sus esquemas como prefijos.

Tablas en bases de datos diferentes (y obviamente en esquemas diferentes) no pueden verse, a menos que instalemos la extensión [Foreign Data Wrapper](https://www.postgresql.org/docs/current/postgres-fdw.html). Esto está totalmente fuera de este curso.

Ahora si, expliquemos este comando línea por línea:

1. `INSERT INTO hospital.doctor`: insertar en la tabla `hospital.doctor`. Si estamos usando el esquema `hospital`, entonces dejamos fuera el prefijo.
2. `(nombres, apellidos, fecha_contratacion, sueldo, id_especializacion)`: nombramos las columnas a las que vamos a insertarles datos. No tienen que estar en orden, ni tienen que ser todas, pero si dejamos fuera alguna que tenga un `NOT NULL`, entonces el comando insert arrojará un error. Igual debemos recordar que el campo `id_especializacion` es una _llave foránea_ y debe cumplir con constraints de _integridad referencial_.
3. `VALUES('Gregorio', 'Casas', '2006-07-23', 823371.24, 2);`: `VALUES` declara una lista de datos que serán insertados en este comando. **Es obligatorio** que los valores coincidan sintácticamente con los tipos de datos declarados para las columnas declaradas en el punto anterior. Esto es: podemos insertar `'12345678'` en el campo `nombres varchar(50)` por ser una cadena de caracteres (ver las comillas), pero no `12345678` porque es un entero, sin comillas. 
