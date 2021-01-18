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
4. **Llave primaria:** le da _unicidad_ a un registro en una tabla. Una tabla no debe tener duplicados, y la llave primaria permite identificar a **UNO, Y SOLAMENTE UNO** de los registros de la tabla, u observaciones de la entidad.
5. **Llaves foráneas:** establece relaciones entre entidades. Cómo saber que un `VISITANTE` viene a visitar a un `PACIENTE`? Cómo saber que mi `WISHLIST` me pertenece _a mi_ y no a alguno de uds? Sigan leyendo...
    - La entidad `WISHLIST` tiene una relación **N** a **1** con la entidad `CLIENTE` en el sistema de Amazon.com y por tanto la llave primaria de `CLIENTE` se copia como llave foránea a la tabla `WISHLIST`. La entidad `PACIENTE` tiene una relación **1** a **N** con la entidad `VISITANTE`, por tanto, la tabla `PACIENTE` copia su llave primaria a la entidad `VISITANTE` como llave foránea.

Existen otros elementos, que quedarán más claros más delante.

## Relaciones en un diagrama E-R

Los diagramas **E**ntidad-**R**elación son perfectos para expresar el contenido de _bases de datos relacionales_. Existen varios tipos:

### 1 a N / N a 1

La usamos cuando una _entidad 1_ puede tener 1 o más objetos del tipo _entidad 2_ asociados. En nuestros ejemplos: **1** `PACIENTE` con **N** `VISITANTE`s. Es importante aquí dejar claro que en este tipo de relaciones, la llave primaria de la entidad en el extremo **1** de la relación _copia_ su llave primaria a la entidad en el extremo del lado **N** de la relación.

Es imposible expresar esta relación _al revés_ en BDs relacionales, debido a que el contenido de las entidades o tablas es de **1 Y SOLO 1** registro u observación, y de **1 Y SOLO 1** tipo, y por tanto no puede tener registros anidados de otro tipo.

![](https://imgur.com/R631tpv.png)

### 1 a 1
Esta es una "especialización" de las relaciones N a 1, con la particularidad de que cuando copiamos la llave primaria de la entidad primaria como llave foránea a la entidad secundaria, _además_ agregamos un _constraint_ de tipo _unique_. Esto significa que le asignamos una regla a la llave foránea de que no puede tener valores repetidos a lo largo de todas las observaciones o registros.

Recuerden que una _llave primaria_, para ser _primaria_, debe ser _única_ e irrepetible, como dictan los libros de autoayuda del tec de mty xD.

Mientras que una llave foránea, puede repetirse (en caso de una relación N a 1), o puede restringirse su repetición, en caso de 1 a 1.

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

Pero si nos fijamos en la parte de arriba de cada poster, cada película tiene varios protagonistas. Del mismo modo, Sean Connery, por ejemplo, después de trabajar con Cage en _The Rock_, actuó en The Avengers, Playing it by Heart, y Entrapment.

Si quisiéramos representar la relación entre películas y actores, podemos decir que **N** actores participan en **N** películas, pero la tabla `film` solo puede representar 1 de ellas por cada renglón, y si agregamos un atributo `actores` solo le cabría un dato. Igualmente a la entidad `actor` solo soporta un dato en el atributo `pelicula`. La solución es tener 2 relaciones **N a 1** hacia una entidad o tabla de soporte.

> Qué llaves primarias se _copiarían_ a esta tabla intermedia de soporte?

## Diseñando una BD

A continuación haremos un ejercicio de diseño de BD a partir de la siguiente narrativa:

> 







