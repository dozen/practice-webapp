SELECT	v.id		AS v_id,
	v.user_id	AS v_uid,
	vu.name		AS v_uname,
	v.comment	as comment,
	v.point		AS p,
	v.created_at	AS v_at,
	a.id		AS a_id,
	a.theme_id	AS a_tid,
	a.user_id	AS a_uid,
	au.name		AS a_uname,
	a.text		AS a_text,
	a.created_at	AS a_at,
	t.user_id 	AS a_uid,
	tu.id		AS t_uid,
	tu.name 	AS t_uname,
	t.image_id	AS t_iid
	FROM votes	AS v
	LEFT JOIN answers	AS a	ON v.answer_id = a.id
	LEFT JOIN themes	AS t	ON a.theme_id = t.id
	LEFT JOIN users		AS vu	ON v.user_id = vu.id
	LEFT JOIN users		AS au	ON a.user_id = au.id
	LEFT JOIN users		AS tu	ON t.user_id = tu.id
	WHERE t.id = 3000;
