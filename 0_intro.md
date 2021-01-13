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

Haremos lo mismo con el archivo `postgres-sakila-insert-data.sql`. Éste último se va a tardar un ratote, por lo que pasaremos a la siguiente parte de la clase cuando comience la carga. Mientras se esté cargando los datos y demás elementos de la BD, no apaguen su máquina, no cierren DBeaver, no respiren, *DON'T BLINK!*

![](https://3.bp.blogspot.com/-HktUV4rOmwQ/VgeIM7vILpI/AAAAAAAAANs/xAbaq18Sphs/s1600/weeping_angel_head1.jpg)

### Qué hago si me equivoco en algo?

Ve a DBeaver, selecciona el esquema `public` (al rato explicaremos que es un esquema, pero por ahora solo entérate que es una estructura que nos permite asignar BDs independientes y que lo que vive en un esquema no puede ver directamente lo que vive en otro.

Luego da click derecho en el esquema `public` y da click en la opción `Delete`.

![](https://imgur.com/IvtcQq3.png)

Luego da click derecho en `Schemas` y luego en `Create New Schema`.

Y dale el nombre de `public` de nuevo, dado que el script de creación e inserción de Sakila **requiere** que el esquema se llame `public`. De lo contrario podríamos llamarlo como deseemos.

![](https://imgur.com/XZkvlIa.png)

Y repite la carga de la estructura y de los datos como lo dijimos arriba.

Podríamos también ejecutar, en orden, el script de borrado de datos y posteriormente el de borrado de la estructura, pero sería más tardado. Si prefieren hacerlo, adelante.

## A qué le estamos tirando?

Para este ejercicio visitaremos el [mapa de COVID de Johns Hopkins](https://coronavirus.jhu.edu/map.html), y haremos un ejercicio en [este pizarrón de Google Jamboard](https://jamboard.google.com/d/1og4fJ0Y3w42JetnOWP04SGoGn4IkzVCK4i_mtp3dPLc/viewer).

![](https://www.inquirer.com/resizer/KmF729M7L9WYkUwX___Smc7_aCo=/1400x932/smart/arc-anglerfish-arc2-prod-pmn.s3.amazonaws.com/public/QLMQQ2PE7ZAXXPYEIUO5N36QPI.jpg)

Si tomamos el mapa como un "destino final" de los datos, entonces cuál es su origen? Vamos a hipotetizar el camino que siguen:

![](https://imgur.com/LDDK5XK.png)

> **AGREGADO EL 2021-01-13 16:55 GMT-6:** Como lo vimos durante el ejercicio, las bases de datos que cubriremos en el semestre son relacionales en cuanto a estructura, y éstas frecuentemente se denominan transaccionales en cuanto a su propósito. Estas bases de datos son muy buenas escribiendo, pero no tan buenas leyendo, sobre todo si hablamos de millones de registros. Aunque podemos usar índices y particiones para mejorar el performance de lectura en presencia de millones de registros, hay un punto de histéresis donde debemos de salir de las BD relacionales y movernos a otros tipos de storage, como BDs columnares o Big Data Stores. Una arquitectura común para un sistema de información global como el COVID Dashboard de JHU es poner una BD columnar o Big Data Store (buena para leer, no tan buena para escribir) detrás del tablero, y luego tener cientos de procesos que jalan información de cada una de los sistemas transaccionales y las bases de datos relacionales que soportan los miles de registros civiles, hospitales, y laboratorios, para luego consolidar toda esta información en un solo esquema unificado, que luego pueda ser alimentado al Big Data Store o base columnar que respalde el tablero.

[Ir al Jamboard](https://jamboard.google.com/d/1og4fJ0Y3w42JetnOWP04SGoGn4IkzVCK4i_mtp3dPLc/viewer)

Al finalizar la sesión aparecieron estas notas en el documento de notas compartidas:

![](https://imgur.com/LUdJupp.png)

Lo que me indica que si se ha entendido este punto. Vientos!

## Esquemas de diseño de BD

En esta materia trabajaremos mayormente con esquemas relacionales de BD, pero existen otros.

### Esquema relacional

Este es el esquema de la BD de Sakila. Este tipo de diagramas se llaman **E**ntidad-**R**elación.

![](https://docs.oracle.com/cd/E17952_01/workbench-en/images/wb-sakila-eer.png)

Como podemos ver, se basa en tablas y relaciones. Las tablas son entidades, las entidades tienen atributos, y algunos atributos están copiados de otras entidades: esto es lo que define una relación.

Ejemplos: Oracle, MySQL, SQL Server, H2, Derby, PostgreSQL

### Esquema de red

Este es un esquema de red, que se representa con un **grafo**, que describe **las interacciones** o co-ocurrencias de una entidad, descrita por un **nodo**, con otra, descrita por otro **nodo**, y donde el grueso del **edge**, es decir, la conexión, representa el **peso** de co-ocurrencias.

Este ejemplo es de Game of Thrones.

![](https://dist.neo4j.com/wp-content/uploads/20170716015001/graph-of-thrones.png?_gl=1*t0n6t3*_ga*MTQyNDUzMjk0Ni4xNjEwNTU4ODM1*_ga_DL38Q8KGQC*MTYxMDU1ODgzNS4xLjAuMTYxMDU1ODgzNS4w&_ga=2.96387615.248246225.1610558835-1424532946.1610558835)

Otra métrica interesante que es fácilmente obtenible con este esquema de red es la **centralidad** de los nodos; osea, el num de **edges** que ingresan a un nodo en particular y su **peso** en el grafo.

Ejemplos: Neo4j

### Esquema de Documentos

Este esquema es famoso para acelerar aplicaciones web debido a que están diseñadas específico para guardar JSON, que es un formato de data exchange muy usado por frameworks web actuales.

Esta es una comparación con los esquemas relacionales:

![](https://annegretsarchitecture.files.wordpress.com/2018/06/docorienteddatabase.gif?w=900)

Y así es como luce un documento JSON proveniente de una webapp:

![](https://static.goanywhere.com/images/tutorials/read-json/ExampleJSON2.png)

Chequen que los corchetes **[]** denotan una **colección**, los dos puntos **:** denotan un **key** a la izq y un **value** a la derecha, y unas llaves **{}** denotan un documento. Un documento puede contener otro, y éste a su vez otro, y otro, y otro, y así ad nauseam. Igual, una colección de documentos puede extenderse ad infinitum.

Ejemplos de motores de BD de documentos: MongoDB, DocumentDB, Firestore.

## Bueno, y ya acabó de configurarse nuestra BD?

No se, veamos...
