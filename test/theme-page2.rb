require 'mysql2'

c = Mysql2::Client.new(database: "ogiri")

s1 = c.prepare(<<EOQ
SELECT 
        v.id            AS v_id,
        v.user_id       AS v_uid,
        vu.name         AS v_uname,
        v.comment       AS comment,
        v.point         AS p,
        v.created_at    AS v_at,
        a.id            AS a_id,
        a.user_id       AS a_uid,
        au.name         AS a_uname,
        a.text          AS a_text,
        a.created_at    AS a_at,
        t1.user_id      AS t_uid,
        tu.name         AS t_uname,
        t1.image_id     AS t_iid,
	t1.created_at	AS t_at
        FROM (SELECT * FROM themes AS t WHERE t.id = ?) AS t1
        INNER JOIN answers  AS a    ON t1.id      = a.theme_id
        INNER JOIN votes    AS v    ON a.id       = v.answer_id
        INNER JOIN users    AS vu   ON v.user_id  = vu.id
        INNER JOIN users    AS au   ON a.user_id  = au.id
        INNER JOIN users    AS tu   ON t1.user_id = tu.id
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
