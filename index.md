## Bases de Datos para Ciencia de Datos

Este website contiene el material para la materia Bases de Datos para Ciencia de Datos.

##   Rules of the game

### Qué texto vamos a usar?

La mayoría del curso está basado en [Learning SQL](https://www.r-5.org/files/books/computers/languages/sql/mysql/Alan_Beaulieu-Learning_SQL-EN.pdf) de A. Bailieau de editorial O'Reilly, que tiene bastantes libros técnicos muy interesantes.

### Cómo vamos a calificar?

1. 1er Parcial (teórico): 10%
2. 2o Parcial (avance proyecto final): 10%
3. 3er Parcial (avance proyecto final): 20%
4. Proyecto final: 50%
5. Tareas: 10%

### Cómo serán los exámenes?
Tendrán un componente teórico y/o un componente práctico.

El componente práctico consistirá generalmente en uno de a) crear o alterar una BD, b) diseñar una BD, c) generar datos en una BD con una cierta forma, o d)  generar un reporte analítico.

El componente teórico es un examen de opción múltiplemen la plataforma [Socrative](https://www.socrative.com/) en el cual podrás sacar apuntes o usar una o varias de las plataformas que configuraremos a lo largo del semestre (PostgreSQL, DBeaver, VSCode, Anaconda, etc).

### Y cómo será el examen final?
Será enteramente práctico y consistirá en el desarrollo de un proyecto integral con todo lo visto en el semestre. Daremos más detalles más adelante durante el curso.

### Cómo me contacto con ud, prof?
Usen el el correo institucional (jesus.ramos@itam.mx) o Slack, o escriban a ramos.cardona@gmail.com.

Pero preferentemente usen Slack.

### Cómo nos comunicaremos?
Por [Slack](https://slack.com), que es un chat orientado a equipos y trabajo. Comenzó como un juego tipo "Among Us", pero cuando hicieron el chat para el juego quedó tan chingón, que lo sacaron como producto separado. Abajo las ligas de descarga:
- [Windows](https://slack.com/downloads/windows)
- [Mac](https://slack.com/help/articles/207677868-Download-Slack-for-Mac)
- [Linux](https://slack.com/downloads/linux) - .rpm para Fedora o RedHat, .deb para Ubuntu

Una vez que descarguen Slack, hagan click [en esta liga](https://join.slack.com/t/db4ds-ago-dic-2021/shared_invite/zt-u0tn3a9g-UodebIH97D6PswT3iT0OZg) para que sean automágicamente agregados a nuestro workspace.

### Por dónde serán las sesiones?
La sesión 0 será por [Teams de Microsoft](https://www.microsoft.com/es-mx/microsoft-365/microsoft-teams/download-app), y posteriormente nos moveremos a [Zoom](https://zoom.us/download), en [este link](https://itam.zoom.us/my/xuxoramos).

### Dónde estará el material?
Aquí en Github. Github es una plataforma de colaboración y control de versiones para no andar como este meme:
![](https://i.redd.it/05b6u19pseoz.png)

Es importante que si nunca has usado Github, o algún otro sistema de control de versiones, [leas esta guía](https://guides.github.com/activities/hello-world/) para que no te agarren en curva y tengas de menos los fundamentos de estas plataformas.

### Qué necesito para la clase?
Las bases de datos son parte de un ecosistema de muchas piezas que nutre el flujo de datos de un problem domain. Quizá sean la más importante, pero no la única. Para ello vamos a utilizar diferentes herramientas para poder interactuar con cada una de estas piezas, incluyendo la base de datos, obvi.
  
Lo mero, mero. La ráison d'etre de este curso. El motivo por el que estamos aquí. El corazón de todo sistema, toda plataforma, aplicación: twitter, albo, Monzo, FB, Valorant, Fortnite, Destiny, etc.

Para poder crear, diseñar, levantar, consultar, administrar bases de datos, necesitamos 2 paquetes.

Debido a que las bases de datos actúan como servidor (es decir, un programa con una conexión abierta, esperando conexiones y escuchando los comandos que caen por esa conexión después de que establecemos una), obviamente necesitamos un programa cliente que establezca esa conexión. Los 2 paquetes que necesitamos son un cliente, y un servidor.

Como servidor [descargaremos e instalaremos PostgreSQL](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads), la mejor base de datos del mundo :P. 

Si tienes Linux, [descarga el PostgreSQL desde aquí](https://www.postgresql.org/download/linux/ubuntu/).

Ahora, para el cliente, descargaremos e instalaremos la edición [Community de DBeaver](https://dbeaver.io/download/), uno de los 3 paquetes de software libre para conexión a bases de datos.

Ya los tienes? Va.

#### Solamente eso?

Dependiendo de como vengan de experiencia y las materias previas que hayan cursado, necesitarán:

1. VSCode - https://code.visualstudio.com/download
2. Python (mediante miniconda) - https://docs.conda.io/en/latest/miniconda.html
3. .NET SDK - https://dotnet.microsoft.com/download

Ya veremos qué necesitaremos de todos estos.

### NEWS & UPDATES

Check back here often.

#### 2021-08-04
Bienvenidos!

### Temario + Fechas = Plan de Materia
A continuación el temario, fecha por fecha:

| Num de sesión | Fecha de sesión | Temas |
|---------------|-----------------|-------|
| 0             | 2021/08/05      | [Intro a BDs. Instalación de PostgreSQL. Instalación de DBeaver. Instalación de BD de pruebas Sakila. Aplicaciones analíticas. ¿De dónde vienen los datos? ¿A dónde van los datos? Esquema de red. Esquema de documentos. Esquema relacional.](https://xuxoramos.github.io/db-4-ds/0_intro)                              |
| 1             | 2021/08/10      | [Diagramas E-R. Relaciones. Entidades. Atributos. Relaciones 1 a 1. Relaciones 1 a N. Relaciones N a N. Llaves primarias. Llaves foráneas. Llaves compuestas. Diseño de BDs.](https://xuxoramos.github.io/db-4-ds/1_database_design_and_creation) / [Sesión en video](https://drive.google.com/file/d/1y91ImAo4I0xlbiECBXBtr0lpmrj1lqCc/view?usp=sharing) |
| 2             | 2021/08/12      | [Parte II - Diagramas E-R. Relaciones. Entidades. Atributos. Relaciones 1 a 1. Relaciones 1 a N. Relaciones N a N. Llaves primarias. Llaves foráneas. Llaves compuestas. Diseño de BDs.](https://xuxoramos.github.io/db-4-ds/1_database_design_and_creation) / [Sesión en video](https://drive.google.com/file/d/1kyxlMO4ji6eeGq8yJgiOJKDuZ5cb1OpH/view?usp=sharing)                                              |
| 3             | 2021/08/18      | [Creación de tablas, creación de secuencias, constraints de llave primaria y de llave foránea](https://xuxoramos.github.io/db-4-ds/2_from_ER_to_DB) / [Sesión en video](https://drive.google.com/file/d/1DmXDKKrly8_utGq9bTZL3RSZqx6OCbxy/view?usp=sharing)                                                                                                                                                         |
| 4             | 2021/08/19      | [Creación de tablas intermedias para relación N a M, inserción de datos, y errores comunes por constraints de foreign key y primary key](https://xuxoramos.github.io/db-4-ds/3_insert_delete_update) / [Sesión en video](https://drive.google.com/file/d/1LSa10rIKtqunsqf4LxI44hrxbiFWQeZl/view?usp=sharing)
| 5             | 2021/08/24      | [Insert, delete, truncate](https://xuxoramos.github.io/db-4-ds/3_insert_delete_update) / [Sesión en video](https://drive.google.com/file/d/1Rg-cy1w0ZAK1I2nfekohdGkIDJCy0H4Z/view?usp=sharing)
| 6             | 2021/08/26      | [Update, drop, y uso de los comandos IRL](https://xuxoramos.github.io/db-4-ds/3_insert_delete_update) / [Sesión en video](https://drive.google.com/file/d/1wmB_Txrdwy2SwhMvxfIjCpOT30E4qUko/view?usp=sharing)
| 7             | 2021/08/31      | [Normalización: 1NF, 2NF y 3NF. Best practices para diseño de bases de datos](https://xuxoramos.github.io/db-4-ds/5_normalizacion) / [Sesión en video](https://drive.google.com/file/d/1oVGX5aqj-Fe7URbKRamK2ce3k3I93WW5/view?usp=sharing)
| 8             | 2021/09/02      | [3.5NF, Relaciones ternarias y sus best practices](https://xuxoramos.github.io/db-4-ds/5_normalizacion). [Intro a queries y ejercicios](https://xuxoramos.github.io/db-4-ds/6_queries_y_queries_y_queries) / [Sesión en video](https://drive.google.com/file/d/1Pg4BrMsnJtSOyzUzmHXd5dv36_6i5l8z/view?usp=sharing)
| 9             | 2021/09/07      | **SESIÓN A REPONER EN VIDEO**
| 10             | 2021/09/09      | [Joins](https://xuxoramos.github.io/db-4-ds/7_joins) / [Sesión en video](https://drive.google.com/file/d/10FevN_jq8v0ozO0r3ymRW2D9vewMj_SP/view?usp=sharing)
| 11             | 2021/09/14      | **SESIÓN A REPONER EN VIDEO**
| 12             | 2021/09/16      | **Sesión repuesta en video num 26**
| 13             | 2021/09/21      | [Joins (inner, outer, left, right y el "anti-join"](https://xuxoramos.github.io/db-4-ds/7_joins) / [Sesión en video](https://drive.google.com/file/d/1rmRE9Aic3_05YzBW_VSGkoeMAGRaBVDs/view?usp=sharing)
| 13             | 2021/09/21      | [Joins (inner, outer, left, right y el "anti-join"](https://xuxoramos.github.io/db-4-ds/7_joins) / [Sesión en video](https://drive.google.com/file/d/1rmRE9Aic3_05YzBW_VSGkoeMAGRaBVDs/view?usp=sharing)
| 14             | 2021/09/23      | [Ejercicios](https://xuxoramos.github.io/db-4-ds/8_ejercicios) / [Sesión en video](https://drive.google.com/file/d/1rnSl_MNVyXZ-JXTE9xILRbMzISNOgGbc/view?usp=sharing)
| 15             | 2021/09/28      | [Filtrado de registros con cláusula `WHERE`](https://xuxoramos.github.io/db-4-ds/10_filtering) / [Sesión en video](https://drive.google.com/file/d/1I0HS6PYIUUi33kGe0Z5G10ZhjrGASvfk/view?usp=sharing)
| 16             | 2021/09/30      | **1ER PARCIAL**
| 17             | 2021/10/05      | [Orden de ejecución de queries. Agrupamiento con cláusula `group by`. Funciones de agregación, estadísticas, booleanas](https://github.com/xuxoramos/db-4-ds/blob/gh-pages/11_group_by.md) / [Sesión en vídeo](https://drive.google.com/file/d/1Anlqf_FijDjWt55zyvFMuEzldnsMiJVy/view?usp=sharing)
| 18             | 2021/10/07      | [Ejercicios con funciones de agregación. Revisión de parte teórica de examen parcial.](https://github.com/xuxoramos/db-4-ds/blob/gh-pages/11_group_by.md) / [Sesión en video](https://drive.google.com/file/d/1Anlqf_FijDjWt55zyvFMuEzldnsMiJVy/view?usp=sharing)
| 19             | 2021/10/12      | [Revisión de parte práctica de examen parcial. Cláusula `distinct on` para combinar funciones de agregación y IDs. Cláusula `grouping sets` para generar subtotales](https://github.com/xuxoramos/db-4-ds/blob/gh-pages/12_group_by_II.md) / [Sesión en video](https://drive.google.com/file/d/1wkRJJrPZQldKrVPKBcwV_OHj51Gvxcig/view?usp=sharing)
| 20             | 2021/10/14      | [Cláusula `group by rollup()` para agregados jerárquicos. Cláusula `group by cube()` para agregados a lo largo de N columnas. Introducción a bases de datos columnares](https://github.com/xuxoramos/db-4-ds/blob/gh-pages/12_group_by_II.md) / [Sesión en video](https://drive.google.com/file/d/1OYgFXgG9DwRcxdfKx_fUMDpmUseQjpcZ/view?usp=sharing)
| 21             | 2021/10/19      | [Demo en vivo de la rapidez de las BDs columnares para queries analíticos VS BDs transaccionales. Cláusula `having`. Ejercicios con `having`. Errores comunes con `having` y condiciones para que se comporte como `where`.](https://github.com/xuxoramos/db-4-ds/blob/38c9f19812fc1f0dbe0b186a3967a5405924e286/13_group_by_III.md) / [Sesión en video](https://drive.google.com/file/d/1JL_3kML6AdSElGZELb5KOppN6LNXf4tA/view?usp=sharing)
| 22             | 2021/10/21      | [Subqueries, correlated queries, cláusula `exists` y `not exists`, y refraseo de queries con `(not) exists` como queries con `join`.](https://github.com/xuxoramos/db-4-ds/blob/gh-pages/14_subselects.md) / [Sesión en video](https://drive.google.com/file/d/1GZyiGcS1qxFFldY5UUjQa2hxcJhjIWXT/view?usp=sharing)
| 23             | 2021/10/26      | [Common-table Expressions](https://github.com/xuxoramos/db-4-ds/blob/gh-pages/15_common_table_expressions.md) / [Sesión en video](https://drive.google.com/file/d/15teEBZ0u8TnTd1gLtbJKKCVw04k8zi7M/view?usp=sharing)
| 24             | 2021/10/28      | [Revisión de proyecto final. Apuntes finales de Common Table Expressions. Intro a funciones](https://github.com/xuxoramos/db-4-ds/blob/gh-pages/17_proyecto_final.md) / [Sesión en video](https://drive.google.com/file/d/1BlAE9uQuLTz6IzNoP-pzrUxzqCfsxLGT/view?usp=sharing)
| 25             | 2021/11/02      | [Funciones numéricas y trigonométricas. Generación de números aleatorios. Funciones con strings](https://github.com/xuxoramos/db-4-ds/blob/gh-pages/16_funciones.md) / [Sesión en video](https://drive.google.com/file/d/1NEsNy5MR5kAOimX5ltIefxP82cZEO2JI/view?usp=sharing)
| 26             | **Sesión de reposición del 2021/09/16**      | [Funciones con `date`, `time`, `interval` y `timestamp`. Ejercicio integrador. Ley de Benford y Detección de Fraudes](https://github.com/xuxoramos/db-4-ds/blob/gh-pages/16_funciones.md) / [Sesión en video](https://drive.google.com/file/d/1GctXfgREEX6Ia2Bg3JjfJfGiNBbZdmcU/view?usp=sharing)
