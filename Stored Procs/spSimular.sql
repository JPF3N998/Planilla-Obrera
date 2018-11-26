use PlanillaObrera
go

begin try
	set nocount on;
	declare @FechaOperacionXML xml;

	select @FechaOperacionXML= X
	from openrowset(bulk 'C:\Users\josep\Google Drive\TEC 2018\SEMESTRE II\Base de datos I\Planilla Obrera\Archivos prueba\FechaOperacion.xml', single_blob) as FechaOperacion(X)

	declare @hdoc int;

	exec sp_xml_preparedocument @hdoc out, @FechaOperacionXML;

	declare @fechasTemp table(id int identity(1,1),fechaOperacion date);

	insert @fechasTemp(fechaOperacion)
	select convert(date,fecha,103) from openxml(@hdoc,'/dataset/FechaOperacion',1)
	with(
		Fecha varchar(50)
	)
	--select * from @fechasTemp

	declare  @firstDate date;
	declare @lastDate date;

	set @firstDate = (select min(FT.fechaOperacion) from @fechasTemp FT);
	set @lastDate = (select max(FT.fechaOperacion) from @fechasTemp FT);

	exec spAbrirPlanillaMensual @fechaOperacionParam = @firstDate;

	declare @ultimaPlanillaMensual int;
	declare @ultimaPlanillaSemanal int;

	while(@firstDate <= @lastDate)
		begin
			set @ultimaPlanillaMensual = (select max(id) from dbo.PlanillaMensual);
			set @ultimaPlanillaSemanal = (select max(id) from dbo.PlanillaSemanal);
			print('Fecha: '+convert(varchar(50),@firstDate)+' '+convert(varchar(10),format(@firstdate,'dddd'))+ '/Planilla Semanal: '+ convert(varchar(100),@ultimaPlanillaSemanal))
			print('Planilla mensual numero: '+convert(varchar(30),@ultimaPlanillaMensual))
			--Daily block
			exec spAgregarEmpleados @fechaOperacionParam = @firstDate
			exec spVerAsistencia @fechaOperacionParam = @firstDate,@idPlanillaSemanal =@ultimaPlanillaSemanal;
			exec spInsertarBonos @fechaOperacionParam=@firstDate, @idPlanillaSemanal =@ultimaPlanillaSemanal;
			exec spInsertarDeducciones @fechaOperacionParam=@firstDate,@planillaSemanalParam = @ultimaPlanillaSemanal;
			--End of daily block
			if format(@firstDate,'dddd') = 'Friday' --Pago de salario y cambio  de planilla semanal
				begin
					declare @nextMonth date=dateadd(day,7,@firstDate);

					if (datepart(month,@firstDate) < datepart(month,@nextmonth) or datepart(year,@firstDate) < datepart(year,@nextmonth)) --Termina semana y mes
						begin
							print('Ultimo Viernes del mes y dia de pago!'); --Se manda reporte a CCSS
							exec spPagarSalario @fechaOperacionParam=@firstDate,@idPlanillaSemanal = @ultimaPlanillaSemanal,@finMes=1;
							exec spReporteMensual @fechaOperacionParam = @firstDate
							exec spAbrirPlanillaMensual @fechaOperacionParam = @firstDate;
						end
					else
						begin --Termina la semana
							print('Dia de pago!');
							exec spPagarSalario @fechaOperacionParam =@firstDate,@idPlanillaSemanal = @ultimaPlanillaSemanal,@finMes=0;
							exec spAbrirPlanillaSemanal @fechaOperacionParam = @firstDate,@idPlanillaMensual = @ultimaPlanillaMensual;
						end
				end
			
			set	@firstDate = dateadd(day,1,@firstDate)
		end
end try
begin catch
			declare @errorMsg varchar(1000) = (select ERROR_MESSAGE())
			select ERROR_LINE() as errorLine
			print('ERROR:'+@errorMsg)
end catch

-- TODO: Agregar en spFill lo de TipoDeducciones


/*exec spFill;
delete dbo.Cuenta;
delete dbo.Asistencia;
delete dbo.Empleado;
delete dbo.Deduccion;
delete dbo.PlanillaSemanal;
delete dbo.Movimiento;
delete dbo.PlanillaMensual;
delete dbo.EmpleadosXPlanillaSemanal;
DBCC CHECKIDENT ('Empleado', RESEED,0);
DBCC CHECKIDENT ('Cuenta', RESEED,0);
DBCC CHECKIDENT ('Asistencia', RESEED,0);
DBCC CHECKIDENT ('Movimiento', RESEED,0);
DBCC CHECKIDENT ('PlanillaSemanal', RESEED,0);
DBCC CHECKIDENT ('PlanillaMensual', RESEED,0);
DBCC CHECKIDENT ('Deduccion', RESEED,0);
DBCC CHECKIDENT ('EmpleadosXPlanillaSemanal',RESEED,0);
go*/
