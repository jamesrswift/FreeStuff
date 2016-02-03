--[[
SprayLoader - Load images from websites
--]]

if ( SERVER ) then
	AddCSLuaFile( "SprayLoader/cl_init.lua" )
else
	include( "SprayLoader/cl_init.lua" )
end


if SERVER then

	util.AddNetworkString( "SprayLoader.POC" )

	function ServerSideSpray()

		local HP = net.ReadVector()
		local Normal = net.ReadVector()
		local TextureName = net.ReadString()
	
		local env_projectedtexture = ents.Create( "env_projectedtexture" )
		env_projectedtexture:SetKeyValue( "Enable Shadows", 0 )
		env_projectedtexture:SetKeyValue( "Target" , "worldspawn" )
		
		env_projectedtexture:SetPos( HP + Normal * 128 )
		env_projectedtexture:SetAngles( (-1 * Normal):Angle() )
		env_projectedtexture:Spawn()
		
		env_projectedtexture:Input( "TurnOn", NULL, NULL )
		env_projectedtexture:Input( "LightOnlyTarget", NULL, NULL, 1 )
		env_projectedtexture:Input( "SpotlightTexture", NULL, NULL, TextureName )
		
	end
	
	net.Receive( "SprayLoader.POC", ServerSideSpray )
	
end