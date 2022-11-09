class TripsRepositoryQueries
  def initialize
    @table       = ENV['DB_TRIPS_TABLE'] ||= 'TRIPS'
    @stats_table = ENV['DB_STATS_TABLE'] ||= 'TRIPS_AVERAGE_TIME'
  end

  def get_completed_trips(start_station, end_station)
    %(
      SELECT * FROM #{@table}
      WHERE start_station = '#{start_station}'
      AND end_station = '#{end_station}'
      AND end_time IS NOT NULL
    )
  end

  def get_last_non_completed_trip(user_id)
    "SELECT * FROM #{@table} WHERE user_id = '#{user_id}' AND end_time IS NULL ORDER BY start_time DESC LIMIT 1"
  end

  def non_completed_trip_exists(user_id)
    "SELECT * FROM #{@table} WHERE user_id = '#{user_id}' AND end_time IS NULL ORDER BY start_time DESC LIMIT 1"
  end

  def get_average_time(start_station, end_station)
    %(SELECT "TRIP_AVG_TIME" FROM "#{@stats_table}" WHERE "JOURNEY" = '#{start_station}-#{end_station}')
  end

  def save(trip)
    end_station = trip.complete? ? "'#{trip.end_station}'" : 'NULL'
    end_time = trip.complete? ? trip.end_time : 'NULL'

    %(
      INSERT INTO #{@table} (user_id, start_station, start_time, end_station, end_time) VALUES (
        #{trip.user_id},
        '#{trip.start_station}',
        #{trip.start_time},
        #{end_station},
        #{end_time}
      ) RETURNING id;
    )
  end

  def update(trip)
    end_station = trip.complete? ? "'#{trip.end_station}'" : 'NULL'
    end_time = trip.complete? ? trip.end_time : 'NULL'

    %(
      UPDATE #{@table} SET
      user_id = #{trip.user_id},
      start_station = '#{trip.start_station}',
      start_time = #{trip.start_time},
      end_station = #{end_station},
      end_time = #{end_time}
      WHERE id = #{trip.id}
    )
  end
end
