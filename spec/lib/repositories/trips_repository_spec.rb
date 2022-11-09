require 'timeout'

require './spec/fakes/repositories/trips_repository'
require './lib/repositories/trips_repository'

RSpec.describe 'trips repository' do
  let(:user_id) { rand(1..100_000) }
  let(:trips_repository) { ENV['test'] == 'integration' ? TripsRepository.new : FakeTripsRepository.new }

  it 'returns the last non completed trip of a user' do
    trips_repository.save(create_completed_trip(user_id, 'Waterloo', 'Cambridge'))
    trips_repository.save(create_started_trip(user_id, 'Cambrige'))

    last_trip = trips_repository.get_last_non_completed_trip(user_id)

    expect(last_trip.complete?).to be false
  end

  it 'returns not found if a users trip does not exist' do
    invalid_user_id = 999_999
    expect { trips_repository.get_last_non_completed_trip(invalid_user_id) }.to raise_error(/not found/)
  end

  it 'returns if a started trip already exists for a user' do
    expect(trips_repository.non_completed_trip_exists(user_id)).to be false

    trips_repository.save(create_started_trip(user_id, 'Cambrige'))

    expect(trips_repository.non_completed_trip_exists(user_id)).to be true
  end

  it 'updates a trip' do
    trip = create_started_trip(user_id, 'Cambrige')
    saved_trip = trips_repository.save(trip)

    trips_repository.update(saved_trip.complete('Waterloo', 10))

    expect { trips_repository.get_last_non_completed_trip(user_id) }.to raise_error(/not found/)
  end

  it 'get trips average time' do
    trip1 = Trip.new(
      user_id: user_id,
      start: TrackingEvent.new(station: 'Paradise', time: 0),
      end: TrackingEvent.new(station: 'Cambridge', time: 1)
    )

    trip2 = Trip.new(
      user_id: user_id,
      start: TrackingEvent.new(station: 'Paradise', time: 2),
      end: TrackingEvent.new(station: 'Cambridge', time: 2)
    )

    trip3 = Trip.new(
      user_id: user_id,
      start: TrackingEvent.new(station: 'Paradise', time: 3),
      end: TrackingEvent.new(station: 'Cambridge', time: 3)
    )

    trips_repository.save(trip1)
    trips_repository.save(trip2)
    trips_repository.save(trip3)

    wait_for { trips_repository.get_average_time('Paradise', 'Cambridge') == 0.33 }
    expect(trips_repository.get_average_time('Paradise', 'Cambridge')).to eq 0.33
  end

  def create_started_trip(user_id, start_station)
    Trip.new(
      user_id: user_id,
      start: TrackingEvent.new(station: start_station, time: 1)
    )
  end

  def create_completed_trip(user_id, start_station, end_station)
    Trip.new(
      user_id: user_id,
      start: TrackingEvent.new(station: start_station, time: 1),
      end: TrackingEvent.new(station: end_station, time: 10)
    )
  end

  def wait_for(timeout = 60)
    Timeout.timeout(timeout) do
      loop do
        condition = yield
        break true if condition
      end
    end
  end
end
