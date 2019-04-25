class Route
  include InstanceCounter
  attr_reader :start_station, :end_station

  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    @railway_stations = []
    register_instance
  end

  def add_station(station)
     @railway_stations << station
  end

  def delete_station(station)
    puts "Промежуточная станция #{station.title} удалена"
    @railway_stations.delete_if {|station_del| station_del == station }
  end

  def stations
    [@start_station, @railway_stations, @end_station].flatten
  end

end