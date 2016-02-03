--[[-------------------------------------
	MUI\sh_errors.lua
	Made by James Swift
--]]-------------------------------------


MUI.Errors = {};
local Errors = MUI.Errors;

--[[-------------------------------------
	MUI.Errors.BuildLogTable( ) [INTERNAL]
	Usage: Build the Log table if it doesn't exist.
	Returns: True if table existed, false if it didn't.
--]]-------------------------------------
function Errors.BuildLogTable( )
	if ( not Errors.Log ) then 
		Errors.Log = {};
		return false;
	end
	return true;
end

--[[-------------------------------------
	MUI.Errors.BuildMessage( sFilename, sNature )
	Usage: Build a soft error string. [INTERNAL]
	Args:  - sFilename [string] = File in which the error occurred.
	       - sNature [string] = The error in question.
	returns: Error message string
--]]-------------------------------------

function Errors.BuildMessage( sFilename, sNature )
	MUI.Errors.CheckArguments( "Errors.BuildMessage( sFilename, sNature )", { sFilename, "string" }, { sNature, "string" } );
	return "Error in file " .. sFilename .. " : " .. sNature;
end

--[[-------------------------------------
	MUI.Errors.Post( sFilename, sNature, ... )
	Usage: Report a soft error.
	Args:  - sFilename [string] = File in which the error occurred.
	       - sNature [string] = The error in question.
		   - ... [any] = Format the sNature string
--]]-------------------------------------

function Errors.Post( sFilename, sNature, ... )
	MUI.Errors.CheckArguments( "Errors.Post( sFilename, sNature, ... )", { sFilename, "string" }, { sNature, "string" } );
	
	if ( MUI.Config.PrintErrors ) then
		MUI.Output( Errors.BuildMessage( sFilename, sNature ), ... );
	end
	
	Errors.BuildLogTable( );
	
	table.insert( Errors.Log, {File = sFilename, Nature = Format( sNature, ... )} );
	
	if ( MUI.Config.CallHooks ) then
		hook.Call( MUI.Config.ErrorHook, nil, sFilename, Format( sNature, ... ) );
	end
end

--[[-------------------------------------
	MUI.Errors.GetLast( )
	Usage: Get the last soft error.
	Returns: Last error [table {File, Nature}] or false.
--]]-------------------------------------

function Errors.GetLast( )
	if ( not Errors.BuildLogTable( ) ) then return false; end
	return Errors.Log[ table.Count( Errors.Log ) ] or false;
end

--[[-------------------------------------
	MUI.Errors.ClearLog()
	Usage: Clear the error log.
--]]-------------------------------------

function Errors.ClearLog( )
	Errors.Log = nil;
	Errors.BuildLogTable( );
end

--[[-------------------------------------
	MUI.Errors.List()
	Usage: Iterator, returns Error number [integer], File [string], and Nature [string]
--]]-------------------------------------

function Errors.List()
	Errors.BuildLogTable( );
	local i, n = 0, table.getn(Errors.Log);
	return function ()
		i = i + 1;
		if i <= n then
			return i, Errors.Log[i].File, Errors.Log[i].Nature;
		end
	end
end 

--[[-------------------------------------
	MUI.Errors.CheckArguments( FunctionName, ... )
	Usage: Check the arguments passed to the function, soft error if they don't match required type.
	Args:  - FunctionName [string]
	       - ... [vargs table {GivenArgument [any], RequiredType [string(/nil for no defined required type)]}]
	Returns: True if arguments match, false if not.
--]]-------------------------------------

function Errors.CheckArguments( FunctionName, ... )
	local Good = true;
	for _, argument in ipairs( {...} ) do
		local Given = argument[ 1 ];
		local RequiredType = argument[ 2 ];
		
		if ( not RequiredType ) then continue; end
		
		if ( Given == nil or type( Given ) ~= RequiredType ) then
			MUI.Output( "Error calling %s, Argument %u expected type %s, got %s", FunctionName, _, RequiredType, type( Given ) );
			Good = false;
		end
	end
	return Good;
end
