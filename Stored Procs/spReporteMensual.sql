use PlanillaObrera
go

drop proc if exists spReporteMensual
go

create proc spReporteMensual @fechaOperacionParam date as
begin
	begin try
		declare @ultimaPlanillaSemanal int = (select max(id) from dbo.PlanillaMensual);

		declare @tempMovsDevengados table(id int identity(1,1),idPlanillaSemanal int, monto money);
		declare @tempMovsDeducciones table(id int identity(1,1),idPlanillaSemanal int, monto money);

		insert into @tempMovsDevengados(idPlanillaSemanal,monto) -- 1,2,3,4,5
		select M.idPlanillaSemanal,M.monto from Movimiento M join dbo.PlanillaSemanal PS on PS.id = M.idPlanillaSemanal
		where @ultimaPlanillaSemanal = PS.idPlanillaMensual and (M.idTipoMovimiento  != 6 or M.idTipoMovimiento !=7 or M.idTipoMovimiento  != 8 or M.idTipoMovimiento !=9 )

		insert into @tempMovsDeducciones(idPlanillaSemanal,monto)-- 6,7,8,9
		select M.idPlanillaSemanal,M.monto from Movimiento M join dbo.PlanillaSemanal PS on PS.id = M.idPlanillaSemanal
		where @ultimaPlanillaSemanal = PS. idPlanillaMensual and(M.idTipoMovimiento=6 or M.idTipoMovimiento=7 or M.idTipoMovimiento=8 or M.idTipoMovimiento=9)

		set transaction isolation level read uncommitted
		begin transaction 
			update dbo.PlanillaMensual
				SET  fechaFin = @fechaOperacionParam where id = @ultimaPlanillaSemanal
		commit

	end try
	begin catch
		declare @errorMsg varchar(100) = (select ERROR_MESSAGE())
		print('ERROR:'+@errorMsg)
		return -1*@@ERROR
	end catch
end
go