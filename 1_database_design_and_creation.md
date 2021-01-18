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

Lo que vemos es esto:

![](https://imgur.com/nDXLA2D.png)

Explicaremos cada elemento de un diagrama E-R a continuación.

> **NOTA:** Es importante mencionar que hay diferentes formas de representar los elementos de un E-R Diagram, entonces váyanse acostumbrando a que "hay variedad" xD






