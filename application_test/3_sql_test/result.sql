WITH second_score as (
    -- 取得擁有第二大score的學生名
    SELECT
        name
    FROM (
        -- 使用row_number對score由大到小排序，並給一個號碼
        SELECT
            score.name
            ROW_NUMBER() OVER ( ORDER BY score.score DESC) as rownum
        FROM
            student.score as score
    )
    WHERE
        rownum = 2
)
-- 先filter出我們要查詢的學生後，再去join class table取得此學生在哪一個班級，這樣子做可以減少join的loading
SELECT
    class
FROM
    student.class as class
INNER JOIN
    second_score as score
ON
    class.name = score.name
