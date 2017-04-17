## テーマの詳細ページを表示

### ちょっとおそい

```
100回で 2.4~2.5sec
```

```
SELECT  v.id            AS v_id,
        v.user_id       AS v_uid,
        vu.name         AS v_uname,
        v.comment       as comment,
        v.point         AS p,
        v.created_at    AS v_at,
        a.id            AS a_id,
        a.user_id       AS a_uid,
        au.name         AS a_uname,
        a.text          AS a_text,
        a.created_at    AS a_at,
        t.user_id       AS t_uid,
        tu.name         AS t_uname,
        t.image_id      AS t_iid,
        t.created_at    AS t_at
        FROM votes      AS v
        LEFT JOIN answers       AS a    ON v.answer_id = a.id
        LEFT JOIN themes        AS t    ON a.theme_id = t.id
        LEFT JOIN users         AS vu   ON v.user_id = vu.id
        LEFT JOIN users         AS au   ON a.user_id = au.id
        LEFT JOIN users         AS tu   ON t.user_id = tu.id
        WHERE t.id = ?
        ORDER BY a_at, v_at;
```

### 別の方法

特に速くない

```
SELECT 
        v.id            AS v_id,
        v.user_id       AS v_uid,
        vu.name         AS v_uname,
        v.comment       as comment,
        v.point         AS p,
        v.created_at    AS v_at,
        a.id            AS a_id,
        a.user_id       AS a_uid,
        au.name         AS a_uname,
        a.text          AS a_text,
        a.created_at    AS a_at,
        t1.user_id       AS t_uid,
        tu.name         AS t_uname,
        t1.image_id      AS t_iid
        FROM (SELECT * FROM themes AS t WHERE t.id = ?) AS t1
        INNER JOIN answers AS a ON t1.id = a.theme_id
        INNER JOIN votes AS v ON a.id = v.answer_id
        INNER JOIN users AS vu ON v.user_id = vu.id
        INNER JOIN users AS au ON a.user_id = au.id
        INNER JOIN users AS tu ON t1.user_id = tu.id
        ORDER BY a_at, v_at;
```
