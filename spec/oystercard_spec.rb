require 'oystercard'

describe Oystercard do
  let(:min_balance) { described_class::MINIMUM_BALANCE }
  let(:min_fare) { described_class::MINIMUM_FARE }
  let(:oystercard) { described_class.new }

  context '#initialize' do
    it 'starts with a balance of zero' do
      expect(subject.balance).to be == 0
    end
  end

  context "#balance" do
    it "Return the current balance" do
      oystercard.balance
      expect(oystercard.balance).to be_an Integer
    end
  end

  context "#top_up" do
    it 'can top up the balance' do
      top_up_amount = Oystercard::MINIMUM_BALANCE
      oystercard.top_up(top_up_amount)
      expect(oystercard.balance).to eq 1
    end

    it "raises an error if the maximum balance is exceeded" do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      oystercard.top_up(maximum_balance)
      expect{ oystercard.top_up 1 }.to raise_error "maximum balance of #{maximum_balance} exceeded."
    end
  end

  context "#deduct" do
    it 'deducts an amount from the balance' do
      oystercard.top_up(20)
      expect { oystercard.deduct 3}.to change{ oystercard.balance }.by -3
    end
  end

  context "#in_journey?" do
    it 'knows when it\'s in use' do
      expect(oystercard).not_to be_in_journey
    end
  end

    context 'touch in' do
      it 'can touch in' do
        oystercard.top_up(Oystercard::MINIMUM_BALANCE + 1)
        oystercard.touch_in("station")
        expect(oystercard).to be_in_journey
      end

      it 'raises an error if balance is less than minimum' do
        expect{ oystercard.touch_in("station") }.to raise_error "balance is below £#{Oystercard::MINIMUM_BALANCE}"
      end

      it 'logs the name of the station that the customer touches in at' do
        oystercard.top_up(10)
        expect { oystercard.touch_in("entry_station") }.not_to raise_error
      end

      it 'logs the station that the card touches in at' do
        oystercard.top_up(10)
        oystercard.touch_in("station")
        expect(oystercard.last_touched_in_destination).to eq "station"
      end

    end

  context 'touch out' do
    it 'can touch out' do
      oystercard.top_up(10)
      oystercard.touch_in("station")
      oystercard.touch_out
      expect(oystercard).not_to be_in_journey
    end

    it 'reduces the card balance by minimum fare' do
      oystercard.top_up(10)
      oystercard.touch_in("station")
      oystercard.touch_out
      expect { oystercard.touch_out }.to change { oystercard.balance }.by min_fare
    end
  end
end
