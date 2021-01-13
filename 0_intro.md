# Intro a Bases de Datos para Ciencia de Datos
Comenzaremos con tareas de instalación, setup y housekeeping, luego pasaremos a carga de BDs de prueba, y finalmente a discutir lo que deben ser capaces de desarrollar al final de este curso, va?

> **DISCLAIMER: ** Disculpen, soy muy malhablado. Si esto les molesta, díganme con toda confianza. Nunca les faltaré al respeto, pero si le diré a villanos (como Oracle, como Palantir, como KIO Networks) por su nombre.

## Documento de dudas y notas

Me he tomado la libertad de crear [este documentito](https://docs.google.com/document/d/1dJmES9XzNGdmnjsh3NNArmbku7ChdwmIJc2AZiHKwOI/edit?usp=sharing) en Google Docs para que todos lo accedan y, si quieren, todos hacer anotaciones en él de forma colaborativa, y "arrobarme" si tienen alguna pregunta que quieran que les responda si acaso no se sienten con la confianza de levantar la mano o hacerla durante la sesión, va?

## Levantando PostgreSQL
Si instalaron PostgreSQL como servicio, entonces debe estar ya levantado al arrancar su máquina. Esto no es del todo recomendable, pero no fatal.

![](https://pbs.twimg.com/media/EU1JsBIUMAEyZrw.jpg)

### Cómo compruebo si está arriba?
Usaremos DBeaver para esto. Ábranlo.

Si es su 1a vez en él, van a ver esta ventanita:

![](https://imgur.com/o0LBDGQ.png)

Seleccionen **PostgreSQL**. Los va a llevar a la selección de drivers:

![](https://imgur.com/h9hyYvW.png)

Esta pantalla es para Oracle, pero ustedes deben ver una pantalla para PostgreSQL, con menos elementos.

Un driver es el que "traduce" SQL escrito en instrucciones que las "tripas" de PostgreSQL entienda. También se encarga de "intermediar" por nosotros (o nuestro código) en cuestión de transacciones y monitoreo. Sin este driver, no podemos "hablarle" a la BD desde fuera, lo cual nos imposibilita las arquitecturas distribuídas y de capas que platicamos antes.

Después los llevará a los detalles de la BD. Explicaré los campos más importantes a continuación:

![](https://imgur.com/qFiLIv6.png)

- Host: es el nombre o la dirección IP donde reside el server. Recuerdan qué era el server? El programita que abría un canal de conexión y se queda "escuchando" o "esperando" conexiones y a través de ella, comandos o sentencias SQL.
- Port: cada dirección IP maneja puertos donde se puede escuchar. Hay puertos _estándar_ para los protocolos o servicios más comunes: `HTTP` en el puerto `80`, `FTP` en el puerto `21`, `SSH` en el puerto `22`. Del puerto `1` al puerto `1023` son de sistema. Del `1024` en adelante son para usuario, aunque muchos ya están "apartados". [Esta pag de Wikipedia](https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers) da un resumen de qué se escucha en cada puerto.
- Database: En una instalación de cualquier motor de base de datos, pueden haber múltiples bases de datos. En su caso, la instalación por default viene con una BD llamada **`postgresql`**.
- Username: el usuario con el cual nos conectaremos a la BD. Cuando instalaron PostgreSQL, se creó un usuario por default llamado **`postgres`**. Éste es ese usuario.
- Password: al instalar el PostgreSQL, les pidió definir un password, y sugerí que entraran **`admin`**. Éste es ese password.

Los demás campos los podemos dejar vacíos o con sus valores por default.

Cuando den "Finish", se habrá creado una conexión. Pueden dar también en "Test connection..." si les da OCD y quieren validarla antes de conectarse de neta xD

Luego darán click en donde puse el circulito rojo:

![](https://imgur.com/JCqhs3v.png)

Si vemos esto:

![](https://imgur.com/OWovUrP.png)

Entonces 1) el PostgreSQL está instalado y levantado, y escuchando conexiones correctamente, y 2) el DBeaver se conecta correctamente con el PostgreSQL.

YAY!

## Carga de las BDs de prueba que usaremos

Como platicamos, usaremos 2 BDs de prueba durante todo el curso:

1. Northwind: BD que Microsoft usa para sus demos. Describe un negocio de transporte de bienes.
2. Sakila: video rental store.

Por el momento solo cargaremos la BD de Sakila, la cual encontrarán en este repo, con 4 archivos:

1. `postgres-sakila-schema.sql`: la estructura de la BD - tablas, relaciones, constraints, etc.
2. `postgres-sakila-insert-data.sql`: los datos de cada tabla.
3. `postgres-sakila-delete-data.sql`: script para borrado de todos los datos de todas las tablas.
4. `postgres-sakila-drop-objects.sql`: script para borrado de la estructura de la BD - tablas, relaciones, constraints, etc.

Vamos a ejecutar, en este orden, el 1 y 2.

Abriremos el archivo `postgres-sakila-schema.sql` en DBeaver. Se debe ver así:

![](https://imgur.com/YrJBscQ.png)

Y daremos click en **Execute SQL Script"** en el pequeño toolbar a la izquierda de la ventana de nuestro archivo, o bien dar click derecho y elegir la misma opción:

![](https://imgur.com/kmIEs29.png)

![](https://imgur.com/HbX6g8a.png)

![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABcAAAB5CAYAAADS1LqKAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAASdEVYdFNvZnR3YXJlAEdyZWVuc2hvdF5VCAUAAAO+SURBVGhD7ZnbbtMwGMc3JuACrrjjeXgAHombdRMICbjkDXgOJMTdQENMY+JQytY2a5yD1F4H/906/eJ8dmynFULKxU9xfPjZseND2oOrq6uqLMu9oOT7QsmLotgLg5xlkLN4yZfHB2x8F97ymAq85avRYbUc3ZH3eSvdRlDL6ycQCZvPJEq+PL1flYtrNi8lTr6hTKdsfk0vOZeXEi3n8pl4y1fyTQkRg+CWc+k2guRcmgtvORffhZc8lkHOMshZBjnLv5ertSUXbJoLb3lMBUHy0AqC5SEVRMl9K4iWgyLP2PyaKLnerLuOdvHdwuQziRtQkvb03ZMqz/knCJabaTuT0zhITTJjgL3lZlyapVUi5kqKlgt5nxsD7CV3ATkq4tJ6yyE2W6zpLXcxyFkGOUu3HJsCJgmuanrjnZYgjHhxK6+LZpkNbnk6r9eVLlQlRnm7XLZseSy/92XBMhnXT1DK9UQhP3DpF56qwHttkd/320JMumR1chQnR+uoXF2z5qNrOY2jdHRLU67CpG9pOkewXN1vjhU0ncMhF43COryNy0mYKS+xy+W7SwvrMCjTWSOuUY5gl8u+pYXrMJkw0QOK1ply81WLf1uAGrimkBIsL28ndYs56h/P8pQc67blKW35zUVLaFKQCbY8udsoT2l3y2blozIrzx/U7zyHfUD/nFfl7zM7SBfrV9KGe0B7MshZBjlLh1yuK1gFsftg2m/AFljgJ251rMCxg/9kdMvJJt1FOb1slbfLcWY5vacKbldGeUUrMeXlcUOnK7AU4CmIwyovFzd1QS4douXIOFoY3WNvObOHYpnV6fhbgaZz2FvO7EQqbDy6C4d8ysoBuszMz2HvFvSpRb56+UjG2bc/TVCf1/eeXWOXk90I96Fi4Ja/eNiQmwdR9Wnu6B6HvBv93c+lgbacnLQoNA+kJjfMG9SS03O5TY7vfcggncn5kMg1iHuCdsvJ0dkm10COn0K4NMD2OU5d6yVVLrFYpCxnEzyB+QMOpdeAdjHIWQY5i1O+yLrXbBdWucg3GV598gJ5fyW+G7REF/o4TlsyjlZ5HznlRyIUmQwfvfncSqd4yWnLdPjrVOxGPr7Nqu9zUX2bbRew6zTfjVzzkwzYTOxIrruChnfWLRyYA3uTo4t23i2P335RXE7TfnI9S20EyycL+54IEvmW4JrKig9fB8ovpqLuBo5n78fVXFYw+jBR97SsSUs+F+uWm1IOWo6D7fN5VlTn12l1NllYQTomklmW4hzQvgxylv9VXlR/AdaUbIndZptuAAAAAElFTkSuQmCC)

Haremos lo mismo con el archivo `postgres-sakila-insert-data.sql`. Éste último se va a tardar un ratote, por lo que pasaremos a la siguiente parte de la clase cuando comience la carga. Mientras se esté cargando los datos y demás elementos de la BD, no apaguen su máquina, no cierren DBeaver, no respiren, *DON'T BLINK!*

### Qué hago si me equivoco en algo?

Ve a DBeaver, selecciona el esquema `public` (al rato explicaremos que es un esquema, pero por ahora solo entérate que es una estructura que nos permite asignar BDs independientes y que lo que vive en un esquema no puede ver directamente lo que vive en otro.

Luego da click derecho en el esquema `public` y da click en la opción `Delete`.

![](https://imgur.com/IvtcQq3.png)

Luego da click derecho en `Schemas` y luego en `Create New Schema`.

Y dale el nombre de `public` de nuevo, dado que el script de creación e inserción de Sakila **requiere** que el esquema se llame `public`. De lo contrario podríamos llamarlo como deseemos.

![](https://imgur.com/XZkvlIa)

Y repite la carga de la estructura y de los datos como lo dijimos arriba.

Podríamos también ejecutar, en orden, el script de borrado de datos y posteriormente el de borrado de la estructura, pero sería más tardado. Si prefieren hacerlo, adelante.

## A qué le estamos tirando?

Para este ejercicio visitaremos el [mapa de COVID de Johns Hopkins](https://coronavirus.jhu.edu/map.html), y haremos un ejercicio en [este pizarrón de Google Jamboard](https://jamboard.google.com/d/1og4fJ0Y3w42JetnOWP04SGoGn4IkzVCK4i_mtp3dPLc/viewer).

Si tomamos el mapa como un "destino final" de los datos, entonces cuál es su origen? Vamos a hipotetizar el camino que siguen:
