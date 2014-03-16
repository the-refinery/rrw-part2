require_relative 'lib/github_wrapper'
require_relative 'lib/arduino'
require_relative 'lib/key_control'

ORG = "d-i"
REPO = "rrw-demo"

RED = "#ff0000"
YELLOW = "#ffff00"
GREEN = "#00ff00"

GREEN_MAX = 1
YELLOW_MAX = 2

@arduino = Arduino.new
github = GithubWrapper.new ORG, REPO

done = false

while !done
  age = github.latest_commit_age

  if age <= GREEN_MAX
    @arduino.show_color GREEN
  elsif age <= YELLOW_MAX
    @arduino.show_color YELLOW
  else
    @arduino.show_color RED
  end

  done = KeyControl.key_sleep 10
end

@arduino.led_off
@arduino.close
