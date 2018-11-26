use PlanillaObrera
go

drop proc if exists spFill
go

create proc spFill as
begin
	delete dbo.SalarioxHora;
	delete  dbo.Puesto;
	delete dbo.TipoJornadas;
	delete dbo.TipoDeduccion;
	delete dbo.TipoMovimiento;
	delete dbo.Feriado;
	declare @hdoc int;

	declare @PuestoXML xml;
	select @PuestoXML = P
	from openrowset(bulk 'C:\Users\josep\Google Drive\TEC 2018\SEMESTRE II\Base de datos I\Planilla Obrera\Archivos prueba\Puesto.xml',single_blob) as Puestos(P)

	exec sp_xml_preparedocument @hdoc out, @PuestoXML

	insert dbo.Puesto(id , nombre )
	select id, nombre from openxml(@hdoc,'/dataset/Puesto',1)
	with(
		id int,
		nombre varchar(50)
	)
	--select * from Puesto

	declare @TipoJornadaXML xml;
	select @TipoJornadaXML = T
	from openrowset(bulk 'C:\Users\josep\Google Drive\TEC 2018\SEMESTRE II\Base de datos I\Planilla Obrera\Archivos prueba\TipoJornadas.xml',single_blob) as TipoJornada(T)

	exec sp_xml_preparedocument @hdoc out, @TipoJornadaXML

	insert dbo.TipoJornadas(id,nombre,HoraInicio,HoraFin)
	select id,nombre,HoraInicio,HoraFin from openxml(@hdoc, '/dataset/TipoJornadas',1)
	with(
		id int,
		nombre varchar(30),
		HoraInicio time(0),
		HoraFin time(0)
		)
	--select * from dbo.TipoJornadas

		declare @TipoMovimientoXML xml;
		select @TipoMovimientoXML= M
		from openrowset(bulk 'C:\Users\josep\Google Drive\TEC 2018\SEMESTRE II\Base de datos I\Planilla Obrera\Archivos prueba\TipoMovimiento.xml',single_blob) as TipoMovimiento(M)

		exec sp_xml_preparedocument @hdoc out, @TipoMovimientoXML

		insert dbo.TipoMovimiento(id,nombre)
		select id,nombre from openxml(@hdoc,'/dataset/TipoMovimiento',1)
		with(
			id int,
			nombre varchar(50)
		)
	--select  * from dbo.TipoMovimiento

	declare @SalarioxHoraXML xml;
	select @SalarioxHoraXML = S
	from openrowset(bulk 'C:\Users\josep\Google Drive\TEC 2018\SEMESTRE II\Base de datos I\Planilla Obrera\Archivos prueba\SalarioxHora.xml',single_blob) as SalariosxHora(S)

	exec sp_xml_preparedocument @hdoc out, @SalarioxHoraXML

	insert dbo.SalarioxHora(id,idPuesto,idTipoJornada,valorHora)
	select id,idPuesto,idTipoJornada,valorHora from openxml(@hdoc,'/dataset/SalarioxHora',1)
	with(
		id int,
		idPuesto int,
		idTipoJornada int,
		valorHora money
	)
	--select * from SalarioxHora

declare @FeriadosXML xml;
select @FeriadosXML = F
from openrowset(bulk 'C:\Users\josep\Google Drive\TEC 2018\SEMESTRE II\Base de datos I\Planilla Obrera\Archivos prueba\Feriados.xml',single_blob) as Feriados(F)

exec sp_xml_preparedocument @hdoc out, @FeriadosXML

insert into dbo.Feriado(id,nombre,fecha)
select id,NombreFeriado,convert(date,Fecha,103) from openxml(@hdoc, '/dataset/Feriados',1)
with(
	id int,
	NombreFeriado varchar(200),
	Fecha varchar(50)
	)
--Select * from dbo.Feriado

declare @TipoDeduccionXML xml;
select @TipoDeduccionXML = X
from openrowset(bulk 'C:\Users\josep\Google Drive\TEC 2018\SEMESTRE II\Base de datos I\Planilla Obrera\Archivos prueba\TipoDeduccion.xml',single_blob) as Feriados(X)

exec sp_xml_preparedocument @hdoc out, @TipoDeduccionXML

insert into dbo.TipoDeduccion(id,nombre)
select id,nombre from openxml(@hdoc,'/dataset/TipoDeduccion',1)
with(
	id int,
	nombre varchar(100)
)

exec sp_xml_removedocument @hdoc

insert into dbo.Administrador(id,nombre,DocId)
values (1,'admin','123456789')

end

go