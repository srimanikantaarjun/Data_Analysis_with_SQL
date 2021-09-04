
Select *
From [PortFolio Project]..CovidDeaths
order by 3, 4

Select *
From [PortFolio Project]..CovidVaccinations
order by 3, 4

-- Select Data that we are going to be using
Select location, date, total_cases, new_cases, total_deaths, population
From [PortFolio Project]..CovidDeaths
order by 1,2

-- Looking at Total cases vs Total Deaths
 Shows likelihood of dying if you contract covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as 'DeathPercentage'
From [PortFolio Project]..CovidDeaths
where location like '%states'
order by 1,2

-- Total cases vs Population
 Shows percentage of COVID-19 positive
Select location, date, population, total_cases, (total_cases/population)*100 as 'PercentPopulationInfected'
From [PortFolio Project]..CovidDeaths
where location like '%states'
order by 1,2

-- Countries with highest infection rate compared to Population
 Select location, population, MAX(total_cases) as HighestInfectionCount, (MAX(total_cases/population))*100 as 
 PercentPopulationInfected
 FROM [PortFolio Project]..CovidDeaths
 GROUP BY location, population
 ORDER BY PercentPopulationInfected DESC

-- Countries with Highest Death Count per Population
Select location, MAX(CAST(total_deaths AS INT)) as TotalDeathCount
FROM [PortFolio Project]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Breaking things down by Continent

Select continent, MAX(CAST(total_deaths AS INT)) as TotalDeathCount
FROM [PortFolio Project]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Continents with Highest Death count

SELECT location, MAX(CAST(total_deaths AS INT)) as TotalDeathCount
FROM [PortFolio Project]..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Global Numbers
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM [PortFolio Project]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

SELECT date, SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS INT)) AS Total_Deaths,
SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS Death_Percentage
FROM [PortFolio Project]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS INT)) AS Total_Deaths,
SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS Death_Percentage
FROM [PortFolio Project]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

-- Total Population vs Vaccinations

SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
SUM(CAST(Vac.new_vaccinations AS INT)) OVER (PARTITION BY Dea.location)
FROM [PortFolio Project]..CovidDeaths Dea
JOIN [PortFolio Project]..CovidVaccinations Vac
ON Dea.location = Vac.location AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
ORDER BY 2,3

SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
SUM(CONVERT(INT, Vac.new_vaccinations)) OVER (PARTITION BY Dea.location)
FROM [PortFolio Project]..CovidDeaths Dea
JOIN [PortFolio Project]..CovidVaccinations Vac
ON Dea.location = Vac.location AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
ORDER BY 2,3

SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
SUM(CONVERT(INT, Vac.new_vaccinations)) OVER
(PARTITION BY Dea.location ORDER BY Dea.location, Dea.date) AS RollingPeopleVaccinated
FROM [PortFolio Project]..CovidDeaths Dea
JOIN [PortFolio Project]..CovidVaccinations Vac
ON Dea.location = Vac.location AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
ORDER BY 2,3

-- CTE

WITH PopvsVac (continent, location, date, population, new_vaccinations, Rolling_People_Vaccinated)
AS
(
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
SUM(CONVERT(INT, Vac.new_vaccinations)) OVER
(PARTITION BY Dea.location ORDER BY Dea.location, Dea.date) AS Rolling_People_Vaccinated
FROM [PortFolio Project]..CovidDeaths Dea
JOIN [PortFolio Project]..CovidVaccinations Vac
ON Dea.location = Vac.location AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
--ORDER BY 2,3
)

SELECT *
FROM PopvsVac


WITH PopvsVac (continent, location, date, population, new_vaccinations, Rolling_People_Vaccinated)
AS
(
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
SUM(CONVERT(INT, Vac.new_vaccinations)) OVER
(PARTITION BY Dea.location ORDER BY Dea.location, Dea.date) AS Rolling_People_Vaccinated
FROM [PortFolio Project]..CovidDeaths Dea
JOIN [PortFolio Project]..CovidVaccinations Vac
ON Dea.location = Vac.location AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
ORDER BY 2,3
)

SELECT *, (Rolling_People_Vaccinated/Population)*100
FROM PopvsVac

-- TEMP TABLE

CREATE TABLE Percent_Population_Vaccinated
(
continent NVARCHAR(255), location NVARCHAR(255), date DATETIME,
Population NUMERIC, new_vaccinations NUMERIC, Rolling_People_Vaccinated NUMERIC
)
INSERT INTO Percent_Population_Vaccinated
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
SUM(CONVERT(INT, Vac.new_vaccinations)) OVER
(PARTITION BY Dea.location ORDER BY Dea.location, Dea.date) AS Rolling_People_Vaccinated
FROM [PortFolio Project]..CovidDeaths Dea
JOIN [PortFolio Project]..CovidVaccinations Vac
ON Dea.location = Vac.location AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
--ORDER BY 2,3
SELECT *, (Rolling_People_Vaccinated/Population)*100
FROM Percent_Population_Vaccinated

-- To make changes to an existing table

DROP TABLE IF EXISTS Percent_Population_Vaccinated
CREATE TABLE Percent_Population_Vaccinated
(
continent NVARCHAR(255), location NVARCHAR(255), date DATETIME,
Population NUMERIC, new_vaccinations NUMERIC, Rolling_People_Vaccinated NUMERIC
)
INSERT INTO Percent_Population_Vaccinated
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
SUM(CONVERT(INT, Vac.new_vaccinations)) OVER
(PARTITION BY Dea.location ORDER BY Dea.location, Dea.date) AS Rolling_People_Vaccinated
FROM [PortFolio Project]..CovidDeaths Dea
JOIN [PortFolio Project]..CovidVaccinations Vac
ON Dea.location = Vac.location AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
--ORDER BY 2,3
SELECT *, (Rolling_People_Vaccinated/Population)*100
FROM Percent_Population_Vaccinated

-- VIEW TO STORE DATA FOR VISUALIZATIONS


CREATE VIEW PercentPopulation_Vaccinated AS
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
SUM(CONVERT(INT, Vac.new_vaccinations)) OVER
(PARTITION BY Dea.location ORDER BY Dea.location, Dea.date) AS Rolling_People_Vaccinated
FROM [PortFolio Project]..CovidDeaths Dea
JOIN [PortFolio Project]..CovidVaccinations Vac
ON Dea.location = Vac.location AND 
   Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
ORDER BY 2,3
