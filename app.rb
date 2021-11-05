require './create_users_db'
require './seed_db'
require 'sqlite3'
require 'pry'
require 'date'

class Application

    def initialize
        @db = Data_base.create
        @db.results_as_hash = true
    end


    #seeding db
    def seed
        puts "Заполнить таблицы случайными данными(s) или добавить пользователя вручную(u)? \n(enter 's'/'u' or press Enter to skip:)"
        ans = gets.chomp.upcase
        if ans == 'S'
            Seed.me(@db)
        elsif ans == 'U'
            add_user
        end
    end

    #shows list of users
    def show_users 
        @db.execute( "select * from users" ) do |row|
        puts "ID - #{row["user_id"]}, #{row["name"]} #{row["surname"]}"
        end
    end

    #запрос ид юзера, который показывает всю инфу по нему из всех таблиц
    def get_id 
        puts 'Введите ID пользователя, информацию о котором Вы хотите получить:'
        @id = gets.chomp
    end

    def avarars_count
    
        count = @db.get_first_value "SELECT count(distinct url)  
                            FROM avatars 
                            WHERE user_id = #{@id}"    
    end

    def search_result
        @result = @db.execute"SELECT *  
                            FROM users  
                            natural join avatars as a 
                            natural join userimages 
                            natural join images
                            WHERE user_id = #{@id}
                            group by image_id, a.url"
        #binding pry
        puts "user # #{@id} #{@result[0]['name']} #{@result[0]['surname']} #{@result[0]['patronumic']} \nadress: #{@result[0]['adress']}"

    avas = []
    images = []
    @result.each do |x|
        avas << {x['url'] => x['creation_date']}
        images << x['path']
    end
    puts "User has #{avarars_count} avatars: "
    avas.uniq.each do |h|
        h.each_pair {|k,v| puts "#{k} created at #{v}" }
    end
    puts "images:"
    puts images.uniq

    end

    def add_user
        puts 'Введите ФИО'
        input_name = gets.chomp.split(' ')
        until input_name.size == 3
            input_name << '-'
        end
        puts'Введите адрес'
        input_adress = gets.chomp ||= '-'
        puts 'введите url аватара'
        input_ava = gets.chomp 
        puts 'Теперь добавьте несколько картинок :) (вводите id картинок через запятую)'
        input_imgs = gets.chomp.split(',')

        @db.execute "INSERT INTO users (name, surname, patronymic, adress)
                    VALUES (?, ?, ?, ?)", [
                                            input_name[0],
                                            input_name[1],
                                            input_name[2],
                                            input_adress
                                              ]
        current_user_id =  @db.get_first_value "SELECT max(user_id) FROM users"
        @db.execute "INSERT INTO avatars (user_id, url, creation_date)
                    VALUES (?, ?, ?)", [
                                current_user_id,
                                input_ava,
                                DateTime.now.to_s
                                ]
        input_imgs.each do |cur_image_id|
            @db.execute "INSERT INTO userimages (user_id, image_id) VALUES (?, ?)", [current_user_id, cur_image_id]
        end
    end

    def work
        seed
        show_users
        get_id
        search_result
    end

end