--[[-------------------------------------
	MUI\sh_config.lua
	Made by James Swift
--]]-------------------------------------


MUI.Config 				= {};

MUI.Config.Version 			= "1.03";
MUI.Config.CheckURL			= "https://api.github.com/repos/JamesxX/MUI/contents/MaterialUI/lua/MUI/sh_config.lua";
MUI.Config.Creator 			= "James Swift";
MUI.Config.BadVersion			= "MUI.BadVersion";
MUI.Config.CallHooks 			= true;

MUI.Config.OutputColor 			= Color( 155, 90, 255 );
MUI.Config.ColorWhite 			= Color( 255, 255, 255 );

MUI.Config.ThemeFolder 			= "MUI/Themes/";
MUI.Config.ThemeFolderLocal 		= "Themes/";
MUI.Config.ThemeDefault			= "Default";
MUI.Config.ThemeLoadHook		= "MUI.ThemeLoaded";
MUI.Config.ThemeChangeHook		= "MUI.ThemeChanged";

MUI.Config.PrintErrors			= true;
MUI.Config.ErrorStart 			= "[MUI] ";
MUI.Config.ErrorHook 			= "MUI.Error";
