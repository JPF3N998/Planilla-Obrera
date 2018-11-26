use PlanillaObrera
go

drop proc if exists spInsertarDeducciones
go

create proc spInsertarDeducciones @fechaOperacionParam date,@planillaSemanalParam int as
begin
	begin try
			set nocount on;
			declare @hdoc int;
				
			declare @FechaOperacionXML xml;
			select @FechaOperacionXML = F
			from openrowset(bulk 'C:\Users\josep\Google Drive\TEC 2018\SEMESTRE II\Base de datos I\Planilla Obrera\Archivos prueba\FechaOperacion.xml' ,single_blob) as FechaOperacion(F)

			exec sp_xml_preparedocument @hdoc out,@FechaOperacionXML;

			declare @tempDeduccionesFijo table(id int identity(1,1),DocId varchar(50),idTipoDeduccion int,descripcion varchar(100),monto money,fecha date);
			declare @tempDeduccionesPorcentual table(id int identity(1,1),DocId varchar(50),idTipoDeduccion int,descripcion varchar(100),monto money,fecha date);

			insert into @tempDeduccionesFijo(DocId,idTipoDeduccion,descripcion,monto,fecha)
			select X.DocId,X.idTipoDeduccion,TD.nombre,X.Valor,@fechaOperacionParam from openxml(@hdoc,'/dataset/FechaOperacion/NuevaDeduccion',1)
			with(
				DocId  varchar(50),
				idTipoDeduccion int,
				Valor money,
				Fecha varchar(30) '../@Fecha'
			) X
			join dbo.Cuenta C on C.DocId = X.DocId
			join TipoDeduccion TD on TD.id = X.idTipoDeduccion
			where @fechaOperacionParam = convert(date,Fecha,103)
			--Deducciones con monto fijo;
			and(X.idTipoDeduccion = 3 or X.idTipoDeduccion =4)

			insert into @tempDeduccionesPorcentual(DocId,idTipoDeduccion,descripcion,monto,fecha)
			select X.DocId,X.idTipoDeduccion,TD.nombre,X.Valor,@fechaOperacionParam from openxml(@hdoc,'/dataset/FechaOperacion/NuevaDeduccion',1)
			with(
				DocId  varchar(50),
				idTipoDeduccion int,
				Valor money,
				Fecha varchar(30) '../@Fecha'
			) X
			join dbo.Cuenta C on C.DocId = X.DocId
			join TipoDeduccion TD on X.idTipoDeduccion = TD.id
			where @fechaOperacionParam = convert(date,Fecha,103)
			--Deducciones con monto porcentual
			and (X.idTipoDeduccion = 1 or X.idTipoDeduccion = 2);
			exec sp_xml_removedocument @hdoc;

			--select * from @tempDeduccionesFijo
			--select * from @tempDeduccionesPorcentual

			 set transaction isolation level read uncommitted
			 begin transaction 
				
				insert into dbo.Deduccion(idTipoDeduccion,idPlanillaSemanal,DocId,descripcion,monto,montoFinal,fecha)
				select TF.idTipoDeduccion,@planillaSemanalParam,TF.DocId,TF.descripcion,TF.monto,monto as montoFinal,@fechaOperacionParam from @tempDeduccionesFijo TF

				insert into dbo.Deduccion(idTipoDeduccion,idPlanillaSemanal,DocId,descripcion,monto,montoFinal,fecha)
				select TP.idTipoDeduccion,@planillaSemanalParam,TP.DocId,TP.descripcion,TP.monto/100,0 as montoFinal,@fechaOperacionParam from @tempDeduccionesPorcentual TP

			 commit
	end try
	begin catch
		declare @errorMsg varchar(100) = (select ERROR_MESSAGE())
		print('ERROR:'+@errorMsg)
		return -1*@@ERROR
	end catch
end
go