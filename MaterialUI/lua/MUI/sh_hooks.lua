--[[-------------------------------------
	MUI\sh_hooks.lua
	Made by James Swift
--]]-------------------------------------

--[[-------------------------------------
	MUI.Config.ThemeChangeHook [HOOK]
	Usage: Called before a theme is changed
	Args:  - sThemeName [string] = Name of theme to change to.
	Returns: True to allow, false to disallow [bool]
--]]-------------------------------------

hook.Add( MUI.Config.ThemeChangeHook, "Default", function( sThemeName )
	return true;
end);

--[[-------------------------------------
	MUI.Config.ThemeLoadHook [HOOK]
	Usage: Called when a theme is loaded
	Args:  - sFilename [string] = Filename of the theme that was loaded
	       - sThemeName [string] = Name of theme defined in theme table
		   - tThemeTable [table theme] = Table containing theme information.
--]]-------------------------------------

hook.Add( MUI.Config.ThemeLoadHook, "Default", function( sFilename, sThemeName, tThemeTable )

end);

--[[-------------------------------------
	MUI.Config.ErrorHook [HOOK]
	Usage: Called when a soft error occurs
	Args:  - sFilename [string] = File in which the error occurred.
	       - sNature [string] = Formatted nature of the error
--]]-------------------------------------

hook.Add( MUI.Config.ErrorHook, "Default", function( sFilename, sNature )

end);

--[[-------------------------------------
	MUI.Config.BadVersion [HOOK]
	Usage: Called when MUI is loaded with an outdated version
	Args:  - CurrentVersion [string] = The version listed in config.
	       - UpdateVersion [string] = The version listen on Github.
--]]-------------------------------------

hook.Add( MUI.Config.BadVersion, "Default", function( CurrentVersion, UpdateVersion )

end);
