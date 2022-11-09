#!/usr/bin/env ruby

require_relative '../../lib/repositories/trips_repository'
require_relative '../../lib/domain/trip'
require_relative '../../lib/domain/tracking_event'

repository = TripsRepository.new

trip = Trip.new(
  user_id: 1,
  start: TrackingEvent.new(station: 'Waterloo', time: 0),
  end: TrackingEvent.new(station: 'Cambridge', time: rand(1..1_000))
)

repository.save(trip)
