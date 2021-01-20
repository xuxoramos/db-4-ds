
--
-- TABLE: tipo_especializacion
-- 
CREATE TABLE tipo_especializacion (
  id_especialidad numeric(4,0) constraint pk_tipo_especializacion primary key,
  nombre varchar(100) NOT NULL 
);
CREATE SEQUENCE tipo_especializacion_id_especialidad_seq START 1 INCREMENT 1 ;
ALTER TABLE tipo_especializacion ALTER COLUMN id_especialidad SET DEFAULT nextval('tipo_especializacion_id_especialidad_seq');

-- 
--
-- TABLE: tipo_estudio
--  
CREATE TABLE tipo_estudio (
  id_tipo_estudio numeric(4,0) constraint pk_tipo_estudio primary key,
  nombre varchar(100) NOT NULL ,
  id_especialidadn numeric(4) references tipo_especializacion (id_especialidad)
);
CREATE SEQUENCE tipo_estudio_id_tipo_estudio_seq START 1 INCREMENT 1 ;
ALTER TABLE tipo_estudio ALTER COLUMN id_tipo_estudio SET DEFAULT nextval('tipo_estudio_id_tipo_estudio_seq');
--
-- TABLE: paciente
-- 
CREATE TABLE paciente (
  id_paciente numeric(4) constraint pk_paciente primary key,
  nombres varchar(50) NOT NULL ,
  apellidos varchar(50) NOT NULL ,
  tipo_sangre char(2) NOT NULL ,
  factor_rh bool NOT NULL ,
  peso numeric(5,2),
  estatura numeric(5,2)
);
CREATE SEQUENCE paciente_id_paciente_seq START 1 INCREMENT 1 ;
ALTER TABLE paciente ALTER COLUMN id_paciente SET DEFAULT nextval('paciente_id_paciente_seq');
-- 
--
-- TABLE: estudio
-- 
CREATE TABLE estudio (
  id_estudio numeric(4,0) constraint pk_estudio primary key,
  fecha_prescripcion date NOT NULL ,
  fecha_realizacion date NOT null,
  id_tipo_estudio numeric(4) references tipo_estudio (id_tipo_estudio),
  id_paciente numeric(4) references paciente (id_paciente) 
);
CREATE SEQUENCE estudio_id_estudio_seq START 1 INCREMENT 1 ;
ALTER TABLE estudio ALTER COLUMN id_estudio SET DEFAULT nextval('estudio_id_estudio_seq');
-- 
--
-- TABLE: doctor
--  
create table doctor (
  id_doctor numeric(4,0) constraint pk_doctor primary key,
  nombres varchar(50) NOT NULL ,
  apellidos varchar(50) NOT NULL ,
  fecha_contratacion date NOT NULL ,
  sueldo numeric(8,2) NOT NULL ,
  id_especializacion numeric(4) REFERENCES tipo_especializacion (id_especialidad) 
);
--
CREATE SEQUENCE doctor_id_doctor_seq START 1 INCREMENT 1 ;
ALTER TABLE doctor ALTER COLUMN id_doctor SET DEFAULT nextval('doctor_id_doctor_seq');
--
--
-- TABLE: paciente_doctor
--  
CREATE TABLE paciente_doctor (
  id_paciente numeric(4) references paciente (id_paciente) ON UPDATE CASCADE ON DELETE CASCADE,
  id_doctor numeric(4) references doctor (id_doctor) ON UPDATE cascade,
  constraint pk_paciente_doctor primary key (id_paciente, id_doctor)
);
-- 



