# Proyecto final DB4DS

## Organización

- 4 equipos de 4
- Combinen perfiles. Lo mejor es:
   - 1 persona que haya llevado DAI y la haya armado chido
   - 1 persona que le mueva chido a entrevistar clientes y sacarles exactamente la información sobre lo que quieren y esperan, y que sepa presentar bien
   - 1 persona que le mueva bien a esta materia
   - 1 persona que le mueva a proba y estadística
- Pueden elegirlos a como se les pegue la gana
- Van a presentar ante cliente, así que deben ensayar su profesionalismo

## Descripción del Proyecto final

> _SocialTIC busca construir un sistema de encuestas que permita conocer la **percepción de ciberseguridad** entre estudiantes de licenciatura. Dicho sistema debe recoger respuestas en temas como 1) privacidad, 2) seguridad e integridad física y psicológica, 3) redes sociales, 4) vigilancia, 5) balance entre otorgar datos VS seguridad y protección civil._

### Requerimientos Funcionales
El desarrollo de una plataforma tecnológica que contemple lo siguiente:

1. **Levantamiento y análisis de información:** esto es mediante el desarrollo de una aplicación móvil o aplicación web, ó bien creación de formularios en Google Forms, formularios en TypeForm, u otra plataforma.
   - OJO: si deciden irse por la ruta de usar una plataforma externa web para el levantamiento de las preguntas, consideren que deberán usar infraestructura en la nube. Si este es su camino, contáctenme para probar cuentas académicas de AWS.
3. **Almacenamiento consistente y correcto de datos**: esto implica el diseño de una base de datos en PostgreSQL que cumpla con las mejores prácticas vistas en nuestras sesiones, y que cumpla al menos con la 3NF.
4. **Vistas analíticas de información**: los datos almacenados en la BD deben procesarse, agregarse y sumarizarse para poder mostrar información relevante a tomadores de decisiones de SocialTIC.
5. **Tableros de presentación**: Los agregados y análisis deben presentarse en tableros y gráficas.

### Requerimientos No Funcionales

1. Los equipos deben entrevistarse con SocialTIC mínimo 2 veces para definir las áreas de información y las preguntas que se van a incluir en la plataforma web o móvil para encuestas, y que SocialTIC las apruebe. Deben asegurarse de tener evidencia de esta aprobación.
2. Los equipos deben hacer una investigación seria sobre los ciber-riesgos que su demográfico tiene que manejar en sus vidas digitales.
   - Si necesitan acceso a profesores del departamento de derecho, avisen, pero una investigación rigurosa debe incluir diferentes fuentes y el diseño de la encuesta **no debe incluir preguntas abiertas**.
4. El producto analítico final de cada equipo debe recabar al menos 250 respuestas.
5. Una vez que los equipos tengan desplegada la plataforma de encuestas de manera pública, deberán responsabilizarse de la difusión masiva para recoger 250 respuestas cada una.
   - En la parte de creación de vistas y analíticos, tienen que considerar registros repetidos para desduplicarlos en los conteos y no tener sesgos y por tanto recomendaciones equivocadas.
   - Deben procurar no cubrir los mismos grupos para no tener respuestas repetidas.

### Evaluación

1. **Levantamiento y análisis de información:**
  - Entregable: 1) **Prototipo** de web application con la encuesta materializada en él, ó bien, diseño de la encuesta en alguna plataforma como TypeFrom, Google Forms, etc. OJO: Para esta fecha ya debe haber una conexión a una BD, aún cuando dicha BD solo tenga de momento 1 tabla. 2) documentos de historias de usuario e historias del problem domain en repositorio público de Github. 3) **EVIDENCIA** de la investigación y entrevistas que se hicieron con SocialTIC y otras fuentes para definir las áreas de interés y sus preguntas de cada una dentro de la encuesta.
  - Valor: 10%
  - Fecha de entrega: 11 de Nov antes de las 23:59:59
  - Medio de entrega: repositorio de Github DEDICADO AL PROYECTO FINAL y presentación de avance a SocialTIC

2. **Almacenamiento consistente y correcto de datos**:
  - Entregables: a) Modelo ER, b) 4 scripts: de creación de objetos, inserción de datos, borrado de datos y eliminación de objetos. Todo en repositorio público de Github. c) Presentación ejecutiva de 15 mins a SocialTIC
  - Valor: 20%
  - Fecha de entrega: 25 de Nov antes de las 23:59:59
  - Medio de entrega: repositorio de Github DEDICADO AL PROYECTO FINAL y presentación de avance a SocialTIC

3. **Vistas analíticas de información:**
  - Entregables: a) 1 o N scripts de creación de vistas, b) documentación de lo que contiene cada vista y la respuesta que intenta responder. Ambos en repositorio público de Github. c) Presentación ejecutiva de 15 mins a SocialTIC.
  - Valor: 25%
  - Fecha de entrega: 8 de Dic antes de las 23:59:59
  - Medio de entrega: repositorio de Github DEDICADO AL PROYECTO FINAL y presentación de avance a SocialTIC

4. **Tableros de presentación y presentación final**:
  - Entregable: presentación ejecutiva de la solución con duración de 30 mins, con énfasis en el modelo ER, las vistas analíticas y las preguntas que intentan responder.
  - Valor: 25%
  - Fecha de entrega: 11 de Nov antes de las 23:59:59
  - Medio de entrega: repositorio de Github DEDICADO AL PROYECTO FINAL y presentación de avance a SocialTIC
 
### Materiales y fuentes de información

1. Recursos e investigaciones que ha hecho SocialTIC sobre Seguridad Digital para diferentes demografías: periodistas, infoactivistas, padres de familia, etc: https://socialtic.org/category/seguridad-digital/

2. Posterior a la recolección de información, y al análisis, el resultado de ellos deberá ser presentado en tableros de información como estos: https://public.tableau.com/en-gb/s/viz-gallery

## Contacto con SocialTIC

Si necesitan contactar a SocialTIC, lo pueden hacer en Slack con nuestro contacto Frida García para que les resuelva dudas en el canal #proyecto-final.

