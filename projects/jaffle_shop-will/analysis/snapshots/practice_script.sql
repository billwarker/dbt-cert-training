-- 1. create an initial table

create or replace table `jaffle-shop-will-dev.analytics.mock_orders` (
    order_id INT64,
    status STRING,
    created_at date,
    updated_at date
);


-- 2. insert initial values
insert into `jaffle-shop-will-dev.analytics.mock_orders` (order_id, status, created_at, updated_at)
values (1, 'delivered', '2020-01-01', '2020-01-04'),
       (2, 'shipped', '2020-01-02', '2020-01-04'),
       (3, 'shipped', '2020-01-03', '2020-01-04'),
       (4, 'processed', '2020-01-04', '2020-01-04');


-- dbt snapshot (run 1)


-- 3. recreate table
create or replace table `jaffle-shop-will-dev.analytics.mock_orders` (
    order_id INT64,
    status STRING,
    created_at date,
    updated_at date
);

-- 4. new values for the snapshot to track
insert into `jaffle-shop-will-dev.analytics.mock_orders` (order_id, status, created_at, updated_at)
values (1, 'delivered', '2020-01-01', '2020-01-05'),
       (2, 'delivered', '2020-01-02', '2020-01-05'),
       (3, 'delivered', '2020-01-03', '2020-01-05'),
       (4, 'delivered', '2020-01-04', '2020-01-05');

-- dbt snapshot (run 2)

-- queries:

-- get the last updated SCD record
SELECT *
FROM `jaffle-shop-will-dev.snapshots.mock_orders`
WHERE
  dbt_valid_to IS NULL