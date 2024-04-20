--select location, date, total_cases, new_cases, total_deaths, population
--from portfoilioproject..CovidDeaths

--looking  at total cases vs total deaths

--select location, date
--from portfoilioproject..CovidDeaths
--where location like '%states%'
--order by 1,2 

--select *
--from CovidDeaths


--select convert(int, 'total_cases') as ntotalcases, convert(int, 'total_deaths') as ntotaldeaths
--from CovidDea,

--select location, date, total_deaths, total_cases, (total_deaths/total_cases)*100 as deathpercentage
--from CovidDeaths

--SELECT
--    location,
--    date,
--    total_deaths,
--    total_cases,
--    CAST(ROUND((total_deaths * 100.0) / NULLIF(total_cases, 0), 0) AS INT) AS deathpercentage
--FROM
--    CovidDeaths;

SELECT
    location,
    date,
    total_deaths,
    total_cases,
    CASE
        WHEN ISNUMERIC(total_deaths) = 1 AND ISNUMERIC(total_cases) = 1 AND total_cases != 0 THEN 
            CAST((CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 AS INT)
        ELSE CAST(NULL AS INT)
    END AS deathpercentage
FROM
    CovidDeaths
WHERE
    location LIKE '%nigeria%';

--	SELECT
--    location,
--    date,
--    total_deaths,
--    total_cases,
--    CASE
--        WHEN ISNUMERIC(total_deaths) = 1 AND ISNUMERIC(total_cases) = 1 AND total_cases != 0 THEN 
--            CAST((CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 AS FLOAT)
--        ELSE NULL
--    END AS deathpercentage
--FROM
--    CovidDeaths
--WHERE
--    location LIKE '%state%';

select location, population, max(total_cases) as highestinfectioncount, max((total_cases/population))*100 as ppid
from coviddeaths
group by location, population
order by ppid desc

--showing the countries with the highest death counts per population

select location, max(cast(total_deaths as int)) as Totaldeathcount
from CovidDeaths
where continent is not null
group by location, population
order by Totaldeathcount desc

--select *
--from coviddeaths
--where continent is not null
--order by 3, 4

--lets bresk tings by continent

select location, max(cast(total_deaths as int)) as Totaldeathcount
from CovidDeaths
where continent is null
group by location
order by Totaldeathcount desc


--showing the conitnent with highest death count


select continent, max(cast(total_deaths as int)) as Totaldeathcount
from CovidDeaths
where continent is not null
group by continent
order by Totaldeathcount desc


--global numbers

SELECT
    date,
    total_deaths,
    total_cases,
    CASE
        WHEN ISNUMERIC(total_deaths) = 1 AND ISNUMERIC(total_cases) = 1 AND total_cases != 0 THEN 
            CAST((CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 AS INT)
        ELSE CAST(NULL AS INT)
    END AS deathpercentage
FROM
    CovidDeaths
where continent is not null
group by date
order by 1, 2


select date, sum(new_cases), sum(cast(new_deaths as int))
from portfoilioproject..CovidDeaths
where continent is not null
group by date
order by 1, 2


select location, date, total_cases, total_deaths, 
(cast(total_deaths as float)/cast(total_cases as float))*100 as ppe
from coviddeaths
where location like '%nigeria%'
order by ppe desc

-- total population vs vaccination
--using CTE
with PopVsVac (continent, location,  date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(cast(v.new_vaccinations as float)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from portfoilioproject..CovidDeaths D
join portfoilioproject..CovidVaccination V
on D.date  = V.date and D.location = V.location
where d.continent is not null
---order by 2, 3
)
select *, (RollingPeopleVaccinated/population)*100
from PopVsVac


--temp table
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Rollingpeoplevaccinated numeric
)

insert into
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(cast(v.new_vaccinations as float)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from portfoilioproject..CovidDeaths D
join portfoilioproject..CovidVaccination V
on D.date  = V.date and D.location = V.location
where d.continent is not null
---order by 2, 3