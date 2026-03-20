/*
A comparison of CTEs vs table subqueries vs temp tables
*/

-- Temp tables
Drop table if exists #PatientByDate
SELECT
    ps.AdmittedDate    
        , COUNT(*) AS NumberOfPatientsEachDay
        , SUM(ps.Tariff) AS TotalTariffEachDay
INTO #PatientByDate
FROM PatientStay ps
GROUP BY ps.AdmittedDate;

Select *
from #PatientByDate;


SELECT
    pbd.AdmittedDate
    , pbd.NumberOfPatientsEachDay
    , pbd.TotalTariffEachDay
    , SUM(pbd.TotalTariffEachDay) OVER (ORDER BY pbd.AdmittedDate) AS RunningTariff
    , SUM(pbd.NumberOfPatientsEachDay) OVER (ORDER BY pbd.AdmittedDate) AS CumulativePatients
FROM #PatientByDate pbd
ORDER BY pbd.AdmittedDate;

-- Table subqueries

Select
    pbd.AdmittedDate
    , pbd.NumberOfPatientsEachDay
    , pbd.TotalTariffEachDay
    , SUM(pbd.TotalTariffEachDay) OVER (ORDER BY pbd.AdmittedDate) AS RunningTariff
    , SUM(pbd.NumberOfPatientsEachDay) OVER (ORDER BY pbd.AdmittedDate) AS CumulativePatients
FROM
    (
 SELECT
        ps.AdmittedDate    
        , COUNT(*) AS NumberOfPatientsEachDay
        , SUM(ps.Tariff) AS TotalTariffEachDay
    FROM PatientStay ps
    GROUP BY ps.AdmittedDate
    ) as pbd;

-- CTEs

;WITH
    CTE (admitteddate, numberofpatientseachday, totaltariffeachday)
    as
    (
        SELECT
            ps.AdmittedDate    
            , COUNT(*) AS NumberOfPatientsEachDay
            , SUM(ps.Tariff) AS TotalTariffEachDay
        FROM PatientStay ps
        GROUP BY ps.AdmittedDate
    ),
    CTE2
    as
    (
        select *
        from CTE
    )
Select
    cte2.AdmittedDate
        , cte2.NumberOfPatientsEachDay
        , cte2.TotalTariffEachDay
        , SUM(cte2.TotalTariffEachDay) OVER (ORDER BY cte2.AdmittedDate) AS RunningTariff
        , SUM(cte2.NumberOfPatientsEachDay) OVER (ORDER BY cte2.AdmittedDate) AS CumulativePatients
from cte2
where cte2.AdmittedDate > '2023-04-01'
order by cte2.AdmittedDate


;WITH
    cte
    AS
    (
        SELECT
            ps.AdmittedDate    
            , COUNT(*) AS NumberOfPatientsEachDay
            , SUM(ps.Tariff) AS TotalTariffEachDay
        FROM PatientStay ps
        GROUP BY ps.AdmittedDate

    )
SELECT
    cte.AdmittedDate
    , cte.NumberOfPatientsEachDay
    , cte.TotalTariffEachDay
    , SUM(cte.TotalTariffEachDay) OVER (ORDER BY cte.AdmittedDate) AS RunningTariff
    , SUM(cte.NumberOfPatientsEachDay) OVER (ORDER BY cte.AdmittedDate) AS CumulativePatients
FROM cte
ORDER BY cte.AdmittedDate;
 
 