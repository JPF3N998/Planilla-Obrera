use PlanillaObrera
go

drop proc if exists spAgregarEmpleados
go

create proc spAgregarEmpleados @fechaOperacionParam date
	as
		begin
			begin try
				set nocount on;
				declare @hdoc int;
				declare @FechaOperacionXML xml;
				select @FechaOperacionXML = F
				from openrowset(bulk 'C:\Users\josep\Google Drive\TEC 2018\SEMESTRE II\Base de datos I\Planilla Obrera\Archivos prueba\FechaOperacion.xml' ,single_blob) as FechaOperacion(F)
				exec sp_xml_preparedocument @hdoc out,@FechaOperacionXML;

				declare @tempEmpleados table(id int identity(1,1),nombre varchar(50),DocId varchar(50),idPuesto int);

				insert into @tempEmpleados(nombre,DocId,idPuesto)
				select nombre,DocId,idPuesto from openxml(@hdoc,'/dataset/FechaOperacion/NuevoEmpleado',1)
				with(
					nombre varchar(50),
					DocId varchar(50),
					idPuesto int,
					Fecha varchar(30) '../@Fecha'
				)  where @fechaOperacionParam = convert(date,Fecha,103)
				--select * from @tempEmpleados
				exec sp_xml_removedocument @hdoc;
				set transaction isolation level read uncommitted
				begin transaction
					--Inserta empleados
					insert into dbo.Empleado(idPuesto,nombre,DocId)
					select TE.idPuesto,TE.nombre,TE.DocId from @tempEmpleados TE
					--Inserta las cuentas de esos clientes
					insert into dbo.Cuenta(idEmpleado,DocId,saldo)
					select E.id,E.DocId,0 as saldo from @tempEmpleados TE join dbo.Empleado E on TE.DocId = E.DocId
				commit
				return 1
			end try
			begin catch
				select ERROR_MESSAGE() as Error
				return -1*@@ERROR
			end catch
		end
go
