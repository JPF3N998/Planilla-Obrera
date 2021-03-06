USE [PlanillaObrera]
GO
/****** Object:  StoredProcedure [dbo].[spEditarSalarioXHora]    Script Date: 11/24/2018 9:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop proc if exists spEditarSalarioXHora
go

create procedure [dbo].[spEditarSalarioXHora]
	@id int,
	@valor int
as
	begin
		begin try
		set transaction isolation level read uncommitted
			begin transaction
				Update SalarioxHora 
					SET valorHora = @valor
				where id = @id
			commit
		end try
		begin catch
			declare @errorMsg varchar(100) = (select ERROR_MESSAGE())
			print('ERROR:'+@errorMsg)
			--return -1*@@ERROR
		end catch
	end