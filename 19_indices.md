# Indices

Para esto necesitamos tener una tabla ENORME.

```sql
create table ecobici_historico (
  id numeric constraint pk_historico_ecobici primary key,
  genero_usuario char(1),
  edad_usuario numeric(3),
  bici numeric(8),
  ciclo_estacion_retiro numeric(8),
  fecha_retiro date,
  hora_retiro time,
  ciclo_estacion_arribo numeric(8),
  fecha_arribo date,
  hora_arribo time
);
create sequence seq_id_ecobici_historico start 1 increment 1;
alter table ecobici_historico alter column id set default nextval('seq_id_ecobici_historico');
```
