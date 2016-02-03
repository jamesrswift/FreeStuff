--[[
SprayLoader - Load images from websites
]]

SprayLoader 			= {};
SprayLoader.Cache 		= {};
SprayLoader.WaitingList = {};
SprayLoader.Panels		= {};
SprayLoader.LoadURL		= "localhost/solarpower/index.php?p=image&s=";

function SprayLoader.GetImage( sIdentifier )
	return SprayLoader.Cache[ sIdentifier ] or false;
end

function SprayLoader.PrecacheImage( sIdentifier, fCallback )

	-- Has the image already been cached?
	if ( SprayLoader.Cache[ sIdentifier ] ) then
		fCallback( sIdentifier, SprayLoader.Cache[ sIdentifier ] );
		return true;
	end
	
	-- Has a cache already been requested?
	if ( SprayLoader.WaitingList[ sIdentifier ] ) then
		return true;
	end

	-- Create the HTML panel so we can load the texture
	local pHTML = vgui.Create( "DHTML" );
	pHTML:SetSize( 512, 512 );
	pHTML:OpenURL( SprayLoader.LoadURL .. sIdentifier );
	pHTML:SetAlpha( 0 );
	pHTML:SetMouseInputEnabled( false );
	pHTML.ConsoleMessage = function() end;
	
	-- Add it to the waiting list so we can get the texture later.
	SprayLoader.WaitingList[ sIdentifier ] = { panel = pHTML, callback = fCallback };
	return true;

end

function SprayLoader.Think( )

	for sIdentifier, tQueued in pairs( SprayLoader.WaitingList ) do
	
		if ( tQueued.panel and tQueued.panel:GetHTMLMaterial() ) then
		
			local spray_mat = tQueued.panel:GetHTMLMaterial();
			
			-- House keeping
			local matdata = { ["$basetexture"] = spray_mat:GetName() };
			local uid = string.Replace( spray_mat:GetName(), "__vgui_texture_", "" );
			
			SprayLoader.Cache[ sIdentifier ] = CreateMaterial( "SprayLoader_"..uid, "DecalModulate", matdata );
			
			-- Callback
			if ( tQueued.callback ) then
				local success, err = pcall( tQueued.callback, sIdentifier, SprayLoader.Cache[ sIdentifier ] );
				if ( not success ) then
					print( Format( "[SprayLoader] Error calling callback for %s : %s", sIdentifier, err ) );
				end
			end
			
			-- Remove panel from waiting list
			SprayLoader.Panels[ sIdentifier ] = tQueued.panel;
			SprayLoader.WaitingList[ sIdentifier ] = nil
			
		end
		
	end

end

function SprayLoader.InvalidateImage( sIdentifier, fCallback )
	SprayLoader.Cache[ sIdentifier ] = nil;
	SprayLoader.PrecacheImage( sIdentifier, fCallback );
end

function SprayLoader.GetMaterial( sIdentifier )
	return SprayLoader.Cache[ sIdentifier ]
end

function SprayLoader.GetTextureID( sIdentifier )
	return surface.GetTextureID( SprayLoader.GetMaterial( sIdentifier ):GetTexture( "$basetexture" ):GetName() )
end


hook.Add( "Think", "SprayLoader.Think", SprayLoader.Think );

--[[

	Proof of concept
	
]]

function SprayLoader.Spray( )

	local TR = LocalPlayer():GetEyeTrace()
	
	SprayLoader.PrecacheImage( LocalPlayer():SteamID64(), function( sIdentifier, mat )
		util.DecalEx( mat, TR.Entity or Entity(0), TR.HitPos, Vector(0,0,0) , Color(255,255,255), 128, 128 )
	end)

end
