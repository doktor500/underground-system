require_relative 'tracking_event'

class Trip
  def initialize(args = {})
    @id = args.fetch(:id, nil)
    @user_id = args.fetch(:user_id)
    @start = args.fetch(:start)
    @end = args.fetch(:end, nil)
  end

  attr_reader :id, :user_id, :start, :end

  def start_time
    @start.time
  end

  def start_station
    @start.station
  end

  def end_time
    @end.time
  end

  def end_station
    @end.station
  end

  def time
    complete? ? end_time - start_time : nil
  end

  def complete?
    @end != nil
  end

  def complete(station_name, time)
    raise Class.new(StandardError), 'A completed trip can not be completed again' if complete?

    Trip.new(
      id: @id,
      user_id: @user_id,
      start: @start,
      end: TrackingEvent.new(station: station_name, time: time)
    )
  end

  def journey_between(start_station, end_station)
    @start.station == start_station && @end.station == end_station
  end
end
