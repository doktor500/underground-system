require 'pg'

require_relative '../domain/trip'
require_relative '../domain/tracking_event'
require_relative './errors/not_found_error'
require_relative './queries'
require_relative './config/db_config'

class TripsRepository
  def initialize
    @db_config = Db.new.config
    @queries = TripsRepositoryQueries.new
  end

  def get_average_time(start_station, end_station)
    results = execute_query(@queries.get_average_time(start_station, end_station))
    results.to_a.first['TRIP_AVG_TIME'].to_f.round(2) unless results.to_a.first.nil?
  end

  def get_last_non_completed_trip(user_id)
    results = execute_query(@queries.get_last_non_completed_trip(user_id))
    trips = results.to_a
    raise NotFoundError, "A trip for user with user_id #{user_id} was not found" if trips.empty?

    trips.map { |trip| to_trip(trip) }.first
  end

  def non_completed_trip_exists(user_id)
    results = execute_query(@queries.non_completed_trip_exists(user_id))
    !results.to_a.empty?
  end

  def save(trip)
    results = execute_query(@queries.save(trip))
    id = results.to_a.first['id']
    Trip.new(id: id, user_id: trip.user_id, start: trip.start, end: trip.end)
  end

  def update(trip)
    execute_query(@queries.update(trip))
  end

  private

  def get_completed_trips(start_station, end_station)
    results = execute_query(@queries.get_completed_trips(start_station, end_station))
    results.to_a.map { |trip| to_trip(trip) }
  end

  def execute_query(query)
    connection = PG::Connection.new(@db_config)
    connection.exec(query)
  rescue PG::Error => e
    puts e.message
  ensure
    connection&.close
  end

  def to_trip(trip)
    start_station = trip['start_station']
    end_station = trip['end_station']
    trip_start = TrackingEvent.new(station: start_station, time: trip['start_time'])
    trip_end = end_station.nil? ? nil : TrackingEvent.new(station: end_station, time: trip['end_time'])

    Trip.new(id: trip['id'], user_id: trip['user_id'], start: trip_start, end: trip_end)
  end
end
