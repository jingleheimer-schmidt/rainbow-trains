
local simulation_script = [[
    if game.active_mods["rainbow-trains"] then
        local tick = game.tick
        local nth_tick = 5
        if not (tick % nth_tick == 0) then goto end_of_rainbow_trains_script end
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
        local sin = math.sin
        local pi_0 = 0 * math.pi / 3
        local pi_2 = 2 * math.pi / 3
        local pi_4 = 4 * math.pi / 3
        local settings = settings.global
        local rainbow_speed = settings["train-rainbow-speed"].value
        if rainbow_speed == "off" then return end
        local alpha = pallette[settings["train-rainbow-palette"].value]
        local frequency = speeds[rainbow_speed]
        for _, surface in pairs(game.surfaces) do
            for _, train in pairs(surface.get_trains()) do
                local modifier = frequency * ((tick / nth_tick) + (train.id * 10))
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
    ::end_of_rainbow_trains_script::
]]

for _, main_menu_simulation in pairs(data.raw["utility-constants"]["default"].main_menu_simulations) do
    if main_menu_simulation then
        if main_menu_simulation.update then
            main_menu_simulation.update = main_menu_simulation.update .. simulation_script
        else
            main_menu_simulation.update = simulation_script
        end
    end
end
