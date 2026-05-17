-- ==============================================================================
-- World Layoffs Data Cleaning Project
-- ==============================================================================

-- Purpose: Clean and prepare layoffs dataset for analysis
-- Tool: MySQL
-- Steps:
--   1. Create staging tables
--   2. Remove duplicates
--   3. Standardize text fields
--   4. Convert date column
--   5. Handle NULL/blank values
--   6. Remove unusable records

--   1. Create staging tables
SELECT * 
FROM world_layoffs.layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

--   2. Remove duplicates
SELECT *,
ROW_NUMBER() OVER( PARTITION BY company, industry, total_laid_off, percentage_laid_off,`date`) as row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER( PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num>1;

SELECT *
FROM layoffs_staging
WHERE company= 'Yahoo';

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
   `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER( PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2;

DELETE
FROM layoffs_staging2
WHERE row_num>1;

--   3. Standardize text fields

-- Remove leading and trailing whitespace from company names
SELECT DISTINCT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;

-- Noticed that Crypto had 2 other names like Cryptocurrency and Crypto. Updated it to look uniform
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Standardize location names with encoding issues
SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY location;

UPDATE layoffs_staging2
SET location = 
CASE
	WHEN location= 'DÃ¼sseldorf' THEN 'Düsseldorf' 
	WHEN location= 'FlorianÃ³polis' THEN 'Florianópolis' 
	WHEN location= 'MalmÃ¶' THEN 'Malmo'
	ELSE location
END;
-- Noticed Duplicate of United states and corrected it
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY country;

UPDATE layoffs_staging2
SET country ='United States'
WHERE country LIKE 'United States%';

SELECT * 
FROM layoffs_staging2;

--   4. Convert date column

SELECT `date`
FROM layoffs_staging2
ORDER BY DATE;

UPDATE layoffs_staging2
SET `date` = CASE
    WHEN `date` LIKE '%/%/%' THEN STR_TO_DATE(`date`, '%m/%d/%Y')
    ELSE `date`
END;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;

--   5. Handle NULL/blank values

UPDATE layoffs_staging2
SET industry=NULL 
WHERE industry ='';

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
or industry ='';

-- Review Airbnb records before populating missing industry values
SELECT *
FROM layoffs_staging2
WHERE company= 'Airbnb';

UPDATE layoffs_staging2 t1 
JOIN layoffs_staging2 t2 
	ON t1.company=t2.company 
SET t1.industry=t2.industry
 WHERE t1.industry IS NULL 
 AND t2.industry IS NOT NULL;
 
 SELECT DISTINCT t1.industry, t2.industry
 FROM layoffs_staging2 t1
 JOIN layoffs_staging2 t2 
	ON t1.company=t2.company 
 WHERE t1.industry IS NULL 
 AND t2.industry IS NOT NULL;

--   6. Remove unusable records
SELECT * 
FROM layoffs_staging2;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Delete records where both total_laid_off and percentage_laid_off are NULL
DELETE FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

--   7. Final validation

SELECT COUNT(*) AS cleaned_row_count
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
LIMIT 10;








