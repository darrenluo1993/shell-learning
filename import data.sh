#!/bin/bash

echo -e "1,aa,11\n##---#\n2,bb,22\n \n3,cc,33\n">data.txt

# 1. 处理 data.txt 文件
sed -i '/^#/d' data.txt # 删除以#开始的行
sed -i '/^$/d' data.txt # 删除空行
sed -i '/^ $/d' data.txt # 删除只有空格的空行
sed -i 's/,/|/g' data.txt # 替换逗号为竖线
sed -i 's/$/|/' data.txt # 在每一行末尾增加竖线

# 2. 清空 appdbtemp1 表
sqlplus -S unnamed/abcd1234@helowin <<EOF
TRUNCATE TABLE appdbtemp1;
EXIT;
EOF

# 3. 导入 data.txt 到 appdbtemp1
echo "LOAD DATA INFILE 'data.txt' INTO TABLE appdbtemp1 FIELDS TERMINATED BY '|' (C1, C2, C3)">data.ctl
sqlldr unnamed/abcd1234@helowin control=data.ctl | grep "Commit point reached"

# 4. 验证记录数量
DATA_LINE_CNT=`cat data.txt | wc -l`
sqlplus -S unnamed/abcd1234@helowin <<EOF
SELECT
	case
		when COUNT(*) = $DATA_LINE_CNT then
			'true'
		else
			'false'
	end IS_EQUAL
FROM
	appdbtemp1;
EXIT;
EOF
unset DATA_LINE_CNT

# 5. 清空 appdbtemp2 表
sqlplus -S unnamed/abcd1234@helowin <<EOF
TRUNCATE TABLE appdbtemp2;
EXIT;
EOF

# 6. 向 appdbtemp2 添加特定记录
sqlplus -S unnamed/abcd1234@helowin <<EOF
INSERT INTO appdbtemp2 (C1, C2, C3) VALUES ('2', 'BB', '2b');
COMMIT;
SELECT * FROM appdbtemp2;
EXIT;
EOF

# 7. 根据 appdbtemp1 更新 appdbtemp2
sqlplus -S unnamed/abcd1234@helowin <<EOF
MERGE INTO
	appdbtemp2 t2
USING
	appdbtemp1 t1
ON
	(t2.C1 = t1.C1)
WHEN MATCHED THEN
	UPDATE SET t2.C3 = t1.C3
WHEN NOT MATCHED THEN
	INSERT (C1, C2, C3) VALUES (t1.C1, t1.C2, t1.C3);
COMMIT;
SELECT * FROM appdbtemp2;
EXIT;
EOF

# 8. 删除 appdbtemp2 中 C1='2' 的记录
sqlplus -S unnamed/abcd1234@helowin <<EOF
DELETE FROM appdbtemp2 WHERE C1 = '2';
COMMIT;
SELECT * FROM appdbtemp2;
EXIT;
EOF

# 9. 根据 data.txt 更新 appdbtemp2
while IFS=\| read -r C1 C2 C3; do
# 使用 sqlplus 执行 SQL 语句
sqlplus -S unnamed/abcd1234@helowin <<EOF
MERGE INTO
	appdbtemp2 t2
USING
	DUAL
ON
	(t2.C1 = '$C1')
WHEN MATCHED THEN
	UPDATE SET t2.C3 = '$C3'
WHEN NOT MATCHED THEN
	INSERT (C1, C2, C3) VALUES ('$C1', '$C2', '$C3');
COMMIT;
SELECT * FROM appdbtemp2;
EXIT;
EOF
done<data.txt