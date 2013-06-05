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
local metadata = {}


-- {{{ spotify widget type
local function worker(format, warg)
    
    local types = {}
    local metadata = {}
    

    -- Get data from spotify via dbus
    handle = io.popen('qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata | awk -F: \'{$1=\"\";$2=\"\";print substr($0,4)}\'') 
    handletypes = io.popen('qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata | awk -F: \'{print $2}\'') 

    

    -- as of spotify for linux version 0.9.0.133 the following metadata types are provided 
    -- artUrl;length;trackid;album;artist;autoRating;contentCreated;discNumber;title;trackNumber;url

    --store all handletypes
    for line in handletypes:lines() do
        table.insert(types, line)
    end
    
    --add data to corresponding handletype in array
    local i = 1
    for line in handle:lines() do
        metadata[types[i]] = helpers.escape(line)
        i = i +1
    end

    -- catch spotify not running
    if i < 3 -- only 1 run so spotify must not be available
        then
         return("spotify is not running")
     end

    handle:close()
    handletypes:close()

    -- No title available return stopped
    if metadata.title == nil
    then
        return {"Something went wrong"}
    end

    return metadata
end
-- }}}

return setmetatable(metadata, { __call = function(_, ...) return worker(...) end })
