
local speeds = {
  veryslow = 0.010,
  slow = 0.025,
  default = 0.050,
  fast = 0.100,
  veryfast = 0.200,
}

script.on_nth_tick(10, function(event)
  local frequency = 0.050
  local rainbow_speed = settings.global["train-rainbow-speed"].value
  if rainbow_speed == "off" then
    return
  else
    frequency = speeds[rainbow_speed]
  end
  for every, surface in pairs(game.surfaces) do
    for each, train in pairs(surface.get_trains()) do
      if train then
        local id = train.id
        local nth_tick = event.nth_tick
        local tick = event.tick
        local rainbow = {
          r = math.sin(frequency*((tick/nth_tick)+(id*10))+(0*math.pi/3))*127+128,
          g = math.sin(frequency*((tick/nth_tick)+(id*10))+(2*math.pi/3))*127+128,
          b = math.sin(frequency*((tick/nth_tick)+(id*10))+(4*math.pi/3))*127+128,
        }
        for _, locomotive in pairs(train.locomotives) do
          locomotive.color = rainbow
        end
      end
    end
  end
end
)
