use PlanillaObrera
go

drop proc if exists spAbrirPlanillaMensual
go

create proc spAbrirPlanillaMensual @fechaOperacionParam date
as
	begin
		begin try
			set transaction isolation level read uncommitted
			begin transaction 
				insert into dbo.PlanillaMensual(devengados,deducciones,fechaInicio,fechaFin)
				values  (0 ,0 ,@fechaOperacionParam,@fechaOperacionParam) 
			commit
			declare @ultimaPlanillaMensual int = (select max(id) from dbo.PlanillaMensual)
			declare @date date = @fechaOperacionParam;
			exec spAbrirPlanillaSemanal @fechaOperacionParam = @date,@idPlanillaMensual = @ultimaPlanillaMensual;
		end try
		begin catch
			declare @errorMsg varchar(100) = (select ERROR_MESSAGE())
			print('ERROR:'+@errorMsg)
			return -1*@@ERROR
		end catch
	end
go