--[[-------------------------------------
	MUI\sh_init.lua
	Made by James Swift
--]]-------------------------------------


MUI = {}

if ( SERVER ) then

	AddCSLuaFile( "sh_config.lua" );
	AddCSLuaFile( "sh_errors.lua" );
	AddCSLuaFile( "sh_update.lua" );
	AddCSLuaFile( "sh_themes.lua" );
	AddCSLuaFile( "sh_hooks.lua" );

end

include( "sh_config.lua" );
include( "sh_errors.lua" );
include( "sh_update.lua" );
include( "sh_themes.lua" );
include( "sh_hooks.lua" );

--[[-------------------------------------
	MUI.Output( sOutput, ... )
	Usage: Print to console without boiler plate code.
	Args:  - sOutput [string] = Template string
	       - ... [any] = Variables to insert into template
--]]-------------------------------------

function MUI.Output( sOutput, ... )
	MsgC( MUI.Config.OutputColor, MUI.Config.ErrorStart, MUI.Config.ColorWhite, Format( sOutput, ... ), "\n" );
end

--[[-------------------------------------
	MUI.Initialize( )
	Usage: Initialize the MUI libraries
--]]-------------------------------------
function MUI.Initialize( )

	MUI.Output( "Initializing..." );
	
	-- Check version
	MUI.CheckVersion( )
	
	MUI.ThemeLoader.LoadThemes( );
	MUI.ThemeLoader.SetSelected( MUI.Config.ThemeDefault );
	
	MUI.Output( "Loaded!" );

end
