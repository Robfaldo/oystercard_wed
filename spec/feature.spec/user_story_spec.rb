require 'oystercard'

describe 'User Story' do
  let(:entry_station) { double :entry_station}
  let(:oystercard) { Oystercard.new }

  # In order to pay for my journey
  # As a customer
  # When my journey is complete, I need the correct amount deducted from my card
  it 'deducts journey cost from card on touch out' do
    oystercard.top_up(4)
    oystercard.touch_in(entry_station)
    oystercard.touch_out
    expect { oystercard.touch_out }.to change { oystercard.balance}.by -2
  end

  # In order to pay for my journey
  # As a customer
  # I need to know where I've travelled from
  it 'logs the location user touches in' do
    oystercard.top_up(10)
    oystercard.touch_in(entry_station) 
    expect(oystercard.last_station).to eq entry_station
  end

end
