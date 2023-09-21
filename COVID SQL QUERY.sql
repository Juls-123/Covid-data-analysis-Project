Select location,date,total_cases,new_cases,total_deaths,population
From [Portfolio project2].dbo.['covid deaths$']
where location like '%United States%'
Order by 1,2

--Death % in the United States
Select location,date,total_cases,total_deaths, CAST(total_deaths AS float) / CAST(total_cases AS float)*100 as Deathpercentage
From [Portfolio project2].dbo.['covid deaths$']
where location like '%United States%'
Order by 1,2

--Infection % in the United States
Select location,date,total_cases,population, CAST(total_cases AS float) / CAST(population AS float)*100 as InfectionRatePercentage
From [Portfolio project2].dbo.['covid deaths$']
where location like '%United States%'
Order by 1,2

--Highest Infection Rate
Select location,population,MAX(total_cases) as Highestcases, MAX(CAST(total_cases AS float) / CAST(population AS float))*100 as HighestInfectRate
From [Portfolio project2].dbo.['covid deaths$']
GROUP BY location, population
Order by HighestInfectRate desc

--Highest Death Count
Select location,MAX(total_deaths) as Highestdeaths
From [Portfolio project2].dbo.['covid deaths$']
GROUP BY location
Order by Highestdeaths desc


--Highest Death Rate
Select location,population,MAX(total_deaths) as Highestdeaths, MAX(CAST(total_deaths AS float) / CAST(total_cases AS float))*100 as HighestdeathRate
From [Portfolio project2].dbo.['covid deaths$']
GROUP BY location, population
Order by HighestdeathRate desc


--Breaking down by Continent
Select continent,MAX(total_deaths) as Highestdeaths
From [Portfolio project2].dbo.['covid deaths$']
where continent is not null
GROUP BY continent
Order by Highestdeaths desc

--Global Numbers
Select date, SUM(new_cases) as TotalNewCases, SUM(new_deaths) as TotalNewDeaths
From [Portfolio project2].dbo.['covid deaths$']
where continent is not null
Group by date
Order by 1,2

Select date, SUM(new_cases) as TotalNewCases, SUM(new_deaths) as TotalNewDeaths, SUM(CAST(new_deaths as float ))/SUM(CAST(new_cases as float)) * 100 as Globaldeathrate
From [Portfolio project2].dbo.['covid deaths$']
where continent is not null
Group by date
having SUM(new_deaths) > 0
and SUM(new_cases) > 0
Order by 1,2


--Total Population vs Vaccinations
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as totalvac
from [Portfolio project2]..['covid deaths$'] dea
join [Portfolio project2]..['covid vaccinations$'] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
Order by 1,2,3


--Using CTE 
with POPvsVAC (continent, location,date,population,new_vaccinations,totalvac)
as
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as totalvac
from [Portfolio project2]..['covid deaths$'] dea
join [Portfolio project2]..['covid vaccinations$'] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
Select *, (totalvac/population)*100 as totalvacpercent
from POPvsVAC

--Creating views 
Create view POPvsVA as 
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as totalvac
from [Portfolio project2]..['covid deaths$'] dea
join [Portfolio project2]..['covid vaccinations$'] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null