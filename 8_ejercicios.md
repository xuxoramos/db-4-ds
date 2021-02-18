# Ejercicios en preparación para el examen

### Obtener un reporte de edades de los empleados para checar su elegibilidad para seguro de gastos médicos menores.

`select e.employee_id , ((now() - e.birth_date)/365) as "age" from employees e;`

otro enfoque puede ser usando el comando `age(date)`, que ya nos ayuda a realizar esta aritmética simple:

`select e.employee_id , age(e.birth_date) as "Age" from employees e;`

**Nota sobre [fechas en SQL](https://www.postgresql.org/docs/current/datatype-datetime.html):** las fechas en SQL, a muy bajo nivel, "viven" en la BD en forma numérica, y gracias a eso pueden responder a operadores aritméticos simples, como el de arriba, donde `now()` nos regresa la fecha y hora de este instante, y podemos restarle el campo `birth_date` de la tabla `employee` para obtener edades.

**Nota sobre representaciones de fechas:** Dado que las fechas son, finalmente, a nivel de BD,  valores numéricos, pero que acá en la realidad las representamos en un formato de texto (i.e. "12-10-1998" es 12 de Octubre de 1998, o Diciembre 10 de 1998?), entonces al insertar o extraer campos de fecha, es conveniente _**formatear**_ esta fecha para quitar ambigüedad de lo que significa el formato, y que la BD sepa dónde buscar el día, mes y año. A continuación ejemplos de transformación de formatos de fecha:

```
select to_date('1-9-2011', 'DD-MM-YYYY'); -- 1 de Sep de 2011
select to_date('1-9-2011', 'MM-DD-YYYY'); -- 9 de Enero de 2011
```

### Cuál es la orden más reciente por cliente?

```
select c3.company_name as "Company Name", 
max(o.order_date) as "Most Recent Order" 
from orders o join customers c3 on o.customer_id = c3.customer_id 
group by c3.company_name;
```

O si queremos también el ID de la orden:




5. De nuestros clientes, qué función desempeñan y cuántos son?
6. Cuántos productos tenemos de cada categoría?
7. Cómo podemos generar el reporte de reorder?
8. A donde va nuestro envío más voluminoso?
9. Cómo creamos una columna en `customers` que nos diga si un cliente es bueno, regular, o malo?
10. Qué colaboradores chambearon durante las fiestas de navidad?
11. Qué productos mandamos en navidad?
12. Qué país recibe el mayor volumen de producto?
