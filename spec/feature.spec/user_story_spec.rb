require 'oystercard'

describe 'User Story' do

  # In order to pay for my journey
  # As a customer
  # When my journey is complete, I need the correct amount deducted from my card
  it 'deducts journey cost from card on touch out' do
    card = Oystercard.new
    card.top_up(4)
    card.touch_in("station")
    card.touch_out
    expect { card.touch_out }.to change { card.balance}.by -2
  end

  # In order to pay for my journey
  # As a customer
  # I need to know where I've travelled from
  it 'logs the location user touches in' do
    oystercard = Oystercard.new
    oystercard.top_up(10)
    oystercard.touch_in("entry_station") 
    expect(oystercard.last_touched_in_destination).to eq "entry_station"
  end

end
