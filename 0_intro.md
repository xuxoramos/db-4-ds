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
- Port: cada dirección IP maneja puertos donde se puede escuchar. Hay puertos _estándar_ para los protocolos o servicios más comunes: HTTP en el puerto 80, FTP en el puerto 21, SSH en el puerto 22. Del puerto 1 al puerto 1023 son de sistema. Del 1024 en adelante son para usuario, aunque muchos ya están "apartados". [Esta pag de Wikipedia](https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers) da un resumen de qué se escucha en cada puerto.
- Database: En una instalación de cualquier motor de base de datos, pueden haber múltiples bases de datos. En su caso, la instalación por default viene con una BD llamada **postgresql**.
- Username: el usuario con el cual nos conectaremos a la BD. Cuando instalaron PostgreSQL, se creó un usuario por default llamado **postgres**. Éste es ese usuario.
- Password: al instalar el PostgreSQL, les pidió definir un password, y sugerí que entraran **admin**. Éste es ese password.

Los demás campos los podemos dejar vacíos o con sus valores por default.

Cuando den "Finish", se habrá creado una conexión. Pueden dar también en "Test connection..." si les da OCD y quieren validarla antes de conectarse de neta xD

Luego darán click en donde puse el circulito rojo:

![](https://imgur.com/JCqhs3v.png)

Si vemos esto:

![](https://imgur.com/OWovUrP.png)

Entonces 1) el PostgreSQL está instalado y levantado, y escuchando conexiones correctamente, y 2) el DBeaver se conecta correctamente con el PostgreSQL.

YAY!

### Carga de las BDs de prueba que usaremos

Como platicamos, usaremos 2 BDs de prueba durante todo el curso:

1. Northwind: BD que Microsoft usa para sus demos. Describe un negocio de transporte de bienes.
2. Sakila: video rental store

Por el momento solo cargaremos la BD de Sakila. Para esto, en el repo 




