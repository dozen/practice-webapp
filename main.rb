#!/usr/bin/env ruby

require 'sinatra'
require 'slim'
require 'slim/include'
require 'mysql2'

set :bind, '0.0.0.0'
set :public_folder, File.dirname(__FILE__) + '/static'


get '/theme/:id' do
  id = params[:id]
  slim :theme, locals: { theme: get_theme(id) }
end

get '/' do
  slim :index
end

get '/image/:id' do
  id = params[:id]
  img = get_image id

  content_type :png
  img['image']
end

helpers do
  def db
    return Thread.current[:db] if Thread.current[:db]
    c = Mysql2::Client.new(
      host: 'localhost',
      username: 'root',
      database: 'ogiri',
      encoding: 'utf8mb4',
      reconnect: 'false',
    )
    Thread.current[:db] = c
    c
  end

  def get_theme id
    result = db.prepare(
<<EOQ
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
        ORDER BY a_at, v_at
EOQ
    ).execute(id)

    theme = {
    };

    result.each do |r|
      theme[r['a_id']] = {
        'id' => r['a_id'],
        'user' => { 'id' => r['a_uid'], 'name' => r['a_uname'] },
        'text' => r['a_text'],
        'created_at' => r['a_at'],
        'image' => r['t_iid'],
        'votes' => {},
      } unless theme.has_key?(r['a_id'])
      theme[r['a_id']]['votes'][r['v_id']] = {
        'id' => r['v_id'],
        'user' => { 'id' => r['v_uid'], 'name' => first_name(r['v_uname']) },
        'comment' => r['comment'],
        'point' => r['p'],
        'created_at' => r['v_at'],
      }
    end
    theme
  end

  def get_image id
    db.prepare('SELECT * FROM images AS i WHERE i.id = ?').execute(id).first
  end

  def p2star point
    case point
    when 1 then '★☆☆'
    when 2 then '★★☆'
    else '★★★'
    end
  end

  def first_name name
    name.split(' ').first
  end

end
