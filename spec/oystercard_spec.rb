require 'oystercard'

describe Oystercard do
  let(:min_fare) { described_class::MINIMUM_FARE }
  let(:oystercard) { described_class.new }
  let(:max_balance) { Oystercard::MAXIMUM_BALANCE }
  let(:min_balance) { Oystercard::MINIMUM_BALANCE }
  let(:entry_station) { double :entry_station }

  context '#default' do
    it 'starts with a balance of zero' do
      expect(oystercard.balance).to be == 0
    end
  end


context 'card funds' do
  context "#deduct" do
      it 'deducts an amount from the balance' do
        oystercard.top_up(20)
        expect { oystercard.deduct 3}.to change{ oystercard.balance }.by -3
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
      top_up_amount = min_balance
      oystercard.top_up(top_up_amount)
      expect(oystercard.balance).to eq 1
    end

    it "raises an error if the maximum balance is exceeded" do
      maximum_balance = max_balance
      oystercard.top_up(maximum_balance)
      expect{ oystercard.top_up 1 }.to raise_error "maximum balance of #{maximum_balance} exceeded."
    end
  end
end


  context 'when travelling' do
    describe "#in_journey?" do
      it 'knows when it\'s in use' do
        expect(oystercard).not_to be_in_journey
      end
    end

    describe 'touch in' do
      it 'can touch in' do
        oystercard.top_up(min_balance + 1)
        oystercard.touch_in(entry_station)
        expect(oystercard).to be_in_journey
      end

      it 'raises an error if balance is less than minimum' do
        expect{ oystercard.touch_in(entry_station) }.to raise_error "balance is below £#{min_balance}"
      end

      it 'logs the station' do
        oystercard.top_up(10)
        oystercard.touch_in(entry_station)
        expect(oystercard.last_station).to eq entry_station
      end
    end

    describe 'touch out' do
      it 'can touch out' do
        oystercard.top_up(10)
        oystercard.touch_in(entry_station)
        oystercard.touch_out
        expect(oystercard).not_to be_in_journey
      end

      it 'reduces the card balance by minimum fare' do
        oystercard.top_up(10)
        oystercard.touch_in(entry_station)
        oystercard.touch_out
        expect { oystercard.touch_out }.to change { oystercard.balance }.by min_fare
      end
    end
  end
end
