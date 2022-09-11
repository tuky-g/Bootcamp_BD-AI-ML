select c.idcoche, m.nombre_modelo, ma.nombre_marca, ge.nombre_grupo, c.dt_compra, 
c.matricula, col.nombre, c.kms_tot, s.empresa_tit, s.num_poliza, a.nombre
from flota.coches c join flota.modelos m on c.idmodelo = m.idmodelo 
join flota.marca ma on m.idmarca = ma.idmarca 
join flota.grupo_empresarial ge on ma.idgrupo_empresarial = ge.idgrupo 
join flota.colores col on c.idcolor = col.idcolor
join flota.seguro s on c.idcoche = s.idcoche 
join flota.aseguradoras a on s.idaseguradora =a.idaseguradora
where c.idactivo ='01';
 
