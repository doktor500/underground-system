require './lib/underground_system'
require './spec/fakes/repositories/trips_repository'

RSpec.describe UndergroundSystem do
  let(:tube) { UndergroundSystem.new({ tripsRepository: FakeTripsRepository.new }) }

  it 'calculates trips average time between Paradise and Cambridge train stations' do
    tube.check_in(45, 'Leyton', 3)
    tube.check_in(32, 'Paradise', 8)
    tube.check_out(45, 'Waterloo', 15)
    tube.check_out(32, 'Cambridge', 22)

    expect(tube.get_average_time('Paradise', 'Cambridge')).to eq 14
  end

  it 'calculates trips average time between different train stations' do
    tube.check_in(45, 'Leyton', 3)
    tube.check_in(32, 'Paradise', 8)
    tube.check_in(27, 'Leyton', 10)
    tube.check_out(45, 'Waterloo', 15)
    tube.check_out(27, 'Waterloo', 20)
    tube.check_out(32, 'Cambridge', 22)

    expect(tube.get_average_time('Paradise', 'Cambridge')).to eq 14
    expect(tube.get_average_time('Leyton', 'Waterloo')).to eq 11

    tube.check_in(10, 'Leyton', 24)
    tube.check_out(10, 'Waterloo', 38)

    expect(tube.get_average_time('Leyton', 'Waterloo')).to eq 12
  end

  it 'calculates trips average time between Waterloo and Cambridge train stations' do
    tube.check_in(1, 'Waterloo', 1)
    tube.check_out(1, 'Cambridge', 21)

    expect(tube.get_average_time('Waterloo', 'Cambridge')).to eq 20
  end

  it 'calculates trips average time between Leyton and Cambridge train stations' do
    tube.check_in(1, 'Leyton', 1)
    tube.check_out(1, 'Cambridge', 21)
    tube.check_in(2, 'Leyton', 1)
    tube.check_out(2, 'Cambridge', 11)
    tube.check_in(3, 'Cambridge', 1)
    tube.check_out(3, 'Leyton', 90)

    expect(tube.get_average_time('Leyton', 'Cambridge')).to eq 15
  end
end
