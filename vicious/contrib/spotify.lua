---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2013, Hoogendijk B.J. <b.j.hoogendijk@tudelft.nl>
---------------------------------------------------

-- {{{ Grab environment
local type = type
local io = { popen = io.popen }
local setmetatable = setmetatable
local string = { find = string.find }
local helpers = require("vicious.helpers")
-- }}}


-- spotify: provides metadata about the currently playing song in spotify
-- vicious.contrib.spotify
local spotify = {}


-- {{{ spotify widget type
local function worker(format, warg)
    

    -- Get data from spotify
    handletitle = io.popen('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify / org.freedesktop.MediaPlayer2.GetMetadata | awk -F\"\\\"\" \'/xesam:title/{getline; print $2}\'')
    title = handletitle:read("*line")
    handleartist = io.popen('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify / org.freedesktop.MediaPlayer2.GetMetadata | awk -F\"\\\"\" \'/xesam:artist/{getline;getline; print $2}\'')
    artist = handleartist:read("*line")
    handletitle:close()
    handleartist:close()

    -- Not installed,
    if title == nil
    then
        return {"Stopped"}
    end

    spotify_currently_playing = (artist .. " - " .. title) 
    print(spotify_currently_playing)
    return {helpers.escape(spotify_currently_playing)}
end
-- }}}

return setmetatable(spotify, { __call = function(_, ...) return worker(...) end })
