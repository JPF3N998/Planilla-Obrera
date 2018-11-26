use PlanillaObrera
go

drop proc if exists spVerPlanillasSemanales
go

create proc spVerPlanillasSemanales @DocIdParam varchar(30),@idPlanillaSemanal int as
	begin
		if @idPlanillaSemanal = 0
			begin
				select A.idPlanillaSemanal as [ID Planilla Semanal],convert(varchar(10),A.fecha) as Fecha,A.HoraEntrada as [Hora Entrada],A.HoraSalida as [Hora Salida],A.horasTrabajadas as [Horas Trabajadas],A.horasExtra as [Horas Extras],(case when A.incapacitado=1 then 'SI' else 'NO' end) as [Incapacitado]
				from Asistencia A
				where A.DocId=@DocIdParam
			end
		else
			begin
				select A.idPlanillaSemanal as [ID Planilla Semanal],convert(date,A.fecha,103) as Fecha,A.HoraEntrada as [Hora Entrada],A.HoraSalida as [Hora Salida],A.horasTrabajadas as [Horas Trabajadas],A.horasExtra as [Horas Extras],(case when A.incapacitado=1 then 'SI' else 'NO' end) as [Incapacitado]
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
		declare @tempPlanillasMensuales table([ID Planilla Mensual] int,[Devengados del mes] money,[Deducciones del mes] money,[Fecha Inicio] varchar(10),[Fecha Fin] varchar(10))
		insert into @tempPlanillasMensuales([ID Planilla Mensual],[Devengados del mes],[Deducciones del mes],[Fecha Inicio],[Fecha Fin])
		select PM.id,sum(EX.devengadosTotales),sum(EX.deduccionesTotales),convert(varchar(10),PM.fechaInicio),convert(varchar(10),PM.fechaFin)
		from PlanillaMensual PM
			join PlanillaSemanal PS on PS.idPlanillaMensual=PM.id
			join EmpleadosXPlanillaSemanal EX on PS.id = EX.idPlanillaSemanal
		where PM.fechaFin != PM.fechaInicio and EX.DocId=@DocIdParam
		group by PM.id,PM.fechaInicio,PM.fechaFin
		order by PM.id

		select * from @tempPlanillasMensuales

		--declare @tempDevengadosDeducciones table(idPlanillaMensual money,totalDevengados money,totalDeducciones money)
		--select 

		--select * from @tempDevengadosDeducciones

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
				select M.idPlanillaSemanal as [ID Planilla Semanal],TM.nombre as Descripcion,M.monto as Monto,convert(varchar(10),M.fecha) as Fecha from Movimiento M join TipoMovimiento TM on TM.id=M.idTipoMovimiento where DocId = @DocIdParam
			end
		else
			begin
				select M.idPlanillaSemanal as [ID Planilla Semanal],TM.nombre as Descripcion,M.monto as Monto,convert(varchar(10),M.fecha) as Fecha from Movimiento M join TipoMovimiento TM on TM.id=M.idTipoMovimiento where DocId = @DocIdParam and idPlanillaSemanal =@idPlanillaSemanal
			end
	end
go



