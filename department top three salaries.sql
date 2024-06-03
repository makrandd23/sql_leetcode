SELECT B.NAME AS DEPARTMENT,
       A.NAME AS EMPLOYEE,
       A.salary
FROM   (SELECT NAME,
               salary,
               departmentid,
               Dense_rank()
                 OVER (
                   partition BY departmentid
                   ORDER BY salary DESC) AS RNK
        FROM   employee) A
       LEFT OUTER JOIN department B
                    ON B.id = A.departmentid
WHERE  A.rnk <= 3 
