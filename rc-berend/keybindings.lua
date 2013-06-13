    
    previous_layout_berend = layouts[2] --default is tile
    function fullscreen_switch() -- I know this does not strictly work for all situations, but i don't want to improve it so it is screen and tag independend
        -- if not fullscreen, go fullscreen; if fullscreen, go to previous state or suit.tile
        local current_layout = awful.layout.get()
        if current_layout==awful.layout.suit.max
            then awful.layout.set(previous_layout_berend)
        else 
            previous_layout_berend = current_layout
            awful.layout.set(layouts[10]) --suit.max
        end
     end


-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),


    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),
    awful.key({ modkey,           }, "F12",   function () awful.util.spawn("xlock")     end),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey, "Control","Shift"}, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey,           }, "space", function () fullscreen_switch() end),


    awful.key({ modkey, "Control" }, "n", awful.client.restore),
    awful.key({ modkey,           }, "p",     function () awful.util.spawn("synapse") end),
    awful.key({ modkey,           }, "c",     function () awful.util.spawn("chromium-browser") end),


    awful.key({modkey, "Shift",},"z", function() awful.util.spawn_with_shell("awsetbg -r /home/berend/Pictures/wallpapers-awesome/wallpapers") end),

   -- X86 KEYBINDINGSZ
   
   -- AUDIO
        -- volume up/down
        awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -q sset Master 2dB-") end),
        awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -q sset Master 2dB+") end),
        -- mute unmute button
        awful.key({ }, "XF86AudioMute", function () 
                awful.util.spawn("amixer -q sset Master toggle")
                awful.util.spawn("amixer -q sset PCM unmute") end),
        -- Start spotify with media button or favorites 1
        awful.key({ }, "XF86Tools", function () awful.util.spawn("spotify") end),
        awful.key({ }, "XF86Launch5", function () awful.util.spawn("spotify") end),
        -- Play pause spotify with play pause button
        awful.key({ }, "XF86AudioPlay", function () spotify_cmd("PlayPause") end),
        -- Next, Previous Song on spotify
        awful.key({modkey,"Control" }, "Right", function () spotify_cmd("Next") end),
        awful.key({modkey,"Control" }, "Left", function () spotify_cmd("Previous") end),

    --MISCELLANEOUS
        -- Start chromium with www button
        awful.key({ }, "XF86HomePage", function () awful.util.spawn("chromium-browser") end),
        --Shutdown the computer when the power button is pressed
        awful.key({ }, "XF86PowerOff", function () awful.util.spawn(terminal .. " -e gksu poweroff") end),      
        -- start calculator
        awful.key({ }, "XF86Calculator", function () awful.util.spawn("galculator") end),      
        -- Start aptitude with search button
        awful.key({ }, "XF86Search", function () awful.util.spawn("aptitude") end),
        awful.key({ }, "XF86Mail", function () awful.util.spawn("chromium-browser --app=https://mail.google.com") end),      
        awful.key({ }, "XF86Launch6", function () awful.util.spawn("dolphin") end),
        awful.key({modkey, }, "f", function () awful.util.spawn("dolphin") end),
        awful.key({ }, "XF86Launch9", function () awful.util.spawn("subl") end),
        awful.key({modkey, }, "e", function () awful.util.spawn("subl") end),
        awful.key({ }, "Print", function () awful.util.spawn("gnome-screenshot -i") end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
 -- awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)




-- Compute the maximum number of digit we need, limited to 9
-- keynumber = 0
-- for s = 1, screen.count() do
--    keynumber = math.min(9, math.max(#tags[s], keynumber));
-- end
-- SHIFTY: initialize shifty
    -- the assignment of shifty.taglist must always be after its actually
-- initialized with awful.widget.taglist.new()
    shifty.taglist = mytaglist
shifty.init()
    shifty.config.clientkeys = clientkeys
    shifty.config.modkey = modkey


for i = 1, 9 do
globalkeys = awful.util.table.join(globalkeys,
        awful.key({modkey}, i, function()
            local t =  awful.tag.viewonly(shifty.getpos(i))
            end),
        awful.key({modkey, "Control"}, i, function()
            local t = shifty.getpos(i)
            t.selected = not t.selected
            end),
        awful.key({modkey, "Control", "Shift"}, i, function()
            if client.focus then
            awful.client.toggletag(shifty.getpos(i))
            end
            end),
        -- move clients to other tags
        awful.key({modkey, "Shift"}, i, function()
            if client.focus then
            t = shifty.getpos(i)
            awful.client.movetotag(t)
            awful.tag.viewonly(t)
            end
            end))
    end


clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}