# Object-Relational Mapping

Los diagramas ER nos sirven para establecer entidades y relaciones, pero nos imponen un lenguaje limitado para describir un sistema complejo.

Mientras que todas las relaciones que podemos expresar en una BD pueden ser expresadas en un lenguaje orientado a objetos, _no todas las relaciones entre objetos pueden ser expresadas en BD_.

Este conflicto entre paradigmas se llama ["object-relational impedace mismatch"](https://en.wikipedia.org/wiki/Object%E2%80%93relational_impedance_mismatch).

Y la herramienta que usamos para darle la vuelta es el Object-Relational Mapping

## Ejemplo: modelado de datos

### En BD

Una tabla `Contacto` con atributos `nombre`, `número`, `dirección`. Todos ellos escalares.

### En OOP

Un objeto `ContactoConocido` con atributos `nombre`, `número`, `dirección`. Qué pasa si queremos sofisticar este diseño?

Un objeto `ContactoTrabajo` con atributos `nombre`, `número`, `dirección`, `horaInicio` y `horaFin`.

Otro objeto `ContactoPersonal` con atributos `nombre`, `número`, `dirección` y `tipoSangre`.

Otro objeto `ContactoFamiliar` con atributos `nombre`, `número`, `dirección` y `códigoSeguridadCasa`.

Un objeto padre u objeto abstracto `Contacto` que tenga los atributos comunes a todos.

Finalmente, _métodos_, que son funciones para que los contactos tengan acciones, como `borrar`, `editar`, `nuevo` a ellos mismos.

Ni de chiste SQL nos deja especificar de manera elegante cuestiones como **herencia**, **polimorfismo**, **composición**, o **herencia abstracta**.

Pero SQL ya es el estándar de facto para almacenamiento de datos en todo el mundo tecnológico!

## Ejemplo 2: acceso a datos

Suponiendo que tenemos una aplicación multicapa, entonces a pesar de que nosotros como creadores de esta aplicación si tenemos acceso a la BD, nuestros usuarios tienen acceso a ella mediante una aplicación. Dicha aplicación probablemente no está hecha en SQL, sino en algún lenguaje orientado a objetos, y por tanto no necesariamente correrá en la misma máquina que la BD.

Para esto, debo hacer un paréntesis y explicar arquitectura de aplicaciones:

## Aplicaciones multicapa

### Mainframes y sistemas monolíticos

Corrían sistemas viejitos (afiliación del IMSS, control aéreo, control del metro, registro en el RFC) y en una misma máquina se ejecutaba todo: almacenamiento de datos, procesamiento de entradas, impresión de reportes, etc.

![image](https://user-images.githubusercontent.com/1316464/116915944-4d3a7e80-ac12-11eb-94a7-a5cee5379b58.png)

Esto se hacía con un lenguaje viejito que se llama COBOL, que creó esta señora:

![image](https://user-images.githubusercontent.com/1316464/116918377-6ee93500-ac15-11eb-9742-9c6309cbdb23.png)

Y si, el lenguaje es tan cuadrado y estricto como esta señora se ve.

### Client-server Architecture

Partimos el monolito y la parte de acceso a datos la sacamos de él, dejando solo el procesamiento.

Para la parte de acceso se construyeron aplicaciones y sistemas _cliente_ que eran cientos de pantallas para consultar, actualizar y registrar datos.

Luego se tendieron conexiones (no de internet) para enlazar las máquinas que corrían estos sistemas con su monolito, en donde se quedó el almacenamiento y procesamiento de datos.

![image](https://user-images.githubusercontent.com/1316464/116916238-af937f00-ac12-11eb-9fc1-2a2808654a76.png)

Luego vino el internet, y BOOM! 

### Arquitecturas de 3 capas

Con la adopción del internet a todos los niveles pudimos tener más capas, comenzando por separar ahora el procesamiento de datos del almacenamiento de los mismos:

![image](https://user-images.githubusercontent.com/1316464/116917752-b1f6d880-ac14-11eb-9fc5-dfcbf2d9e8b0.png)

Esto nos permitió una explosión comercial de ofertas de productos y servicios para cada capa:

- **Client**: ya no necesitábamos frozosamente estar frente a la maquinota para poder usarla, ya podíamos usarla desde nuestras compus personales, las cuales estaban apenas comenzando. Este momento fue en el que la brecha de género de mujeres en STEM se comenzó a dar.

- **Application:** ya podíamos tener servidores de todo tipo y con varios sabores de sistema operativo, y a IBM se le acaba su gravy train de ser el único fabricante de mainframes. Con la variedad de sistemas operativos vino el boom de la adopción de Linux, y el boom de los lenguajes de programación, dado que podíamos construir esta capa con Java, Python, C#, etc.

- **Database:** la misma variedad de alternativas para las capas de arriba acompañaron un boom de variedad de la capa de datos. Aquí es cuando se cementa la BD como la parte más importante de las aplicaciones, y donde nacen varios productos de BD como Oracle, Informix, AS400, etc.

### Arquitecturas de N capas

Los sistemas modernos ahora tienen una arquitectura muy compleja con muchísimos moving parts:

![image](https://user-images.githubusercontent.com/1316464/116940104-0ad56980-ac33-11eb-948f-9c6f464de4b5.png)

Sobre todo porque ya estamos hablando de aplicaciones con accesos globales, en diferentes zonas, diferentes frentes y diferentes propósitos, y cada componentito puede ejecutarse en una máquina individual o en contenedores.

Nuestro proyecto final es un ejemplo de una aplicación multicapa.









## En BD

## 

