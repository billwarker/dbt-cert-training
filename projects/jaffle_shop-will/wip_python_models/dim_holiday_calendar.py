import pandas as pd
import holidays

def get_holiday(date_col):
    canadian_holidays = holidays.country_holidays('CA')
    if date_col in canadian_holidays:
        return canadian_holidays.get(date_col)

def dim_holiday_calendar(dbt, session):

    dbt.config(materialized ="table")
    df = dbt.ref("dim_business_dates")
    df['holiday'] = df['date_day'].apply(get_holiday)

    return df