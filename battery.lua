local awful = require("awful")
local io = require("io")
local battery = {}

local function execute_command(command)
    local fh = io.popen(command)
    local str = fh:read("*all")
    io.close(fh)
    return str
end

battery.add = function(wibox)
    mybatterypanel = wibox.widget.textbox()
    mybatterypanel:set_text("")

    batterytimer = timer({ timeout = 10 })
    batterytimer:connect_signal("timeout", function() mybatterypanel:set_text(execute_command("bash -c \"acpi | sed -nr 's/.* ([0-9]+%).*/\\1/p'\"")) end)

    mybatterypanel_t = awful.tooltip({
        objects = { mybatterypanel }, timer_function = function() return execute_command("acpi") end})

    batterytimer:start()
end

return battery

