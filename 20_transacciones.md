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

## Cómo se demarca una transacción en SQL?

## Cómo se finaliza una transacción en SQL?

## Cómo se reversa una transacción en SQL?

## Propiedades ACID

### Atomicity

### Consistency

### Isolation

### Durability

### Propiedades BASE

## Temas avanzados

### Transacciones anidadas
