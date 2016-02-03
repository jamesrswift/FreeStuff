-- Radio/Server.lua

Radio = {};
include("sh_config.lua");
include("sv_waitinglist.lua");
include("sv_hooks.lua");
AddCSLuaFile("sh_config.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_vgui.lua")
AddCSLuaFile("vgui/vtimebar.lua")
AddCSLuaFile("vgui/vradio.lua")

-- Internal Workings
Radio.SongList = {};
Radio.CurrentSong = {};
Radio.CurrentSong.Name = "";
Radio.CurrentSong.Length = 0;
Radio.CurrentSong.Started = 0;

-- Networking
util.AddNetworkString("Radio.Play");
util.AddNetworkString("Radio.SongEnded"); -- For premature ending of songs.
util.AddNetworkString("Radio.UpdateSongList"); -- To tell clients to update their song list. Shouldn't need to be used.
util.AddNetworkString("Radio.RequestSong");
util.AddNetworkString("Radio.RequestSongList");
util.AddNetworkString("Radio.RequestStopAll");

--
--	Radio.GetSongList() - Load the song list from the webserver.
--
function Radio.GetSongList(ply)
	http.Fetch( Radio.Config.GetSongListURL, function(body)
		local songs = string.Explode( ";", body );
		for _,songdata in pairs(songs) do
			local info = string.Explode( "\t", songdata );
			if (info[2]) then
				Radio.SongList[info[1]] = Radio.TimeConversion(info[2]);
			end
		end
		
		-- Send to clients;
		net.Start("Radio.UpdateSongList");
		if (not Radio.Config.GetSongListFromWebsite) then
			net.WriteTable( Radio.SongList );
		end
		if ply then net.Send(ply) else net.Broadcast(); end
		
		if (Radio.Config.Debug) then
			PrintTable( Radio.SongList );
		end
		
		hook.Call("Radio.SongListUpdated",GAMEMODE);
		
	end,
	function(err)
		print( "[Radio] Unable to get song list! Error: " .. err );
	end)
end

--
-- Radio.PlaySong( Name ) - Tells the clients to play a song
--
function Radio.PlaySong( Name )
	if not Radio.SongList[Name] then
		print( "[Radio] Unable to play song as song does not exist!");
		return false;
	end
	
	if Radio.GetCurrentSong() then
		print("[Radio] Already playing a song!");
		return false
	end
	
	net.Start("Radio.Play");
		net.WriteString( Name );
	net.Broadcast();
	
	Radio.CurrentSong.Name = Name;
	Radio.CurrentSong.Length = Radio.SongList[Name];
	Radio.CurrentSong.Started = os.time();
	
	timer.Create("Radio.EndSong", Radio.CurrentSong.Length, 1, Radio.EndSong );
	hook.Call( "Radio.SongPlayed", GAMEMODE, Name)
end

--
--	Radio.EndSong() - Tells the clients the song has ended.
--
function Radio.EndSong()
	hook.Call("Radio.SongEnded", GAMEMODE);
	
	if timer.Exists( "Radio.EndSong" ) then
		timer.Destroy( "Radio.EndSong" )
	end
	
	net.Start("Radio.SongEnded");
	net.Broadcast();
	
	Radio.CurrentSong.Name = "";
	Radio.CurrentSong.Length = 0;
	Radio.CurrentSong.Started = 0;
	
	if (Radio.Config.AutomaticlyPlayNextSong) then
		local NextSong = Radio.GetBottomWaitingItem();
		if (NextSong) then
			Radio.PlaySong( NextSong );
			Radio.RemoveBottomWaitingItem()
		end
	end
end

--
--	Radio.GetCurrentSong() -- Returns the current song playing or false
--
function Radio.GetCurrentSong()
	if ( Radio.CurrentSong.Name == "" ) then return false; end
	return Radio.CurrentSong.Name;
end

concommand.Add("Radio_requestsong", function(ply, cmd, args)
	Radio.AddToWaitingList( args[1] );
end)

function Radio.TimeConversion(s)
	local t = string.Explode(":",s);
	return tonumber(t[1]) * 60 + tonumber(t[2]);
end

net.Receive( "Radio.RequestSong", function(len, ply)
	Radio.AddToWaitingList( net.ReadString() );
end)

net.Receive( "Radio.RequestSongList", function(len, ply)
	Radio.GetSongList()
end)

net.Receive( "Radio.RequestStopAll", function(len, ply)
	Radio.EndSong()
end)