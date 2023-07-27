##Analisis Exploratorio Base de Datos de Negocios Verdes en Colombia, informacion extraida de datos.gov y 
suministrada por Camilo Martinez Burgos en su curso "Data Storytelling Case Study: Green Businesses" en DataCamp. 

##En este analisis inicial se generarán consultas para conocer la base datos y extraer conocimientos iniciales.

#1.Cuántas columnas tiene la tabla?

Select *
FROM negocios_verdes
Limit 10

##La tabla contiene 8 columnas, de las cuales se destacan el año en que la licensia fue otorgada, columnas de localización
tales como region, departamento y municipio, categoria y sector industral del negocio, y el puntaje obtenido.

#2. Cuántas licencias se otorgaron?

SELECT count(*) total_licencias
FROM negocios_verdes

#3. Cuantas regiones, departamentos y municipios hacen parte de la base de datos

SELECT count(distinct region) total_regiones, count(distinct departamento) total_departamentos, 
count(distinct municipio) total_municipios
FROM negocios_verdes

#4. Cuáles son los tipos de categoria presentes en la base de datos?

SELECT DISTINCT categoria
FROM negocios_verdes

#5. Cuáles son los tipos de Sector presentes en la base de datos?

SELECT DISTINCT sector
FROM negocios_verdes

#6. Cuáles son los posibles resultados al obtener la licencia?

SELECT DISTINCT resultado
FROM negocios_verdes

##Basado en los criterios de verificación se tiene que los resultados tienen un nivel ascendente de inicial, básico,
intermedio,  satisfactorio, avanzado e ideal, siendo inicial el resultado con el menor porcentaje de criterios 
alcanzados, llegando a ideal con el mayor porcentaje.

#7. Cúantas han sido año a año la cantidad de licencias otorgadas?

SELECT año, COUNT(*) total_licensias
FROM negocios_verdes
GROUP BY año
ORDER BY año

#8. Cómo ha variado porcentualmente la cantidad de licencias año a año?

with cte as (SELECT año, COUNT(*) total_licencias,
	   lag(COUNT(*),1) over (order by año)
FROM negocios_verdes
GROUP BY año
ORDER BY año)

SELECT año, total_licencias, lag, ROUND(100*((total_licencias::NUMERIC - lag)/lag),2) variacion_porcentual
FROM cte

## Apartir del año 2016 se genera un Boom de las licencias otorgadas a negocios verdes en el país,
continuando así hasta el año 2020, donde debido a la situación global hay un decrecimiento del -85.73%

#9. Cuáles son las regiones con mayor cantidad de licencias otorgadas?

SELECT region, count(*) total_licencias
FROM negocios_verdes
GROUP BY region
ORDER BY total_licencias DESC

#10. Cuáles son los 10 departamentos con mayor cantidad de licencias?

SELECT departamento, count(*) total_licencias
FROM negocios_verdes
GROUP BY  departamento
ORDER BY total_licencias DESC
LIMIT 10

#11. Cuáles son los 10 departamentos con menor cantidad de licencias?

SELECT departamento, count(*) total_licencias
FROM negocios_verdes
GROUP BY  departamento
ORDER BY total_licencias 
LIMIT 10

#12. Cuáles son los sectores con mayor cantidad de Licensias?

SELECT sector, count(*) total_licencias
FROM negocios_verdes
GROUP BY sector
ORDER BY total_licencias DESC

#13. Al interior de los 3 mejores departamentos en cuanto a licencias otrogadas, cuales son sus mejores ciudades?

with cte as (SELECT departamento, municipio, count(*) total_licencias,
	   dense_rank() over (partition by departamento order by count(*) DESC)
FROM negocios_verdes
WHERE departamento IN (
SELECT departamento 
FROM negocios_verdes
GROUP BY  departamento
ORDER BY count(*) DESC
LIMIT 3)
GROUP BY 1,2)

SELECT departamento, municipio, total_licencias
FROM CTE
WHERE dense_rank IN (1,2,3)
ORDER BY departamento

#14. Que sectores hacen presencia entre los 5 departamentos con menor cantidad de licencias?

SELECT sector, count(*) total_licencias
FROM negocios_verdes
WHERE departamento IN (
SELECT departamento  
FROM negocios_verdes
GROUP BY  departamento
ORDER BY count(*)
LIMIT 5)
GROUP BY sector
ORDER BY total_licencias

#15. Cuál es la cantidad de licencias frente al resultado obtenido

SELECT resultado, count(*) total_licencias,
CASE WHEN resultado = 'Initial' then 1 
	 WHEN resultado = 'Basic' then 2
	 WHEN resultado = 'Intermediate' then 3
	 WHEN resultado = 'Satisfactory' then 4
	 WHEN resultado = 'Advanced' then 5 ELSE 6 END AS rank
FROM negocios_verdes
GROUP BY resultado
ORDER BY RANK

#16. Cómo ha sido el comportamiento año a año de los resultados en variación porcentual?

with cte as (SELECT año, resultado, count(*) total,
lag(count(*),1) over (partition by resultado order by año)
FROM negocios_verdes
GROUP BY año,resultado
ORDER BY resultado,año)

SELECT año, resultado, total, ROUND(100*((total::numeric-lag)/lag),2) variación_porcentual
FROM cte
ORDER BY resultado, año

#17. Cuál es el promedio de licencias otorgadas por departamento?

SELECT count(*)/count(distinct departamento) as promedio_departamental
FROM negocios_verdes

#18. Cuáles departamentos se encuentran por debajo del promedio departamental?

SELECT departamento, count(*) total_licencias
FROM negocios_verdes
GROUP BY departamento
HAVING COUNT(*) < (
SELECT count(*)/count(distinct departamento) as promedio_departamental
FROM negocios_verdes)
ORDER BY total_licencias DESC

###Ahora, de qué manera este proyecto puede generar un impacto para actores interesados en los negocios verdes
en Colombia.

En primer lugar se observa el comportamiento general año a año del otorgamiento de estas licencias, permitiendo
esto al sector empresarial y al gobierno establecer rutas claras en cuanto al manejo, divulgación y apoyo a las 
empresas que desean incursionar en este tipo de iniciativas, todo esto debido a que la conciencia sobre la importancia 
de la sostenibilidad crece a nivel mundial, y así, los negocios verdes se posicionan como actores clave en la construcción 
de un futuro más próspero, equitativo y en armonía con el entorno. Explorar su impacto en la economía de un país 
proporcionará una visión más clara y holística de cómo estas empresas están forjando un camino hacia un desarrollo 
sostenible y responsable, beneficiando tanto a la sociedad actual como a las generaciones venideras.

Tras el analisis regional, de dónde se encuentran los lugares con más y menos licencias otorgadas a nivel departamental, 
municipal, así como los sectores de la economia a la cual hacen parte estos negocios, tanto los empresarios como el gobierno
pueden enfocar sus esfuerzos en áreas específicas que puedan requerir más apoyo o donde haya oportunidades para el crecimiento 
sostenible. Esto permitirá una mejor planificación y asignación de recursos para fomentar el desarrollo sostenible en todo 
el país.




