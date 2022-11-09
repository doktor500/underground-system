class TrackingEvent
  def initialize(args = {})
    @station = args.fetch(:station)
    @time = args.fetch(:time)
  end

  attr_reader :station, :time
end
