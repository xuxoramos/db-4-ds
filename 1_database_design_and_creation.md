# Diseño y creación de Bases de Datos

Hemos cargado una basesotototota de datos a nuestro PostgreSQL, pero nunca vimos cómo hacerlo realmente. Solo descargamos un script ya hecho y lo ejecutamos, sin saber las tripas. Vamos a ver qué tiene por dentro nuestra estructura.

## Obteniendo el E-R Diagram de Sakila

Los diagramas E-R son el primer artefacto que debemos tener antes de crear bases de datos en cualquier manejador. Definen entidades de negocio y sus relaciones.

En el ejemplo del sistema de ingresos hospitalarios en el hospital COVID que imaginamos en el ejercicio pasado:

- **1** `PACIENTE` recibe **N** `VISITANTES`
- **N** `ESTUDIOS` son realizados en **1** `PACIENTE`
- **N** `ESTUDIOS` pueden ser solicitados por **?** `DOCTORES`

> Qué va ahí? 1? N?

Abramos DBeaver y vayamos a la ventana `Projects` debajo de nuestro `Database Navigator`. Si no aparece, podemos ir al menú `Window -> Show View -> Projects`.

En la ventana de `Projects` hagamos click derecho en la opción `ER Diagrams`.

Luego, dentro del menú contextual que aparece, hagamos click en `Create New ER Diagram`.

![](https://imgur.com/rLPgNbR.png)

DBeaver está chido, aparte de todo, porque tiene un generador de modelos ER, lo cual facilita tareas de ingeniería inversa.

Ahora DBeaver nos pide que, en todo el árbol de elementos de la BD `postgres`, seleccionemos a partir del cual vamos a hacerle _reverse engineering_ para obtener el diagrama que **probablemente** hicieron los que crearon la BD original.

Vamos a recorrerlo hasta llegar al esquema `public`. Los esquemas no son más que folders o directorios para ayudarnos a organizar el contenido de la BD. Ahorita nuestro PostgreSQL tiene 1 BD, pero en producción, donde 1 BD sirve como backend a cientos de sistemas y donde todos escriben a él, tener estos elementos de agrupación ayuda a no perdernos.
 
También vamos a bautizar nuestro diagrama E-R como `sakila-er` y darle `Finish`.

![](https://imgur.com/ZflCCJJ.png)

## Elementos de un E-R Diagram

Lo que vemos es esto:

![](https://imgur.com/nDXLA2D.png)

Explicaremos cada elemento de un diagrama E-R a continuación.

> **NOTA:** Es importante mencionar que hay diferentes formas de representar los elementos de un E-R Diagram, entonces váyanse acostumbrando a que "hay variedad" xD


1. **Tabla / Entidad:** Son las entidades del problem domain que vamos a modelar. Usualmente aparecen como _sustantivos_ en una narrativa.
2. **Relaciones:** Cuando 2 entidades tienen una conexión, se establece una relación. Estas relaciones denotan _composición_; es decir, una cosa _tiene_ otra. En este diagrama, una relación se expresa con una línea que conecta 2 entidades, y además podemos verlas porque la **llave primaria** de la entidad central en la relación _se copia_ como **llave foránea** en la entindad secundaria.
3. **Atributos:** son campos que le dan _contexto_ a una entidad. Un `VISITANTE` puede serlo para [Amazon.com](https://www.amazon.com.mx/hz/wishlist/ls/1QLHZMUHUQOH9?ref_=wl_share) si le agregamos atributos como `email`, `account_id`, `país`, `ultima_compra`, pero si le agregamos atributos como `hora_entrada` y `placa_vehiculo`, quizá sea un visitante a un condominio.
    - Qué atributos o relaciones le agergarían para hacerlo un `VISITANTE` de un paciente en un sistema hospitalario?
    
Existen otros elementos, que quedarán más claros más delante.

## Relaciones y llaves en un diagrama E-R

Los diagramas **E**ntidad-**R**elación son perfectos para expresar el contenido de _bases de datos relacionales_. Existen varios tipos:

### Relaciones 1 a N / N a 1

La usamos cuando una _entidad 1_ puede tener 1 o más objetos del tipo _entidad 2_ asociados. En nuestros ejemplos: **1** `PACIENTE` con **N** `VISITANTE`s. Es importante aquí dejar claro que en este tipo de relaciones, la entidad en el extremo **1** de la relación _copia_ su llave primaria (ver abajo) a la entidad en el extremo del lado **N** de la relación, donde su tipo cambia a llave foránea.

Es imposible expresar esta relación _al revés_ en BDs relacionales, debido a que el contenido de las entidades o tablas es de **1 Y SOLO 1** registro u observación, y de **1 Y SOLO 1** tipo, y por tanto no puede tener registros anidados de otro tipo.

Qué es eso de las llaves primarias y foráneas? Sigan leyendo...

#### Llave primaria
 Le da _**unicidad**_ a un registro en una tabla y es la forma de identificar _**inequívocamente**_ a uno, y solo un registro. Es buena práctica que una tabla no tenga _duplicados_, y la llave primaria permite identificar a **UNO, Y SOLAMENTE UNO** de los registros de la tabla, u observaciones de la entidad.
 
 #### Llaves foráneas

Establece relaciones entre entidades. Cómo saber que un `VISITANTE` viene a visitar a un `PACIENTE`? Cómo saber que mi `WISHLIST` me pertenece _a mi_ y no a alguno de uds? Sigan leyendo...

    - La entidad `WISHLIST` tiene una relación **N** a **1** con la entidad `CLIENTE` en el sistema de Amazon.com y por tanto la llave primaria de `CLIENTE` se copia como llave foránea a la tabla `WISHLIST`. La entidad `PACIENTE` tiene una relación **1** a **N** con la entidad `VISITANTE`, por tanto, la tabla `PACIENTE` copia su llave primaria a la entidad `VISITANTE` como llave foránea.
    - Como regla, en una relación **N a 1**, la llave primaria de la tabla del lado del **1** se copia **como llave foránea** a la tabla del lado de la **N**.
 
#### Buenas prácticas para llaves primarias
1. No tener que ver con nada del problem domain (i.e. no ser un folio que se use en un proceso del problem domain, no ser el RFC, ni CURP, etc).
2. No tener el potencial de repetirse (i.e. nombres completos, apellidos, marcas, razones sociales, etc)
3. Sugerimos que sea _numérica, entera y consecutiva_.

Es importante elegir bien, o diseñar, nuestras propias llaves primarias, porque se copiarán como llaves foráneas en el resto de las relaciones, y si las elegimos mal tal que deban sufrir cambios o redefinirlas, tendremos que rediseñar toda nuestra base de datos.

Aquí la llave primaria de la tabla `customer` de la BD de Sakila:

![](https://imgur.com/0uBNW9w.png)

Y en esta captura ejecutamos 2 consultas: una para obtener todas las llaves primarias de la tabla `customer` y otra para obtener la misma lista, pero sin duplicados. Podemos ver que ambas son las mismas, por lo que podemos deducir que la llave `customer_id` cumple con que no haya duplicados.

![](https://imgur.com/khpB92C.png)

#### Lave primaria compuesta

Las llaves compuestas las usamos **como llaves primarias** en 2 casos:

**1. En tablas intermedias de relaciones N a M:** juntamos las llaves foráneas (ver abajo) de las tablas que queremos conectar con este tipo de relación, logrando el N a M en esta tabla intermedia con 2 relaciones N a 1 y 1 a M. Aquí un ejemplo entre las tablas `film` y `actor`:

![](https://imgur.com/s3hsDN8.png)

Como podemos ver, para representar que _"N actores aparecen en M películas"_, debemos de copiar la llave primaria de `actor` y la llave primaria de `film` a una tabla de soporte, cuya llave primaria, entonces, se forma por la composición de ambas llaves foráneas. Si no tuviéramos esto, entonces no sabríamos qué actor aparece en qué película.

Por otro lado, si quisiéramos evitar el uso de llaves compuestas, o de tablas intermedias del todo, tendríamos que hacer esto:

![](https://imgur.com/G7jVGeY.png)

O esto:

![](https://imgur.com/BQEymAp.png)

O esto:

![](https://imgur.com/NZ39XQY.png)

Y ninguna de las 3 formas cumple con el paradigma relacional (el 1o es más un esquema de documentos, y el 2o y 3o son totalmente antipatrones)

**2. En tablas con información histórica:** guardamos la llave de la entidad a la que queremos construirle el histórico, y además el **timestamp** o marca de tiempo, en la granularidad necesaria (hora, min, seg, milis, micros, nanos) de modo que sepamos el instante en el que sucedieron los tipos de eventos que queremos registrar. Aquí un ejemplo de tabla histórica hipotética que registra cambios en su contrato de internet de Infinitum:

![](https://imgur.com/BNdzuAD.png)

Podemos ver que no es posible definir el `id_contrato` como llave primaria de esta tabla histórica porque se repite por cada evento. Igual no podemos definir el `id_cliente` porque también se repite. Nuestra única forma de definir que cada evento le pertenece a un contrato y a un cliente es definiendo una llave compuesta con el `id_cliente`, `id_contrato` y el `timestamp`. Solamente de este modo podemos responder a la pregunta "por qué nuestro cliente dejó de contratar nuestros servicios?" (hint: vean las fechas).
    
### Relaciones 1 a 1
Esta es una "especialización" de las relaciones N a 1, con la particularidad de que cuando copiamos la llave primaria de la entidad primaria como llave foránea a la entidad secundaria, _además_ agregamos un _constraint_ de tipo _unique_. Esto significa que le asignamos una regla **estructural** a la llave foránea de que no puede tener valores repetidos a lo largo de todas las observaciones o registros.

Recuerden que una _llave primaria_, para ser _primaria_, debe ser _única_ e irrepetible, como dictan los libros de autoayuda del tec de mty xD.

Mientras que una llave foránea, puede repetirse (en caso de una relación **N a 1**), o puede restringirse su repetición (en caso de **1 a 1**).

![](https://imgur.com/R631tpv.png)

En este ejemplo podemos ver como un miembro del staff en la BD de Sakila tiene asociado solo 1 `address`, que a su vez tiene asociada 1 `city`, que a su vez tiene asociado un `country`.

Veremos más tipos de constraints más delante.

#### Un caso particular de 1 a N / 1 a 1: Relaciones Recursivas

Las relaciones recursivas las usamos cuando tenemos una entidad que debe hacer referencia a sí misma para poder representar bien el problem domain. Las tenemos cuando, por ejemplo, deseamos representar un reporte directo de la entidad empleado con otro del mismo tipo:

![](https://web.csulb.edu/colleges/coe/cecs/dbdesign/img/recursive-uml.gif)

Como podemos ver, **N** `Employee`s pueden tener **1** `Employee` como reporte directo, definido como llave foránea en el campo `manager`.

Otro ejemplo puede ser en el contexto de mercado de valores. Antes de cerrar una operación, se debe hacer match entre una postura de compra y una postura de venta. La relación es de 1 a 1, pero son 2 instancias de una misma entidad, con los mismos atributos y mismo comportamiento dentro del contexto del problem domain. Su única diferencia es el tipo de postura: de **C**ompra o de **V**enta.

Esto podemos modelarlo con una relación recursiva, de este modo:

![](https://imgur.com/T0rQZdT.png)



### N a N

Las bases de datos relacionales tienen una desventaja, que cada renglón de cada tabla representa una, y solo una observación. Esto complica representar relaciones de N a N, como por ejemplo:
- **N** actores apareciendo en **N** películas
- **N** cirugías realizadas por **N** médicos cirujanos
- **N** marcas de vacunas suministradas a **N** estados de la república

La forma de definir esto en un diagrama E-R es **_poniendo una tabla/entidad intermedia_** entre ambas entidades. Esta entidad intermedia tiene una relación **1 a N** con una de las entidades, y **N a 1** con la otra entidad.

Tomemos como ejemplo la BD de Sakila, y como representa la relación entre películas y actores:

![](https://imgur.com/JchRxBA.png)

Tomemos el período más productivo del mejor actor de las últimas décadas: Don Nicholas Cage.

De 1995 a 1999 Don Nicholas Cage participó en las siguientes películas:

![](https://upload.wikimedia.org/wikipedia/en/thumb/3/39/Leaving_las_vegas_ver1.jpg/220px-Leaving_las_vegas_ver1.jpg) ![](https://upload.wikimedia.org/wikipedia/en/thumb/8/82/The_Rock_%28movie%29.jpg/220px-The_Rock_%28movie%29.jpg) ![](https://upload.wikimedia.org/wikipedia/en/thumb/1/1d/Conairinternational.jpg/220px-Conairinternational.jpg) ![](https://upload.wikimedia.org/wikipedia/en/1/1c/FaceOff_poster.jpg) ![](https://upload.wikimedia.org/wikipedia/en/thumb/e/e1/City_Of_Angels.jpg/220px-City_Of_Angels.jpg) ![](https://upload.wikimedia.org/wikipedia/en/thumb/b/bc/8mm-film-poster.jpg/220px-8mm-film-poster.jpg)

Pero si nos fijamos en la parte de arriba de cada poster, cada película tiene varios protagonistas. Del mismo modo, Sean Connery, por ejemplo, después de trabajar con Cage en _The Rock_, actuó en _The Avengers_ (no la del MCU), _Playing it by Heart_, y _Entrapment_.

Si quisiéramos representar la relación entre películas y actores, podemos decir que **N** actores participan en **N** películas, pero la tabla `film` solo puede representar 1 de ellas por cada renglón, y si agregamos un atributo `actores` solo le cabría un dato. Igualmente a la entidad `actor` solo soporta un dato en el atributo `pelicula`. La solución es tener 2 relaciones **N a 1** hacia una entidad o tabla intermedia de soporte.

> Qué llaves primarias se _copiarían_ a esta tabla intermedia de soporte?


## Diseñando una BD

A continuación haremos un ejercicio de diseño de BD a partir de la siguiente narrativa ficticia:

### Médica Sur VS COVID19

El protocolo global de reporteo de COVID19 sugerido por la OMS ha obligado a Médica Sur a modificar sus sistemas de ingreso hospitalario. El sistema actual permite capturar los datos generales de un paciente, como nombre, dirección, RFC, y síntomas. También permitía la captura de N visitantes, cada uno con sus atributos. Ahora, entre los cambios impuestos, están:

1. Los pacientes deberán llegar por urgencias y se les realizará un triage respiratorio. Ya no se admitián pacientes "walk-in".
2. El triage respiratorio resultará en canalización del paciente hacia el área de atención a COVID, o hacia el área de atención de enfermedades respiratorias no COVID, y hacia atención general.
    - Se deberá registrar minuciosamente los síntomas, el estudio con el cual se detectaron, y el médico que los ordenó, y el médico que definió el triage.
3. Solo se podrá registrar un visitante para cualquier paciente.
4. Para los pacientes que han sido canalizados al área de COVID, su visitante se le asignará pase de estacionamiento mostrando tarjeta de circulación vigente.
5. Se mantendrá registro de todo medicamento que se le administre al paciente. Dicho medicamento sale de un inventario específico para COVID que mantiene el hospital.
6. Cada paciente con COVID se tratará con algunas de las siguientes 3 etapas:
    - Etapa de tratamiento: desde los primeros síntomas hasta fiebre difícil de controlar.
    - Etapa crítica: desde detección de neumonía hasta entubamiento.
    - Etapa de recuperación: los pacientes pueden declararse en esta etapa sin necesariamente haber transcurrido la etapa 2.
7. A los pacientes que se recuperen el hospital les realizará una llamada de screening cada 2 semanas para registrar secuelas y estado general de salud.

Para dibujar esta relación, entra a https://www.diagrameditor.com/







