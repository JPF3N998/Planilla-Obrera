use PlanillaObrera
go

drop proc if exists spInsertarBonos
go

create proc spInsertarBonos @fechaOperacionParam date,@idPlanillaSemanal int as
begin
	begin try
		set nocount on;
			declare @hdoc int;
				
			declare @FechaOperacionXML xml;
			select @FechaOperacionXML = F
			from openrowset(bulk 'C:\Users\josep\Google Drive\TEC 2018\SEMESTRE II\Base de datos I\Planilla Obrera\Archivos prueba\FechaOperacion.xml' ,single_blob) as FechaOperacion(F)

			exec sp_xml_preparedocument @hdoc out,@FechaOperacionXML;
				
				declare @tempBonos table(id int identity(1,1),DocId varchar(50), idTipoMovimiento int, idPlanillaSemanal int, monto money,fecha date);

				insert into @tempBonos(DocId,idTipoMovimiento,idPlanillaSemanal,monto,fecha)
				select X.DocId,4 as idTipoMovimiento, @idPlanillaSemanal, X.Monto,@fechaOperacionParam from openxml(@hdoc,'/dataset/FechaOperacion/Bono',1)
				with(
					DocId varchar(50),
					Monto money,
					Fecha varchar(30) '../@Fecha'
				) X where @fechaOperacionParam=convert(date,X.Fecha,103)
			exec sp_xml_removedocument @hdoc out
			--select * from @tempBonos

			set transaction isolation level read uncommitted
			begin transaction
				insert into dbo.Movimiento(idTipoMovimiento,idPlanillaSemanal,DocId,monto,fecha)
				select TB.idTipoMovimiento,@idPlanillaSemanal,TB.DocId,TB.monto,@fechaOperacionParam from @tempBonos TB
			commit
	end try
	begin catch
		declare @errorMsg varchar(100) = (select ERROR_MESSAGE())
		print('ERROR:'+@errorMsg)
		return -1*@@ERROR
	end catch
end
go