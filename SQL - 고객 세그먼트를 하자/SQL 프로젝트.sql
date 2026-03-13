-- 컬럼 출력
SELECT *
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
LIMIT 10;

-- 10개 행 출력
SELECT COUNT(*) AS total_rows
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`;

-- 데이터 수 세기
SELECT
  COUNT(InvoiceNo)    AS InvoiceNo_cnt,
  COUNT(StockCode)    AS StockCode_cnt,
  COUNT(Description)  AS Description_cnt,
  COUNT(Quantity)     AS Quantity_cnt,
  COUNT(InvoiceDate)  AS InvoiceDate_cnt,
  COUNT(UnitPrice)    AS UnitPrice_cnt,
  COUNT(CustomerID)   AS CustomerID_cnt,
  COUNT(Country)      AS Country_cnt
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`;

-- 컬럼 별 누락된 값의 비율 계산
SELECT
  541909 - COUNT(InvoiceNo)   AS InvoiceNo_null,
  541909 - COUNT(StockCode)   AS StockCode_null,
  541909 - COUNT(Description) AS Description_null,
  541909 - COUNT(Quantity)    AS Quantity_null,
  541909 - COUNT(InvoiceDate) AS InvoiceDate_null,
  541909 - COUNT(UnitPrice)   AS UnitPrice_null,
  541909 - COUNT(CustomerID)  AS CustomerID_null,
  541909 - COUNT(Country)     AS Country_null
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`;

SELECT
  'InvoiceNo' AS column_name,
  ROUND(SUM(CASE WHEN InvoiceNo IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`

UNION ALL

SELECT
  'StockCode' AS column_name,
  ROUND(SUM(CASE WHEN StockCode IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`

UNION ALL

SELECT
  'Description' AS column_name,
  ROUND(SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`

UNION ALL

SELECT
  'Quantity' AS column_name,
  ROUND(SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`

UNION ALL

SELECT
  'InvoiceDate' AS column_name,
  ROUND(SUM(CASE WHEN InvoiceDate IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`

UNION ALL

SELECT
  'UnitPrice' AS column_name,
  ROUND(SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`

UNION ALL

SELECT
  'CustomerID' AS column_name,
  ROUND(SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`

UNION ALL

SELECT
  'Country' AS column_name,
  ROUND(SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`;


-- 결측치 비율 계산. 위와 다른 방법으로 
SELECT column_name, ROUND((total - column_value) / total * 100, 2) AS missing_percentage
FROM
(
    SELECT 'InvoiceNo' AS column_name, COUNT(InvoiceNo) AS column_value, COUNT(*) AS total FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data` UNION ALL
    SELECT 'StockCode' AS column_name, COUNT(StockCode) AS column_value, COUNT(*) AS total FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data` UNION ALL
    SELECT 'Description' AS column_name, COUNT(Description) AS column_value, COUNT(*) AS total FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data` UNION ALL
    SELECT 'Quantity' AS column_name, COUNT(Quantity) AS column_value, COUNT(*) AS total FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data` UNION ALL
    SELECT 'InvoiceDate' AS column_name, COUNT(InvoiceDate) AS column_value, COUNT(*) AS total FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data` UNION ALL
    SELECT 'UnitPrice' AS column_name, COUNT(UnitPrice) AS column_value, COUNT(*) AS total FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data` UNION ALL
    SELECT 'CustomerID' AS column_name, COUNT(CustomerID) AS column_value, COUNT(*) AS total FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data` UNION ALL
    SELECT 'Country' AS column_name, COUNT(Country) AS column_value, COUNT(*) AS total FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
) AS column_data;

-- Description 결측치 제거
SELECT DISTINCT Description
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
WHERE StockCode = '85123A';

-- CustomerID 결측치 제거
DELETE FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
WHERE CustomerID IS NULL;

-- 중복값 확인
SELECT COUNT(*) AS duplicate_cnt
FROM (
  SELECT CONCAT(
    CAST(InvoiceNo AS STRING), 
    CAST(StockCode AS STRING), 
    CAST(Description AS STRING), 
    CAST(Quantity AS STRING), 
    CAST(InvoiceDate AS STRING), 
    CAST(UnitPrice AS STRING), 
    CAST(CustomerID AS STRING), 
    CAST(Country AS STRING)
  )
  FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
  GROUP BY InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country
  HAVING COUNT(*) > 1
);

-- 중복값 제거
CREATE OR REPLACE TABLE `project-91ffa091-d786-4187-b0d.Segmentation_260310.data` AS
SELECT DISTINCT *
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`;

-- InvoiceNo 살펴보기
SELECT COUNT(DISTINCT InvoiceNo) AS unique_invoice_cnt
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`;

-- 고유한 행 100개 출력
SELECT DISTINCT InvoiceNo
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
LIMIT 100;

-- C로 시작하는 행 100개 출력
SELECT * 
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
WHERE InvoiceNo LIKE 'C%'
LIMIT 100;

-- 구매 상태가 Cancled인 데이터의 비율 확인
SELECT ROUND(SUM(CASE WHEN InvoiceNo LIKE 'C%' THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) AS cancel_rate
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`;

-- StockCode 살펴보기
SELECT COUNT(DISTINCT StockCode) AS unique_stockcode_cnt
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`;

-- 등장 빈도 출력
SELECT StockCode, COUNT(*) AS sell_cnt 
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
GROUP BY StockCode
ORDER BY sell_cnt DESC
LIMIT 10;

-- 숫자가 0~1개인 값에는 어떤 코드가 있는지 확인
SELECT DISTINCT StockCode, number_count
FROM (
  SELECT StockCode,
    LENGTH(StockCode) - LENGTH(REGEXP_REPLACE(StockCode, r'[0-9]', '')) AS number_count
  FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
) 
WHERE number_count <= 1;

-- 해당 코드 값을 가지고 있는 데이터 수의 비율
SELECT ROUND(COUNT(*) / (SELECT COUNT(*) FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`) * 100, 2) AS percentage
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
WHERE StockCode IN (
  SELECT DISTINCT StockCode
  FROM (
    SELECT StockCode,
      LENGTH(StockCode) - LENGTH(REGEXP_REPLACE(StockCode, r'[0-9]', '')) AS number_count
    FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
  )
  WHERE number_count <= 1
);

-- 제품과 관련되지 않은 거래기록 제거
DELETE FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
WHERE StockCode IN (
  SELECT DISTINCT StockCode
  FROM (
    SELECT StockCode,
      LENGTH(StockCode) - LENGTH(REGEXP_REPLACE(StockCode, r'[0-9]', '')) AS number_count
    FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
  )
  WHERE number_count <= 1
);

-- Description 살펴보기
SELECT Description, COUNT(*) AS description_cnt
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
GROUP BY Description
ORDER BY description_cnt DESC
LIMIT 30;

-- 대소문자 혼합 행 확인
SELECT DISTINCT Description
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
WHERE REGEXP_CONTAINS(Description, r'[a-z]');

-- 서비스 관련 정보를 포함하는 행 제거
DELETE
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
WHERE
  REGEXP_CONTAINS(Description, r'[a-z]');


-- 대소문자를 혼합하고 있는 데이터를 대문자로 표준화
CREATE OR REPLACE TABLE `project-91ffa091-d786-4187-b0d.Segmentation_260310.data` AS
SELECT
  * EXCEPT (Description),
  UPPER(Description) AS Description
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`;


-- UnitPrice 살펴보기
SELECT 
  MIN(UnitPrice) AS min_price, 
  MAX(UnitPrice) AS max_price, 
  AVG(UnitPrice) AS avg_price
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`; 

-- 최솟값, 최댓값, 평균
SELECT 
  COUNT(*) AS cnt_quantity, 
  MIN(Quantity) AS min_quantity, 
  MAX(Quantity) AS max_quantity, 
  AVG(Quantity) AS avg_quantity
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
WHERE UnitPrice = 0;

-- UnitPrice=0 행 제거
CREATE OR REPLACE TABLE `project-91ffa091-d786-4187-b0d.Segmentation_260310.data` AS
SELECT *
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
WHERE UnitPrice > 0;

-- InvoiceDate 컬럼을 연월일 자료형으로 변경하기
SELECT DATE(InvoiceDate) AS InvoiceDay, *
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`;

-- 가장 최근 구매 일자를 MAX() 함수로 찾아보기
SELECT 
   MAX(DATE(InvoiceDate)) OVER () AS most_recent_date, 
   DATE(InvoiceDate) AS InvoiceDay,
   *
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`;

-- 유저 별로 가장 큰 InvoiceDay를 찾아서 가장 최근 구매일로 저장하기
SELECT 
  CustomerID,
  MAX(DATE(InvoiceDate)) AS InvoiceDay
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
GROUP BY CustomerID;

-- 가장 최근 일자(most_recent_date)와 유저별 마지막 구매일(InvoiceDay)간의 차이를 계산하기
SELECT 
  CustomerID, 
  EXTRACT(DAY FROM MAX(InvoiceDay) OVER () - InvoiceDay) AS recency
FROM (
  SELECT 
    CustomerID,
    MAX(DATE(InvoiceDate)) AS InvoiceDay
  FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
  GROUP BY CustomerID
);

-- 최종 데이터 셋에 필요한 데이터들을 각각 정제해서 이어붙이고 지금까지의 결과를 user_r이라는 이름의 테이블로 저장하기
CREATE OR REPLACE TABLE `project-91ffa091-d786-4187-b0d.Segmentation_260310.user_r` AS
SELECT 
  CustomerID, 
  EXTRACT(DAY FROM MAX(InvoiceDay) OVER () - InvoiceDay) AS recency
FROM (
  SELECT 
    CustomerID,
    MAX(DATE(InvoiceDate)) AS InvoiceDay
  FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
  GROUP BY CustomerID
);

-- 고객마다 고유한 InvoiceNo의 수를 세어보기
SELECT
  CustomerID,
  COUNT(DISTINCT InvoiceNo) AS purchase_cnt
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
GROUP BY CustomerID;

-- 각 고객 별로 구매한 아이템의 총 수량 더하기
SELECT
  CustomerID,
  SUM(Quantity) AS item_cnt
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
GROUP BY CustomerID;

-- 전체 거래 건수 계산와 구매한 아이템의 총 수량 계산의 결과를 합쳐서 user_rf라는 이름의 테이블에 저장하기
CREATE OR REPLACE TABLE `project-91ffa091-d786-4187-b0d.Segmentation_260310.user_rf` AS

-- (1) 전체 거래 건수 계산
WITH purchase_cnt AS (
  SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS purchase_cnt
  FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
  GROUP BY CustomerID
),

-- (2) 구매한 아이템 총 수량 계산
item_cnt AS (
  SELECT
    CustomerID,
    SUM(Quantity) AS item_cnt
  FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
  GROUP BY CustomerID
)

-- 기존의 user_r에 (1)과 (2)를 통합
SELECT
  pc.CustomerID,
  pc.purchase_cnt,
  ic.item_cnt,
  ur.recency
FROM purchase_cnt AS pc
JOIN item_cnt AS ic
  ON pc.CustomerID = ic.CustomerID
JOIN `project-91ffa091-d786-4187-b0d.Segmentation_260310.user_r` AS ur
  ON pc.CustomerID = ur.CustomerID;


-- 고객별 총 지출액 계산
SELECT
  CustomerID,
  ROUND(SUM(Quantity * UnitPrice), 1) AS user_total
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
GROUP BY CustomerID;

-- 고객별 평균 거래 금액 계산
CREATE OR REPLACE TABLE `project-91ffa091-d786-4187-b0d.Segmentation_260310.user_rfm` AS
SELECT
  rf.CustomerID AS CustomerID,
  rf.purchase_cnt,
  rf.item_cnt,
  rf.recency,
  ut.user_total,
  ROUND(ut.user_total / rf.purchase_cnt, 2) AS user_average
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.user_rf` rf
LEFT JOIN (
  -- 고객별 총 지출액
  SELECT
    CustomerID,
    ROUND(SUM(Quantity * UnitPrice), 1) AS user_total
  FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
  GROUP BY CustomerID
) ut
ON rf.CustomerID = ut.CustomerID;

-- 최종 rfm 출력
SELECT *
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.user_rfm`;


-- 구매하는 제품의 다양성
CREATE OR REPLACE TABLE `project-91ffa091-d786-4187-b0d.Segmentation_260310.user_data` AS
WITH unique_products AS (
  SELECT
    CustomerID,
    COUNT(DISTINCT StockCode) AS unique_products
  FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
  GROUP BY CustomerID
)
SELECT ur.*, up.* EXCEPT (CustomerID)
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.user_rfm` AS ur
JOIN unique_products AS up
ON ur.CustomerID = up.CustomerID;

-- 평균 구매 주기
CREATE OR REPLACE TABLE `project-91ffa091-d786-4187-b0d.Segmentation_260310.user_data` AS 
WITH purchase_intervals AS (
  -- (2) 고객 별 구매와 구매 사이의 평균 소요 일수
  SELECT
    CustomerID,
    CASE WHEN ROUND(AVG(interval_), 2) IS NULL THEN 0 ELSE ROUND(AVG(interval_), 2) END AS average_interval
  FROM (
    -- (1) 구매와 구매 사이에 소요된 일수
    SELECT
      CustomerID,
      DATE_DIFF(InvoiceDate, LAG(InvoiceDate) OVER (PARTITION BY CustomerID ORDER BY InvoiceDate), DAY) AS interval_
    FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
    WHERE CustomerID IS NOT NULL
  )
  GROUP BY CustomerID
)
SELECT u.*, pi.* EXCEPT (CustomerID)
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.user_data` AS u
LEFT JOIN purchase_intervals AS pi
ON u.CustomerID = pi.CustomerID;

-- 구매 취소 경향성
CREATE OR REPLACE TABLE `project-91ffa091-d786-4187-b0d.Segmentation_260310.user_data` AS
WITH TransactionInfo AS (
  SELECT
    CustomerID,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN InvoiceNo LIKE 'C%' THEN 1 ELSE 0 END) AS cancel_frequency
  FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.data`
  GROUP BY CustomerID
)
SELECT 
  u.*, 
  t.* EXCEPT(CustomerID),
  ROUND(t.cancel_frequency / t.total_transactions * 100, 2) AS cancel_rate
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.user_data` AS u
LEFT JOIN TransactionInfo AS t
ON u.CustomerID = t.CustomerID;

-- 최종 출력
SELECT *
FROM `project-91ffa091-d786-4187-b0d.Segmentation_260310.user_data`;