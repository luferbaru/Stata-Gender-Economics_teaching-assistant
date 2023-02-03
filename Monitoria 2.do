*****************************************************************************
*******************************MONITORIA 2***********************************
*****************************************************************************

cd"C:\Users\Luisa Ballen\Downloads\Monitoria G&E\MONITORIAS\SESIONES\Monitoria 2"

use "C:\Users\Luisa Ballen\Downloads\Monitoria G&E\MONITORIAS\STATA\ENUT_2016_2017.dta", clear

*****************************************************************************


*********************Estado civil*******************
/*D.7. <...> actualmente:
1 No está casado(a) y vive en pareja hace menos de dos años
2 No esta casado(a) y vive en pareja hace dos años o más
3 Esta casado(a)
4 Está viudo(a)
5 Está separado(a) o divorciado(a)
6 Está soltero(a)*/
tab p1173

gen estado_civil=.
#delimit ;
replace estado_civil=1 if p1173==1|p1173==2;
replace estado_civil=2 if p1173==3;
replace estado_civil=3 if p1173==5;
replace estado_civil=4 if p1173==6;

label define estado_civillbl 1"Unión libre"2"Casado"3"Separado o divorciado"4"Soltero"
label values estado_civil estado_civillbl
tab estado_civil

**********************Sexo***************
tab p6020
/*¿Cuál es el sexo de...? 1 Hombre 2 Mujer*/

gen mujer=.
replace mujer=1 if p6020==2
replace mujer=0 if p6020==1
tab mujer

label define mujerlbl 0"Hombre"1"Mujer"
label values mujer mujerlbl
tab mujer

*Edad*
tab p6040
gen edad= p6040
br p6040 edad

*Nivel educativo*
tab p6210
/*G. 10. ¿Cuál es el nivel educativo más alto
alcanzado por <...> y el último grado o año
aprobado en ese nivel? Niveles Grado o año que
cursa 1 Ninguno 2 Preescolar 3 Primaria 4
Secundaria o media 5 Técnico sin título 6 Técnico
con título 7 Tecnológico sin título 8 Tecnológico con
título 9 Universitario sin título 10 Universitario con
título 11 Posgrado sin título 12 Posgrado con título
*/

gen nivel_educativo=.
#delimit ;
replace nivel_educativo=1 if p6210==1;
replace nivel_educativo=2 if p6210==2|p6210==3;
replace nivel_educativo=3 if p6210==4;
replace nivel_educativo=4 if p6210==5|p6210==6|p6210==7|p6210==8;
replace nivel_educativo=5 if p6210==9|p6210==10;
replace nivel_educativo=6 if p6210==11|p6210==12;

label define nivel_educativolbl 1"Ninguno"2"Primaria"3"Bachiller"4"Técnico y Tecnológico"5"Universitario"6"Postgrado"
label values nivel_educativo nivel_educativolbl		
tab nivel_educativo

gen bachiller_mujer=.
replace bachiller_mujer=1 if mujer==1 & p6210==4
replace bachiller_mujer=0 if mujer==0 & p6210==4
tab bachiller_mujer

*******************PET********************
/*Este segmento está constituido por las personas de 12 años y más en las zonas urbanas y 10 años y más en las zonas
rurales. Se divide en población económicamente activa y población económicamente inactiva.*/

gen pet = (edad>=10)
tab pet

tab p1152 
/****¿En qué actividad ocupó
<...> La mayor parte del
tiempo la semana pasada?
1 Trabajando.
2 Buscando trabajo.
3 Estudiando.
4 Oficios del hogar.
5 Incapacitado permanente para trabajar.
6 Otra actividad ¿Cuál?_______
***/
gen pet2=(p1152==1|p1152==2|p1152==3|p1152==4|p1152==5|p1152==6)
tab pet2

***********PEA********************************
*Ocupados*
tab p1152
/*¿En qué actividad ocupó <...> La mayor
parte del tiempo la semana pasada? 1
Trabajando. 2 Buscando trabajo. 3 Estudiando.
4 Oficios del hogar. 5 Incapacitado
permanente para trabajar. 6 Otra actividad
¿Cuál?_______
*/

gen e=pet
replace e=1 if p1152==1
replace e=0 if p1152==2|p1152==3|p1152==4|p1152==5|p1152==6
replace e=1 if p5953==1 /*Además de lo anterior, ¿<...> realizó la SEMANA PASADA alguna actividad paga por una hora o más?*/
replace e=1 if p6260==1 /*Aunque <...> no trabajó la semana pasada POR UNA HORA O MÁS en forma remunerada, ¿tenía durante esa semana algún trabajo o negocio por el que recibe ingresos?*/
replace e=1 if p8340==1 /*¿<...> trabajó la semana pasada en un negocio por UNA HORA O MÁS, sin que le pagaran?*/
replace e=. if pet2==0
label variable e "empleados==1"
tab e
br e
*Desempleados*
tab p1152 p6300

tab p6300 
/*¿Desea <...> conseguir un
trabajo remunerado o
instalar un negocio?*/

gen u =0
replace u=1 if p1152==2
replace u = . if pet==0
label variable u "desempleados==1"
tab u e
*Total*
gen pea=0
replace pea=1 if e==1|u==1
replace pea =. if pet==0
label var pea "poblacion_economicamente_activa==1"	
tab pea 
tab pet

*Tasa global de participación laboral*
/*Tasa global de participación (TGP): es la relación porcentual entre la población económicamente activa (PEA) y 
la población en edad de trabajar (PET). Este indicador refleja la presión de la población en edad de trabajar sobre el mercado laboral.*/


gen TGP_productivo=.
replace TGP_productivo=1 if pea==1 & pet==1
replace TGP_productivo=0 if pea==1 & pet==0
replace TGP_productivo=0 if pea==0 & pet==0
replace TGP_productivo=0 if pea==0 & pet==1
tab pet
tab TGP_productivo
br TGP_productivo pea pet
tab TGP_productivo mujer

*Trabaja*
tab p1150
/*H.20. ¿<...> trabajó el día [...]? 1 Sí 2 No.*/
tab p6535
/*H. 36. ¿… trabajó el día [...] en este
segundo empleo o trabajo? 1. Sí 2. No*/

gen trabaja=1 if p1150==1 & p6535==.
replace trabaja=1 if p1150==1 & p6535==1
replace trabaja=1 if p1150==1 & p6535==2
replace trabaja=0 if p1150==2 & p6535==.
replace trabaja=0 if p1150==2 & p6535==2

label define trabajalbl 1"trabajo" 0"No trabajo"
label values trabaja trabajalbl
tab trabaja
tabstat trabaja, by(mujer)stat(sum)

gen casado_trabaja_mujer=.
replace casado_trabaja_mujer=1 if p1173==3 & mujer==1 & trabaja==1
replace casado_trabaja_mujer=0 if p1173==3 & mujer==0 & trabaja==1
tab casado_trabaja_mujer

gen union_libre_trabaja_mujer=.
replace union_libre_trabaja_mujer=1 if p1173==1 & mujer==1 & trabaja==1
replace union_libre_trabaja_mujer=0 if p1173==1 & mujer==0 & trabaja==1
replace union_libre_trabaja_mujer=1 if p1173==2 & mujer==1 & trabaja==1
replace union_libre_trabaja_mujer=0 if p1173==2 & mujer==0 & trabaja==1
tab union_libre_trabaja_mujer

gen soltero_trabaja_mujer=.
replace soltero_trabaja_mujer=1 if p1173==6 & mujer==1 & trabaja==1
replace soltero_trabaja_mujer=0 if p1173==6 & mujer==0 & trabaja==1
tab soltero_trabaja_mujer

gen casado_mujer=.
replace casado_mujer=1 if mujer==1 & p1173==3
replace casado_mujer=0 if mujer==0 & p1173==3

************Salario mensual********************
sum p6500
tabstat p6500, by(p427)
/*Antes de descuentos, ¿cuánto
ganó ... el mes pasado en este
empleo?*/

sum p6533
tabstat p6533, by(p427)
/*H.38. ¿Cuánto recibió o ganó… el MES
PASADO en ese segundo trabajo o negocio?
Valor mensual: $_______*/

tab p427
/*H. 23. En este trabajo <...> es: (Lea las
alternativas) 1 Obrero o empleado de
empresa particular 2 Obrero o empleado
del gobierno 3 Empleado doméstico 4
Jornalero o Peón 5 Trabajador por cuenta
propia (Pase a 30) 6 Patrón o empleador
(Pase a 30) 7 Trabajador de su propia finca
o de finca en arriendo o aparcería. (Pase a
30) 8 Trabajador familiar sin remuneración
(Pase a 34) 9 Trabajador sin remuneración
en empresas o negocios de otros hogares.
(Pase a 34)*/

sum p6541
/*H.30. ¿Cuál fue la ganancia neta o los
honorarios netos de <....> en esa actividad,
negocio, profesión o finca, el MES PASADO?
Ganancia neta u honorarios netos:
$___________*/

tab p6540
/*H.31. ¿A cuántos meses de trabajo
corresponde esta ganancia? Número de
meses___*/


egen salario1=rowtotal(p6500 p6533) if p427==1|p427==2|p427==3|p427==4
br salario1 p6500 p6533
recode salario1(0=.)

gen ganancia_neta=p6541/p6540
br p6541 p6540 ganancia_neta

egen salario2=rowtotal(ganancia_neta p6533) if p427==5|p427==6|p427==7 & p6540!=. & p6540<=12
recode salario2(0=.)

egen salario=rowtotal(salario1 salario2)
recode salario(0=.)
br salario salario1 salario2

gen log_salario=ln(salario)
***************************Tiempo en actividades comprendidas por scn******************

*Tiempo dedicado al trabajo productivo*
/*Normalmente, ¿cuántas horas a la
semana trabaja... en este empleo o trabajo?
Horas*/

tab p1151
gen tiempo_productivo=p1151

*************Tiempo y participacion en actividades no comprendidas en scn******
*Participación en trabajo doméstico y tiempo*
*********************************************

*a.El suministro de alimentos a miembros del hogar*
gen p_alimentos=p1143s1
gen t_alimentos=p1143s1a1+(p1143s1a2/60)
tabstat t_alimentos,by(mujer) stat(mean)
/*Preparar y servir alimentos
para las personas de este
hogar*/

gen p_lavar_platos=p1143s2
gen t_lavar_platos=p1143s2a1+(p1143s2a2/60)
tabstat p_lavar_platos,by(mujer) stat(sum)
/*Levantar los platos, lavar la
loza en este hogar.*/

gen p_transportar_comida=p1143s4
gen t_transportar_comida=p1143s4a1+(p1143s4a2/60)
tabstat p_transportar,by(mujer) stat(sum)
/* Llevarle la comida a
personas de este hogar a su
sitio de trabajo, estudio u
otro lugar fuera de esta
vivienda.*/

****b.Mantenimiento de vestuario****
gen p_ropa=p1142s1
gen t_ropa=p1142s1a1+(p1142s1a2/60)
tabstat p_ropa,by(mujer) stat(sum)
/*Lavar, planchar o guardar
ropa para las personas de
este hogar.*/

gen p_reparar=p1142s2
gen t_reparar=p1142s2a1+(p1142s2a2/60)
tabstat p_reparar,by(mujer) stat(sum)

/*Reparar ropa, manteles,
cobijas, calzado, maletas,
etc., para las personas de
este hogar.*/

gen p_lavar=p1142s4
gen t_lavar=p1142s4a1+(p1142s4a2/60)
tabstat p_lavar,by(mujer) stat(sum)
/*Llevar o recoger ropa o
calzado de las personas de
este hogar, a la lavandería,
zapatería o remontadora
(incluya tiempo de espera).*/

****c.Limpieza y mantenimiento y reparación del hogar****
gen p_limpiar=p1136s1
gen t_limpiar=p1136s1a1+(p1136s1a2/60)
tab p_limpiar
/*Limpiar esta vivienda
(barrer, trapear, tender las
camas, sacudir el polvo,
sacar la basura, etc.).*/

gen p_cuidar_mascotas_otros=p1136s2
gen t_cuidar_mascotas_otros=p1136s2a1+(p1136s2a2/60)
/*Cuidar mascotas (alimentar,
bañar, pasear, llevar a la
veterinaria, etc.), cuidar el
jardín o limpiar algún
vehículo de este hogar.*/

gen p_cuidar_platas=p1136s3
gen t_cuidar_platas=p1136s3a1+(p1136s3a2/60)
/*Cuidar el jardín o regar
plantas ornamentales*/

gen p_limpiar_vehiculos=p1136s4
gen t_limpiar_vehiculos=p1136s4a1+(p1136s4a2/60)
/*Limpiar algún vehículo de
su propiedad o de este
hogar.*/

gen p_construir_casa=p1141s1
gen t_construir_casa=p1141s1a1+(p1141s1a2/60)
/*Construir o ampliar esta
vivienda.*/

gen p_reparar_casa=p1141s2
gen t_reparar_casa=p1141s2a1+(p1141s2a2/60)
/*Reparar, hacer instalaciones
o mantenimiento a esta
vivienda.*/

gen p_reparar_cosas=p1141s3
gen t_reparar_cosas=p1141s3a1+(p1141s3a2/60)
/*Reparar electrodomésticos,
muebles o vehículos de este
hogar.*/

gen p_llevar_reparar=p1141s4
gen t_llevar_reparar=p1141s4a1+(p1141s4a2/60)
/*Llevar a reparar
electrodomésticos, muebles
o vehículos de este hogar.*/

****d.Compras y administración del hogar****

gen p_mercar=p1140s1
gen t_mercar=p1140s1a1+(p1140s1a2/60)
/*Comprar artículos
personales o para este
hogar (alimentos,
elementos de aseo, útiles
escolares, ropa, calzado,
muebles, etc.).*/

gen p_comprar_medicamentos=p1140s2
gen t_comprar_medicamentos=p1140s2a1+(p1140s2a2/60)
/*Comprar o reclamar
medicamentos para usted o
alguna persona de este
hogar.*/

gen p_supervisar_actividades_hogar=p1140s3
gen t_supervisar_actividades_hogar=p1140s3a1+(p1140s3a2/60)
/*Dirigir o supervisar las
actividades de este hogar
tales como: preparación de
alimentos, limpieza,
construcción, ampliación o
reparación de esta vivienda.*/

gen p_pagar_facturas=p1140s4
gen t_pagar_facturas=p1140s4a1+(p1140s4a2/60)
/*Pagar facturas, hacer
trámites, poner o recoger
encomiendas.*/

gen p_buscar_vivienda=p1140s5
gen t_buscar_vivienda=p1140s5a1+(p1140s5a2/60)
/*Buscar vivienda para tomar
en arriendo o comprar.*/

gen p_cobrar_subsidios=p1140s6
gen t_cobrar_subsidios=p1140s6a1+(p1140s6a2/60)
/*Cobrar subsidios para usted
o alguna persona de este
hogar ante entidades
públicas o privadas*/

gen p_trasladarse=p1140s7
gen t_trasladarse=p1140s7a1+(p1140s7a2/60)
/*Trasladarse (ir y volver)
para efectuar alguna de las
anteriores compras o pagos
(si realizó más de una
actividad, registre el tiempo
de traslado total)*/

gen suministro_alimentos=0
replace suministro_alimentos=1 if p_alimentos==1|p_lavar_platos==1|p_transportar_comida==1 
tab suministro_alimentos
tabstat suministro_alimentos,by(mujer) stat(sum)

gen TP_suministro_alimentos=0
replace TP_suministro_alimentos=1 if suministro_alimentos==1 & pet==1
replace TP_suministro_alimentos=. if pet==0
tab TP_suministro_alimentos
tabstat TP_suministro_alimentos, by(mujer) stat(sum)

gen mantenimiento_vestuario=0
replace mantenimiento_vestuario=1 if p_ropa==1|p_reparar==1|p_lavar
tabstat mantenimiento_vestuario, by(mujer) stat(sum)

gen TP_mantenimiento_vestuario=0
replace TP_mantenimiento_vestuario=1 if mantenimiento_vestuario==1 & pet==1
replace TP_mantenimiento_vestuario=. if pet==0
tab TP_mantenimiento_vestuario

gen limpieza_hogar=0
replace limpieza_hogar=1 if p_limpiar==1|p_cuidar_mascotas_otros==1|p_cuidar_platas==1|p_limpiar_vehiculos==1
replace limpieza_hogar=1 if p_construir_casa==1|p_reparar_casa==1|p_reparar_cosas==1|p_llevar_reparar==1

gen TP_limpieza_hogar=0
replace TP_limpieza_hogar=1 if limpieza_hogar==1 & pet==1
replace TP_limpieza_hogar=. if pet==0
tab TP_limpieza_hogar

gen admon_hogar=0
replace admon_hogar=1 if p_mercar==1|p_comprar_medicamentos==1|p_supervisar_actividades_hogar==1|p_pagar_facturas==1|p_buscar_vivienda==1|p_cobrar_subsidios==1|p_trasladarse==1

gen TP_admon_hogar=0
replace TP_admon_hogar=1 if admon_hogar==1 & pet==1
replace TP_admon_hogar=. if  pet==0
tab TP_admon_hogar
tab pet


****** Cuidado pasivo******************
***************************************

gen p_personas_pendientes=.
replace p_personas_pendientes=1 if p1139s1==1|p1139s2==1|p1139s3==1

gen t_personas_pendientes1=p1139s1a1+(p1139s1a2/60)
gen t_personas_pendientes2=p1139s2a1+(p1139s2a2/60)
gen t_personas_pendientes3=p1139s3a1+(p1139s3a2/60)


/*El día (...) ¿de qué personas
de este hogar estuvo
pendiente? (Persona 1)*/


**Participacion del Trabajo de cuidado y tiempo*****
****************************************************

*a.Las actividades con menores de 5 años pertenecientes al hogar*****
gen p_jugar=p1137s1
gen t_jugar=p1137s1a1+(p1137s1a2/60)


gen p_leer_cuentos=p1137s2
gen t_leer_cuentos=p1137s2a1+(p1137s2a2/60)

gen p_llevar_alparque=p1137s3
gen t_llevar_alparque=p1137s3a1+(p1137s3a2/60)

***b.el cuidado físico de miembros del hogar*

gen p_ayudar_alimentar=.
replace p_ayudar_alimentar=1 if p1135s1==1
replace p_ayudar_alimentar=1 if p1135s2==1
replace p_ayudar_alimentar=1 if p1135s3==1
gen t_ayudar_alimentar1=p1135s1a1+(p1135s1a2/60)
gen t_ayudar_alimentar2=p1135s2a1+(p1135s2a2/60)
gen t_ayudar_alimentar3=p1135s3a1+(p1135s3a2/60)
egen t_ayudar_alimentar=rowtotal(t_ayudar_alimentar1 t_ayudar_alimentar2 t_ayudar_alimentar3)
recode t_ayudar_alimentar(0=.)
br t_ayudar_alimentar p1135s1a1 p1135s1a2 p1135s2a1 p1135s2a2 p1135s3a1 p1135s3a2

/*El día [...], sin que por ello
le pagaran, ¿a qué
persona(s) de este hogar
<...> alimentó o le(s) ayudó
a hacerlo?*/

gen p_ayudar_vestir=.
replace p_ayudar_vestir=1 if p1134s1==1
replace p_ayudar_vestir=1 if p1134s2==1
replace p_ayudar_vestir=1 if p1134s3==1
gen t_ayudar_vestir1=p1134s1a1+(p1134s1a2/60)
gen t_ayudar_vestir2=p1134s2a1+(p1134s2a2/60)
gen t_ayudar_vestir3=p1134s3a1+(p1134s3a2/60)
egen t_ayudar_vestir=rowtotal(t_ayudar_vestir1 t_ayudar_vestir2 t_ayudar_vestir3)
recode t_ayudar_vestir(0=.)

/*El día [...], sin que por ello
le pagaran, ¿a qué
persona(s) de este hogar
<...> bañó, vistió o le(s)
ayudó a hacerlo? (Persona 1)*/

gen p_suministrar_medicamentos=.
replace p_suministrar_medicamentos=1 if p1133s1==1
replace p_suministrar_medicamentos=1 if p1133s2==1
replace p_suministrar_medicamentos=1 if p1133s3==1
gen t_suministrar_medicamentos=p1133s3a1+(p1133s3a2/60)
/*El día [...], sin que por ello
le pagaran, ¿a qué
persona(s) de este hogar
<...> suministró
medicamentos, realizó
terapias, rehabilitaciones o
dio tratamiento a
enfermedades?*/


**c.el apoyo a miembros del hogar**
gen p_ayuda_tareas=.
replace p_ayuda_tareas=1 if p1132s1==1
replace p_ayuda_tareas=1 if p1132s2==1
replace p_ayuda_tareas=1 if p1132s3==1
gen t_ayuda_tareas1=p1132s1a1+(p1132s1a2/60)
gen t_ayuda_tareas2=p1132s2a1+(p1132s2a2/60)
gen t_ayuda_tareas3=p1132s3a1+(p1132s3a2/60)
egen t_ayuda_tareas=rowtotal(t_ayuda_tareas1 t_ayuda_tareas2 t_ayuda_tareas3)
recode t_ayuda_tareas(0=.)

/*El día [...], sin que por ello
le pagaran, ¿a qué
persona(s) de este hogar
<...> ayudó con sus tareas
o trabajos escolares?
(Persona 1)*/

gen p_citas=.
replace p_citas=1 if p1131s1==1
replace p_citas=1 if p1131s2==1
replace p_citas=1 if p1131s3==1
gen t_citas1=p1131s1a1+(p1131s1a2/60)
gen t_citas2=p1131s1a3+(p1131s1a4/60)
gen t_citas3=p1131s2a1+(p1131s2a2/60)
gen t_citas4= p1131s2a3+(p1131s2a4/60)
gen t_citas5= p1131s3a1+(p1131s3a2/60)
gen t_citas6= p1131s3a3+(p1131s3a4/60)
egen t_citas=rowtotal(t_citas1 t_citas2 t_citas3 t_citas4 t_citas5 t_citas6)
recode t_citas(0=.)

/*El día [...], sin que por ello
le pagaran, ¿a qué
persona(s) de este hogar
<...> acompañó a citas
médicas, odontológicas,
urgencias, terapias,
exámenes u otras
atenciones en salud?
(Persona 1)*/

gen p_aconsejar_familiar=p1114s1
gen t_aconsejar_familiar=p1114s1a1+(p1114s1a2/60)
/*Aconsejar o consolar a
personas del hogar*/

gen p_acompañar_menor12=p1114s2
gen t_acompañar_menor12=p1114s2a1+(p1114s2a2/60)
/*Llevar o traer a alguna
persona de este hogar de
12 años o menos al sitio de
estudio.*/

gen p_acompañar_mayor12=p1114s3
gen t_acompañar_mayor12=p1114s3a1+(p1114s3a2/60)
/*Llevar o traer a alguna
persona de este hogar
mayor de 12 años al sitio de
estudio o trabajo.*/

gen p_llevar_traer_arecreativas=p1114s4
gen t_llevar_traer_arecreativas=p1114s4a1+(p1114s4a2/60)
/*Llevar o traer a algúna
persona de este hogar a
eventos sociales, culturales
o recreativos.*/



*************Trabajo Voluntario*********************
****************************************************

gen p_cocinar_otrosh=p1128s1
gen t_cocinar_otrosh=p1128s1a1+(p1128s1a2/60)
/*Oficios del hogar (Cocinar,
limpiar la casa, lavar la ropa,
planchar, hacer las compras,
etc.).*/

gen p_reparar_otrosh=p1128s2
gen t_reparar_otrosh=p1128s2a1+(p1128s2a2/60)
/*Reparaciones menores en
una vivienda o labores de
jardinería*/

gen p_construir_otrosh=p1128s3
gen t_construir_otrosh=p1128s3a1+(p1128s3a2/60)
/*Construir o realizar alguna
ampliación en una vivienda*/

gen p_cuidar_menores_otrosh=p1128s4
gen t_cuidar_menores_otrosh=p1128s4a1+(p1128s4a2/60)
/*Cuidar a personas de 12
años o menos que no estén
enfermas o en condición de
discapacidad.*/

gen p_cuidar_adultos_otrosh=p1128s5
gen t_cuidar_adultos_otrosh=p1128s5a1+(p1128s5a2/60)
/*Cuidar a personas de 60
años o más que no estén
enfermas o en condición de
discapacidad.*/

gen p_cuidar_enfermos_otrosh=p1128s6
gen t_cuidar_enfermos_otrosh=p1128s6a1+(p1128s6a2/60)
/*Cuidar a personas enfermas.*/

gen p_cuidar_discapacidad_otrosh=p1128s7
gen t_cuidar_discapacidad_otrosh=p1128s7a1+(p1128s7a2/60)
/*Cuidar a personas en
condición de discapacidad.*/

gen p_trasladarse_otrosh=p1128s8
gen t_trasladarse_otrosh=p1128s8a1+(p1128s8a2/60)
/*Trasladarse para realizar
una o más de las anteriores
actividades.*/

gen p_reparar_voluntariado=p1127s1
gen t_reparar_voluntariado=p1127s1a1+(p1127s1a2/60)
/*Hacer reparaciones, labores
de limpieza o algún trabajo
en beneficio de su barrio,
vereda, centro poblado o
comunidad.*/

gen p_actividades_voluntariado=p1127s2
gen t_actividades_voluntariado=p1127s2a1+(p1127s2a2/60)
/*Realizar actividades de
voluntariado (sin que le
pagaran) a través de una
institución sin ánimo de
lucro como: damas grises
de la Cruz Roja, un techo
para mi pais, entre otros.*/

gen p_participar_sindicatos=p1127s3
gen t_participar_sindicatos=p1127s3a1+(p1127s3a2/60)
/*Participar en reuniones de
asociaciones de padres,
sindicatos, partidos politicos,
juntas de acción comunal*/
gen p_otras_actividades_voluntarias=p1127s4
gen t_otras_actividades_voluntarias=p1127s4a1+(p1127s4a2/60)


****Actividades simultaneas*******************************
**********************************************************
gen t_extra_domestico=.
replace t_extra_domestico=(p1121s1d+(p1121s1e/60)) if p1121s1b==13|p1121s1b==16|p1121s1b==18|p1121s1b==19|p1121s1b==51|p1121s1b==57|p1121s1b==82|p1121s1b==46|p1121s1b==65|p1121s1b==66
replace t_extra_domestico=(p1121s1d+(p1121s1e/60)) if p1121s1b==34|p1121s1b==44|p1121s1b==73|p1121s1b==20|p1121s1b==21|p1121s1b==28|p1121s1b==33|p1121s1b==47|p1121s1b==48|p1121s1b==49
replace t_extra_domestico=(p1121s1d+(p1121s1e/60)) if p1121s1b==59|p1121s1b==70|p1121s1b==71|p1121s1b==72|p1121s1b==74|p1121s1b==80|p1121s1b==81
replace t_extra_domestico=(p1121s2d+(p1121s2e/60)) if p1121s2b==13|p1121s2b==16|p1121s2b==18|p1121s2b==19|p1121s2b==51|p1121s2b==57|p1121s2b==82|p1121s2b==46|p1121s2b==65|p1121s2b==66
replace t_extra_domestico=(p1121s2d+(p1121s2e/60)) if p1121s2b==34|p1121s2b==44|p1121s2b==73|p1121s2b==20|p1121s2b==21|p1121s2b==28|p1121s2b==33|p1121s2b==47|p1121s2b==48|p1121s2b==49
replace t_extra_domestico=(p1121s2d+(p1121s2e/60)) if p1121s2b==59|p1121s2b==70|p1121s2b==71|p1121s2b==72|p1121s2b==74|p1121s2b==80|p1121s2b==81
replace t_extra_domestico=(p1121s3d+(p1121s3e/60)) if p1121s3b==13|p1121s3b==16|p1121s3b==18|p1121s3b==19|p1121s2b==51|p1121s3b==57|p1121s3b==82|p1121s3b==46|p1121s3b==65|p1121s3b==66
replace t_extra_domestico=(p1121s3d+(p1121s3e/60)) if p1121s3b==34|p1121s3b==44|p1121s3b==73|p1121s3b==20|p1121s2b==21|p1121s3b==28|p1121s3b==33|p1121s3b==47|p1121s3b==48|p1121s3b==49
replace t_extra_domestico=(p1121s3d+(p1121s3e/60)) if p1121s3b==59|p1121s3b==70|p1121s3b==71|p1121s3b==72|p1121s2b==74|p1121s3b==80|p1121s3b==81
sum t_extra_domestico

gen t_extra_cuidado=.
replace t_extra_cuidado=(p1121s1d+(p1121s1e/60)) if p1121s1b==22|p1121s1b==43|p1121s1b==50|p1121s1b==3|p1121s1b==12|p1121s1b==76|p1121s1b==1|p1121s1b==2|p1121s1b==2|p1121s1b==9
replace t_extra_cuidado=(p1121s1d+(p1121s1e/60)) if p1121s1b==39|p1121s1b==52|p1121s1b==53|p1121s1b==54|p1121s1b==55
replace t_extra_cuidado=(p1121s2d+(p1121s2e/60)) if p1121s2b==22|p1121s2b==43|p1121s2b==50|p1121s2b==3|p1121s2b==12|p1121s2b==76|p1121s2b==1|p1121s2b==2|p1121s2b==2|p1121s2b==9
replace t_extra_cuidado=(p1121s2d+(p1121s2e/60)) if p1121s2b==39|p1121s2b==52|p1121s2b==53|p1121s2b==54|p1121s2b==55
replace t_extra_cuidado=(p1121s3d+(p1121s3e/60)) if p1121s3b==22|p1121s3b==43|p1121s3b==50|p1121s3b==3|p1121s3b==12|p1121s3b==76|p1121s3b==1|p1121s3b==2|p1121s3b==2|p1121s3b==9
replace t_extra_cuidado=(p1121s3d+(p1121s3e/60)) if p1121s3b==39|p1121s3b==52|p1121s3b==53|p1121s3b==54|p1121s3b==55
sum t_extra_cuidado

**********Actividades adicionales******************
***************************************************
gen t_actividades_adicionales_no_scn=.
replace t_actividades_adicionales_no_scn=p1122s1a2+(p1122s1a3/60) if p1122s1_cod==1|p1122s1_cod==2|p1122s1_cod==3|p1122s1_cod==4|p1122s1_cod==2401|p1122s1_cod==2402|p1122s1_cod==2403|p1122s1_cod==2404
replace t_actividades_adicionales_no_scn=p1122s2a2+(p1122s2a3/60) if p1122s2_cod==1|p1122s2_cod==2|p1122s2_cod==3|p1122s2_cod==4|p1122s2_cod==2401|p1122s2_cod==2402|p1122s2_cod==2403|p1122s2_cod==2404
replace t_actividades_adicionales_no_scn=p1122s3a2+(p1122s3a3/60) if p1122s3_cod==1|p1122s3_cod==2|p1122s3_cod==3|p1122s3_cod==4|p1122s3_cod==2401|p1122s3_cod==2402|p1122s3_cod==2403|p1122s3_cod==2404
sum t_actividades_adicionales_no_scn


*tiempo total**************************************
***************************************************
egen tiempo_suministro_alimentos=rowtotal(t_alimentos t_lavar_platos t_transportar_comida)
recode tiempo_suministro_alimentos(0=.)
sum tiempo_suministro_alimentos


egen tiempo_mantenimiento_vestuario=rowtotal(t_ropa t_reparar t_lavar)
recode tiempo_mantenimiento_vestuario(0=.)
sum tiempo_mantenimiento_vestuario
 
egen tiempo_limpieza_hogar=rowtotal(t_limpiar t_cuidar_mascotas_otros t_cuidar_platas t_limpiar_vehiculos t_construir_casa t_reparar_casa t_reparar_cosas t_llevar_reparar)
recode tiempo_limpieza_hogar(0=.)
sum tiempo_limpieza_hogar

egen tiempo_admon_hogar=rowtotal(t_mercar t_comprar_medicamentos t_supervisar_actividades_hogar t_pagar_facturas t_buscar_vivienda t_cobrar_subsidios )
recode tiempo_admon_hogar(0=.)
sum tiempo_admon_hogar

egen tiempo_TDNR=rowtotal(tiempo_suministro_alimentos tiempo_mantenimiento_vestuario tiempo_limpieza_hogar tiempo_admon_hogar)
recode tiempo_TDNR(0=.)
sum tiempo_TDNR
tabstat tiempo_TDNR,by(mujer) stat(mean)


egen cuidado_pasivo=rowtotal(t_personas_pendientes1 t_personas_pendientes2 t_personas_pendientes3)
recode cuidado_pasivo(0=.)
sum cuidado_pasivo

egen tiempo_actividades_con_menores5=rowtotal(t_jugar t_leer_cuentos t_llevar_alparque)
recode tiempo_actividades_con_menores5(0=.)
sum tiempo_actividades_con_menores5
tabstat tiempo_actividades_con_menores5 if mujer==0,by(clase)stat(mean)

egen tiempo_cuidado_fisico_familiares=rowtotal(t_ayudar_alimentar t_ayudar_vestir t_suministrar_medicamentos)
recode tiempo_cuidado_fisico_familiares(0=.)
sum tiempo_cuidado_fisico_familiares

br t_ayudar_alimentar t_ayudar_vestir t_suministrar_medicamentos tiempo_cuidado_fisico_familiares mujer
tabstat tiempo_cuidado_fisico_familiares if mujer==1,by(clase)stat(mean)

egen tiempo_apoyo_familiares=rowtotal(t_ayuda_tareas t_citas t_aconsejar_familiar t_acompañar_menor12 t_acompañar_mayor12 t_llevar_traer_arecreativas)
recode tiempo_apoyo_familiares(0=.)
sum tiempo_apoyo_familiares

egen tiempo_trabajo_cuidado=rowtotal(tiempo_actividades_con_menores5 tiempo_cuidado_fisico_familiares tiempo_apoyo_familiares)
recode tiempo_trabajo_cuidado(0=.)
tabstat tiempo_trabajo_cuidado, by(mujer)

egen t_trabajo_cuidado_otrosh=rowtotal(t_cocinar_otrosh t_reparar_otrosh t_construir_otrosh t_cuidar_menores_otrosh t_cuidar_adultos_otrosh t_cuidar_enfermos_otrosh t_cuidar_discapacidad_otrosh t_trasladarse_otrosh)
recode t_trabajo_cuidado_otrosh(0=.)

egen t_trabajo_voluntario=rowtotal(t_reparar_voluntariado t_actividades_voluntariado t_participar_sindicatos t_otras_actividades_voluntarias)
recode t_trabajo_voluntario(0=.)

egen t_total_trabajo_voluntario=rowtotal(t_trabajo_cuidado_otrosh t_trabajo_voluntario)
recode t_total_trabajo_voluntario(0=.)
sum t_total_trabajo_voluntario

egen t_actividades_simultaneas=rowtotal(t_extra_domestico t_extra_cuidado)
recode t_actividades_simultaneas(0=.)

egen total_tiempo_no_scn=rowtotal(tiempo_TDNR tiempo_trabajo_cuidado cuidado_pasivo t_total_trabajo_voluntario t_actividades_simultaneas t_actividades_adicionales_no_scn t_trasladarse)
recode total_tiempo_no_scn(0=.)
sum total_tiempo_no_scn
tabstat total_tiempo_no_scn,by(mujer)

**************Diferencias de medias*************

cap program drop difmedias
program define difmedias
syntax varlist [, by(varname)]
 di "Var" " {col 20} " "Media T Media C Diff t Valor-p"
  foreach v of local varlist{
  qui ttest `v', by(`by')
  di "`v'" "{col 20}" %6.2f r(mu_2) " " %6.2f r(mu_1) " " %6.2f r(mu_2)-r(mu_1) " " %6.2f r(t) " " %6.2f r(p)
 }
end

global X tiempo_productivo total_tiempo_no_scn
difmedias $X, by(mujer) 

global X tiempo_productivo total_tiempo_no_scn
difmedias $X, by(casado_trabaja_mujer) 
difmedias $X, by(union_libre_trabaja_mujer) 
difmedias $X, by(soltero_trabaja_mujer) 

global Y tiempo_suministro_alimentos tiempo_mantenimiento_vestuario tiempo_limpieza_hogar tiempo_admon_hogar
difmedias $Y, by(mujer)
difmedias $Y, by(casado_trabaja_mujer) 
difmedias $Y, by(union_libre_trabaja_mujer) 
difmedias $Y, by(soltero_trabaja_mujer) 

global Z tiempo_actividades_con_menores5 tiempo_cuidado_fisico_familiares tiempo_apoyo_familiares
difmedias $Z, by(mujer) 
difmedias $Z, by(casado_trabaja_mujer) 
difmedias $Z, by(union_libre_trabaja_mujer) 
difmedias $Z, by(soltero_trabaja_mujer) 

global Q e TGP_productivo
difmedias e,by(mujer)
difmedias e,by(casado_mujer)
difmedias $Q, by(casado_mujer)

difmedias e,by(bachiller_mujer)
difmedias TGP_productivo,by(mujer)
ttest TGP_productivo, by (mujer)

**********Estadisticos descriptivos**********
graph bar (mean) total_tiempo_no_scn,over(nivel_educativo) over(casado_trabaja_mujer) blabel(total)
graph bar (mean) total_tiempo_no_scn,over(nivel_educativo) over(union_libre_trabaja_mujer) blabel(total)
graph bar (mean) total_tiempo_no_scn,over(nivel_educativo) over(soltero_trabaja_mujer) blabel(total)

***Brecha salarial*****

difmedias log_salario, by(mujer) 
difmedias log_salario, by(casado_mujer) 

difmedias log_salario, by(casado_trabaja_mujer) 
difmedias log_salario, by(union_libre_trabaja_mujer) 
difmedias log_salario, by(soltero_trabaja_mujer) 
