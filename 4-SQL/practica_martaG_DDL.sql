-------------------
--DDL 
-------------------

create schema flota authorization abrwnkbr;


--Tabla coches
create table flota.coches(
	idCoche varchar(20) not null, -- PK
	Matricula varchar(200) not null,
	idModelo varchar(20) not null, -- FK
	idColor varchar(20) not null, -- FK
	kms_tot varchar(200) not null,
	dt_compra date not null,
	idactivo varchar(10) not null default('01'),
	comentarios varchar(512) null
);


alter table flota.coches 
add constraint idCoche_PK primary key (idCoche);

---Tabla modelo

create table flota.Modelos(
	idModelo varchar(20) not null, -- PK
	nombre_modelo varchar(200) not null,
	idMarca varchar(20) not null ---FK
);

alter table flota.Modelos 
add constraint idModelo_PK primary key (idModelo);


---Tabla MARCA

create table flota.marca(
	idmarca varchar(20) not null, -- PK
	nombre_marca varchar(200) not null,
	idGrupo_empresarial varchar(20) --FK
);

alter table flota.marca 
add constraint idmarca_PK primary key (idmarca);

---Tabla grupo_empresarial

create table flota.grupo_empresarial(
	idgrupo varchar(20) not null, -- PK
	nombre_grupo varchar(200) not null
);

alter table flota.grupo_empresarial
add constraint idgrupo_PK primary key (idgrupo);



---Tabla colores

create table flota.Colores(
	idColor varchar(20) not null, -- PK
	Nombre varchar(200) not null
);

alter table flota.Colores 
add constraint idColor_PK primary key (idColor);

---Tabla aseguradoras

create table flota.aseguradoras(
	idAseguradora varchar(20) not null, -- PK
	Nombre varchar(200) not null
);

alter table flota.aseguradoras
add constraint idAseguradora_PK primary key (idAseguradora);


---Tabla hist_revisiones

create table flota.hist_revisiones(
	idCoche varchar(20) not null, -- PK, FK
	dt_revision date not null, ---PK
	km_revision varchar(200) not null,
	importe_revision varchar(200) not null,
	idcurrency varchar(200) not null---FK
);

alter table flota.hist_revisiones
add constraint idCoche_dtrevi_PK primary key (idCoche,dt_revision);

---Tabla currency

create table flota.currency(
	idcurrency varchar(200) not null, -- PK
	Nombre varchar(200) not null
);

alter table flota.currency
add constraint idcurrency_PK primary key (idcurrency);

create table flota.idactivo(
	idactivo varchar(10) not null, -- PK
	descripcion varchar(20) not null
);

alter table flota.idactivo
add constraint idactivo_PK primary key (idactivo);

---Tabla SEGURO

create table flota.seguro(
	idCoche varchar(20) not null, -- PK, FK
	idaseguradora varchar(20) not null, --PK,FK
	empresa_tit varchar(200) not null,
	num_poliza varchar(200) not null,
	importe varchar(200) not null,
	idcurrency varchar(200) not null---FK
);

alter table flota.seguro
add constraint idCoche_idaseg_PK primary key (idCoche,idaseguradora);

-- FK's
alter table flota.coches
add constraint coches_modelo_FK 
				foreign key (idModelo) 
				references flota.Modelos (idModelo);

			
alter table flota.modelos 
add constraint modelos_marca_FK 
				foreign key (idMarca) 
				references flota.Marca (idMarca);			
			
alter table flota.marca 
add constraint marca_grupo_FK 
				foreign key (idgrupo_empresarial) 
				references flota.grupo_empresarial (idgrupo);	
			
			
alter table flota.coches
add constraint coches_color_FK 
				foreign key (idColor) 
				references flota.colores (idColor);
			
alter table flota.coches
add constraint coches_idactivo_FK 
				foreign key (idactivo) 
				references flota.idactivo (idactivo);
			
alter table flota.hist_revisiones
add constraint histrevi_currency_FK 
				foreign key (idcurrency) 
				references flota.currency (idcurrency);

alter table flota.hist_revisiones
add constraint histrevi_coche_FK 
				foreign key (idcoche) 
				references flota.coches (idcoche);
			
alter table flota.seguro
add constraint seguro_currency_FK 
				foreign key (idcurrency) 
				references flota.currency (idcurrency);
			
alter table flota.seguro
add constraint seguro_idaseg_FK 
				foreign key (idaseguradora) 
				references flota.aseguradoras (idaseguradora);
			
alter table flota.seguro
add constraint seguro_coche_FK 
				foreign key (idcoche) 
				references flota.coches (idcoche);
			
-------------------
-- DML 
-------------------
	
--- Cargar datos de tabla grupo_empresarial

insert into flota.grupo_empresarial (idgrupo, nombre_grupo)
values ('0001', 'VOLKSWAGEN');		
insert into flota.grupo_empresarial (idgrupo, nombre_grupo)
values ('0002', 'TOYOTA');			
insert into flota.grupo_empresarial (idgrupo, nombre_grupo)
values ('0003', 'PSA');			
insert into flota.grupo_empresarial (idgrupo, nombre_grupo)
values ('0004', 'FORD');
insert into flota.grupo_empresarial (idgrupo, nombre_grupo)
values ('0005', 'RENAULT NISSAN');

--- Cargar datos de tabla MARCA

insert into flota.marca (idmarca, nombre_marca, idgrupo_empresarial)
values ('001', 'SEAT', '0001');		
insert into flota.marca (idmarca, nombre_marca, idgrupo_empresarial)
values ('002', 'SKODA', '0001');	
insert into flota.marca (idmarca, nombre_marca, idgrupo_empresarial)
values ('003', 'VOLSKWAGEN', '0001');	
insert into flota.marca (idmarca, nombre_marca, idgrupo_empresarial)
values ('004', 'TOYOTA', '0002');
insert into flota.marca (idmarca, nombre_marca, idgrupo_empresarial)
values ('005', 'LEXUS', '0002');
insert into flota.marca (idmarca, nombre_marca, idgrupo_empresarial)
values ('006', 'CITROEN', '0003');
insert into flota.marca (idmarca, nombre_marca, idgrupo_empresarial)
values ('007', 'PEUGEOUT', '0003');
insert into flota.marca (idmarca, nombre_marca, idgrupo_empresarial)
values ('008', 'OPEL', '0003');
insert into flota.marca (idmarca, nombre_marca, idgrupo_empresarial)
values ('009', 'FORD', '0004');
insert into flota.marca (idmarca, nombre_marca, idgrupo_empresarial)
values ('010', 'RENAULT', '0005');

--- Cargar datos de tabla modelos
			

insert into flota.modelos (idmodelo, nombre_modelo, idmarca)
values ('0001', 'LEON', '001');
insert into flota.modelos (idmodelo, nombre_modelo, idmarca)
values ('0002', 'FABIA', '002');
insert into flota.modelos (idmodelo, nombre_modelo, idmarca)
values ('0003', 'GOLF', '003');
insert into flota.modelos (idmodelo, nombre_modelo, idmarca)
values ('0004', 'YARIS', '004');
insert into flota.modelos (idmodelo, nombre_modelo, idmarca)
values ('0005', 'RX', '005');
insert into flota.modelos (idmodelo, nombre_modelo, idmarca)
values ('0006', 'PICASSO', '006');
insert into flota.modelos (idmodelo, nombre_modelo, idmarca)
values ('0007', '308', '007');
insert into flota.modelos (idmodelo, nombre_modelo, idmarca)
values ('0008', 'CORSA', '008');
insert into flota.modelos (idmodelo, nombre_modelo, idmarca)
values ('0009','MONDEO', '009');
insert into flota.modelos (idmodelo, nombre_modelo, idmarca)
values ('0010', 'CLIO', '010');

--- Cargar datos de tabla COLORES

insert into flota.colores (idcolor, nombre)
values ('0001', 'AMARILLO');
insert into flota.colores (idcolor, nombre)
values ('0002', 'NEGRO');
insert into flota.colores (idcolor, nombre)
values ('0003', 'BLANCO');
insert into flota.colores (idcolor, nombre)
values ('0004', 'AZUL');
insert into flota.colores (idcolor, nombre)
values ('0005', 'VERDE');
insert into flota.colores (idcolor, nombre)
values ('0006', 'ROJO');
insert into flota.colores (idcolor, nombre)
values ('0007', 'PLATEADO');

--- Cargar datos de tabla aseguradoras

insert into flota.aseguradoras (idaseguradora, nombre)
values ('0001', 'MAPFRE');
insert into flota.aseguradoras (idaseguradora, nombre)
values ('0002', 'ALLIANZ');
insert into flota.aseguradoras (idaseguradora, nombre)
values ('0003', 'LINEA DIRECTA');
insert into flota.aseguradoras (idaseguradora, nombre)
values ('0004', 'AXA');
insert into flota.aseguradoras (idaseguradora, nombre)
values ('0005', 'PELAYO');
insert into flota.aseguradoras (idaseguradora, nombre)
values ('0006', 'VERTI');
insert into flota.aseguradoras (idaseguradora, nombre)
values ('0007', 'GENERALLI');

--- Cargar datos de tabla idactivo

insert into flota.idactivo (idactivo, descripcion)
values ('01', 'Activo');
insert into flota.idactivo (idactivo, descripcion)
values ('02', 'Inactivo Permanente');
insert into flota.idactivo (idactivo, descripcion)
values ('03', 'Inactivo temp');


--- Cargar datos de tabla COCHES
insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0001', '0343ABC', '0001', '0001','96244', '2000-01-01', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0002', '6002CDE', '0002', '0002','22365', '2000-01-27', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0003', '1545FGH', '0003', '0003','73689', '2000-03-29', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0004', '0240IJK', '0004', '0004','2853', '2002-05-06', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0005', '1781LMN', '0005', '0005','44659', '2003-03-01', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0006', '1052OPQ', '0006', '0006','45923', '2004-07-09', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0007', '0423RST', '0007', '0007','97402', '2005-03-20', '02', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0008', '6221UVW', '0008', '0001','78371', '2016-08-04', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0009', '5667XYZ', '0009', '0002','29254', '2007-06-24', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0010', '6784ABC', '0010', '0003','89979', '2008-04-19', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0011', '8487DEF', '0001', '0004','73575', '2009-12-10', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0012', '2029GHI', '0002', '0005','55634', '2000-01-01', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0013', '2659ABC', '0003', '0006','80606', '2000-01-27', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0014', '1031LKM', '0004', '0007','71267', '2000-03-29', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0015', '5745RRF', '0005', '0001','55068', '2002-05-06', '03', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0016', '6497MNB', '0006', '0002','45065', '2003-03-01', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0017', '9326CDE', '0007', '0003','32969', '2004-07-09', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0018', '5694FGH', '0008', '0004','19143', '2005-03-20', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0019', '8129IJK', '0009', '0005','69154', '2016-08-04', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0020', '1309LMN', '0010', '0006','62180', '2007-06-24', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0021', '2270OPQ', '0001', '0007','30363', '2008-04-19', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0022', '0435PQL', '0002', '0001','46253', '2009-12-10', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0023', '8276PPE', '0003', '0002','62887', '2000-01-01', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0024', '9301OPI', '0004', '0003','32036', '2000-01-27', '01', 'Actulizado sept 22');insert into flota.coches (idcoche,matricula,idmodelo,idcolor,kms_tot,dt_compra,idactivo,comentarios)
values ( '0025', '6081KKM', '0005', '0004','7470', '2000-03-29', '01', 'Actulizado sept 22');

--- Cargar datos de tabla currency


insert into flota.currency  (idcurrency, nombre)
values ('EUR', 'Euro');
insert into flota.currency  (idcurrency, nombre)
values ('USD', 'Dolar');
insert into flota.currency  (idcurrency, nombre)
values ('GBP', 'Libra esterlina');
insert into flota.currency  (idcurrency, nombre)
values ('CHF', 'Franco suizo');
insert into flota.currency  (idcurrency, nombre)
values ('JPY', 'Yen japones');

--- CREAR TABLA DE HIST REVISIONES


insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0001', '2000-10-27', '86244','140', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0002', '2000-10-28', '12365','153', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0003', '2000-10-29', '63689','299', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0004', '2000-10-30', '1000','251', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0005', '2000-10-31', '34659','137', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0006', '2000-10-30', '35923','117', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0007', '2000-10-25', '87402','386', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0008', '2000-10-05', '68371','200', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0009', '2000-10-15', '19254','362', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0010', '2000-10-12', '79979','178', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0011', '2000-10-14', '63575','184', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0012', '2000-10-06', '45634','373', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0013', '2000-10-09', '70606','340', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0014', '2000-10-07', '61267','247', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0015', '2000-10-22', '45068','206', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0016', '2000-10-23', '35065','272', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0017', '2000-10-24', '22969','203', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0018', '2000-10-25', '9143','114', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0019', '2000-10-26', '59154','387', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0020', '2000-10-27', '52180','206', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0021', '2000-10-28', '20363','322', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0022', '2000-10-29', '36253','113', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0023', '2000-10-11', '52887','244', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0024', '2000-10-18', '22036','67', 'GBP');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0025', '2000-10-16', '2500','372', 'GBP');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0001', '2000-10-14', '66244','230', 'GBP');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0003', '2000-10-17', '43689','207', 'GBP');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0005', '2012-10-30', '14659','114', 'GBP');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0006', '2014-10-10', '15923','384', 'GBP');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0007', '2015-05-09', '67402','227', 'GBP');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0008', '2008-05-03', '48371','144', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0010', '2007-06-08', '59979','105', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0011', '2008-10-01', '43575','98', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0012', '2000-10-02', '25634','268', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0013', '2005-12-09', '50606','377', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0014', '2004-02-12', '41267','114', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0015', '2000-10-13', '25068','143', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0016', '2000-10-24', '15065','297', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0017', '2000-10-15', '2969','318', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ('0019', '2000-10-16', '39154','150', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ('0020', '2005-10-27', '32180','133', 'EUR');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0021', '2009-10-18', '363','124', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0022', '2010-10-29', '16253','207', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0023', '2007-10-15', '32887','352', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0024', '2020-10-07', '2036','183', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0003', '2002-10-12', '16244','109', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0008', '2001-10-03', '17402','88', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0011', '2000-10-17', '9979','94', 'USD');insert into flota.hist_revisiones (idcoche,dt_revision,km_revision,importe_revision,idcurrency)
 values ( '0014', '2005-10-05', '606','162', 'USD');
 

----Tabla de seguro

insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0001', '0001', 'KEEP CODING ','391820300', '396', 'EUR');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0002', '0002', 'KEEP CODING ','286233665', '510', 'EUR');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0003', '0003', 'KEEP CODING ','685685335', '313', 'EUR');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0004', '0004', 'KEEP CODING ','253659852', '386', 'EUR');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0005', '0005', 'KEEP CODING ','187353698', '716', 'EUR');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0006', '0006', 'KEEP CODING ','608784943', '499', 'EUR');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0007', '0007', 'KEEP CODING ','966405995', '367', 'EUR');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0008', '0001', 'KEEP CODING ','791197264', '262', 'EUR');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0009', '0002', 'KEEP CODING ','120408740', '631', 'USD');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0010', '0003', 'KEEP CODING ','233959287', '762', 'USD');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0011', '0004', 'KEEP CODING ','770259497', '267', 'USD');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0012', '0005', 'KEEP CODING ','749989349', '371', 'USD');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0013', '0006', 'KEEP CODING ','994501314', '683', 'USD');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0014', '0007', 'KEEP CODING ','640323868', '501', 'USD');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0015', '0001', 'KEEP CODING ','218296019', '772', 'USD');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0016', '0002', 'KEEP CODING ','176461451', '325', 'USD');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0017', '0003', 'KEEP CODING ','604412642', '631', 'USD');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0018', '0004', 'KEEP CODING ','027169993', '776', 'USD');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0019', '0005', 'KEEP CODING ','651188763', '278', 'USD');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0020', '0006', 'KEEP CODING ','405794206', '340', 'USD');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0021', '0007', 'KEEP CODING ','187150433', '332', 'USD');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0022', '0001', 'KEEP CODING ','752136690', '289', 'USD');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0023', '0002', 'KEEP CODING ','145090752', '242', 'USD');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0024', '0003', 'KEEP CODING ','447793682', '673', 'GBP');insert into flota.seguro (idcoche,idaseguradora,empresa_tit,num_poliza,importe,idcurrency)
values ( '0025', '0004', 'KEEP CODING ','612092348', '306', 'GBP');


