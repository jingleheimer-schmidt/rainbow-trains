local rainbowSpeedSetting = {
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

data:extend({
  rainbowSpeedSetting
})
