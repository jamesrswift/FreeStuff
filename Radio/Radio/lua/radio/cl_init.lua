-- Radio/cl_init.lua

Radio = {};
include("sh_config.lua");
include("cl_vgui.lua");

Radio.SongList = {}
Radio.CurrentSong = {};
Radio.CurrentSong.Name = "";
Radio.CurrentSong.Length = 0;
Radio.CurrentSong.Started = 0;
Radio.WaitingList = {}
Radio.Sounds = false;

Radio.Volume = Radio.Config.Volume;


net.Receive("Radio.Play", function()
	local media = net.ReadString();
	if ( media ) then
		sound.PlayURL( Radio.Config.MediaURL..media..".mp3",Radio.Config.Flags, function(station, errid, arrname)
			Radio.Sounds = station;
			if ( IsValid( station ) ) then
				station:Play()
				station:SetVolume(Radio.Volume)
				
				Radio.CurrentSong.Name = media;
				Radio.CurrentSong.Length = Radio.SongList[media];
				Radio.CurrentSong.Started = os.time();
				
				hook.Call("Radio.SongPlayed", GAMEMODE, media, Radio.SongList[media], os.time());

			else
				print("[Radio] Invalid playback URL!")
			end
		end)
	else
		print("[Radio] Radio.Play failed!");
	end
end)

net.Receive("Radio.UpdateSongList", function()
	if (Radio.Config.GetSongListFromWebsite) then
		http.Fetch( Radio.Config.GetSongListURL, function(body, len, headers, code)
			local songs = string.Explode( ";", body );
			for _,songdata in pairs(songs) do
				local info = string.Explode( "\t", songdata );
				if (info[2]) then
					Radio.SongList[info[1]] = Radio.TimeConversion(info[2]);
				end
			end
			
			if (Radio.Config.Debug) then
				PrintTable( Radio.SongList );
			end
			
			hook.Call("Radio.SongListUpdated");
			
		end,
		function(err)
			print( "[Radio] Unable to get song list! Error: " .. err );
		end)
	else
		local media = net.ReadTable();
		if ( media ) then
			Radio.SongList = media;
		else
			print("[Radio] Radio.GetSongList failed!");
		end
	end
end)

net.Receive("Radio.SongEnded", function()
	if ( Radio.Sounds ) then
		Radio.Sounds:Stop();
		
		Radio.CurrentSong.Name = "";
		Radio.CurrentSong.Length = 0;
		Radio.CurrentSong.Started = 0;
		hook.Call("Radio.SongEnded");
	else
		print("[Radio] Radio.SongEnded - No song playing!");
	end
end)

net.Receive("Radio.UpdateWaitingList", function()
	Radio.WaitingList = net.ReadTable()
	hook.Call("Radio.WaitingListUpdated");
end)

function Radio.EndSong_Personal()
	if ( Radio.Sounds ) then
		Radio.Sounds:Stop();
			
		Radio.CurrentSong.Name = "";
		Radio.CurrentSong.Length = 0;
		Radio.CurrentSong.Started = 0;
	end
end

--
--	Radio.GetCurrentSong() -- Returns the current song playing or false
--
function Radio.GetCurrentSong()
	if ( Radio.CurrentSong.Name == "" ) then return false; end
	return Radio.CurrentSong.Name;
end

function Radio.GetVolume()
	return Radio.Volume;
end

function Radio.SetVolume(nVol)
	Radio.Volume = math.Clamp( nVol, 0, 1);
	if Radio.Sounds then
		Radio.Sounds:SetVolume(Radio.Volume);
	end
end

function Radio.TimeConversion(s)
	local t = string.Explode(":",s)
	return t[1] * 60 + t[2]
end

function Radio.AntiTimeConversion(s)
	return string.FormattedTime( s, "%02i:%02i" )
end

function Radio.RequestSong( Name )
	net.Start("Radio.RequestSong")
	net.WriteString( Name )
	net.SendToServer()
end

function Radio.RequestWaitingList()
	net.Start( "Radio.RequestWaitingList")
	net.SendToServer();
end

function Radio.RequestSongList()
	net.Start( "Radio.RequestSongList")
	net.SendToServer();
end

function Radio.RequestStopAll()
	net.Start("Radio.RequestStopAll")
	net.SendToServer()
end