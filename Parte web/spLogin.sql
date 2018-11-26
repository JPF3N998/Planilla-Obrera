use PlanillaObrera
go

drop proc if exists spLogin
go

/*
	0 = not accepted
	1 = admin
	2 = obrero
*/

create proc spLogin @username varchar(100), @password varchar(100),@accepted int output
as
	begin
		begin try
		if exists (select E.DocId from Empleado E where E.DocId=@username) and exists(select E.DocId from Empleado E where E.DocId = @password)
			begin
				set @accepted = 2;
			end
		else if exists(select A.id from Administrador A where A.id = convert(int,@username))
			begin
				if exists (select A.DocId from Administrador A  where A.DocId = @password)
					set @accepted=1
				else
					set @accepted=0
			end
		else
			begin
				set @accepted=0
			end
		end try
		begin catch
			set @accepted =0
		end catch
	end
go
/*
declare @user varchar(100) = '1'
declare @password varchar(100) = '123456789'
declare @response int;
exec spLogin @user,@password,@response out
print(@response)
*/