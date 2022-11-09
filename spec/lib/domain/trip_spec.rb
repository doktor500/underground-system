require './lib/domain/trip'
require './lib/domain/tracking_event'

RSpec.describe Trip do
  [
    { start_time: 1, end_time: 11, expected_time: 10 },
    { start_time: 5, end_time: 25, expected_time: 20 }
  ].each do |data|
    it 'calculates a completed trip time' do
      trip = Trip.new(
        user_id: 1,
        start: TrackingEvent.new(station: 'Waterloo', time: data.fetch(:start_time)),
        end: TrackingEvent.new(station: 'Cambridge', time: data.fetch(:end_time))
      )

      expect(trip.time).to eq data.fetch(:expected_time)
    end
  end

  it 'can complete a started trip' do
    trip = Trip.new(user_id: 100, start: TrackingEvent.new(station: 'Waterloo', time: 1))
    completed_trip = trip.complete('Cambridge', 10)

    expect(completed_trip.complete?).to be true
    expect(completed_trip.journey_between('Waterloo', 'Cambridge')).to be true
    expect(completed_trip.time).to eq 9
  end

  it 'can not complete a completed trip' do
    trip = Trip.new(
      user_id: 1,
      start: TrackingEvent.new(station: 'Waterloo', time: 10),
      end: TrackingEvent.new(station: 'Cambridge', time: 60)
    )

    expect { trip.complete('Cambridge', 10) }.to raise_error(/completed trip/)
  end
end
