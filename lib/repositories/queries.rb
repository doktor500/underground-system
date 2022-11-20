class TripsRepositoryQueries
  def get_completed_trips(start_station, end_station)
    query = "SELECT * FROM TRIPS WHERE start_station = $1 AND end_station = $2 AND end_time IS NOT NULL"
    params = [start_station, end_station]

    { query: query, params: params }
  end

  def get_last_non_completed_trip(user_id)
    query = "SELECT * FROM TRIPS WHERE user_id = $1 AND end_time IS NULL ORDER BY start_time DESC LIMIT 1"
    params = [user_id]

    { query: query, params: params }
  end

  def non_completed_trip_exists(user_id)
    query = "SELECT * FROM TRIPS WHERE user_id = $1 AND end_time IS NULL ORDER BY start_time DESC LIMIT 1"
    params = [user_id]

    { query: query, params: params }
  end

  def get_average_time(start_station, end_station)
    query = %(SELECT "TRIP_AVG_TIME" FROM "TRIPS_AVERAGE_TIME" WHERE "JOURNEY" = $1)
    params = ["#{start_station}-#{end_station}"]

    { query: query, params: params }
  end

  def save(trip)
    query = %(
      INSERT INTO TRIPS (user_id, start_station, start_time, end_station, end_time)
      VALUES ($1, $2, $3, $4, $5) RETURNING id;
    )
    params = [trip.user_id, trip.start_station, trip.start_time, trip.end_station, trip.end_time]

    { query: query, params: params }
  end

  def update(trip)
    query = %(
      UPDATE TRIPS SET user_id = $1, start_station = $2, start_time = $3, end_station = $4, end_time = $5 WHERE id = $6
    )
    params = [trip.user_id, trip.start_station, trip.start_time, trip.end_station, trip.end_time, trip.id]

    { query: query, params: params }
  end
end
