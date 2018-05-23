class Oystercard

attr_reader :balance, :entry_station

MAXIMUM_BALANCE = 90
MINIMUM_BALANCE = 1
MINIMUM_FARE = -2

def initialize
  @balance = 0
  @journey = false
end

def top_up(amount)
  fail "maximum balance of 90 exceeded." if amount + @balance > MAXIMUM_BALANCE
  @balance += amount
end

def deduct(amount)
  @balance -= amount
end

def in_journey?
  @journey
end

def touch_in(entry_station)
  fail "balance is below £#{MINIMUM_BALANCE}" if @balance < MINIMUM_BALANCE
  @entry_station = entry_station
  @journey = true
end

def touch_out
  @journey = false
  @balance += MINIMUM_FARE
end

def last_touched_in_destination
  @entry_station
end

end
