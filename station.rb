class Station
  include InstanceCounter
  attr_reader :trains, :title

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(title)
    @title = title
    @trains = []
    @@stations << self
    register_instance
  end

  def add_train(train)
    @trains << train
  end

  def delete_train(train)
    puts "Поезд № #{train.number} отправлен со станции #{title}"
    trains.delete_if {|train_go| train_go == train }
  end

end
