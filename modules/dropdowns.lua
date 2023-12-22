Dropdowns = {}
Dropdowns.dd_gpt_on = false
Dropdowns.dd_utils_on = false
Dropdowns.dropdowns = {"gpt", "utils"}

function Dropdowns.setup()
    -- When changing tag, hide the active dropdown, on the specific screen
    tag.connect_signal("property::selected", function(t)
        Dropdowns.hide_screen(t.screen)
    end)
end

function Dropdowns.start_gpt()
    Utils.spawn("firefox-developer-edition -P chatgpt")
end

function Dropdowns.start_utils()
    Utils.spawn("dolphin")
    Utils.spawn("speedcrunch")
    Utils.spawn("tilix --session ~/other/tilix.json")
end

-- When raising a client from the tasklist
function Dropdowns.check_hide(c)
    if not Dropdowns.included(c) then
        Dropdowns.hide_screen(c.screen)
    end
end

function Dropdowns.included(c)
    for index, dropdown in ipairs(Dropdowns.dropdowns) do
        if c[Dropdowns.get_x(dropdown)] then return true end
    end

    return false
end

function Dropdowns.get_x(what)
    return "x_dropdown_" .. what
end

function Dropdowns.get_on(what)
    return Dropdowns["dd_" .. what .. "_on"]
end

function Dropdowns.set_on(what, value)
    Dropdowns["dd_" .. what .. "_on"] = value
end

function Dropdowns.get_tag(what)
    return Dropdowns["dd_" .. what .. "_tag"]
end

function Dropdowns.set_tag(what, value)
    Dropdowns["dd_" .. what .. "_tag"] = value
end

function Dropdowns.get_screen(what)
    return Dropdowns["dd_" .. what .. "_screen"]
end

function Dropdowns.set_screen(what, value)
    Dropdowns["dd_" .. what .. "_screen"] = value
end

function Dropdowns.toggle(what)
    if Dropdowns.get_on(what) then
        local tag = Dropdowns.get_tag(what)
        local highest = Utils.highest_in_tag(tag)
        local same_tag = tag == Utils.my_tag()

        if not same_tag or not tag.selected or
            (highest ~= nil and not highest[Dropdowns.get_x(what)]) then
            Dropdowns.show(what)
        else
            Dropdowns.hide(what)
        end
    else
        Dropdowns.show(what)
    end
end

function Dropdowns.show(what)
    Dropdowns.hide_screen(Utils.my_screen())
    local t = Utils.my_tag()
    local max

    for _, c in ipairs(client.get()) do
        if c[Dropdowns.get_x(what)] then
            c:move_to_tag(t)
            c.hidden = false
            c:raise()

            if not Dropdowns.get_on(what) then
                Rules.reset(c)
            else
                if c.maximized then max = c end
            end
        end
    end

    if max ~= nil then Utils.focus(max) end
    Dropdowns.set_on(what, true)
    Dropdowns.set_screen(what, Utils.my_screen())
    Dropdowns.set_tag(what, Utils.my_tag())
end

function Dropdowns.hide(what)
    for _, c in ipairs(client.get()) do
        if c[Dropdowns.get_x(what)] then c.hidden = true end
    end

    Dropdowns.set_on(what, false)
end

function Dropdowns.hide_others(what)
    for index, dropdown in ipairs(Dropdowns.dropdowns) do
        if dropdown ~= what then
            if Dropdowns.get_on(dropdown) then
                Dropdowns.hide(dropdown)
            end
        end
    end
end

function Dropdowns.hide_screen(screen)
    for index, dropdown in ipairs(Dropdowns.dropdowns) do
        if Dropdowns.get_on(dropdown) then
            if Dropdowns.get_screen(dropdown) == screen then
                Dropdowns.hide(dropdown)
            end
        end
    end
end

function Dropdowns.check()
    for index, dropdown in ipairs(Dropdowns.dropdowns) do
        if Dropdowns.get_on(dropdown) then
            if Dropdowns.get_screen(dropdown) == Utils.my_screen() then
                Dropdowns.hide(dropdown)
            end
        end
    end
end

Dropdowns.setup()
