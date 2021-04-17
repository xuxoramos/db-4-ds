# Indices

Para esto necesitamos tener una tabla ENORME.

```sql
create table ecobici_historico (
  id numeric constraint pk_historico_ecobici primary key,
  genero_usuario char(1),
  edad_usuario numeric(3),
  bici varchar(100),
  ciclo_estacion_retiro varchar(100),
  fecha_retiro date,
  hora_retiro numeric(3),
  ciclo_estacion_arribo varchar(100),
  fecha_arribo date,
  hora_arribo numeric(3)
);
create sequence seq_id_ecobici_historico start 1 increment 1;
alter table ecobici_historico alter column id set default nextval('seq_id_ecobici_historico');
```
