USE PortfolioProject

--Using CovidDeaths tables:

SELECT *
FROM coviddeaths

--Looking at Tatoal Cases vs Total Deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM coviddeaths
WHERE location LIKE '%cambo%'
ORDER BY location, date;

	--Looking at Tatoal Cases vs Population
SELECT location, date,population, total_cases,(total_deaths/population)*100 as InfectedPercent
FROM coviddeaths
WHERE location LIKE '%cambo%'
ORDER BY location, date;

--Looking at countries with the Highest infection Rate compared to Pop
SELECT location, population, MAX(total_cases) AS HigestInfection, MAX((total_cases/population))*100 as InfectionPercent
FROM coviddeaths
GROUP BY location, population
ORDER BY 4 DESC;

--Looking at countries with the Highest Death Count Per Pop 
SELECT location, MAX(CAST(total_deaths as int)) AS TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

--Looking at continents with the Highest Death Count Per Pop 
SELECT continent, MAX(CAST(total_deaths as int)) AS TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths,
SUM(CAST(new_deaths as INT))/SUM(new_cases)*100 as DeathPercentage
FROM
coviddeaths
WHERE continent IS NOT NULL;

-----
SELECT d.continent, d.location, d.date, d.population, c.new_vaccinations,
SUM(CONVERT(int,c.new_vaccinations)) 
OVER (PARTITION by d.location ORDER BY d.location, d.date) AS TotalVac
FROM coviddeaths AS d
JOIN covidvaccination AS c
	ON d.location = c.location
	AND d.date = c.date
WHERE d.continent IS NOT NULL
ORDER BY 2,3;

--USE CTE

WITH PopvsVac (continent, location, Date, Population, New_Vaccination, TotalVac)
AS
(
	SELECT d.continent, d.location, d.date, d.population, c.new_vaccinations,
	SUM(CONVERT(int,c.new_vaccinations)) 
	OVER (PARTITION by d.location ORDER BY d.location, d.date) AS TotalVac
	FROM coviddeaths d
	JOIN covidvaccination c
		ON d.location = c.location
		AND d.date = c.date
	WHERE d.continent IS NOT NULL
	--ORDER BY 2,3;
)
SELECT *, (TotalVac/Population)*100
FROM PopvsVac;

--Global Number
SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
SUM(CAST(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

--Conitnent with the Highest death per count per population
SELECT continent, MAX(CAST(total_deaths AS INT)) as TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

--Creating View to stor data for later viz
CREATE VIEW PercentPopVaccinated AS
	SELECT d.continent, d.location, d.date, d.population, c.new_vaccinations,
	SUM(CONVERT(int,c.new_vaccinations)) 
	OVER (PARTITION by d.location ORDER BY d.location, d.date) AS TotalVac
	FROM coviddeaths d
	JOIN covidvaccination c
		ON d.location = c.location
		AND d.date = c.date
	WHERE d.continent IS NOT NULL;