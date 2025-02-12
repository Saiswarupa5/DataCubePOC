select emp_name FROM source_table1 vss INNER JOIN source_table1_1 var
ON (vss.emp_id = var.emp_id)
WHERE frequency = 'MONTHLY';

INSERT INTO target_table1(col1,col2) VALUES ('hello','M');
