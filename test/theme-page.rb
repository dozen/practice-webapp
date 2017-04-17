require 'mysql2'

c = Mysql2::Client.new(database: "ogiri")

s1 = c.prepare(<<EOQ
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
EOQ
)

ids = []
r = Random.new
(0...100).each do |_|
	ids << r.rand(1..4000)
end

ids.each do |theme_id|
	s1.execute(theme_id)
end
