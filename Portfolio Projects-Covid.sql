select * from CovidDeaths
where continent is not null
order by 3,4;

-- select * from CovidVaccinations
-- order by 3,4;

-- Select Data that we are going to be using
select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths
where continent is not null
order by 1,2

-- Looking at Total cases VS Total Deaths
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where continent is not null
order by 1,2
-- 结论:在阿富汗,当有34人感染新冠时,就有1名感染者死亡.看最后感染者的死亡百分数大约为4%

-- Shows likelihood of dying if you contract covid in your country
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%states%'
order by 1,2
-- 结论:

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%hin%'
order by 1,2
-- 结论:

-- Looking at Total Case vs Population
-- Shows what percentage of population got covid
select location,date,population,total_cases,(total_cases/population)*100 as Percent_Population_Infected
from CovidDeaths
where location like '%states%'
order by 1,2
-- 结论:在第173项,当感染人数达到3,311,312人时,就产生1%的感染率


-- Looking at countries with Highest Infection Rate compared to Population
-- 查看与人口相比感染率最高的国家
select location,population,MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as Percent_Population_Infected
from CovidDeaths
-- where location like '%states%'
GROUP BY location,population
order by Percent_Population_Infected desc
-- 结论:Andorra,77265,13232,17.13%

-- 新建感染率的排名
SELECT
    ROW_NUMBER() OVER (ORDER BY MAX((total_cases/population))*100 DESC) AS Index_Value,
     -- 新建列排名,以MAX((total_cases/population))*100 DESC感染率来倒序排序
    location,
    population,
    MAX(total_cases),
    MAX((total_cases/population))*100 AS Percent_Population_Infected
FROM
    CovidDeaths
-- WHERE location LIKE '%states%'
GROUP BY
    location,
    population
ORDER BY
    Percent_Population_Infected DESC;

-- Showing Countries with Highest Death Count per Population
-- 显示人均死亡人数最高的国家
select location, MAX(CAST(total_deaths AS SIGNED)) AS TotalDeathCount
-- CAST 是一个函数，它接受两个参数：要转换的表达式和目标数据类型。
-- total_deaths 是要进行转换的字段或表达式。
-- AS SIGNED 指定了目标数据类型为有符号整数类型。
from CovidDeaths
where continent is not null -- 添加在这里可以排除[洲]的列表项
GROUP BY location
order by TotalDeathCount desc

-- LET’S BREAK THINGS DOWN BY CONTINENT
-- 让我们按大陆来细分
select location, MAX(CAST(total_deaths AS SIGNED)) AS TotalDeathCount
-- CAST 是一个函数，它接受两个参数：要转换的表达式和目标数据类型。
-- total_deaths 是要进行转换的字段或表达式。
-- AS SIGNED 指定了目标数据类型为有符号整数类型。
from CovidDeaths
where continent is null -- 添加在这里可以排除[洲]的列表项
GROUP BY location
order by TotalDeathCount desc

-- 哪个大陆板块死亡人数最高
select continent, MAX(CAST(total_deaths AS SIGNED)) AS TotalDeathCount
-- CAST 是一个函数，它接受两个参数：要转换的表达式和目标数据类型。
-- total_deaths 是要进行转换的字段或表达式。
-- AS SIGNED 指定了目标数据类型为有符号整数类型。
from CovidDeaths
where continent is not null -- 添加在这里可以排除[洲]的列表项
GROUP BY continent
order by TotalDeathCount desc

-- Global Numbers 全球感染数据
SELECT date, SUM(new_cases) AS 'CaseCount'
FROM CovidDeaths
WHERE continent IS NOT NULL -- AND 'CaseCount' IS NOT NULL
GROUP BY date
-- HAVING CaseCount IS NOT NULL
ORDER BY 2 desc

-- 去除掉null值的当天感染人数
SELECT DATE,location,SUM(new_cases) AS '当日感染总数' -- 将每天的新增数相加,变为当日感染总数
FROM CovidDeaths
WHERE continent IS NOT NULL AND '当日感染总数' IS NOT NULL -- 满足两个条件
GROUP BY DATE,location
HAVING 当日感染总数 IS NOT NULL -- 过滤掉是null值的列表项
ORDER BY 3 desc

SELECT DATE,SUM(new_cases),SUM(CAST(new_deaths AS SIGNED))
--  CAST()函数用于将"new_deaths"列的数据类型转换为有符号整数类型（SIGNED），以便进行求和操作。
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY DATE
ORDER BY 1,2
-- 解释:
-- 从"CovidDeaths"表中选择日期DATE、累计新病例new_cases和累计新死亡人数new_deaths，并且只包括具有非空大陆值的行。
-- 然后，它按日期对结果进行分组，并按日期和累计新病例的升序进行排序。


SELECT DATE,SUM(new_cases) as Total_Cases, SUM(CAST(new_deaths AS SIGNED)) as Total_Deaths,
      SUM(CAST(new_deaths AS SIGNED))/SUM(new_cases)*100 as DeathPercentage
--  CAST()函数用于将"new_deaths"列的数据类型转换为有符号整数类型（SIGNED），以便进行求和操作。
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY DATE
ORDER BY 1,2
-- 解释: 累计新病例new_cases和累计新死亡人数new_deaths,死亡率.
-- 2020-01-23,98,1,1.0204,当在2020-01-23,感染人数达到98人,其中死亡人数是1人,死亡率为1.0204%

SELECT SUM(new_cases) as Total_Cases, SUM(CAST(new_deaths AS SIGNED)) as Total_Deaths,
      SUM(CAST(new_deaths AS SIGNED))/SUM(new_cases)*100 as DeathPercentage
--  CAST()函数用于将"new_deaths"列的数据类型转换为有符号整数类型（SIGNED），以便进行求和操作。
FROM CovidDeaths
WHERE continent IS NOT NULL
-- GROUP BY DATE
ORDER BY 1,2
-- 解释: 算出总感染人数,总死亡人数,死亡率.


-- 查看新冠接种疫苗情况 CovidVaccinations
SELECT * FROM CovidVaccinations

-- 结合两张表内容
-- Looking at Total Population vs Vaccinations
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations as signed)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date)
           AS RollingPeopleVaccinated
        -- OVER (PARTITION BY dea.location : 使用SUM函数和OVER子句，对每个地点进行分组.
        -- ORDER BY dea.location,dea.date : 并按照地点和日期进行排序，计算累计接种人数
        -- 综述:按照地点来计数,并且按照地点与时间做由小到大的正序排序.
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

-- USE CTE
WITH PopvsVac (Continent,Location,Date,Population,New_Vaccinations,RollingPeopleVaccinated)
AS(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations as signed)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date)
           AS RollingPeopleVaccinated
        -- OVER (PARTITION BY dea.location : 使用SUM函数和OVER子句，对每个地点进行分组.
        -- ORDER BY dea.location,dea.date : 并按照地点和日期进行排序，计算累计接种人数
        -- 综述:按照地点来计数,并且按照地点与时间做由小到大的正序排序.
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- ORDER BY 2,3
# 解释:在使用CTE（公共表达式）时，
# ORDER BY子句应该放在CTE之外的主查询中，而不是放在CTE内部。
# 在代码中，将ORDER BY 2,3放在CTE内部，这会导致语法错误。
)
SELECT *,(RollingPeopleVaccinated/Population)*100 AS VaccinationRate
FROM PopvsVac
ORDER BY 2, 3

-- Temp Table
DROP Table if exists PercentPopulationVaccinated
CREATE TABLE PercentPopulationVaccinated
(
    Continent nvarchar(255),
    Location nvarchar(255),
    Date datetime,
    Population numeric,
    NewVaccinations numeric,
    RollingPeopleVaccinated numeric
)

INSERT INTO PercentPopulationVaccinated
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations as signed)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date)
           AS RollingPeopleVaccinated
        -- OVER (PARTITION BY dea.location : 使用SUM函数和OVER子句，对每个地点进行分组.
        -- ORDER BY dea.location,dea.date : 并按照地点和日期进行排序，计算累计接种人数
        -- 综述:按照地点来计数,并且按照地点与时间做由小到大的正序排序.
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
-- ORDER BY 2,3

SELECT *,(RollingPeopleVaccinated/Population)*100 AS VaccinationRate
FROM PercentPopulationVaccinated

-- Creating View to store data for later visualizations
-- 创建视图来存储数据以供以后可视化
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations as signed)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
