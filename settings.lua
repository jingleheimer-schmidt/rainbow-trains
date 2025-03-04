local rainbow_speed = {
    type = "string-setting",
    name = "train-rainbow-speed",
    setting_type = "runtime-global",
    default_value = "default",
    allowed_values = {
        "off",
        "veryslow",
        "slow",
        "default",
        "fast",
        "veryfast"
    }
}

local rainbow_theme = {
    type = "string-setting",
    name = "train-rainbow-theme",
    setting_type = "runtime-global",
    default_value = "default",
    allowed_values = {
        "pastel",
        "light",
        "default",
        "vibrant",
        "deep"
    }
}

data:extend({
    rainbow_speed,
    rainbow_theme
})
