use PlanillaObrera
go

drop proc if exists spVerAsistencia
go

create proc spVerAsistencia @fechaOperacionParam date,@idPlanillaSemanal int as
begin
	begin try
		set nocount on;
				declare @hdoc int;
				
				declare @FechaOperacionXML xml;
				select @FechaOperacionXML = F
				from openrowset(bulk 'C:\Users\josep\Google Drive\TEC 2018\SEMESTRE II\Base de datos I\Planilla Obrera\Archivos prueba\FechaOperacion.xml' ,single_blob) as FechaOperacion(F)
				
				exec sp_xml_preparedocument @hdoc out,@FechaOperacionXML;

				declare @tempAsistencia table(id int identity(1,1),DocId varchar(50),idTipoJornada int,horaEntrada time(0),horaInicio time(0),horaSalida time(0),horaSalidaJ time(0),horasTrabajadas int,horasExtra int);
				insert into @tempAsistencia(DocId,idTipoJornada,horaEntrada,horaInicio,horaSalida,horaSalidaJ,horasTrabajadas,horasExtra) 
				select X.DocId,X.idTipoJornada,X.HoraEntrada,TJ.horaInicio,X.HoraSalida,TJ.horaFin,abs(datediff(hour,X.HoraEntrada,X.HoraSalida)),abs( datediff(hour,TJ.horaFin,X.HoraSalida)) from openxml(@hdoc,'/dataset/FechaOperacion/Asistencia',1)
				with(
					DocId varchar(50),
					idTipoJornada int,
					HoraEntrada time(0),
					HoraSalida time(0),
					Fecha varchar(30) '../@Fecha'
				) X
				inner join dbo.TipoJornadas TJ on TJ.id=X.idTipoJornada where @fechaOperacionParam = convert(date,Fecha,103)
				--select * from @tempAsistencia

				--Aqui esta la tabla temporal para los ausentes por incapacidad
				declare @tempIncapacitados table(id int identity(1,1),DocId varchar(50),idTipoJornada int);
				insert into @tempIncapacitados(DocId,idTipoJornada) 
				select X.DocId,X.idTipoJornada from openxml(@hdoc,'/dataset/FechaOperacion/Incapacidad',1)
				with(
					DocId varchar(50),
					idTipoJornada int,
					Fecha varchar(30) '../@Fecha'
				) X
				where @fechaOperacionParam = convert(date,Fecha,103)
				--select * from @tempIncapacitados
				exec sp_xml_removedocument @hdoc;
				

				set transaction isolation level read uncommitted
				begin transaction

					insert into dbo.Asistencia(idEmpleado,idTipoJornada,idPlanillaSemanal,incapacitado,DocId,HoraEntrada,HoraSalida,horasTrabajadas,horasExtra,fecha)
					select E.id,TA.idTipoJornada,@idPlanillaSemanal,0 as incapacitado, TA.DocId,TA.horaEntrada,TA.horaSalida,TA.horasTrabajadas,TA.horasExtra,@fechaOperacionParam
					from @tempAsistencia TA join Empleado E on E.DocId=TA.DocId
					
					insert into dbo.Asistencia(idEmpleado,idTipoJornada,idPlanillaSemanal,incapacitado,DocId,HoraEntrada,HoraSalida,horasTrabajadas,horasExtra,fecha)
					select TI.id,TI.idTipoJornada,@idPlanillaSemanal,1 as incapacitado,TI.DocId,cast('1am' as time),cast('1am' as time(0)),0 as horasTrabajadas,0 as horasExtra,@fechaOperacionParam
					from @tempIncapacitados TI join Empleado E on E.DocId=TI.DocId


					insert into dbo.EmpleadosXPlanillaSemanal(idPlanillaSemanal,idEmpleado,DocId,idTipoJornada,devengadosTotales,deduccionesTotales)
					select (select max(id) from PlanillaSemanal P) as idPlanillaSemanal, E.id,TA.DocId,TA.idTipoJornada,0,0
					from Empleado E join @tempAsistencia TA on E.DocId=TA.DocId
					

					insert into dbo.EmpleadosXPlanillaSemanal(idPlanillaSemanal,idEmpleado,DocId,idTipoJornada,devengadosTotales,deduccionesTotales)
					select (select max(id) from PlanillaSemanal) as idPlanillaSemanal, E.id,TI.DocId,TI.idTipoJornada,0,0
					from Empleado E join @tempIncapacitados TI on E.DocId=TI.DocId
					
				commit
				--NOTE: Se verifica la fecha de la asistencia para ver si es dia feriado o Domingo para multiplicar el salario correspondiente (x2)
				return 1
	end try
	begin catch
			declare @errorMsg varchar(1000) = convert(varchar(10),(select ERROR_LINE()))+ (select ERROR_MESSAGE())
			print(@errorMsg)
			return -1*@@ERROR
	end catch
end
go