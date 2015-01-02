local awful = require("awful")
local io = require("io")
local naughty = require("naughty")
local beautiful = require("beautiful")
local battery = {}
local warned = false;

local function execute_command(command)
    local fh = io.popen(command)
    local str = fh:read("*all")
    io.close(fh)
    return tostring(str)
end

local function get_battery_level()
    local status = execute_command("bash -c \"acpi | sed -nr 's/.* ([0-9]+)%.*/\\1/p'\"")

    if tonumber(status) < 20 and warned == false then
        naughty.notify({ title    = "Battery Warning"
        , text     = "Battery is low! - " .. status .. "%"
        , timeout  = 5
        , position = "top_right"
        , fg       = beautiful.fg_focus
        , bg       = beautiful.bg_focus})

        warned = true;
    end

    return tostring(status)
end

battery.add = function(wibox)
    mybatterypanel = wibox.widget.textbox()
    mybatterypanel:set_text("")

    batterytimer = timer({ timeout = 1 })

    batterytimer:connect_signal("timeout", function()
        local statusBattery = get_battery_level() .. '%'
        mybatterypanel:set_text(statusBattery)
    end)

    -- mybatterypanel_t = awful.tooltip({
    --    objects = { mybatterypanel }, timer_function = function() return execute_command("acpi") end})

   batterytimer:start()
end

return battery

