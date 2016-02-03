-- Radio/sv_hooks.lua

hook.Add("PlayerInitialSpawn", "Radio.UpdateSongList", function(ply)
	Radio.GetSongList(ply);
end)

hook.Add("Radio.SongEnded", "Radio.AutoQueue", function()
	if Radio.Config.Debug then
		print("Radio.SongEnded hook works")
	end
end)

hook.Add("Radio.SongAddedToWaitingList", "Radio.PlayNextSong", function(Name)
	if Radio.Config.Debug then
		print("Radio.SongPlayed hook works")
	end
end)

hook.Add("Radio.SongPlayed", "RandomHook", function()
	if Radio.Config.Debug then
		print("Radio.SongPlayed hook works")
	end
end)