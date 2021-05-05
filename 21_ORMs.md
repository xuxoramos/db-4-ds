# Object-Relational Mapping

Los diagramas ER nos sirven para establecer entidades y relaciones, pero nos imponen un lenguaje limitado para describir un sistema complejo.

Mientras que todas las relaciones que podemos expresar en una BD pueden ser expresadas en un lenguaje orientado a objetos, _no todas las relaciones entre objetos pueden ser expresadas en BD_.

Este conflicto entre paradigmas se llama ["object-relational impedace mismatch"](https://en.wikipedia.org/wiki/Object%E2%80%93relational_impedance_mismatch).

Y la herramienta que usamos para darle la vuelta es el Object-Relational Mapping

## Ejemplo: modelado de datos

### En BD

Una tabla `Contacto` con atributos `nombre`, `número`, `dirección`. Todos ellos escalares.

### En OOP

Un objeto `ContactoConocido` con atributos `nombre`, `número`, `dirección`. Qué pasa si queremos sofisticar este diseño?

Un objeto `ContactoTrabajo` con atributos `nombre`, `número`, `dirección`, `horaInicio` y `horaFin`.

Otro objeto `ContactoPersonal` con atributos `nombre`, `número`, `dirección` y `tipoSangre`.

Otro objeto `ContactoFamiliar` con atributos `nombre`, `número`, `dirección` y `códigoSeguridadCasa`.

Un objeto padre u objeto abstracto `Contacto` que tenga los atributos comunes a todos.

Finalmente, _métodos_, que son funciones para que los contactos tengan acciones, como `borrar`, `editar`, `nuevo` a ellos mismos.

Ni de chiste SQL nos deja especificar de manera elegante cuestiones como **herencia**, **polimorfismo**, **composición**, o **herencia abstracta**.

Pero SQL ya es el estándar de facto para almacenamiento de datos en todo el mundo tecnológico!

## Ejemplo 2: acceso a datos

Suponiendo que tenemos una aplicación multicapa, entonces a pesar de que nosotros como creadores de esta aplicación si tenemos acceso a la BD, nuestros usuarios tienen acceso a ella mediante una aplicación. Dicha aplicación probablemente no está hecha en SQL, sino en algún lenguaje orientado a objetos, y por tanto no necesariamente correrá en la misma máquina que la BD.

Para esto, debo hacer un paréntesis y explicar arquitectura de aplicaciones:

## Aplicaciones multicapa

### Mainframes y sistemas monolíticos

Corrían sistemas viejitos (afiliación del IMSS, control aéreo, control del metro, registro en el RFC) y en una misma máquina se ejecutaba todo: almacenamiento de datos, procesamiento de entradas, impresión de reportes, etc.

![image](https://user-images.githubusercontent.com/1316464/117094165-a98fc200-ad28-11eb-812e-ca373ff650c2.png)

Esto se hacía con un lenguaje viejito que se llama COBOL, que creó esta señora:

![image](https://user-images.githubusercontent.com/1316464/116918377-6ee93500-ac15-11eb-9742-9c6309cbdb23.png)

Y si, el lenguaje es tan cuadrado y estricto como esta señora se ve.

### Client-server Architecture

Partimos el monolito y la parte de acceso a datos la sacamos de él, dejando solo el procesamiento.

Para la parte de acceso se construyeron aplicaciones y sistemas _cliente_ que eran cientos de pantallas para consultar, actualizar y registrar datos.

Luego se tendieron conexiones (no de internet) para enlazar las máquinas que corrían estos sistemas con su monolito, en donde se quedó el almacenamiento y procesamiento de datos.

![image](https://user-images.githubusercontent.com/1316464/117094522-9f21f800-ad29-11eb-8244-baad3c7e6d9d.png)

Luego vino el internet, y BOOM! 

### Arquitecturas de 3 capas

Con la adopción del internet a todos los niveles pudimos tener más capas, comenzando por separar ahora el procesamiento de datos del almacenamiento de los mismos:

![image](https://user-images.githubusercontent.com/1316464/117096431-a0a1ef00-ad2e-11eb-9422-12aab57c4b87.png)

Esto nos permitió una explosión comercial de ofertas de productos y servicios para cada capa:

- **Client**: ya no necesitábamos frozosamente estar frente a la maquinota para poder usarla, ya podíamos usarla desde nuestras compus personales, las cuales estaban apenas comenzando. Este momento fue en el que la brecha de género de mujeres en STEM se comenzó a dar.

- **Application:** ya podíamos tener servidores de todo tipo y con varios sabores de sistema operativo, y a IBM se le acaba su gravy train de ser el único fabricante de mainframes. Con la variedad de sistemas operativos vino el boom de la adopción de Linux, y el boom de los lenguajes de programación, dado que podíamos construir esta capa con Java, Python, C#, etc.

- **Database:** la misma variedad de alternativas para las capas de arriba acompañaron un boom de variedad de la capa de datos. Aquí es cuando se cementa la BD como la parte más importante de las aplicaciones, y donde nacen varios productos de BD como Oracle, Informix, AS400, etc.

### Arquitecturas de N capas

Los sistemas modernos ahora tienen una arquitectura muy compleja con muchísimos moving parts:

![image](https://user-images.githubusercontent.com/1316464/116940104-0ad56980-ac33-11eb-948f-9c6f464de4b5.png)

Sobre todo porque ya estamos hablando de aplicaciones con accesos globales, en diferentes zonas, diferentes frentes y diferentes propósitos, y cada componentito puede ejecutarse en una máquina individual o en contenedores.

Nuestro proyecto final es un ejemplo de una aplicación multicapa.

Y qué tiene que ver todo esto con ORMs y bases de datos?

## Ahora si, back to our example

Los ORM nos permiten tratar las tablas como objetos y representar relaciones más complejas sin necesidad de salir de nuestro lenguaje de programación, y al mismo tiempo interactuar con nuestra BD gracias a su labor de _traducción_:

De esta forma, podemos tener esto:

![image](https://user-images.githubusercontent.com/1316464/117098626-a569a180-ad34-11eb-9fa1-a15f55dee7c4.png)

### Algunas equivalencias y traducciones entre ORM y SQL

| ORM | SQL |
|-----|-----|
var p = repository.getPayment(10) | select * from payment p where p.id = 10
p2 = new Product() | insert into product values...
product.setUnitPrice(200) | update product set unit_price = 200 where...

### Clases VS Tablas

Recordemos este modelo ER del inicio de semestre:

![](https://camo.githubusercontent.com/1783c43244b8d415030171d26d899b55a682559b38b43ca3f046a79147414bcb/68747470733a2f2f696d6775722e636f6d2f6a534a75664e742e706e67)

Al desarrollar una aplicación para registro hospitalario, necesitamos varias funcionalidades como autenticación, transacciones, pantallas, y en general user experience...

**COSA QUE ES PERRÍSIMA CON SQL**

Entonces recurrimos a una plataforma o lenguaje de programación. .NET, Python, Java, etc.

PERO...

Estos son lenguajes orientados a objetos.

Por lo tanto tendríamos este diagrama de clases:

![image](https://user-images.githubusercontent.com/1316464/117180994-653d0a00-ad9a-11eb-9223-377dc52c1789.png)

Los diagramas de clase nos permiten mucho más expresividad y contar mucho más historias de un sistema y sus interacciones:

- Un `Doctor` puede `consultar(Paciente)`
- Un `Doctor` puede ser `Cirujano`.
- Un `Cirujano` puede hacer todo lo de un `Doctor`, excepto `operar()`.
- Un `Paciente` tiene una colección de `Doctor` que son todos los que lo han atendido. Cuando un `Doctor` nuevo se suma a la atención de un `Paciente`, lo agregamos con `addDoctor(Doctor)`.
- No necesitamos _clases_ intermedias para una relación **N a M**, solo especificar que hay una relación.

⚠️ Pero de todos modos nuestra BD sigue siendo SQL. ⚠️

## Levantando un ORM

Vamos a utilizar la BD de hospital que hicimos al inicio del semestre.

### Descargar e instalar .NET SDK

De [aquí](https://dotnet.microsoft.com/download/dotnet/thank-you/sdk-5.0.202-windows-x64-installer).

### Crear solución y andamiaje de HospitApp

```sh
mkdir hospitapp
cd hospitapp
dotnet new console -o HospitApp
dotnet new sln
dotnet sln add HospitApp/HospitApp.csproj
dotnet add package Npgsql --version 6.0.0-preview3
dotnet tool install --global dotnet-ef
dotnet ef dbcontext scaffold "Server=localhost;Port=5433;Database=hospitapp;User Id=postgres;Password=admin;" Npgsql.EntityFrameworkCore.PostgreSQL -o Model
```

Debemos terminar con un archivo llamado `HospitApp.csproj` con el siguiente contenido:

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net5.0</TargetFramework>
  </PropertyGroup>
  <ItemGroup>
    <PackageReference Include="Npgsql.EntityFrameworkCore.PostgreSQL" Version="5.0.5"/>
    <PackageReference Include="Microsoft.EntityFrameworkCore.Design" Version="5.0.5"/>
    <PackageReference Include="Npgsql.EntityFrameworkCore.PostgreSQL.Design" Version="*"/>
  </ItemGroup>
</Project>
```

Creando las tablas con este script:

```sql
-- paciente definition

-- Drop table

-- DROP TABLE paciente;

CREATE TABLE paciente (
	id_paciente serial NOT NULL ,
	nombres varchar(50) NOT NULL,
	apellidos varchar(50) NOT NULL,
	tipo_sangre bpchar(2) NOT NULL,
	factor_rh bool NOT NULL,
	peso numeric(5,2) NULL,
	estatura numeric(5,2) NULL,
	CONSTRAINT pk_paciente PRIMARY KEY (id_paciente)
);


-- tipo_especializacion definition

-- Drop table

-- DROP TABLE tipo_especializacion;

CREATE TABLE tipo_especializacion (
	id_especializacion serial NOT NULL ,
	nombre varchar(100) NOT NULL,
	CONSTRAINT pk_tipo_especializacion PRIMARY KEY (id_especializacion)
);


-- doctor definition

-- Drop table

-- DROP TABLE doctor;

CREATE TABLE doctor (
	id_doctor serial NOT NULL,
	nombres varchar(50) NOT NULL,
	apellidos varchar(50) NOT NULL,
	fecha_contratacion date NOT NULL,
	sueldo numeric(8,2) NOT NULL,
	id_especializacion integer NULL,
	CONSTRAINT pk_doctor PRIMARY KEY (id_doctor),
	CONSTRAINT doctor_id_especializacion_fkey FOREIGN KEY (id_especializacion) REFERENCES tipo_especializacion(id_especializacion)
);


-- paciente_doctor definition

-- Drop table

-- DROP TABLE paciente_doctor;

CREATE TABLE paciente_doctor (
	id_paciente integer NOT NULL,
	id_doctor integer NOT NULL,
	CONSTRAINT pk_paciente_doctor PRIMARY KEY (id_paciente, id_doctor),
	CONSTRAINT paciente_doctor_id_doctor_fkey FOREIGN KEY (id_doctor) REFERENCES doctor(id_doctor) ON UPDATE CASCADE,
	CONSTRAINT paciente_doctor_id_paciente_fkey FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON UPDATE CASCADE ON DELETE CASCADE
);


-- tipo_estudio definition

-- Drop table

-- DROP TABLE tipo_estudio;

CREATE TABLE tipo_estudio (
	id_tipo_estudio serial NOT NULL ,
	nombre varchar(100) NOT NULL,
	id_especializacion integer NULL,
	CONSTRAINT pk_tipo_estudio PRIMARY KEY (id_tipo_estudio),
	CONSTRAINT tipo_estudio_id_especialidadn_fkey FOREIGN KEY (id_especializacion) REFERENCES tipo_especializacion(id_especializacion)
);


-- estudio definition

-- Drop table

-- DROP TABLE estudio;

CREATE TABLE estudio (
	id_estudio serial NOT NULL ,
	fecha_prescripcion date NOT NULL,
	fecha_realizacion date NOT NULL,
	id_tipo_estudio integer NULL,
	id_paciente integer NULL,
	CONSTRAINT pk_estudio PRIMARY KEY (id_estudio),
	CONSTRAINT estudio_id_paciente_fkey FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
	CONSTRAINT estudio_id_tipo_estudio_fkey FOREIGN KEY (id_tipo_estudio) REFERENCES tipo_estudio(id_tipo_estudio)
);
```
