SELECT *
FROM ['Covid Deaths - SQL']
where continent is not null
order by 3,4;



--SELECT *
--FROM ['Covid Vaccinations - SQL']
--order by 3,4


--Introducing Data to be Used
Select Location, date, total_cases, new_cases, total_deaths, population
from ['Covid Deaths - SQL']
where continent is not null
order by 1,2;


--Calculate total cases versus total deaths
--Btw total_cases and total_death are cumulative
--The death_percentage shows the likelihood of individuals dying from covid if the contract it today
Select Location, date, total_cases, total_deaths, 
(total_deaths/total_cases) * 100 as death_percentage
from ['Covid Deaths - SQL']
where location = 'Nigeria'
and continent is not null
order by 1,2;


--Looking at Total cases versus Population.
--What percentage of the population actually got infected
Select Location, Population, date, total_cases,  
(total_cases/population) * 100 as Cases_rate
from ['Covid Deaths - SQL']
where location = 'Nigeria'
and continent is not null
order by 1,3;

Select Location, Population, date, total_cases, 
(total_cases/population) * 100 as Cases_rate
from ['Covid Deaths - SQL']
where location like '%states%'
and continent is not null
order by 1,2;

--What countries have the highest infection rate in relation to their population
select location, population, MAX(total_cases) as infection_popn,
MAX((total_cases/population)) * 100 as highest_infection_rate
from ['Covid Deaths - SQL']
where continent is not null
group by location, population 
order by highest_infection_rate DESC;


--Countries with Highest Death count in relation to their population
select location, population, MAX(cast(total_deaths as int)) as Deathcount, MAX((total_deaths/population)) as Deathrate
from ['Covid Deaths - SQL']
where continent is not null
group by location, population 
Order by Deathcount desc;


/*Let's break it down by continent*/
--Showing Continents with Highest Death Count
SELECT
continent, MAX((total_deaths/population)) AS Deathrate, MAX(cast(total_deaths as int)) AS Deathcount
FROM
['Covid Deaths - SQL']
WHERE continent is not null
GROUP BY 
continent
ORDER BY
3 DESC




--Global Numbers
SELECT 
SUM(new_cases) as Globalcases, SUM(cast(new_deaths as bigint)) as Globaldeaths, 
SUM(cast(new_deaths as bigint))/SUM(new_cases) * 100 as Globaldeathratio
FROM
['Covid Deaths - SQL']
WHERE
continent is not null


SELECT 
*
FROM 
['Covid Vaccinations - SQL'] dea
JOIN
['Covid Vaccinations - SQL'] vac
ON
dea.location = vac.location
AND 
dea.date = vac.date


--Total Number of People in the World that have been Vaccinated relative to popn
--Using CTE

With popn_vs_vac (continent, location, date,  population, new_vaccinations, Cumulative_vaccinations)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(Convert(bigint,vac.new_vaccinations))
OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS Cumulative_vaccinations
FROM 
['Covid Deaths - SQL'] dea
JOIN
['Covid Vaccinations - SQL'] vac 
ON 
dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3 
)
SELECT *, (Cumulative_vaccinations/population) * 100
FROM popn_vs_vac


--Using Temp Table
DROP Table if exists #percentpopnvac
Create Table #percentpopnvac 
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetimE,
Population numeric,
New_vaccinations numeric,
Cumulative_vaccinations numeric
)


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(Convert(bigint,vac.new_vaccinations))
OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS Cumulative_vaccinations
FROM 
['Covid Deaths - SQL'] dea
JOIN
['Covid Vaccinations - SQL'] vac 
ON 
dea.location = vac.location
AND dea.date = vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3 

SELECT *, (Cumulative_vaccinations/population) * 100
FROM #percentpopnvac


Create view percentpopnvac as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(Convert(bigint,vac.new_vaccinations))
OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS Cumulative_vaccinations
FROM 
['Covid Deaths - SQL'] dea
JOIN
['Covid Vaccinations - SQL'] vac 
ON 
dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3 
