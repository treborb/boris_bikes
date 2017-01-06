require 'docking_station'

describe DockingStation do
  it { is_expected.to respond_to :release_bike}
  it { is_expected.to respond_to :dock_bike }

  it 'releases working bikes' do
    bike = subject.release_bike
    expect(bike).to be_working
  end
  it 'shows currently docked bikes when empty' do
    subject.release_bike
    expect(subject.bikes).to eq []
  end
  it 'shows currently docked bikes when asked' do
    expect(subject).to respond_to :bikes
  end
  it 'shows no bikes when we remove the bike in it' do
    subject.release_bike
    expect(subject.bikes).to eq []
  end
  it 'raises an error when told to release a bike when docking station is empty' do
    subject.release_bike
    expect{subject.release_bike}.to raise_error("no bikes available")
  end

  it 'raises error if station full' do
    bike = subject.release_bike
    DockingStation::DEFAULT_CAPACITY.times { subject.dock_bike(Bike.new) }
    expect{subject.dock_bike(Bike.new)}.to raise_error("bike station full")
  end

  it 'sets bespoke capacity on new docking station' do
    input = 100
    station = DockingStation.new(input)
    expect(station.capacity).to eq input
  end

  it 'uses default capacity on new docking station' do
    station = DockingStation.new
    expect(station.capacity).to eq DockingStation::DEFAULT_CAPACITY
  end

  it 'allows a member of the public to report a bike as broken upon return' do
    users_bike = subject.release_bike
    subject.dock_bike(users_bike, false)
    expect(users_bike).not_to be_working
  end

  it "prevents release of broken bike from station" do
  released_bike = subject.release_bike
  subject.dock_bike(released_bike,false)
  expect{ subject.release_bike }.to raise_error "all bikes are broken"

  end

  it "prevents release of broken bike from station" do
  released_bike = subject.release_bike
  subject.dock_bike(released_bike,false)
  subject.dock_bike(Bike.new,false)
  expect{ subject.release_bike }.to raise_error "all bikes are broken"

  end

end
