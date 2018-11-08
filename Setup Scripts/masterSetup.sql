use PlanillaObrera
go
/*
Catalogos:
Puesto
TipoJornadas
TipoDeduccion
SalarioxHora
TipoMovimiento
*/

drop table if exists dbo.Puesto
go

create table Puesto(
	id int primary key,
	nombre varchar(30) not null
)
go

drop table if exists dbo.TipoJornadas
go

create table  TipoJornadas(
	id int primary key,
	nombre varchar(30) not null,
	horaInicio time(0) not null,
	horaFin time(0) not null
)

drop table if exists dbo.TipoDeduccion
go

create table TipoDeduccion(
	id int primary key,
	nombre varchar(50) not null
)
go

drop table if exists dbo.SalarioxHora
go

create table SalarioxHora(
	id int primary key,
	idPuesto int not null,
	idTipoJornada int not null,
	valorHora int not null
)

/****************************/

drop table if exists dbo.Empleado
go

create table Empleado(
	id int identity(1,1) primary key,
	idPuesto int not null,
	nombre varchar(50) not null,
	DocId varchar(50) not null
)

drop table if exists dbo.Cuenta
go

create table Cuenta(
	id int identity(1,1)  primary key,

)

drop table if exists dbo.Asistencia
go

create table Asistencia(
	id int identity(1,1)  primary key,
	idTipoJornada int not null,
	DocId varchar(50) not null,
	HoraEntrada time(0) not null,
	HoraSalida time(0) not null
)

drop table if exists dbo.Deduccion
go

create table Deduccion(
	id int identity(1,1)  primary key,
	idTipoDeduccion int not null,
	DocId varchar(50) not null
)

drop table if exists dbo.Bono
go

create table Bono(
	id int identity(1,1) primary key,
	DocId varchar(50) not null,
	Monto int not null
)

drop table if exists dbo.Incapacidad
go

create table Incapacidad(
	id int identity(1,1)  primary key,
	idTipoJornada int not null,
	DocId varchar(50) not null
)

drop table if exists Movimiento
go

create table Movimiento(
	id int identity(1,1) primary key,
	idCuentaBancaria int,

)