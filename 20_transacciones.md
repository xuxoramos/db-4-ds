# Transacciones

Una transacción es una estructura que permite empaquetar varios comandos de BD en una sola operación tipo _all or nothing_, es decir o se ejecutan todos los comandos dentro del paquete, o no se ejecuta ninguno.

Usaremos una tabla de ejemplo y la poblaremos con 1M de registros:

```sql
create table random_data (
	id serial primary key, -- el tipo SERIAL reemplaza todo el merequetengue de crear una sequence y ponerle como default el nextval para esta columna :)
	valor text,
	fecha timestamp
);

insert into random_data (valor, fecha)
select substr(md5(random()::text), 1, 10) as valor,                     -- la función md5() cifra justo con el algoritmo md5 una cadena
current_timestamp - (((random() * 365) || ' days')::interval) as fecha  -- crea fechas de hoy a un num de días random hasta 1 año atrás
from generate_series(1, 1000000);
```

Igual para esto debemos usar `pgAdmin` en lugar de DBeaver. Lo pueden encontrar en Windows así:

![image](https://user-images.githubusercontent.com/1316464/115486475-57c14500-a21c-11eb-88f2-311f1ed65810.png)

O en Mac así:

![](https://www.linode.com/docs/guides/securely-manage-remote-postgresql-servers-with-pgadmin-on-macos-x/pg-admin-open-new-window_hud9f4df0c614323b68e9919c449ea7406_51182_694x0_resize_q71_bgfafafc_catmullrom_2.jpg)

## Cómo se demarca una transacción en SQL?

Demarcamos las transacciones con 3 comandos:

1. **`begin`** para iniciar la transacción; posterior a esto usualmente incluimos el paquete comandos de escritura como `insert`, `update` y `delete`.
2. **`commit`** para escribir la transacción (y su paquete de comandos) a PostgreSQL
3. **`rollback`** para _reversar_ las operaciones que están incluídas en el paquete de transacciones que aparecen después del `begin`

Dependiendo como nos estemos conectando a la BD, usualmente las transacciones son controladas por:

1. El DBeaver
2. Nuestro application code
3. Manualmente con los comandos de arriba

Para esta sesión vamos a mostrar como lo hacemos con comandos y como lo hace DBeaver.

### Transacciones con DBeaver

Fíjense arriba en su toolbar de DBeaver y verán esto:

![image](https://user-images.githubusercontent.com/1316464/115487955-4d547a80-a21f-11eb-9906-702b13e33bc6.png)

Esto significa que DBeaver está en modo **Auto-commit**, que significa que cada comando(s) que ejecutamos, en automático nuestro cliente los encerrará en `begin` y `commit`.

Para ilustrar como funcionan las transacciones, debemos ponerlo en **Manual commit**.

![image](https://user-images.githubusercontent.com/1316464/115488233-c6ec6880-a21f-11eb-9274-f8b82c7aed15.png)


## Propiedades ACID

### Atomicity

### Consistency

### Isolation

### Durability

### Propiedades BASE

## Temas avanzados

### Transacciones anidadas
