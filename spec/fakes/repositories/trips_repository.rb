require './lib/repositories/errors/not_found_error'

class FakeTripsRepository
  def initialize
    @trips = []
  end

  def get_average_time(start_station, end_station)
    trips = get_completed_trips(start_station, end_station)
    trips_average_time = trips.map(&:time).sum(0.0) / trips.size
    trips_average_time.round(2)
  end

  def get_last_non_completed_trip(user_id)
    trip = started_trip(user_id)
    raise NotFoundError, "A trip for user with user_id #{user_id} was not found" if trip.nil?

    trip
  end

  def non_completed_trip_exists(user_id)
    !started_trip(user_id).nil?
  end

  def save(trip)
    @trips.append(trip)
    trip
  end

  def update(updated_trip)
    trip = get_last_non_completed_trip(updated_trip.user_id)
    @trips.delete(trip)
    @trips.append(updated_trip)
  end

  private

  def get_completed_trips(start_station, end_station)
    @trips.filter { |trip| trip.complete? && trip.journey_between(start_station, end_station) }
  end

  def started_trip(user_id)
    @trips.filter { |trip| !trip.complete? && trip.user_id == user_id }.last
  end
end
