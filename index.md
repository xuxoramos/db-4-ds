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
