CREATE DATABASE weather_report;
USE weather_report;
CREATE TABLE weather_report.weather_data (
    Date_  DATE,
    Average_temperature double,
    Average_humidity double,
    Average_dewpoint double,
    Average_barometer double,
    Average_windspeed double,
    Average_gust_speed double,
    Average_direction double,
    Rainfall_for_month double,
    Rainfall_for_year double,
    Maximum_rain_per_minute double,
    Maximum_temperature double,
    Minimum_temperature double,
    Maximum_humidity double,
    Minimum_humidity double,
    Maximum_pressure double,
    Minimum_pressure double,
    Maximum_wind_speed double,
    Maximum_gust_speed double,
    Maximum_heat_index double,
    Month_ double,
    Diff_pressure double,
    PRIMARY KEY (Date_) );
    SELECT * FROM weather_data;
    describe weather_data;
    
    /***********************************************************************************
   1.Give the count of the minimum number of days for the time when temperature reduced
*****************************************************************************************/
SELECT COUNT(*)
FROM (
  SELECT w1.Date_, w1.Minimum_temperature, w2.Minimum_temperature AS Prev_temp
  FROM weather_data w1
  JOIN weather_data w2
  ON w1.Date_ = w2.Date_ + INTERVAL 1 DAY
  WHERE w1.Minimum_temperature < w2.Minimum_temperature
) subq;    
   /***********************************************************************************/
   /***********************************************************************************/
   /***2.Find the temperature as Cold / hot by using the case and avg of values of the given data set
   ********************************************************************************************/
   SELECT 
  AVG(Average_temperature) AS Average_Temperature,
  CASE 
    WHEN AVG(Average_temperature) < 10 THEN 'Cold'
    WHEN AVG(Average_temperature) >= 10 THEN 'Hot'
  END AS Temperature_Classification
FROM weather_data;
/************************************************************************
**************************************************************************/
/** 3. Can you check for all 4 consecutive days when the temperature was below 30 Fahrenheit
*****************************************************************************************/
SELECT w1.Date_
FROM weather_data w1
JOIN weather_data w2 ON w1.Date_ = w2.Date_ + INTERVAL 1 DAY
JOIN weather_data w3 ON w1.Date_ = w3.Date_ + INTERVAL 2 DAY
JOIN weather_data w4 ON w1.Date_ = w4.Date_ + INTERVAL 3 DAY
WHERE w1.Average_temperature < 30 AND w2.Average_temperature < 30 
  AND w3.Average_temperature < 30 AND w4.Average_temperature < 30;
  /***************************************************************************************
  ***************************************************************************************/
  /*** 4. Can you find the maximum number of days for which temperature dropped
  **********************************************************************************/
WITH cte AS (
   SELECT 
     Date_,
     Minimum_temperature,
     ROW_NUMBER() OVER (ORDER BY Date_) AS rn
   FROM weather_data
 )
 SELECT 
   MAX(c1.rn) - MIN(c2.rn) + 1
 FROM cte c1
 JOIN cte c2
 ON c1.rn + 1 = c2.rn
 WHERE c1.Minimum_temperature > c2.Minimum_temperature;
 /************************************************************************************************
 ***************************************************************************************************/
 /***5. Can you find the average of average humidity from the dataset 
**************************************************************************************************/
SELECT AVG(Average_humidity)
FROM weather_data
GROUP BY Date_
ORDER BY Date_;
/****************************************************************************************************
*******************************************************************************************************/
/****6. Use the GROUP BY clause on the Date column and make a query to fetch details for average windspeed 
*********************************************************************************************************/
SELECT 
  Date_, 
  AVG(Average_windspeed) AS avg_windspeed
FROM weather_data
GROUP BY Date_
ORDER BY Date_;
/*******************************************************************************************************
*******************************************************************************************************/
/****7. Please add the data in the dataset for 2034 and 2035 as well as forecast predictions for these years 
**************************************************************************************************************/
WITH forecast AS (
  SELECT
    Date_,
    Average_temperature,
    AVG(Average_temperature) OVER (ORDER BY Date_ ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS avg_temp_2
  FROM weather_data
),
forecast_2034_2035 AS (
  SELECT
    DATE_ADD(Date_, INTERVAL 1 YEAR) AS Date_,
    avg_temp_2 AS Average_temperature
  FROM forecast
)
SELECT *
FROM forecast_2034_2035;
/*****************************************************************************************************
****************************************************************************************************/
/********** 8.If the maximum gust speed increases from 55mph, fetch the details for the next 4 days
***************************************************************************************************/
SELECT *
FROM weather_data
WHERE Date_ BETWEEN (SELECT MIN(Date_) FROM weather_data WHERE Maximum_gust_speed > 55) AND DATE_ADD((SELECT MIN(Date_) FROM weather_data WHERE Maximum_gust_speed > 55), INTERVAL 4 DAY);
/***********************************************************************************************************************************
************************************************************************************************************************************/
/***** 9. Find the number of days when the temperature went below 0 degrees Celsius 
********************************************************************************************/
SELECT COUNT(*)
FROM weather_data
WHERE Average_temperature < 0;
/***************************************************************************************************
*******************************************************************************************************/
/***** 10. Create another table with a “Foreign key” relation with the existing given data set.
********************************************************************************************************/
CREATE TABLE weather_data_2 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    weather_data_id DATE,
    some_other_column VARCHAR(255),
    FOREIGN KEY (weather_data_id) REFERENCES weather_data(Date_));
    /****************************************************************************************************
    ****************************************************************************************************/
    
    

    
    
    
    
    
    
    
    
    
    