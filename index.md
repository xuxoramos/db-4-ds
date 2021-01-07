## Bases de Datos para Ciencia de Datos

Este website contiene el material para la materia Bases de Datos para Ciencia de Datos.

### Temario + Fechas = Plan de Materia

| fecha de sesión | temas                                                                                                                                                                                                                                                 |
|-----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 2021/01/11      | Intro a BDs. ¿A qué le estamos tirando? ¿De dónde vienen los datos? ¿A dónde van los datos? Formas de guardarlos. Formas de consultarlos. Esquema de red. Esquema de documentos. Esquema jerárquico. Esquema relacional.                              |
| 2021/01/13      | Instalación de PostgreSQL. Descargar datos de prueba. Carga de bases de datos de prueba Northwind y Sakila. Creación de tablas (create table). Tipos de datos. Modificaciones a tablas (alter table). Borrado o "dropeo" de tablas (drop y truncate). |
| 2021/01/18      | Relaciones 1 a 1. Relaciones 1 a N. Relaciones N a N. Integridad referencial. Inserción de datos (insert). Borrado de datos (delete). Actualización de datos (update). Bloopers y errores en statements.                                              |
| 2021/01/20      | Diseño de BDs. Normalización. Identificación de entidades, identificación de relaciones.                                                                                                                                                              |
| 2021/01/25      | Lab 0: De un user story a un modelo E-R                                                                                                                                                                                                               |
| 2021/01/27      | Queries, queries, queries! Extrayendo datos con select. Asignando aliases a columnas. Quitando duplicados con distinct. Combinando tablas con from. Filtrando con where.                                                                              |
| 2021/02/01      | Agrupando con group by y having. Ordenando con order by. Más condiciones dentro de where. Tratamiento de null.                                                                                                                                        |
| 2021/02/03      | Lab 1: De la carga a la consulta.                                                                                                                                                                                                                     |
| 2021/02/08      | 1er Parcial                                                                                                                                                                                                                                           |
| 2021/02/10      | Extrayendo datos de múltiples tablas con inner join. Usando subqueries. Haciendo auto-join.                                                                                                                                                           |
| 2021/02/15      | Teoría de conjuntos aplicada a BDs. Unión, intersección, exclusión en extracción de datos. Reglas y precedencia de operadores.                                                                                                                        |
| 2021/02/17      | Joins avanzados. Left. Right. Outer. Cross. Joins naturales.                                                                                                                                                                                          |
| 2021/02/22      | Funciones en string. Funciones numéricas. Precisión numérica. Datos temporales. Conversión entre tipos.                                                                                                                                               |
| 2021/02/24      | Funciones analíticas simples. Agrupaciones. Agregados. Conteos. Filtrado. Queries complejos.                                                                                                                                                          |
| 2021/03/01      | Subqueries. ¿Cuándo usarlos? ¿Cuándo no? Subqueries correlacionados.                                                                                                                                                                                  |
| 2021/03/03      | Lógica condicional. Case. Exists. Updates condicionales.                                                                                                                                                                                              |
| 2021/03/08      | Lab 2: Queries analíticos complejos.                                                                                                                                                                                                                  |
| 2021/03/10      | 2o Parcial                                                                                                                                                                                                                                            |
| 2021/03/15      | Transacciones. Bloqueos. Aislamiento. Lecturas sucias. Serializaciones.                                                                                                                                                                               |
| 2021/03/17      | Transacciones. Propiedades ACID. Transacciones globales. Propiedades BASE.                                                                                                                                                                            |
| 2021/03/22      | Lab 3: Manejo de transacciones                                                                                                                                                                                                                        |
| 2021/03/24      | Performance y Administración de recursos: Índices y Constraints.                                                                                                                                                                                      |
| 2021/03/29      | Lab 4: Acelerando queries analíticos                                                                                                                                                                                                                  |
| 2021/03/31      | Vistas. ¿Por qué y para qué? Casos de uso: aislamiento de complejidad, seguridad de datos y agregación analítica. Vistas "updeiteables"                                                                                                               |
| 2021/04/05      | Lab 5: creando vistas analíticas                                                                                                                                                                                                                      |
| 2021/04/07      | Metadatos (datos sobre los datos): esquemas, validación de deployment, generación dinámica de SQL, ley de benford.                                                                                                                                    |
| 2021/04/12      | Lab 6: detección de fraude                                                                                                                                                                                                                            |
| 2021/04/14      | Funciones analíticas avanzadas: window functions, rolling windows, cumulative sum, ranking, lag, lead, concatenaciones.                                                                                                                               |
| 2021/04/19      | Lab 7: funciones analíticas avanzadas                                                                                                                                                                                                                 |
| 2021/04/21      | 3er Parcial                                                                                                                                                                                                                                           |
| 2021/04/26      | Aplicaciones multicapa con Django                                                                                                                                                                                                                     |
| 2021/04/28      | Acceso a BD desde aplicaciones multicapa                                                                                                                                                                                                              |
| 2021/05/03      | Intro a Datawarehousing y Big Data. Bases de datos transaccionales VS bases de datos analíticas. "No analices donde operas"                                                                                                                           |
| 2021/05/05      | Bases de datos columnares. MonetDB. Cassandra.                                                                                                                                                                                                        |
| 2021/05/11      | Intro a ETLs. Transformaciones. Desnormalización.                                                                                                                                                                                                     |
| 2021/05/12      | Presentación proyecto final                                                                                                                                                                                                                           |
| TBD             | Examen final                                                                                                                                                                                                                                          |
```markdown
Syntax highlighted code block

# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```

For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/xuxoramos/bd-4-ds/settings). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://docs.github.com/categories/github-pages-basics/) or [contact support](https://github.com/contact) and we’ll help you sort it out.
