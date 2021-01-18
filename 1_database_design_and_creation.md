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

### N a N







