require './app.rb'


  go = Application.new
 loop do
  go.work
  puts 'one more time? (y|n)'
  answer = gets.chomp.upcase
  case answer
  when 'Y'
    p 'OK, let\'s go!'
  when 'N'
    exit
  end
end