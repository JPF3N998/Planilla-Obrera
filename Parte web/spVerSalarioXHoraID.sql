USE [PlanillaObrera]
GO
/****** Object:  StoredProcedure [dbo].[spVerSalarioXHoraID]    Script Date: 11/24/2018 9:51:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop proc if exists spVerSalarioXHoraID
go


create procedure [dbo].[spVerSalarioXHoraID]
	@id int
as
	begin
		begin try
			SELECT *
			FROM SalarioxHora
			WHERE id = @id
		end try
		begin catch
			declare @errorMsg varchar(100) = (select ERROR_MESSAGE())
			print('ERROR:'+@errorMsg)
			--return -1*@@ERROR
		end catch
	end