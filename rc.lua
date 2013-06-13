-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Load Debian menu entries
require("debian.menu")
-- shifty - dynamic tagging library
require("shifty")
-- vicious for widgets http://awesome.naquadah.org/wiki/Vicious#Getting_Vicious
vicious = require("vicious")

os.execute("test -d " .. awful.util.getdir("cache") .. " || mkdir -p " .. awful.util.getdir("cache"))
os.execute("XDG_CACHE_HOME=" .. awful.util.getdir("cache"))

-- Simple function to load additional LUA files from rc/.
function loadrc(name, mod)
   local success
   local result

   -- Which file? In rc/ or in lib/?
   local path = awful.util.getdir("config") .. "/" ..
      (mod and "lib" or "rc-berend") ..
      "/" .. name .. ".lua"

   -- If the module is already loaded, don't load it again
   if mod and package.loaded[mod] then return package.loaded[mod] end

   -- Execute the RC/module file
   success, result = pcall(function() return dofile(path) end)
   if not success then
      naughty.notify({ title = "Error while loading an RC file",
           text = "When loading `" .. name ..
        "`, got the following error:\n" .. result,
           preset = naughty.config.presets.critical
         })
      return print("E: error loading RC file '" .. name .. "': " .. result)
   end

   -- Is it a module?
   if mod then
      return package.loaded[mod]
   end

   return result
end


loadrc("errors")
loadrc("xrun")


-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/usr/share/awesome/themes/default/theme.lua")
-- beautiful.init("/usr/share/awesome/themes/default/theme_adapted.lua")

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- adapted from http://ubuntuforums.org/showthread.php?t=1797848
-- possible options for s:Play Pause PlayPause Next Previous Stop
function spotify_cmd( s )
  awful.util.spawn_with_shell("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player." .. s .. " 1> /dev/null")
end

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- Shifty configured tags.
shifty.config.tags = {
    main = {
        layout    = awful.layout.suit.tile,
        mwfact    = 0.50,
        exclusive = false,
        position  = 1,
        init      = true,
        screen    = {1,2},
        slave     = true,
    },
    web = {
        layout      = awful.layout.suit.tile,
        init        = true,
        nopopup     = true,
        mwfact      = 0.65,
        position    = 2,
        -- spawn       = browser,
    },
    files = {
        layout    = awful.layout.suit.left,
        init      = true,
        nopopup   = true,
        mwfact    = 1,
        exclusive = false,
        position  = 5,
        spawn     = dolphin,
    },
    chat = {
        layout = awful.layout.suit.tile.left,
        init = false,
        mwfact = 0.5,
        nopopup = false,
        exclusive = false,
        position = 9,
    },
    tex = {
        layout = awful.layout.suit.tile.left,
        exclusive = false,
        init = false,
        position = 6,
    },
    media = {
        layout    = awful.layout.suit.max,
        exclusive = false,
        position  = 8,
        nopopup = true,
    },
    office = {
        layout   = awful.layout.suit.tile,
        position = 7,
    },
}

-- SHIFTY: application matching rules
-- order here matters, early rules will be applied first
shifty.config.apps = {
    {
        match = {
            "plugin-container",
            "Exe",
            "exe",
        },
        float = true,
    },
    {
        match = {
            "Chromium-browser",
            "chromium-browser",
        },
        nofocus = false,
    },
    {
        match = { 
             "hangouts",
             "Hangouts",
        },
        tag = "chat",
    },
    {
        match = {
            "synapse",        --opstartprogramma
        },
        intrusive = true,
        float = true,
    },
    {
        match = {
            "libreoffice*",
        },
        tag = "office",
    },
    {
        match = {
            "Spotify",
        },
        tag = "media",
        --screen = math.max(screen.count(), 2),
        screen = 1,
        nopopup = true,
        urgent = false,
        nofocus = false,
    },
    {
        match = {
            "MPlayer",
            "Gnuplot",
            "galculator",
        },
        float = true,
    },
    {
        match = {
            terminal,
        },
        honorsizehints = false,
        slave = true,
    },
}

-- SHIFTY: default tag creation rules
-- parameter description
--  * floatBars : if floating clients should always have a titlebar
--  * guess_name : should shifty try and guess tag names when creating
--                 new (unconfigured) tags?
--  * guess_position: as above, but for position parameter
--  * run : function to exec when shifty creates a new tag
--  * all other parameters (e.g. layout, mwfact) follow awesome's tag API
shifty.config.defaults = {
    layout = awful.layout.suit.tile.left,
    ncol = 1,
    mwfact = 0.50,
    floatBars = true,
    guess_name = true,
    guess_position = true,
}



loadrc("menu")


-- Initialize widget
memwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(memwidget, vicious.widgets.mem, "Mem: $1%", 10)

seperator = widget({type = "textbox"})
seperator.text = " <span color='#767b8a'>::</span> "

-- tag seperator
tagseperator = widget({type = "textbox"})
tagseperator.text = " <span color='#767b8a'>|</span> "

-- Initialize widget
datewidget = widget({ type = "textbox" })
-- Register widget
vicious.register(datewidget, vicious.widgets.date, "%b %d, %R", 60)
-- {{{ Wibox
-- Create a textclock widget
-- mytextclock = awful.widget.textclock({ align = "right" })

-- cpu
cpuwidget = widget({ type = "textbox" })
cpuwidget.width,cpuwidget.align = 53, "left"
vicious.register(cpuwidget, vicious.widgets.cpu, "CPU: $1%")


-- network
wlan1widget = widget({type = "textbox"})
vicious.register(wlan1widget, vicious.widgets.net, "${wlan1 up_kb} kb/s / ${wlan1 down_kb} kb/s")

netimgup = widget({ type = "imagebox" })
netimgup.image = image("/home/berend/.config/awesome/icons/widgets/up.png")

netimgdown = widget({ type = "imagebox" })
netimgdown.image = image("/home/berend/.config/awesome/icons/widgets/down.png")

-- Create a systray
mysystray = widget({ type = "systray" })

    -- Keyboard map indicator and changer
    kbdcfg = {}
    kbdcfg.cmd = "setxkbmap"
    kbdcfg.layout = { "us", "dvorak" }
    kbdcfg.current = 2  -- dvorak is the default layout
    kbdcfg.widget = widget({ type = "textbox", align = "left" })
    kbdcfg.widget.text = " " .. kbdcfg.layout[kbdcfg.current] .. " "
    kbdcfg.switch = function ()
       kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
       local t = " " .. kbdcfg.layout[kbdcfg.current] .. " "
       kbdcfg.widget.text = t
       os.execute( kbdcfg.cmd .. t )
    end
    
    -- Mouse bindings
    kbdcfg.widget:buttons(awful.util.table.join(
        awful.button({ }, 1, function () kbdcfg.switch() end)
    ))


-- Spotify widget
spotwidget= widget({type = "textbox"})
vicious.register(spotwidget,vicious.contrib.spotify,"$artist - $title",1)

musicimg = widget({ type = "imagebox" })
musicimg.image = image("/home/berend/.config/awesome/icons/widgets/music.png")

-- File systems
-- local fs = { "/",
--        "/home",
--        "/var",
--        "/usr",
--        "/tmp",
--         }
-- local fsicon = widget({ type = "imagebox" })
-- fsicon.image = image("/home/berend/.config/awesome/icons/widgets/disk.png")
-- local fswidget = widget({ type = "textbox" })
-- vicious.register(fswidget, vicious.widgets.fs,
--      function (widget, args)
--         local result = ""
--         for _, path in pairs(fs) do
--            local used = args["{" .. path .. " used_p}"]
--            local color = "gray"
--            if used then
--         if used > 90 then
--            color = "red"
--         end
--                           local name = string.gsub(path, "[%w/]*/(%w+)", "%1")
--                           if name == "/" then name = "root" end
--         result = string.format(
--            '%s%s<span color="' .. "gray" .. '">%s: </span>' ..
--         '<span color="' .. color .. '">%2d%%</span>',
--            result, #result > 0 and " " or "", name, used)
--            end
--         end
--         return result
--      end, 53)

-- Create a wibox for each screen and add it
mywibox = { }
mybottomwibox = { } -- only on homescreen
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))



for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)


    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        datewidget,
        tagseperator,
        kbdcfg.widget,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end

mybottomwibox[1] = awful.wibox({position = "bottom", screen = 1})
mybottomwibox[1].widgets = 
                     {cpuwidget,
                      seperator,
                      memwidget,
                      seperator,
                      netimgdown,
                      wlan1widget,
                      netimgup,
                      seperator,
                      spotwidget,
                      musicimg,
                      layout = awful.widget.layout.horizontal.rightleft}
-- }}}

-- KEYBINDINGS
loadrc("keybindings")

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    -- prevent chromium from opening as a floating window
    { rule = { class = "Chromium-browser" },
      properties = { floating = false } },
    {rule = {class = "sublime-text-2"},
    properties = {floating = false } },  
    -- prevent full screen flash windows from being tiled
    { rule = { instance = "plugin-container" },
        properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
-- awful.util.spawn("gtk-redshift -l 52.0:4.36")
-- awful.util.spawn("nm-applet")
--awful.util.spawn("gtk-redshift","gtk-redshift -l 52.0:4.36")
-- xrun("NetworkManager Applet", "nm-applet")
awful.util.spawn_with_shell("awsetbg -r /home/berend/Pictures/wallpapers-awesome/wallpapers")
