USE [PlanillaObrera]
GO
/****** Object:  StoredProcedure [dbo].[spVerSalarioXHora]    Script Date: 11/24/2018 9:51:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop proc if exists spVerSalarioXHora
go
create procedure [dbo].[spVerSalarioXHora]
as
	begin
		begin try
		SELECT *
		FROM dbo.SalarioxHora 
		end try
		begin catch
			declare @errorMsg varchar(100) = (select ERROR_MESSAGE())
			print('ERROR:'+@errorMsg)
			--return -1*@@ERROR
		end catch
	end