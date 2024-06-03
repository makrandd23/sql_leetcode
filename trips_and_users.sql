SELECT request_at AS DAY,
       CASE
         WHEN cnt / id IS NULL THEN 0.00
         ELSE Cast((cnt/id) AS DECIMAL(4, 2))
       end        AS 'CANCELLATION rate'
FROM   (SELECT Count(id) AS ID,
               A.request_at,
               D.cnt
        FROM   trips A
               INNER JOIN (SELECT *
                           FROM   users
                           WHERE  banned = 'No')B
                       ON A.client_id = B.users_id
               INNER JOIN (SELECT *
                           FROM   users
                           WHERE  banned = 'No')C
                       ON A.driver_id = C.users_id
               LEFT OUTER JOIN (SELECT Count(id) AS CNT,
                                       request_at
                                FROM   trips d
                                       INNER JOIN (SELECT *
                                                   FROM   users
                                                   WHERE  banned = 'No')B
                                               ON D.client_id = B.users_id
                                       INNER JOIN (SELECT *
                                                   FROM   users
                                                   WHERE  banned = 'No')C
                                               ON D.driver_id = C.users_id
                                WHERE  B.role IS NOT NULL
                                       AND C.role IS NOT NULL
                                       AND status <> 'completed'
                                GROUP  BY request_at) D
                            ON D.request_at = A.request_at
        WHERE  B.role IS NOT NULL
               AND C.role IS NOT NULL
               AND A.request_at BETWEEN "2013-10-01" AND "2013-10-03"
        GROUP  BY request_at)TEMP 
