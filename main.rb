require_relative "instance_counter"
require_relative "manufacturer"
require_relative "station"
require_relative "route"
require_relative "train"
require_relative "wagon"
require_relative "cargo_train"
require_relative "cargo_wagon"
require_relative "passenger_train"
require_relative "passenger_wagon"



@stations = []
@trains = []
@routes = []
@train = nil
@route = nil
@station = nil
@wagon = nil


def list_of_trains
  puts "Доступные поезда:"
  i = 0
  @trains.each do |train|
    puts "#{(i+1).to_s }: номер: '#{train.number}', тип: #{train.type}"
    i += 1
  end
end

def list_of_stations
  puts "Доступные станции:"
  i = 0
  @stations.each do |station|
    puts "#{(i+1).to_s } - #{station.title}"
    i += 1
  end
end

def list_of_routes
  puts "Доступные маршруты:"
  i = 0
  @routes.each do |route|
    print "#{(i+1).to_s} : #{route.start_station.title} - #{route.end_station.title} ПОЛНЫЙ МАРШРУТ:"
    route = route.stations
    route.each {|station| print "#{station.title} - "}
    puts ""
    i += 1
  end
end

def choose_of_train
  puts "Введите номер строки."
  str_number = gets.chomp.to_i
  @train = @trains[str_number-1]
end

loop do
puts "Выберите действие, которое вы хотите сделать
      1 - создать станции
      2 - создать поезд
      3 - создать маршрут
      4 - назначить маршрут поезду
      5 - добавить вагоны к поезду
      6 - отцепить вагон от поезда
      7 - переместить поезд по маршруту (вперед, назад)
      8 - посмотреть список станций и список поездов на станции
      0 - выход"

act = gets.chomp.to_i

break if act == 0

case act

  when 1
    loop do
     puts "Количество станций: #{Station.instances}"
     puts "Введите название станции
     \r(введите 'стоп' для прекращения ввода)"
     title = gets.chomp
     break if title == "стоп"
     @stations << Station.new(title)
     end

  when 2
    loop do
      puts "Какой тип поезда вы хотите создать?
      \rп - пассажирский, г -грузовой."
      train_type = gets.chomp
      break if train_type == "стоп"
      puts "Введите номер поезда:"
      number_train = gets.chomp
      if train_type == "п"
         @trains << PassengerTrain.new(number_train)
      elsif train_type == "г"
        @trains << CargoTrain.new(number_train)
      else
        puts "Такой тип поезда создать невозможно!"
      end
      #puts Train.find("аб123")
      puts "Количество поездов типа #{@trains.last.type}:  #{@trains.last.class.instances}"
      puts "Добавить еще поезд? (введите 'д' или 'н' )"
      user_answer = gets.chomp
      break if user_answer == "н"
    end

  when 3
    list_of_stations
    loop do
      puts "Выберите начальную станцию"
      start_station = gets.chomp.to_i
      puts "Выберите конечную станцию"
      end_station = gets.chomp.to_i
      @routes << Route.new(@stations[start_station-1],@stations[end_station-1])
      puts "Маршрут создан!
      \rДобавить промежуточные станции? (введите 'д' или 'н' )"
      user_answer = gets.chomp
      if user_answer == 'д'
        loop do
          puts "введите промежуточную станцию"
          middle_station = gets.chomp.to_i
          @routes.last.add_station(@stations[middle_station-1])
          puts "Добавить еще станцию? (введите 'д' или 'н')"
          user_answer = gets.chomp
          break if user_answer == 'н'
        end
      end
      puts "Создать еще маршрут? (введите 'д' или 'н')"
      user_answer = gets.chomp
      break if user_answer == 'н'
    end

  when 4
    list_of_trains
    choose_of_train
    list_of_routes
    loop do
      puts "Выберите маршрут"
      route = gets.chomp.to_i
      @train.add_route(@routes[route-1])
      puts "Маршрут к поезду добавлен!"
      break
    end

  when 5
    list_of_trains
    choose_of_train
    # $train содержит выбранный поезд
    puts "Выбран поезд: #{@train.number}, тип: #{@train.type}"
    loop do
      puts "Укажите номер вагона"
      number_wagon = gets.chomp.to_i
      if @train.is_a? PassengerTrain
        @wagon = PassengerWagon.new(number_wagon)
      else
        @wagon = CargoWagon.new(number_wagon)
      end
      @train.add_wagon(@wagon)
      puts "Добавить еще вагон? (введите 'д' или 'н')"
      user_answer = gets.chomp
      break if user_answer == 'н'
    end
   # $train.wagons.each {|w| puts w.id}

  when 6
    list_of_trains
    choose_of_train
    puts "Выбран поезд: #{@train.number}, тип: #{@train.type}"
    puts "Выберите вагон, который хотите отцепить"
    @train.wagons.each {|wagon| print wagon.id.to_s + " "}
    puts ""
    wagon_number = gets.chomp.to_i
    index_wagon = @train.wagons.index { |wagon| wagon.id == wagon_number}
    @wagon = @train.wagons[index_wagon]
    @train.delete_wagon(@wagon)

  when 7
    list_of_trains
    choose_of_train
    # $train содержит выбранный поезд
    puts "Куда перемещаем? в-вперед, н-назад"
    move = gets.chomp
    if move == "в"
      @train.forward
    elsif move == "н"
      @train.back
    else
      puts "Неизвестное направление"
    end

  when 8
    list_of_stations
    puts "выберите станцию"
    station = gets.chomp.to_i
    station = @stations[station-1]
    station.trains.each {|train| puts train.number }

  else
    puts "Неизвестное действие"
  end
end


