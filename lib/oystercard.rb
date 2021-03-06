class Oystercard

  attr_reader :balance, :entry_station, :exit_station, :trips

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = -2

  def initialize
    @balance = 0
    @journey = false
    @trips = {}
  end

  def top_up(amount)
    fail "maximum balance of 90 exceeded." if amount + @balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def in_journey?
    !!entry_station
  end

  def touch_in(entry_station)
    fail "balance is below £#{MINIMUM_BALANCE}" if @balance < MINIMUM_BALANCE
    @entry_station = entry_station
    @journey = true
  end

  def touch_out(exit_station)
    @journey = false
    @balance += MINIMUM_FARE
    @trips[@entry_station] = exit_station
    @entry_station = nil 
  end

  def last_station
    @entry_station
  end

  def previous_trips
    @trips
  end
end

# We want previous trips to store a trip, with entry and exit values 
# 
