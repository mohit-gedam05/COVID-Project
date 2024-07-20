SELECT *
FROM [Covid Deaths]
ORDER BY 3,4

SELECT *
FROM [Covid Vaccinations]
ORDER BY 3,4

SELECT Location, Date, total_cases, new_cases, total_deaths, population
FROM [Covid Deaths]
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM [Covid Deaths]
WHERE Location LIKE '%India%'
ORDER BY 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of Population got COVID

SELECT Location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage, Population
FROM [Covid Deaths]
WHERE Location = 'India'
ORDER BY 1,2


-- Looking at countries with highest infection rate compared to population
SELECT Location, Population, MAX(total_cases)as Highestinfectioncount, max((total_cases/population))*100 as Percentpopulationinfected
FROM [Covid Deaths]
-- WHERE Location = 'India'
GROUP BY Location, Population
ORDER BY Percentpopulationinfected DESC

-- Showing Countries with Highest Death count per population

SELECT continent, MAX(Total_deaths) as Totaldeathcount
FROM [Covid Deaths]
-- Where Location = 'India'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Totaldeathcount DESC

-- Global Numbers

SELECT date, SUM(new_cases), SUM(new_deaths), SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM [Covid Deaths]
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

-- Looking at total population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM [Covid Deaths] dea
JOIN [Covid Vaccinations] vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

-- Total Vaccination by countries
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (partition BY dea.location ORDER BY dea.location,dea.date) as Cumulative_vaccinations
FROM [Covid Deaths] dea
JOIN [Covid Vaccinations] vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


-- USE CTE
WITH popvsVac (Continent, Location, Date, Population, New_vaccinations, Cumulative_vaccinations)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (partition BY dea.location ORDER BY dea.location,dea.date) as Cumulative_vaccinations
FROM [Covid Deaths] dea
JOIN [Covid Vaccinations] vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
 -- ORDER BY 2,3 
)
SELECT *, (Cumulative_vaccinations/Population)*100
FROM popvsVac

