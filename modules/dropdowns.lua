Dropdowns = {}
Dropdowns.util_screen_on = false
Dropdowns.chat_gpt_on = false
Dropdowns.dropdowns = {"util_screen", "chat_gpt"}

function Dropdowns.start_util_screen()
    Utils.spawn("dolphin")
    Utils.spawn("speedcrunch")
    Utils.spawn("tilix --session ~/other/tilix.json")
end

function Dropdowns.start_util_screen()
    Utils.spawn("dolphin")
    Utils.spawn("speedcrunch")
    Utils.spawn("tilix --session ~/other/tilix.json")
end

function Dropdowns.start_chat_gpt()
    Utils.spawn("firefox-developer-edition -P chatgpt")
end

function Dropdowns.toggle(what)
    if Dropdowns[what .. "_on"] then
        local tag = Dropdowns[what .. "_tag"]
        local highest = Utils.highest_in_tag(tag)
        local same_tag = tag == Utils.mytag()

        if not same_tag or not tag.selected or
            (highest ~= nil and not highest["x_dropdown_" .. what]) then
            Dropdowns.show(what)
        else
            Dropdowns.hide(what)
        end
    else
        Dropdowns.show(what)
    end
end

function Dropdowns.show(what)
    Dropdowns.hide_others(what)
    local t = Utils.mytag()
    local max

    for _, c in ipairs(client.get()) do
        if c["x_dropdown_" .. what] then
            c:move_to_tag(t)
            c.hidden = false
            c:raise()

            if not Dropdowns[what .. "_on"] then
                Rules.reset_rules(c)
            else
                if c.maximized then max = c end
            end
        end
    end

    if max ~= nil then Utils.focus(max) end
    Dropdowns[what .. "_on"] = true
    Dropdowns[what .. "_screen"] = Utils.myscreen()
    Dropdowns[what .. "_tag"] = Utils.mytag()
end

function Dropdowns.hide(what)
    for _, c in ipairs(client.get()) do
        if c["x_dropdown_" .. what] then c.hidden = true end
    end

    Dropdowns[what .. "_on"] = false
end

function Dropdowns.hide_others(what)
    for index, dropdown in ipairs(Dropdowns.dropdowns) do
        if dropdown ~= what then
            if Dropdowns[dropdown .. "_on"] then
                Dropdowns.hide(dropdown)
            end
        end
    end
end

function Dropdowns.check()
    for index, dropdown in ipairs(Dropdowns.dropdowns) do
        if Dropdowns[dropdown .. "_on"] then
            if Dropdowns[dropdown .. "_screen"] == Utils.myscreen() then
                Dropdowns.hide(dropdown)
            end
        end
    end
end