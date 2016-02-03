print ( "loading?" )

matproxy.Add( {
	name = "SprayLoader",
	init = function( self, mat, values )
		-- Store the name of the variable we want to set
		print( "callind mat proxy thingy" )
		self.ResultTo = values.SprayLoaderBT
		PrintTable( values )
	end,
	bind = function( self, mat, ent )
		print ( mat, ent )
		SprayLoader.PrecacheImage( LocalPlayer():SteamID64(), function( sIdentifier, spraymat )
			mat:SetString( self.ResultTo, spraymat:GetString( "$basetexture" ) )
		end)
	end
} )
