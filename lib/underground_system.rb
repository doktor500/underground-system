require_relative 'repositories/trips_repository'

class UndergroundSystem
  def initialize(args = {})
    @trips_repository = args.fetch(:tripsRepository) { TripsRepository.new }
  end

  def check_in(id, station_name, time)
    trip = Trip.new(user_id: id, start: TrackingEvent.new(station: station_name, time: time))

    @trips_repository.save(trip) unless @trips_repository.non_completed_trip_exists(id)
  end

  def check_out(id, station_name, time)
    trip = @trips_repository.get_last_non_completed_trip(id)
    completed_trip = trip.complete(station_name, time)

    @trips_repository.update(completed_trip)
  end

  def get_average_time(start_station, end_station)
    @trips_repository.get_average_time(start_station, end_station)
  end
end
