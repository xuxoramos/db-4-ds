# Object-Relational Mapping

Los diagramas ER nos sirven para establecer entidades y relaciones, pero nos imponen un lenguaje limitado para describir un sistema complejo.

Mientras que todas las relaciones que podemos expresar en una BD pueden ser expresadas en un lenguaje orientado a objetos, _no todas las relaciones entre objetos pueden ser expresadas en BD_.

Este conflicto entre paradigmas se llama ["object-relational impedace mismatch"](https://en.wikipedia.org/wiki/Object%E2%80%93relational_impedance_mismatch).

Y la herramienta que usamos para darle la vuelta es el Object-Relational Mapping

## Ejemplo: modelado de datos

### En BD

Una tabla `Contacto` con atributos `nombre`, `número`, `dirección`. Todos ellos escalares.

### En OOP

Un objeto `ContactoConocido` con atributos `nombre, `número`, `dirección`. Qué pasa si queremos sofisticar este diseño?

Un objeto `ContactoTrabajo` con atributos `nombre`, `número`, `dirección`, `horaInicio` y `horaFin`.

Otro objeto `ContactoPersonal` con atributos `nombre`, `número`, `dirección` y `tipoSangre`.

Otro objeto `ContactoFamiliar` con atributos `nombre`, `número`, `dirección` y `códigoSeguridadCasa`.

Un objeto padre u objeto abstracto `Contacto` que tenga los atributos comunes a todos.

Finalmente, _métodos_, que son funciones para que los contactos tengan acciones, como `borrar`, `editar`, `nuevo` a ellos mismos.

Ni de chiste SQL nos deja especificar de manera elegante cuestiones como **herencia**, **polimorfismo**, **composición**, o **herencia abstracta**.

Pero SQL ya es el estándar de facto para almacenamiento de datos en todo el mundo tecnológico!

## Ejemplo 2: acceso a datos

Suponiendo que tenemos una aplicación multicapa, entonces a pesar de que nosotros como creadores de esta aplicación si tenemos acceso a la BD, nuestros usuarios tienen acceso a ella mediante una aplicación. Dicha aplicación probablemente no está hecha en SQL, sino en algún lenguaje orientado a objetos, y por tanto no necesariamente correrá en la misma máquina que la BD.

## PARÉNTESIS: Aplicaciones multicapa



## En BD

## 

