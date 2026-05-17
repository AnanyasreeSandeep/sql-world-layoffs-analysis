-- ==============================================================================
-- World Layoffs Exploratory Data Analysis Project
-- ==============================================================================

-- Purpose: Perform exploratory data analysis on global layoffs dataset
-- Tool: MySQL
-- Focus Areas:
--   1. Layoff trends
--   2. Industry impact
--   3. Country-wise layoffs
--   4. Time-series analysis
--   5. Company rankings
--   6. Rolling totals


--   1. Initial Data Exploration
SELECT *
FROM layoffs_staging2;

--   2. Maximum Layoffs Analysis
SELECT MAX(total_laid_off) AS max_total_laid_off, 
MAX(percentage_laid_off) AS max_percentage_laid_off
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off= 1
ORDER BY total_laid_off DESC;

--   3. Company-wise Layoffs

SELECT company, 
SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC;

SELECT MIN(date),
 MAX(date)
FROM layoffs_staging2;

--   4. Industry-wise Layoffs

SELECT industry, 
SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC;

--   5. Country-wise Layoffs

SELECT country,
 SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY country
ORDER BY SUM(total_laid_off) DESC;

--   6. Yearly Layoff Trends

SELECT YEAR(`date`) AS layoff_year,
SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(date)
ORDER BY YEAR(date) DESC;

--   7. Monthly Rolling Layoff Analysis
SELECT SUBSTRING(date,1,7) as dates, 
SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(date,1,7) IS NOT NULL
GROUP BY dates
ORDER BY dates ASC;

WITH monthly_layoffs AS
( SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(date,1,7) IS NOT NULL
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates,
 total_laid_off,
 SUM(total_laid_off) OVER (ORDER BY dates) AS rolling_total_layoffs
FROM monthly_layoffs;

--   8. Top Companies by Year

SELECT company, 
SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC;

SELECT company,
 year(`date`), 
 SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, year(`date`)
ORDER BY SUM(total_laid_off) DESC;

WITH Company_year(company,years, total_laid_off) AS
(SELECT company, year(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, year(`date`)
), company_year_rankings AS
(SELECT *, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) as Ranking
FROM Company_year
WHERE years IS NOT NULL)
SELECT * 
FROM company_year_rankings
WHERE Ranking<=5;

-- 9. Identify industries most affected by layoffs
SELECT 
    industry,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_layoffs DESC;