## Bases de Datos para Ciencia de Datos

Este website contiene el material para la materia Bases de Datos para Ciencia de Datos.

### Temario + Fechas = Plan de Materia

| Num de sesión | Fecha de sesión | Temas                                                                                                                                                                                                                                                 |
|---------------|-----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 0             | 2021/01/11      | Intro a BDs. ¿A qué le estamos tirando? ¿De dónde vienen los datos? ¿A dónde van los datos? Formas de guardarlos. Formas de consultarlos. Esquema de red. Esquema de documentos. Esquema jerárquico. Esquema relacional.                              |
| 1             | 2021/01/13      | Instalación de PostgreSQL. Descargar datos de prueba. Carga de bases de datos de prueba Northwind y Sakila. Creación de tablas (create table). Tipos de datos. Modificaciones a tablas (alter table). Borrado o "dropeo" de tablas (drop y truncate). |
| 2             | 2021/01/18      | Relaciones 1 a 1. Relaciones 1 a N. Relaciones N a N. Integridad referencial. Inserción de datos (insert). Borrado de datos (delete). Actualización de datos (update). Bloopers y errores en statements.                                              |
| 3             | 2021/01/20      | Diseño de BDs. Normalización. Identificación de entidades, identificación de relaciones.                                                                                                                                                              |
| 4             | 2021/01/25      | Lab 0: De un user story a un modelo E-R                                                                                                                                                                                                               |
| 5             | 2021/01/27      | Queries, queries, queries! Extrayendo datos con select. Asignando aliases a columnas. Quitando duplicados con distinct. Combinando tablas con from. Filtrando con where.                                                                              |
| 6             | 2021/02/01      | Asueto                                                                                                                                                                                                                                                |
| 7             | 2021/02/03      | Agrupando con group by y having. Ordenando con order by. Más condiciones dentro de where. Tratamiento de null.                                                                                                                                        |
| 8             | 2021/02/08      | Lab 1: De la carga a la consulta.                                                                                                                                                                                                                     |
| 9             | 2021/02/10      | 1er Parcial                                                                                                                                                                                                                                           |
| 10            | 2021/02/15      | Extrayendo datos de múltiples tablas con inner join. Usando subqueries. Haciendo auto-join.                                                                                                                                                           |
| 11            | 2021/02/17      | Teoría de conjuntos aplicada a BDs. Unión, intersección, exclusión en extracción de datos. Reglas y precedencia de operadores.                                                                                                                        |
| 12            | 2021/02/22      | Joins avanzados. Left. Right. Outer. Cross. Joins naturales.                                                                                                                                                                                          |
| 13            | 2021/02/24      | Funciones analíticas simples. Agrupaciones. Agregados. Conteos. Filtrado. Queries complejos.                                                                                                                                                          |
| 14            | 2021/03/01      | Subqueries. ¿Cuándo usarlos? ¿Cuándo no? Subqueries correlacionados.                                                                                                                                                                                  |
| 15            | 2021/03/03      | Lógica condicional. Case. Exists. Updates condicionales.                                                                                                                                                                                              |
| 16            | 2021/03/08      | Lab 2: Queries analíticos complejos.                                                                                                                                                                                                                  |
| 17            | 2021/03/10      | 2o Parcial                                                                                                                                                                                                                                            |
| 18            | 2021/03/15      | Asueto                                                                                                                                                                                                                                                |
| 19            | 2021/03/17      | Transacciones. Bloqueos. Aislamiento. Lecturas sucias. Serializaciones.                                                                                                                                                                               |
| 20            | 2021/03/22      | Transacciones. Propiedades ACID. Transacciones globales. Propiedades BASE.                                                                                                                                                                            |
| 21            | 2021/03/24      | Lab 3: Manejo de transacciones                                                                                                                                                                                                                        |
| 22            | 2021/03/29      | Asueto                                                                                                                                                                                                                                                |
| 23            | 2021/03/31      | Performance y Administración de recursos: Índices y Constraints.                                                                                                                                                                                      |
| 24            | 2021/04/05      | Lab 4: Acelerando queries analíticos                                                                                                                                                                                                                  |
| 25            | 2021/04/07      | Vistas. ¿Por qué y para qué? Casos de uso: aislamiento de complejidad, seguridad de datos y agregación analítica. Vistas "updeiteables"                                                                                                               |
| 26            | 2021/04/12      | Lab 5: creando vistas analíticas                                                                                                                                                                                                                      |
| 27            | 2021/04/14      | Metadatos (datos sobre los datos): esquemas, validación de deployment, generación dinámica de SQL, ley de benford.                                                                                                                                    |
| 28            | 2021/04/19      | Lab 6: detección de fraude                                                                                                                                                                                                                            |
| 29            | 2021/04/21      | Funciones analíticas avanzadas: window functions, rolling windows, cumulative sum, ranking, lag, lead, concatenaciones.                                                                                                                               |
| 30            | 2021/04/26      | Lab 7: funciones analíticas avanzadas                                                                                                                                                                                                                 |
| 31            | 2021/04/28      | 3er Parcial                                                                                                                                                                                                                                           |
| 32            | 2021/05/03      | Aplicaciones multicapa con Django                                                                                                                                                                                                                     |
| 33            | 2021/05/05      | Acceso a BD desde aplicaciones multicapa                                                                                                                                                                                                              |
| 34            | 2021/05/11      | Intro a Datawarehousing y Big Data. Bases de datos transaccionales VS bases de datos analíticas. "No analices donde operas"                                                                                                                           |
| 35            | 2021/05/12      | Bases de datos columnares. MonetDB. ETLs. Desnormalización                                                                                                                                                                                            |
| 36            | TBD             | Presentación proyecto final                                                                                                                                                                                                                           |
### Cómo nos comunicaremos?
Por [Slack](https://slack.com), que es un chat orientado a equipos y trabajo. Comenzó como un juegoi tipo "Among Us", pero cuando hicieron el chat para el juego quedó tan chingón, que lo sacaron como producto separado. Abajo las ligas de descarga:
- [Windows](https://slack.com/downloads/windows)
- [Mac](https://slack.com/help/articles/207677868-Download-Slack-for-Mac)
- [Linux](https://slack.com/downloads/linux) - .rpm para Fedora o RedHat, .deb para Ubuntu

### Por dónde serán las sesiones?
La sesión 0 será por [Teams de Microsoft](https://www.microsoft.com/es-mx/microsoft-365/microsoft-teams/download-app), y posteriormente nos moveremos a [Zoom](https://zoom.us/download).

### Dónde estará el material?
Aquí en Github. Github es una plataforma de colaboración y control de versiones para no andar como este meme:
![](https://i.redd.it/05b6u19pseoz.png)

### Qué necesito para la clase?
Las bases de datos son parte de un ecosistema de muchas piezas que nutre el flujo de datos de un problem domain. Quizá sean la más importante, pero no la única. Para ello vamos a utilizar diferentes herramientas para poder interactuar con cada una de estas piezas, incluyendo la base de datos, obvi.

#### Capa de aplicación
Para esto vamos a descargar e instalar [VSCode](https://code.visualstudio.com/), un I(ntegrated) D(evelopment) E(nvironment) poder construir una pequeña aplicación en [Django](https://www.djangoproject.com/), un poderoso framework web hecho en Python.

> **IMPORTANTE:** Seguro tu OS ya tiene Python instalado, y seguro no es la última versión. **Ni la bajes, ni la instales!**. Usaremos mejor un administrador de ambientes virtuales para que podamos instalar paquetes de Python sin estropear tu instalación de sistema, de la cual depende mucha de la funcionalidad de tu OS.

#### Capa de middleware, APIs y servicios
Para esto descargaremos e instalaremos [Anaconda](https://www.anaconda.com/products/individual), un administrador de ambientes virtuales de Python para poder hacer nuestros desarrollos más tolerantes a fallos (fallos del tipo "no ma! instalé un paquete y se encimó sobre una dependencia y ahora mi MacOS ya no arranca!". Es una instalación larga y pesada (3GB), así que asegúrate de tener el espacio.

### Cómo vamos a calificar?
1. 1er Parcial: 10%
2. 2o Parcial: 15%
3. 3er Parcial: 20%
4. 
