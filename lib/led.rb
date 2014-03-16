require 'pi_piper'
include PiPiper

class Led
  attr_reader :name,
              :pin

  def initialize name, pin_number
    @name = name
    @pin = PiPiper::Pin.new(pin: pin_number, direction: :out)
  end

  def on
    @pin.on
  end

  def off
    @pin.off
  end

  def toggle
    if off?
      on
    else
      off
    end
  end

  def blink times=1, cycle=0.25
    @pin.off
    sleep cycle

    0.step(times-1) do
      @pin.on
      sleep cycle
      @pin.off
      sleep cycle
    end

    @pin.off
  end

  def on?
    @pin.read
    @pin.on?
  end

  def off?
    @pin.read
    @pin.off?
  end
end
