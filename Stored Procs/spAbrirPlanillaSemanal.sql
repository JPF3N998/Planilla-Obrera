use PlanillaObrera
go

drop proc if exists spAbrirPlanillaSemanal
go

create proc spAbrirPlanillaSemanal @fechaOperacionParam date, @idPlanillaMensual int
as
	begin
		begin try
			set transaction isolation level read uncommitted
			begin transaction
				insert into dbo.PlanillaSemanal(idPlanillaMensual,fechaInicio,fechaFin,totalDevengados,totalDeducciones)
				values(@idPlanillaMensual,@fechaOperacionParam,@fechaOperacionParam,0, 0)
			commit
		end try
		begin catch
			declare @errorMsg varchar(100) = (select ERROR_MESSAGE())
			print('ERROR:'+@errorMsg)
		return -1*@@ERROR
	end catch
	end