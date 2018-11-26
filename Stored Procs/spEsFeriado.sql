use PlanillaObrera
go

drop proc if exists spEsFeriado
go

create proc spEsFeriado @fechaOperacionParam date, @bool bit output
as
	begin
		if exists (select fecha from dbo.Feriado where @fechaOperacionParam=fecha)
			set @bool = 1;
		else if(format(@fechaOperacionParam,'dddd')='Sunday')
			set @bool=1
		else
			set @bool=0
	end
go
/*
declare @date date;
declare @bit bit;
set @date = convert(date,'4/11/2018',103)
exec spEsFeriado @fechaOperacionParam=@date ,@bool=@bit out
print(@bit)
*/