/*

COVID-19 DATA EXPLORATION

SKILLS APPLIED: COMMON_TABLE_EXPRESSIONs, TEMP TABLES, WINDOWS FUNCTIONS,
				AGGREGATE FUNCTIONS, CREATING VIEWS, CONVERTING DATA TYPES

*/
SELECT *
FROM [PortFolio Project]..CovidDeaths
ORDER BY 3, 4


SELECT *
FROM [PortFolio Project]..CovidVaccinations
ORDER BY 3, 4


-- SELECT DATA

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [PortFolio Project]..CovidDeaths
ORDER BY 1,2


-- TOTAL CASES vs TOTAL DEATHS
-- LIKELIHOOD OF DYING BY COUNTRY

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS 'DeathPercentage'
FROM [PortFolio Project]..CovidDeaths
WHERE location like '%INDIA' -- CHANGE INDIA TO ANY COUNTRY
ORDER BY 1,2


-- TOTAL CASES vs POPULATION
-- PERCENTAGE OF POPULATION INFECTED WITH COVID-19 POSITIVE IN A COUNTRY

SELECT location, date, population, total_cases, (total_cases/population)*100 AS 'PercentPopulationInfected'
FROM [PortFolio Project]..CovidDeaths
WHERE location like '%states'
ORDER BY 1,2


-- COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

 SELECT location, population, MAX(total_cases) AS HighestInfectionCount, (MAX(total_cases/population))*100 AS 
 PercentPopulationInfected
 FROM [PortFolio Project]..CovidDeaths
 GROUP BY location, population
 ORDER BY PercentPopulationInfected DESC


-- COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM [PortFolio Project]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC


-- BREAKING THINGS DOWN BY CONTINENT

SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM [PortFolio Project]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- THE ABOVE QUERY IS NOT PERFECT AS NORTH AMERICA IS INCLUDING ONLY USA AND NOT CANADA AND MEXICO
-- IT CAN BE MODIFIED AS BELOW
-- CONTINENTS WITH HIGHEST DEATH COUNT

SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM [PortFolio Project]..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC


-- GLOBAL NUMBERS

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
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


-- TOTAL POPULATION vs VACCINATIONS
-- PERCENTAGE OF POPULATION THAT HAS RECEIVED AT LEAST ONE VACCINE

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


-- USING COMMON TABLE EXPRESSIONS (CTE) TO PERFORM CALCULATION ON {PARTITION BY} IN PREVIOUS QUERY

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




-- USING TEMP TABLE TO PERFORM CALCULATION ON {PARTITION BY} IN PREVIOUS QUERY

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




-- TO MAKE CHANGES TO AN EXISTING TABLE

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
