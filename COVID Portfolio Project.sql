SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

--Select data we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

--Likelihood of dying if you contract COVID
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2

-- What percentage of the population has COVID
SELECT Location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2

-- Total Cases vs Total Deaths
SELECT Location, date, population, total_cases, (total_cases/population)*100 as PercentPopInfected
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

-- Looking at countries with highest infection rate compared to Population
SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopInfected desc

-- Showing Countries with Highest Death Count per Population
SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount desc

--BREAKING THINGS DOWN BY CONTINENT

--Showing continents with highest death counts
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null AND continent
GROUP BY continent
ORDER BY TotalDeathCount desc

-- GLOBAL NUMBERS

SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2 

-- Looking at Total Population vs Vaccinations
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(Cast(v.new_vaccinations as int)) OVER (Partition by d.Location ORDER BY d.location, d.date) as RollingVaccinations
FROM PortfolioProject..CovidDeaths d
JOIN PortfolioProject..CovidVaccinations v
	ON d.location = v.location
	and d.date = v.date
WHERE d.continent is not null
ORDER BY 2,3

-- USE CTE to find percentage of population vaccinated

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingVaccinations)
as
(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(Cast(v.new_vaccinations as int)) OVER (Partition by d.Location ORDER BY d.location, d.date) as RollingVaccinations
FROM PortfolioProject..CovidDeaths d
JOIN PortfolioProject..CovidVaccinations v
	ON d.location = v.location
	and d.date = v.date
WHERE d.continent is not null
--ORDER BY 2,3
)

SELECT *, (RollingVaccinations/Population)*100
FROM PopvsVac

-- TEMP TABLE

DROP TABLE if exists #PercentPopulationVaccinated
 
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

INSERT INTO #PercentPopulationVaccinated
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(Cast(v.new_vaccinations as int)) OVER (Partition by d.Location ORDER BY d.location, d.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths d
JOIN PortfolioProject..CovidVaccinations v
	ON d.location = v.location
	and d.date = v.date
WHERE d.continent is not null
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

-- Creating View to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated as
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(Cast(v.new_vaccinations as int)) OVER (Partition by d.Location ORDER BY d.location, d.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths d
JOIN PortfolioProject..CovidVaccinations v
	ON d.location = v.location
	and d.date = v.date
WHERE d.continent is not null
--ORDER BY 2,3