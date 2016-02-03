--[[-------------------------------------
	MUI\sh_update.lua
	Made by James Swift
--]]-------------------------------------

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local function dec(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

function MUI.CheckVersion( )

	HTTP( {
		url = MUI.Config.CheckURL,
		
		method = "get",
	
		success = function( code, body, headers )

			if ( string.len( body ) == 0 ) then
				MUI.Output( "Couldn't check version!");
				return;
			end
			
			local APIReturn = util.JSONToTable( body );
			if ( APIReturn and APIReturn.content) then
				local FileContents = dec(string.gsub( APIReturn.content, "\n", "" ));

				for _, line in pairs( string.Explode( "\n", FileContents ) ) do
					if ( not string.StartWith( line, "MUI.Config.Version" ) ) then continue; end
					
					local _Version = string.gsub( line, "MUI.Config.Version(%s*)=(%s*)\"", "", 1 );
					_Version = string.gsub( _Version, "\";", "", 1 );
					if ( _Version ~= MUI.Config.Version ) then
						MUI.Output( "You are using an out of date version (version %s) of MUI. Current version is %s", MUI.Config.Version, _Version );
						if ( MUI.Config.CallHooks ) then
							hook.Call( MUI.Config.BadVersion, nil, MUI.Config.Version, _Version );
						end
					end
				end
			
			end

		end,
	
		failed = function( error )
			MUI.Output( "Couldn't check version! Error: %s", error);
		end
	})

end