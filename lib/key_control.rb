require 'io/wait'

class KeyControl

  def self.key_sleep seconds, interval=2

    slept = 0
    done = false

    while slept <= seconds && !done
      char = KeyControl.char_if_pressed

      if char.nil?
        sleep interval
        slept = slept + interval
      else
        done = true
      end
    end

    done

  end

  def self.char_if_pressed
    begin
      system("stty raw -echo") # turn raw input on
      c = nil
      if $stdin.ready?
        c = $stdin.getc
      end
      c.chr if c
    ensure
      system "stty -raw echo" # turn raw input off
    end
  end
end
