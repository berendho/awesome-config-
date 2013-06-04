-- {{{ Menu
-- Create a laucher widget and a main menu

function setScreenOrientation(orientation) 
	awful.util.spawn("xrandr --auto --output VGA-0 --auto --" .. orientation .. "-of LVDS-0")
	os.execute("sleep 2")
	awesome.restart()
end

function setScreenLaptopOnly()
	awful.util.spawn("xrandr --auto --output VGA-0 --off") 
end

launchers = {
	{"Spotify", "spotify"},
}

config = {
	{"edit rc.lua", "subl /home/berend/.config/awesome/rc.lua"},
}



screenlayout = {
	{"Screen left",function () setScreenOrientation("left") end},
	{"Screen right",function () setScreenOrientation("right") end},	
	{"Laptop only",function () setScreenLaptopOnly() end},
}

myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "open terminal", terminal },
									{ "programs", 	launchers},
									{ "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "monitor layout", screenlayout}
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}