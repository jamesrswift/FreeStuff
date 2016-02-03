--[[-------------------------------------
	MUI\sh_themes.lua
	Made by James Swift
--]]-------------------------------------

MUI.ThemeLoader = {};
local ThemeLoader = MUI.ThemeLoader;
SetGlobalString( "MUI.ThemeLoader.Selected", MUI.Config.ThemeDefault );

--[[-------------------------------------
	MUI.ThemeLoader.BuildThemeTable( ) [INTERNAL]
	Usage: Build the theme table if it doesn't exist.
	Returns: True if table existed, false if it didn't.
--]]-------------------------------------

function ThemeLoader.BuildThemeTable( )
	if not ThemeLoader.Themes then
		ThemeLoader.Themes = {};
		return false;
	end
	return true;
end

--[[-------------------------------------
	MUI.ThemeLoader.SetSelected( sThemeName )
	Usage: Select a theme
	Args:  - sThemeName [string] = Theme to select
	Returns: True if theme was changed, false if not
--]]-------------------------------------

function ThemeLoader.SetSelected( sThemeName )
	MUI.Errors.CheckArguments( "ThemeLoader.SetSelected( sThemeName )", { sThemeName, "string" } );
	sThemeName = tostring( sThemeName );
	
	if ( ThemeLoader.GetSelected() == sThemeName ) then
		return true;
	end
	
	if not ThemeLoader.Themes[ sThemeName ] then
		MUI.Errors.Post( "MUI\\sh_themes.lua", "Attempted to select theme that wasn't loaded (%s)!", sThemeName );
		return false;
	end

	local bCanChange = true;
	
	if ( MUI.Config.CallHooks ) then
		bCanChange = bCanChange and hook.Call( MUI.Config.ThemeChangeHook, nil, sThemeName );
	end
	
	if ( bCanChange ) then
		ThemeLoader.Selected = sThemeName;
		SetGlobalString( "MUI.ThemeLoader.Selected", sThemeName );
		return true;
	end
	
	return false;
end

--[[-------------------------------------
	MUI.ThemeLoader.GetSelected( )
	Usage: Get the selected a theme.
	Returns: Selected theme or default theme.
--]]-------------------------------------

function ThemeLoader.GetSelected( )

	return GetGlobalString( "MUI.ThemeLoader.Selected", MUI.Config.ThemeDefault );

end

--[[-------------------------------------
	MUI.ThemeLoader.LoadThemes( ) [INTERNAL]
	Usage: Load themes from themes directory
--]]-------------------------------------

function ThemeLoader.LoadThemes( )

	ThemeLoader.BuildThemeTable( );
	
	local Themes = file.Find( MUI.Config.ThemeFolder .. "*.lua" , "LUA"  );
	
	if ( table.Count( Themes ) == 0 ) then
		MUI.Errors.Post( "MUI\\sh_themes.lua", "No themes to load!");
	end
	
	for _, sFilename in pairs( Themes ) do
		ThemeLoader.LoadTheme( sFilename );
	end
end

--[[-------------------------------------
	MUI.ThemeLoader.LoadTheme( sFilename ) [INTERNAL]
	Usage: Load theme from themes directory
	Args:  - sFilename [string] Name for theme file in directory.
--]]-------------------------------------

function ThemeLoader.LoadTheme( sFilename )
	MUI.Errors.CheckArguments( "ThemeLoader.LoadTheme( sFilename )", { sFilename, "string" } );
	ThemeLoader.BuildThemeTable( );
	
	Theme = {};
	include( MUI.Config.ThemeFolder .. sFilename );
	local Loaded = ThemeLoader.RegisterTable( Theme, sFilename );
	Theme = nil;

	return Loaded;

end

--[[-------------------------------------
	MUI.ThemeLoader.RegisterTable( tThemeTable, sFilename ) [INTERNAL]
	Usage: Register a theme from a table. 
	Args:  - tThemeTable [table theme] Table containing theme information.
	       - sFilename [string] Name for theme file in directory.
--]]-------------------------------------

function ThemeLoader.RegisterTable( tThemeTable, sFilename )

	MUI.Errors.CheckArguments( "ThemeLoader.RegisterTable( tThemeTable, sFilename )", { tThemeTable, "table" }, { sFilename, "string" } );

	if ( not tThemeTable.Name ) then
		MUI.Errors.Post( MUI.Config.ThemeFolder .. sFilename, "Failed to load theme!");
		return false;
	end
	
	local sThemeName = tThemeTable.Name;
	
	ThemeLoader.Themes[ sThemeName ] = table.Copy( tThemeTable );
	
	if ( ThemeLoader.Themes[ sThemeName ].Base ) then
		if ( ThemeLoader.Themes[ ThemeLoader.Themes[ sThemeName ].Base ] ) then
			local NewBaseTable = table.Copy( ThemeLoader.Themes[ ThemeLoader.Themes[ sThemeName ].Base ] );
			table.Merge( NewBaseTable, ThemeLoader.Themes[ sThemeName ] );
			ThemeLoader.Themes[ sThemeName ] = NewBaseTable;
			ThemeLoader.Themes[ sThemeName ].BaseClass = ThemeLoader.Themes[ ThemeLoader.Themes[ sThemeName ].Base ];
		end
	end
	
	if ( ThemeLoader.Themes[ sThemeName ].Initialize ) then
		ThemeLoader.Themes[ sThemeName ]:Initialize();
	end
	
	if ( MUI.Config.CallHooks ) then
		hook.Call( MUI.Config.ThemeLoadHook, nil, sFilename, sThemeName, ThemeLoader.Themes[ sThemeName ] );
	end

	if ( SERVER ) then
		AddCSLuaFile( MUI.Config.ThemeFolder .. sFilename );
	end
	
	MUI.Output( "The %s theme was loaded!", sThemeName );
	
	return true;
end

--[[-------------------------------------
	MUI.ThemeLoader.GetTheme( sThemeName )
	Usage: Get the theme table with a given name
	Args:  - sThemeName [string] Name of the theme to get
	Returns: ThemeTable [table] or false [bool]
--]]-------------------------------------

function ThemeLoader.GetTheme( sThemeName )
	MUI.Errors.CheckArguments( "ThemeLoader.GetTheme( sThemeName )", { sThemeName, "string" } );
	if ( not ThemeLoader.BuildThemeTable( ) ) then return false; end
	return ThemeLoader.Themes[ sThemeName ] or false;
end

--[[-------------------------------------
	MUI.ThemeLoader.GetCurrentTheme( )
	Usage: Get then current theme table
	Returns: ThemeTable [table] or false [bool]
--]]-------------------------------------

function ThemeLoader.GetCurrentTheme( )
	return ThemeLoader.GetTheme( ThemeLoader.GetSelected() );
end

--[[-------------------------------------
	MUI.ThemeLoader.GetThemes( )
	Usage: Get all the theme tables
	Returns: ThemeTables [table] or false [bool]
--]]-------------------------------------

function ThemeLoader.GetThemes( )
	if ( not ThemeLoader.BuildThemeTable( ) ) then return false; end
	return ThemeLoader.Themes;
end

--[[-------------------------------------
	MUI.ThemeLoader.GetThemeCount( )
	Usage: Get how many themes are currently registered
	Returns: ThemeCount [int]
--]]-------------------------------------

function ThemeLoader.GetThemeCount( )
	if ( not ThemeLoader.BuildThemeTable( ) ) then return 0; end
	return table.Count( ThemeLoader.Themes );
end
