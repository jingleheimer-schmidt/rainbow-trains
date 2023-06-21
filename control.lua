
local speeds = {
  veryslow = 0.010,
  slow = 0.025,
  default = 0.050,
  fast = 0.100,
  veryfast = 0.200,
}

local pallette = {
  pastel = 1,
  light = 64,
  default = 128,
  vibrant = 192,
  deep = 255,
}

local function initialize_settings()
  local settings = settings.global
  global.settings = {}
  global.settings["train-rainbow-speed"] = settings["train-rainbow-speed"].value
  global.settings["train-rainbow-palette"] = settings["train-rainbow-palette"].value
end

local function reset_trains_global()
  ---@type table<uint, LuaTrain>
  global.lua_trains = {}
  for _, surface in pairs(game.surfaces) do
    for _, train in pairs(surface.get_trains()) do
      global.lua_trains[train.id] = train
    end
  end
end

script.on_event(defines.events.on_runtime_mod_setting_changed, function()
  initialize_settings()
end)

script.on_configuration_changed(function()
  reset_trains_global()
  initialize_settings()
end)

script.on_init(function()
  reset_trains_global()
  initialize_settings()
end)

script.on_event(defines.events.on_train_created, function(event)
  global.lua_trains = global.lua_trains or {}
  global.lua_trains[event.train.id] = event.train
end)

local sin = math.sin
local pi_0 = 0 * math.pi / 3
local pi_2 = 2 * math.pi / 3
local pi_4 = 4 * math.pi / 3

script.on_nth_tick(5, function(event)
  if not global.settings then
    initialize_settings()
  end
  local settings = global.settings
  local rainbow_speed = settings["train-rainbow-speed"]
  if rainbow_speed == "off" then return end
  local alpha = pallette[settings["train-rainbow-palette"]]
  local frequency = speeds[rainbow_speed]
  global.lua_trains = global.lua_trains or {}
  for id, train in pairs(global.lua_trains) do
    if not train.valid then
      global.lua_trains[id] = nil
    else
      local nth_tick = event.nth_tick
      local tick = event.tick
      local modifier = frequency * ((tick / nth_tick) + (id * 10))
      local rainbow = {
        r = sin(modifier + pi_0) * 127 + 128,
        g = sin(modifier + pi_2) * 127 + 128,
        b = sin(modifier + pi_4) * 127 + 128,
        a = alpha,
      }
      for _, locomotive in pairs(train.locomotives.front_movers) do
        locomotive.color = rainbow
      end
      for _, locomotive in pairs(train.locomotives.back_movers) do
        locomotive.color = rainbow
      end
    end
  end
end
)
