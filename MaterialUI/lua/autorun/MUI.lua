--[[-------------------------------------
	autorun\MUI.lua
	Made by James Swift
--]]-------------------------------------

if ( SERVER ) then
	AddCSLuaFile( "MUI/sh_init.lua" );
end

include( "MUI/sh_init.lua" );

MUI.Initialize( );

hook.Add( "HUDPaint", "MUITest", function()
	local CurrentTheme = MUI.ThemeLoader.GetCurrentTheme()
	if ( CurrentTheme ) then
			
		CurrentTheme:DrawCard( 50, 50, 170, 250, Color( 255,255,255 ), false )
		surface.SetDrawColor( Color( 42, 124, 235 ) )
		surface.DrawRect( 55, 55, 160, 240 )
		CurrentTheme:DrawText( "This is a sample test that should involve a couple lines and what have you. \nOh \nlook \nline \nsupport!",
			"MUI.Default.Calibri.18.Bold", 60, 60, Color(255,255,255) , nil, nil, 150, nil );
	else
		print( CurrentTheme )
	end
end)
