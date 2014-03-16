require 'serialport'

class Arduino

  def initialize debug=false
    @sp = SerialPort.new "/dev/ttyACM0", 9600
    @sp.read_timeout = 500
    @debug = debug
    sleeep 2
  end

  def show_color hex
    bytes = parse_hex hex
    set_color bytes
  end

  def close
    @sp.close
  end

  private

  def parse_hex hex

    unless hex[0] == "#"
      hex = "#" + hex
    end

    m = hex.match /#(..)(..)(..)/

    rgb = [m[1], m[2], m[3]].map {|x| x.hex.chr}
    rgb.join
  end

  def set_color color
    @sp.flush_input
    @sp.flush_output

    @sp.write color

    if @debug
      resp = @sp.readline("\n").chomp

      while resp != "DONE"
        print "#{resp}\n"
        resp = @sp.readline("\n").chomp
      end
    end
  end

end