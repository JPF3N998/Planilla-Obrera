create database PlanillaObrera
go
use PlanillaObrera
go

create table Puesto(
	id int primary key,
	nombre varchar(30) not null
)
go
	create table TipoMovimiento(
	id int primary key,
	nombre varchar(50)
	)
go
create table  TipoJornadas(
	id int primary key,
	nombre varchar(30) not null,
	horaInicio time(0) not null,
	horaFin time(0) not null
)
go
create table TipoDeduccion(
	id int primary key,
	nombre varchar(50) not null
)
go
create table SalarioxHora(
	id int primary key,
	idPuesto int not null,
	idTipoJornada int not null,
	valorHora int not null
)
go
create table Feriado(
	id int primary key,
	nombre varchar(100),
	fecha date
)
go
create table Administrador(
	id int primary key,
	nombre varchar(100) not null,
	DocId varchar(100)not null
)
go
create table Eventos(
	id int primary key,
	idTipoMovimiento int not null,
	idAdmin int not null,
	monto money not null,
	descripcion varchar(500) not null,
	fecha date not null
)
go
/****************************/

create table Empleado(
	id int identity(1,1) primary key,
	idPuesto int not null,
	nombre varchar(50) not null,
	DocId varchar(50) not null
)
go
create table Cuenta(
	id int identity(1,1)  primary key,
	idEmpleado int not null,
	DocId varchar(50)not null,
	saldo money not null
)
go
create table Asistencia(
	id int identity(1,1)  primary key,
	idEmpleado int not null,
	idTipoJornada int not null,
	idPlanillaSemanal int not null,
	incapacitado bit not null,
	DocId varchar(50) not null,
	HoraEntrada time(0) not null,
	HoraSalida time(0) not null,
	horasTrabajadas int not null,
	horasExtra int not null,
	fecha date not null
)
go
create table Deduccion(
	id int identity(1,1)  primary key,
	idTipoDeduccion int not null,
	idPlanillaSemanal int not null,
	DocId varchar(50) not null,
	descripcion varchar(100) not null,
	monto money not null,
	montoFinal money not null,
	fecha date
)
go
create table Movimiento(
	id int identity(1,1) primary key,
	idTipoMovimiento int not null,
	idPlanillaSemanal int not null,
	DocId varchar(50) not null,
	monto money not null,
	fecha date not null
)
go
create table PlanillaSemanal(
	id int identity(1,1) primary key,
	idPlanillaMensual int not null,
	fechaInicio date not null,
	fechaFin date not null,
	totalDevengados money not null,
	totalDeducciones money not null
)
go
create table PlanillaMensual(
	id int identity(1,1) primary key,
	devengados money not null,
	deducciones money not null,
	fechaInicio date not null,
	fechaFin date not null
)
go
create table EmpleadosXPlanillaSemanal(
	id int identity(1,1) primary key,
	idPlanillaSemanal int not null,
	idEmpleado int not null,
	DocId varchar(30) not null,
	idTipoJornada int not null,
	devengadosTotales money not null,
	deduccionesTotales money not null
)
go
---RESEED
DBCC CHECKIDENT ('Empleado', RESEED,0);
DBCC CHECKIDENT ('Cuenta', RESEED,0);
DBCC CHECKIDENT ('Asistencia', RESEED,0);
DBCC CHECKIDENT ('Movimiento', RESEED,0);
DBCC CHECKIDENT ('PlanillaSemanal', RESEED,0);
DBCC CHECKIDENT ('PlanillaMensual', RESEED,0);
DBCC CHECKIDENT ('Deduccion', RESEED,0);
/*
exec spCrearTablas
exec spFill
exec spRelationLinker
*/