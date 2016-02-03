-- Radio/sh_config.lua

-- Configurations:
Radio.Config = {};
Radio.Config.GetSongListURL 			= "http://127.0.0.1/radio/get.php?s";
Radio.Config.MediaURL 					= "http://127.0.0.1/radio/media/";
Radio.Config.Debug 						= false; -- To check if the song list is being downloaded correctly.
Radio.Config.GetSongListFromWebsite 	= true;

Radio.Config.AutomaticlyPlayNextSong 	= true;
Radio.Config.MaxWaitingList 			= 10;

Radio.Config.Volume 					= 1; -- Between 0 and 1
Radio.Config.Flags 						= "";
Radio.Config.RadioPanelSizeX			= 280;
Radio.Config.RadioPanelSizeY			= 70;