use PlanillaObrera
go

drop proc if exists spPagarSalario
go

create proc spPagarSalario @fechaOperacionParam date,@idPlanillaSemanal int,@finMes bit
as
	begin
		begin try
			set nocount on;
			
			declare @beginDate date =(select PS.fechaInicio from dbo.PlanillaSemanal PS where @idPlanillaSemanal = PS.id);
			declare @endDate date  =(select PS.fechaFin from dbo.PlanillaSemanal PS where @idPlanillaSemanal=PS.id);
			
			declare @hdoc int;
				
			declare @FechaOperacionXML xml;
			select @FechaOperacionXML = F
			from openrowset(bulk 'C:\Users\josep\Google Drive\TEC 2018\SEMESTRE II\Base de datos I\Planilla Obrera\Archivos prueba\FechaOperacion.xml' ,single_blob) as FechaOperacion(F)
			
			exec sp_xml_preparedocument @hdoc out,@FechaOperacionXML;

			
			declare @tempSalario table(id int identity(1,1),DocId varchar(50),horasTrabajadas int,monto money);

			insert into @tempSalario(DocId,horasTrabajadas,monto)
			select A.DocId,sum(A.horasTrabajadas),sum(A.horasTrabajadas*SH.valorHora)
			from Asistencia A join ((Empleado E join Puesto P on E.idPuesto=P.id) join SalarioxHora SH on SH.idPuesto= E.idPuesto) on A.DocId = E.DocId
			where A.fecha <= @endDate and A.fecha >= @beginDate
			group by A.DocId

			--select * from @tempSalario
		
			declare @tempIncapacitado table(id int identity(1,1),DocId varchar(50),idPuesto int,fecha date,idTipoJornada int,idSalarioXHora money,monto money);

			insert into @tempIncapacitado(DocId,idPuesto,fecha,idTipoJornada,idSalarioXHora,monto)
			select A.DocId,E.idPuesto,A.fecha,A.idTipoJornada,SH.valorHora,SH.valorHora*0.6 as monto
			from Asistencia A join ((Empleado E join Puesto P on E.idPuesto=P.id) join SalarioxHora SH on SH.idPuesto= E.idPuesto) on A.DocId=E.DocId
			where A.fecha <= @endDate and A.fecha >= @beginDate and A.incapacitado=1

			--select * from @tempIncapacitado 
		
			declare @tempExtra table(id int identity(1,1),DocId varchar(50),idPuesto int,horasExtra int,fecha date,nombre varchar(30),idTipoJornada int,idSalarioXHora money,monto money); --HorasExtra

			insert into @tempExtra(DocId,idPuesto,horasExtra,fecha,nombre,idTipoJornada,idSalarioXHora,monto) --Horas extra
			select A.DocId,E.idPuesto,A.horasExtra,A.fecha,format(A.fecha,'dddd'),A.idTipoJornada,SH.valorHora,(A.horasExtra*SH.valorHora) from Asistencia A join ((Empleado E join Puesto P on E.idPuesto=P.id) join SalarioxHora SH on SH.idPuesto= E.idPuesto) on A.DocId = E.DocId
			where A.fecha <= @endDate and A.fecha >= @beginDate and horasExtra != 0 and (format(A.fecha,'dddd') != 'Sunday' and not exists(select F.fecha from Feriado F where A.fecha = F.fecha))

			--select * from @tempExtra
			
			declare @tempEmpleadosDeLaSemana table(DocId varchar(30));
			insert into @tempEmpleadosDeLaSemana(DocId)
			select EX.DocId from EmpleadosXPlanillaSemanal EX  where EX.idPlanillaSemanal = @idPlanillaSemanal group by EX.DocId

			--select * from @tempEmpleadosDeLaSemana

			declare @tempEspecial table(id int identity(1,1),DocId varchar(50),idPuesto int,horasTrabajadas int,horasExtra int,fecha date,nombre varchar(30),idTipoJornada int,idSalarioXHora money,monto money);

			insert into @tempEspecial(DocId,idPuesto,horasTrabajadas,horasExtra,fecha,nombre,idTipoJornada,idSalarioXHora,monto) -- Domingos y feriados
			select TES.DocId,A.idTipoJornada,A.horasTrabajadas,A.horasExtra,A.fecha,format(A.fecha,'dddd'),A.idTipoJornada,SH.valorHora,(A.horasTrabajadas + A.horasExtra)*(SH.valorHora*2)
			from Asistencia A
				join @tempEmpleadosDeLaSemana TES on A.DocId = TES.DocId
				join TipoJornadas TJ on A.idTipoJornada = TJ.id
				join SalarioxHora SH on SH.idTipoJornada = TJ.id
			where A.idPlanillaSemanal= @idPlanillaSemanal and (format(A.fecha,'dddd')='Sunday' or exists(select F.fecha from Feriado F where A.fecha = F.fecha))
		
			--select * from @tempEspecial
			
			declare @tempBono table(id int identity(1,1),DocId varchar(30),monto money);
			
			insert into @tempBono(DocId,monto)
			select M.DocId,M.monto from Movimiento M
			where idTipoMovimiento= 4 and M.idPlanillaSemanal=@idPlanillaSemanal

			--select * from @tempBono

			declare @tempBruto table(id int identity(1,1),DocId varchar(30),salarioBruto money);
			
			--Tabla con los salarios brutos
			insert into @tempBruto(DocId,salarioBruto)
			select TES.DocId,
			isnull(sum(TS.monto),0)+isnull(sum(TI.monto),0)+isnull(sum(TE.monto),0)+isnull(sum(THE.monto),0)+isnull(sum(TB.monto),0)
			from @tempEmpleadosDeLaSemana TES
				join @tempSalario TS on TES.DocId=TS.DocId
				left join @tempIncapacitado TI on TES.DocId = TI.DocId
				left join @tempExtra TE on TES.DocId = TE.DocId
				left join @tempEspecial THE on TES.DocId = THE.DocId
				left join @tempBono TB on TES.DocId=TB.DocId
			group by TES.DocId

			--select * from @tempBruto
			
		------------------------------------------------------- FIN CALCULO DE SALARIO BRUTO ---------------------------------------------------------------------

			declare @tempDeduccionesFijas table(id int identity(1,1),DocId varchar(30),idDeduccion int,idTipoDeduccion int,monto money);
			
			insert into @tempDeduccionesFijas(DocId,idDeduccion,idTipoDeduccion,monto)
			select D.DocId,D.id,D.idTipoDeduccion,D.monto
			from Deduccion D join @tempBruto TB on D.DocId = TB.DocId
			where D.idTipoDeduccion in (3,4) and D.idPlanillaSemanal=@idPlanillaSemanal

			declare @tempDeduccionesPorcentual table(id int identity(1,1),DocId varchar(30),idDeduccion int,idTipoDeduccion int,monto money,montoFinal int);

			insert into @tempDeduccionesPorcentual(DocId,idDeduccion,idTipoDeduccion,monto,montoFinal)
			select D.DocId,D.id,D.idTipoDeduccion,D.monto,(TB.salarioBruto*D.monto)
			from Deduccion D join @tempBruto TB on D.DocId=TB.DocId
			where D.idTipoDeduccion in (1,2) and D.idPlanillaSemanal=@idPlanillaSemanal

			--select *,@fechaOperacionParam as fecha from @tempDeduccionesFijas
			--select isnull(sum(TDP.montoFinal),0),@fechaOperacionParam as fecha from @tempDeduccionesPorcentual TDP
		
			declare @tempSalarioNeto table(DocId varchar(30),salarioBruto money,monto money,salarioNeto money)
			insert into @tempSalarioNeto(DocId,salarioBruto,monto,salarioNeto)
			select TB.DocId,sum(TB.salarioBruto),(sum(TDP.montoFinal)+sum(TDJ.monto)),sum(TB.salarioBruto) - (sum(TDP.montoFinal)+sum(TDJ.monto)) as salarioNeto
			from @tempBruto TB
				join @tempDeduccionesPorcentual TDP on TB.DocId=TB.DocId
				join @tempDeduccionesFijas TDJ on TB.DocId=TDJ.DocId
			group by TB.DocId

			--select * from @tempSalarioNeto
		------------------------------------------------------- FIN CALCULO DE DEDUCCIONES ---------------------------------------------------------------------
			
			exec sp_xml_removedocument @hdoc;
			set transaction isolation level read uncommitted
			begin transaction
				
				insert into Movimiento(idTipoMovimiento,idPlanillaSemanal,DocId,monto,fecha)
				select 1 as idTipoMovimiento,@idPlanillaSemanal as idPlanillaSemanal,TSN.DocId,TSN.salarioNeto,@fechaOperacionParam
				from @tempSalarioNeto TSN

				update dbo.EmpleadosXPlanillaSemanal
					set devengadosTotales = isnull((select TB.salarioBruto from @tempBruto TB where EmpleadosXPlanillaSemanal.DocId = TB.DocId),0) where @idPlanillaSemanal = EmpleadosXPlanillaSemanal.idPlanillaSemanal
				update dbo.EmpleadosXPlanillaSemanal
					set deduccionesTotales = deduccionesTotales + isnull((select isnull(sum(TDF.monto),0) from @tempDeduccionesFijas TDF where EmpleadosXPlanillaSemanal.DocId=TDF.DocId),0) where @idPlanillaSemanal = EmpleadosXPlanillaSemanal.idPlanillaSemanal
				update dbo.EmpleadosXPlanillaSemanal
					set deduccionesTotales = deduccionesTotales + isnull((select isnull(sum(TDP.montoFinal),0) from @tempDeduccionesPorcentual TDP where EmpleadosXPlanillaSemanal.DocId=TDP.DocId),0) where @idPlanillaSemanal = EmpleadosXPlanillaSemanal.idPlanillaSemanal
				
				update dbo.Deduccion 
					set montoFinal = TDP.montoFinal from @tempDeduccionesPorcentual TDP join Deduccion D on D.id=TDP.idDeduccion
				update dbo.PlanillaSemanal
					set fechaFin = @fechaOperacionParam where PlanillaSemanal.id=@idPlanillaSemanal
				update dbo.PlanillaSemanal
					set totalDeducciones = totalDeducciones +(select isnull(sum(TDF.monto),0) from @tempDeduccionesFijas TDF) where id = @idPlanillaSemanal
				update dbo.PlanillaSemanal
					set totalDevengados = (select isnull(sum(TB.salarioBruto),0) from @tempBruto TB) where id= @idPlanillaSemanal
				update dbo.Cuenta
					set saldo = saldo + TSN.salarioNeto from @tempSalarioNeto TSN where TSN.DocId=Cuenta.DocId
				update dbo.PlanillaSemanal
					set totalDeducciones = totalDeducciones +(select isnull(sum(TDP.montoFinal),0) from @tempDeduccionesPorcentual TDP) where id= @idPlanillaSemanal
				
				if @finMes = 1
					begin
						update dbo.PlanillaMensual 
							set deducciones = (select sum(PS.totalDeducciones) from dbo.PlanillaSemanal PS where PS.idPlanillaMensual=(select max(id) from PlanillaMensual)) where id=(select max(id) from PlanillaMensual)
						update dbo.PlanillaMensual
							set devengados = (select sum(PS.totalDevengados) from dbo.PlanillaSemanal PS where PS.idPlanillaMensual=(select max(id) from PlanillaMensual)) where id=(select max(id) from PlanillaMensual)
						update dbo.PlanillaMensual
							set fechaFin = @fechaOperacionParam where (select max(id) from PlanillaMensual) = id
					end
				
			commit
			print('Planilla semanal '+ convert(varchar(20),@idPlanillaSemanal) + ' va del ' + convert(varchar(30),@beginDate) +' a '+convert(varchar(10),@fechaOperacionParam))
			return 1
		end try
		begin catch
			declare @errorMsg varchar(1000) = (select ERROR_MESSAGE())
			print(@errorMsg)
			return -1*@@ERROR
		end catch
	end 
go

/*HELP
select A.DocId,A.idPlanillaSemanal,sum(A.horasTrabajadas) as totalHoras
from Asistencia A join EmpleadosXPlanillaSemanal EX on A.DocId=EX.DocId
where A.idPlanillaSemanal = EX.idPlanillaSemanal 
group by A.DocId,A.idPlanillaSemanal
order by idPlanillaSemanal
*/