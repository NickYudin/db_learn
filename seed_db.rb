require 'sqlite3'
require 'faker'

class Seed
    def self.me(db)
        17.times do
            name = Faker::Name.first_name.to_s 
            surname = Faker::Name.last_name.to_s
            patronymic = Faker::Name.middle_name.to_s 
            adress = Faker::Address.full_address.to_s
            path = Faker::Internet.url.to_s
            url = Faker::Internet.url.to_s
            cd = Faker::Date.backward(days: 17).to_s
            id = db.get_first_value "SELECT max(user_id) FROM users"
            db.execute "INSERT INTO images (path) 
                        VALUES (?)", ["#{path}"]

            db.execute "INSERT INTO users (name, surname, patronymic, adress) 
                        VALUES (?,?,?,?)", [
                                        "#{name}",
                                        "#{surname}",
                                        "#{patronymic}",
                                        "#{adress}"
                                           ]
            db.execute "INSERT INTO avatars (user_id, url, creation_date) 
                        VALUES (?,?,?)", [
                                        "#{id}",
                                        "#{url}",
                                        "#{cd}"
                                           ]
        end

        rand(17..42).times do
            count = db.get_first_value "SELECT max(user_id) FROM users"
            count2 = db.get_first_value "SELECT max(image_id) FROM images"
            fu_id = rand (1..count)
            fi_id = rand (1..count2 )
            db.execute "INSERT INTO userimages (user_id, image_id) VALUES (?, ?)", [fu_id, fi_id]
        end
    end
end