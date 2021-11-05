require 'sqlite3'

class Data_base

  def self.create
    db = SQLite3::Database.new "users.db"
    db.results_as_hash = true

    #создать таблицу с пользователями (ид, Ф,И,О)
    db.execute "CREATE TABLE IF NOT EXISTS users(
                                                  user_id INTEGER PRIMARY KEY AUTOINCREMENT,
                                                  name TEXT default '---',
                                                  surname TEXT default '---',
                                                  patronymic TEXT default '---',
                                                  adress TEXT
                                                  
                                                  )"

    #создать таблицу с аватарами (ид, ава, дата изменения)
    db.execute "CREATE TABLE IF NOT EXISTS avatars(
                                                  user_id INTEGER, 
                                                  url TEXT default '---',
                                                  creation_date DATESTAMP,
                                                  foreign key (user_id) references users (user_id)
                                                  )"

    #создать таблицу с картинками (картинки и юзеры)
    db.execute "CREATE TABLE IF NOT EXISTS images(
                                                  image_id INTEGER PRIMARY KEY AUTOINCREMENT,
                                                  path TEXT
                                                  )"

    #создаем связующую таблицу
    db.execute "CREATE TABLE IF NOT EXISTS userimages (
                                                      user_id INTEGER, 
                                                      image_id INTEGER,
                                                      foreign key (user_id) references users (user_id),
                                                      foreign key (image_id) references images (image_id) 
                                                      )"
  return db

  end
end