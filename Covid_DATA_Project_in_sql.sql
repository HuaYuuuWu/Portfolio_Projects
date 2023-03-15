
SELECT *
FROM Project_1_USE.dbo.Covid_deaths_info
WHERE continent is not null
order by location,date;



-- Looking at Total cases vs. Total Deaths in each country
-- Finding the % rate of death contracting Covid in each country

SELECT location, date, nullif(cast(total_cases as int),0) total_cases, nullif(cast(total_deaths as int),0) total_deaths,
(total_deaths/nullif(cast(total_cases as float),0))*100 Death_Percentage
FROM Project_1_USE.dbo.Covid_deaths_info
WHERE continent is not null
order by 1,2


-- Finding the % rate of death if contracting Covid in Canada

SELECT location, date, nullif(cast(total_cases as int),0) total_cases, nullif(cast(total_deaths as int),0) total_deaths,
(total_deaths/nullif(cast(total_cases as float),0))*100 Death_Percentage
FROM Project_1_USE.dbo.Covid_deaths_info
WHERE continent is not null and location = 'Canada'
order by 1,2



-- Covert data type into proper type, then come back into project again
-- Covert data type into proper type, then come back into project again
-- Covert data type into proper type, then come back into project again



-- Looking at Total cases vs. Population
-- Shows what percentage of population got Covid in Canada

select
	location,date,total_cases, Population, total_cases, (total_cases/population)*100 as Infection_Rate
from
	Project_1_USE.dbo.Covid_deaths_info
Where
	continent is not null and location = 'Canada'
order by 1,2
;



-- Looking at countries with the highest infection rate compared to its population

select
	location, population, max(total_cases) as highestinfectionCount, max((total_cases/population))*100 as percentrate_populateioninfected
from
	Project_1_USE.dbo.Covid_deaths_info
Where
	continent is not null and location = 'Canada'
Group by 1,2
order by percentrate_populateioninfected desc
;


-- Showing countries with the hightest death count per population

select
	location, max(total_deaths) Total_Death_Count
from
	Project_1_USE.dbo.Covid_deaths_info
Where continent is not null
Group by 1
order by Total_Death_Count desc



-- finding the rollingvacciated rate in each country

with PopulationvsVac (continent, location, date, population, new_vaccinations,RollingpeopleVaccinated)
as
(
select
	d.continent,d,location,d.date,d.population,v.new_vaccinations,
	sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) RollingpeopleVaccinated
from
	Project_1_USE.dbo.Covid_deaths_info  d join Project_1_USE.dbo.Covid_vaccinations_info v
	on d.location = v.location and a.date = v.date
where a.continent is not null
)
select 
	*, (RollingpeopleVaccinated/population)*100
from
	PopulationvsVac
