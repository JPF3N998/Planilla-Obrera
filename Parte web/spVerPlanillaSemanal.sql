USE [PlanillaObrera]
GO
/****** Object:  StoredProcedure [dbo].[spVerPlanillaSemanal]    Script Date: 11/24/2018 9:50:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop proc if exists spVerPlanillaSemanal
go

create procedure [dbo].[spVerPlanillaSemanal] @idEmpleado int
as
	begin
		begin try
		declare @tempPlanillaS table(id int, idPlanillaMensual int, fechaInicio date, fechaFin date)
		insert into @tempPlanillaS(id, idPlanillaMensual, fechaInicio,fechaFin)
		SELECT P.id,
				P.idPlanillaMensual,
				P.fechaInicio,
				P.fechaFin
		FROM dbo.PlanillaSemanal P inner join dbo.EmpleadosXPlanillaSemanal E on P.id = E.idPlanillaSemanal
		where  @idEmpleado = E.idEmpleado
		select * from @tempPlanillaS
		end try
		begin catch
			declare @errorMsg varchar(100) = (select ERROR_MESSAGE())
			print('ERROR:'+@errorMsg)
			return -1*@@ERROR
		end catch
	end