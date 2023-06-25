select *
from very_large_table
{{ limit_data_in_dev('partition_column', 10)}}