
local speeds = {
    veryslow = 0.010,
    slow = 0.025,
    default = 0.050,
    fast = 0.100,
    veryfast = 0.200,
}

local themes = {
    pastel = 1,
    light = 64,
    default = 128,
    vibrant = 192,
    deep = 255,
}

local function initialize_settings()
    if not storage.settings then
        storage.settings = {}
    end
    local settings = settings.global
    storage.settings = {}
    storage.settings["train-rainbow-speed"] = settings["train-rainbow-speed"].value
    storage.settings["train-rainbow-palette"] = settings["train-rainbow-palette"].value
end

local function reset_trains_global()
    storage.lua_trains = {}
    for each, surface in pairs(game.surfaces) do
        for every, train in pairs(surface.get_trains()) do
            storage.lua_trains[train.id] = train
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
    if not storage.lua_trains then
        storage.lua_trains = {}
    end
    storage.lua_trains[event.train.id] = event.train
    if event.old_train_id_1 then
        storage.lua_trains[event.old_train_id_1] = nil
    end
    if event.old_train_id_2 then
        storage.lua_trains[event.old_train_id_2] = nil
    end
end)

local sin = math.sin
local pi_0 = 0 * math.pi / 3
local pi_2 = 2 * math.pi / 3
local pi_4 = 4 * math.pi / 3

script.on_nth_tick(10, function(event)
    if not storage.settings then
        initialize_settings()
    end
    local settings = storage.settings
    local frequency = 0.050
    local rainbow_speed = settings["train-rainbow-speed"]
    if rainbow_speed == "off" then
        return
    else
        frequency = speeds[rainbow_speed]
    end
    if storage.lua_trains then
        for each, train in pairs(storage.lua_trains) do
            -- for every, surface in pairs(game.surfaces) do
            --   for each, train in pairs(surface.get_trains()) do
            if not train.valid then
                storage.lua_trains[each] = nil
            else
                -- if train then
                local id = train.id
                local nth_tick = event.nth_tick
                local tick = event.tick
                local rainbow = {
                    r = sin(frequency * ((tick / nth_tick) + (id * 10)) + (pi_0)) * 127 + 128,
                    g = sin(frequency * ((tick / nth_tick) + (id * 10)) + (pi_2)) * 127 + 128,
                    b = sin(frequency * ((tick / nth_tick) + (id * 10)) + (pi_4)) * 127 + 128,
                    a = themes[settings["train-rainbow-palette"]],
                }
                for front, locomotive in pairs(train.locomotives.front_movers) do
                    locomotive.color = rainbow
                end
                for back, locomotive in pairs(train.locomotives.back_movers) do
                    locomotive.color = rainbow
                end
            end
        end
    end
end
)
