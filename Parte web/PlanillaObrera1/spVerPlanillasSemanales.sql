use PlanillaObrera
go

drop proc if exists spVerPlanillasSemanales
go

create proc spVerPlanillasSemanales @DocIdParam varchar(30),@idPlanillaSemanal int as
	begin
		if @idPlanillaSemanal = 0
			begin
				select A.idPlanillaSemanal as [ID Planilla Semanal],A.fecha as Fecha,A.HoraEntrada as [Hora Entrada],A.HoraSalida as [Hora Salida],A.horasTrabajadas as [Horas Trabajadas],A.horasExtra as [Horas Extras],(case when A.incapacitado=1 then 'SI' else 'NO' end) as [Incapacitado]
				from Asistencia A
				where A.DocId=@DocIdParam
			end
		else
			begin
				select A.idPlanillaSemanal as [ID Planilla Semanal],A.fecha as Fecha,A.HoraEntrada as [Hora Entrada],A.HoraSalida as [Hora Salida],A.horasTrabajadas as [Horas Trabajadas],A.horasExtra as [Horas Extras],(case when A.incapacitado=1 then 'SI' else 'NO' end) as [Incapacitado]
				from Asistencia A
				where A.DocId=@DocIdParam and @idPlanillaSemanal = A.idPlanillaSemanal
				
			end
	end
go

/*
	exec spVerPlanillasSemanales '5873618232',5
*/

drop proc if exists spVerPlanillasMensuales
go

create proc spVerPlanillasMensuales @DocIdParam varchar(30)
as
	begin
		declare @tempPlanillasMensuales table(idPlanillaMensual int,idPlanillaSemanal int)
		insert into @tempPlanillasMensuales(idPlanillaMensual,idPlanillaSemanal)
		select PM.id,PS.id from PlanillaMensual PM join PlanillaSemanal PS on PS.idPlanillaMensual=PM.id where PM.fechaFin != PM.fechaInicio

		select * from @tempPlanillasMensuales

		declare @tempDevengadosDeducciones table(idPlanillaMensual money,totalDevengados money,totalDeducciones money)
		select idPlanillaMensual,sum(EX.devengadosTotales)/count(EX.devengadosTotales),sum(EX.deduccionesTotales)/count(EX.deduccionesTotales)
		from EmpleadosXPlanillaSemanal EX join @tempPlanillasMensuales TPM on TPM.idPlanillaSemanal = EX.idPlanillaSemanal
		where EX.DocId = @DocIdParam
		group by idPlanillaMensual
	end
go

--exec spVerPlanillasMensuales '5873618232'

drop proc if exists spVerMovimientos
go

create proc spVerMovimientos @DocIdParam varchar(30), @idPlanillaSemanal int
as
	begin
		if @idPlanillaSemanal = 0
			begin
				select * from Movimiento where DocId = @DocIdParam
			end
		else
			begin
				select * from Movimiento where DocId = @DocIdParam and @idPlanillaSemanal = idPlanillaSemanal
			end
	end
go

exec spVerMovimientos '5873618232',0