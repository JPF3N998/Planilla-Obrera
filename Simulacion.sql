SET LANGUAGE SPANISH
--BEGIN

	DECLARE @OperacionesXML xml
	DECLARE @hdoc INT

	SELECT @OperacionesXML = O
	FROM OPENROWSET (BULK 'C:\XML\FechaOperacion.xml',SINGLE_BLOB) AS FechaOperacion(O)

	EXEC sp_xml_preparedocument @hdoc OUTPUT,@OperacionesXML 

	--Tabla temporal con las fechas de operacion
	DECLARE @tempFechaOperaciones TABLE(sec INT IDENTITY(1,1), FechaOperacion DATE)

	INSERT INTO @tempFechaOperaciones(FechaOperacion)
	SELECT Fecha FROM OPENXML(@hdoc,'/dataset/FechaOperacion',1)
	WITH(	
			Fecha DATE
		)
	SET NOCOUNT ON;

	--Tabla temporal con los empleados
	DECLARE @tempEmpleado TABLE(sec int identity(1,1), nombre varchar(50), DocId varchar(50), idPuesto int, FechaOperacion DATE)

	INSERT INTO @tempEmpleado(nombre, DocId, idPuesto, FechaOperacion)
	SELECT nombre, DocId, idPuesto, Fecha FROM OPENXML(@hdoc,'/dataset/FechaOperacion/NuevoEmpleado',1)
	WITH(
			nombre varchar(50),
			DocId varchar(50),
			idPuesto int,
			Fecha DATE '../@Fecha'
		)
	SET NOCOUNT ON;

	-- Tabla temporal para las asistencias
	DECLARE @tempAsistencias TABLE(sec INT IDENTITY(1,1), DocId varchar(50), idTipoJornada int, HoraEntrada time(0), HoraSalida time(0), fechaCreacion DATE)

	INSERT INTO @tempAsistencias(DocId, idTipoJornada, HoraEntrada, HoraSalida, fechaCreacion)
	SELECT DocId, idTipoJornada, HoraEntrada, HoraSalida, Fecha AS fechaCreacion FROM OPENXML(@hdoc,'/dataset/FechaOperacion/Asistencia',1)
	WITH(
			DocId varchar(50),
			idTipoJornada int,
			HoraEntrada time(0),
			HoraSalida time(0),
			Fecha DATE '../@Fecha'
		)
	SET NOCOUNT ON;

	-- Tabla temporal para las nuevas deducciones
	DECLARE @tempDeducciones TABLE(sec INT IDENTITY(1,1), DocId varchar(50), idTipoDeduccion int, Valor float, fechaCreacion DATE)

	INSERT INTO @tempDeducciones(DocId, idTipoDeduccion, Valor, fechaCreacion)
	SELECT DocId, idTipoDeduccion, Valor, Fecha AS fechaCreacion FROM OPENXML(@hdoc,'/dataset/FechaOperacion/NuevaDeduccion',1)
	WITH(
			DocId varchar(50),
			idTipoDeduccion int,
			Valor float,
			Fecha DATE '../@Fecha'
		)
	SET NOCOUNT ON;

	-- Tabla temporal para los bonos
	DECLARE @tempBono TABLE(sec INT IDENTITY(1,1), DocId varchar(50), Monto money, fechaCreacion DATE)

	INSERT INTO @tempBono(DocId, Monto, fechaCreacion)
	SELECT DocId, Monto, Fecha AS fechaCreacion FROM OPENXML(@hdoc,'/dataset/FechaOperacion/Bono',1)
	WITH(
			DocId varchar(50),
			Monto money,
			Fecha DATE '../@Fecha'
		)
	SET NOCOUNT ON;

	-- Tabla temporal para las incapacidades
	DECLARE @tempIncapacidad TABLE(sec INT IDENTITY(1,1), DocId varchar(50), idTipoJornada int, fechaCreacion DATE)

	INSERT INTO @tempIncapacidad(DocId, idTipoJornada, fechaCreacion)
	SELECT DocId, idTipoJornada, Fecha AS fechaCreacion FROM OPENXML(@hdoc,'/dataset/FechaOperacion/Incapacidad',1)
	WITH(
			DocId varchar(50),
			idTipoJornada int,
			Fecha DATE '../@Fecha'
		)
	SET NOCOUNT ON;

	EXEC sp_xml_removedocument @hdoc

	SELECT* FROM @tempFechaOperaciones
	SELECT* FROM @tempEmpleado
	SELECT* FROM @tempAsistencias
	SELECT* FROM @tempDeducciones
	SELECT* FROM @tempBono
	SELECT* FROM @tempIncapacidad

	DECLARE @contador INT;
	SET @contador = 0;
	
	DECLARE @currentDate DATE;
	DECLARE @lastDate DATE;

	SELECT @currentDate = MIN(FechaOperacion) FROM @tempFechaOperaciones;
	SELECT @lastDate =MAX(FechaOperacion) FROM @tempFechaOperaciones;

	--EMPIEZA EL BUCLE WHILE
	WHILE @currentDate <= @lastDate
		BEGIN
			SET NOCOUNT ON;
			SET @contador = @contador+1;

			SET @currentDate = DATEADD(DAY,1,@currentDate);
		END
