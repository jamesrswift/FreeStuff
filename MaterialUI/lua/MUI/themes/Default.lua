--[[-------------------------------------
	MUI\Themes\Default.lua
	Made by James Swift
--]]-------------------------------------

local LuaReloaded = false;
if ( not Theme ) then 
	LuaReloaded = true;
	Theme = {};
end

-----------------------------------------
--	Theme definition
-----------------------------------------

Theme.Name = "Default";
Theme.FileName = "Default.lua";
Theme.GwenTexture = Material("MUI/Themes/Default/SpriteSheet.png");
Theme.GoldenRatio = 1.61803398875; -- This is our awesome number that makes everything look pretty. http://en.wikipedia.org/wiki/Golden_ratio
Theme.ReducedGoldenRatio = Theme.GoldenRatio - 0.25; -- Line height fix for GMod

Theme.DefaultLineHeight = 24; -- Incase something goes wrong
Theme.DefaultFont = "MUI.Default.Calibri.24";

function Theme:Initialize( )
	
	if ( SERVER ) then
	
		resource.AddFile( "materials/MUI/Themes/Default/SpriteSheet.png" );
	
		resource.AddFile( "resources/fonts/Calibri.ttf" );
		resource.AddFile( "resources/fonts/OpenSans-Regular.ttf" );
		resource.AddFile( "resources/fonts/OpenSans-Semibold.ttf" );
	
	else
	
		self:CreateFonts()
		
		self.DrawCard = self:CreateTextureBorder( 2, 2, 110, 110, 5, 5, 5, 5)
	
	end

end

function Theme:CreateFonts()

	self:AddFont( "MUI.Default.Calibri.18", {
		font = "Calibri",
		size = 18,
		weight = 400,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	})
	
	self:AddFont( "MUI.Default.Calibri.18.Bold", {
		font = "Calibri",
		size = 18,
		weight = 600,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	})
	
	self:AddFont( "MUI.Default.Calibri.24", {
		font = "Calibri",
		size = 24,
		weight = 400,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	})


end

-----------------------------------------
--	Don't edit below this line unless you know how to lua
-----------------------------------------

function Theme:AddFont( sFont, tFontData)
	if ( not self.Fonts ) then self.Fonts = {}; end
	surface.CreateFont( sFont, tFontData );
	self.Fonts[sFont] = tFontData;
end

function Theme:GetFontHeight( sFont )
	if ( not self.Fonts ) then return self.DefaultLineHeight; end
	if ( not self.Fonts[sFont] ) then return self.DefaultLineHeight; end
	if ( not self.Fonts[sFont].size ) then return self.DefaultLineHeight end
	return self.Fonts[sFont].size;
end

function Theme:CreateTextureBorder( _x, _y, _w, _h, l, t, r, b )

	local mat = self.GwenTexture;
	local tex = mat:GetTexture( "$basetexture" );
	
	_x = _x / tex:Width();
	_y = _y / tex:Height();
	_w = _w / tex:Width();
	_h = _h / tex:Height();
	
	local _l = l / tex:Width();
	local _t = t / tex:Height();
	local _r = r / tex:Width();
	local _b = b / tex:Height();
	
	local x, y, w, h = 0, 0, 110, 110
	
	return function( self, x, y, w, h, col, middle )
		
		if ( middle == nil ) then middle = true end
		
		surface.SetMaterial( mat );
		if ( col ) then 
			surface.SetDrawColor( col );
		else
			surface.SetDrawColor( 255, 255, 255, 255 );
		end
		
		-- top 
		surface.DrawTexturedRectUV( x, y, l, t, _x, _y, _x+_l, _y+_t );
		surface.DrawTexturedRectUV( x+l, y, w-l-r, t, _x+_l, _y, _x+_w-_r, _y+_t );
		surface.DrawTexturedRectUV( x+w-r, y, r, t, _x+_w-_r, _y, _x+_w, _y+_t );
	
		-- bottom 
		surface.DrawTexturedRectUV( x, y+h-b, l, b, _x, _y+_h-_b, _x+_l, _y+_h );
		surface.DrawTexturedRectUV( x+l, y+h-b, w-l-r, b, _x+_l, _y+_h-_b, _x+_w-_r, _y+_h );
		surface.DrawTexturedRectUV( x+w-r, y+h-b, r, b, _x+_w-_r, _y+_h-_b, _x+_w, _y+_h );
		
		-- middle. 
		if ( middle ) then
		surface.DrawTexturedRectUV( x+l, y+t, w-l-r, h-t-b, _x+_l, _y+_t, _x+_w-_r, _y+_h-_b );
		end
		surface.DrawTexturedRectUV( x, y+t, l, h-t-b, _x, _y+_t, _x+_l, _y+_h-_b );
		surface.DrawTexturedRectUV( x+w-r, y+t, r, h-t-b, _x+_w-_r, _y+_t, _x+_w, _y+_h-_b );
	
	end

end

function Theme:CreateTextureNormal( _x, _y, _w, _h )

	local mat = self.GwenTexture;
	local tex = mat:GetTexture( "$basetexture" );
	
	_x = _x / tex:Width();
	_y = _y / tex:Height();
	_w = _w / tex:Width();
	_h = _h / tex:Height();
		
	return function( self, x, y, w, h, col )
		
		surface.SetMaterial( mat );
		
		if ( col ) then 
			surface.SetDrawColor( col );
		else
			surface.SetDrawColor( 255, 255, 255, 255 );
		end
		
		surface.DrawTexturedRectUV( x, y, w, h, _x, _y, _x+_w, _y+_h );

	end

end

function Theme:CreateTextureCentered( _x, _y, _w, _h )

	local mat = self.GwenTexture;
	local tex = mat:GetTexture( "$basetexture" );
	
	local width = _w;
	local height = _h;
	
	_x = _x / tex:Width();
	_y = _y / tex:Height();
	_w = _w / tex:Width();
	_h = _h / tex:Height();
		
	return function( self, x, y, w, h, col )
		
		x = x + (w-width)*0.5;
		y = y + (h-height)*0.5;
		w = width;
		h = height;
		
		surface.SetMaterial( mat );
		
		if ( col ) then 
			surface.SetDrawColor( col );
		else
			surface.SetDrawColor( 255, 255, 255, 255 );
		end
		
		surface.DrawTexturedRectUV( x, y, w, h, _x, _y, _x+_w, _y+_h );

	end;

end

function Theme:TextureColor( x, y )

	local mat = self.GwenTexture;
	return mat:GetColor( x, y );

end

function Theme:CalculateLineHeight( iFontHeight )
	return math.floor( iFontHeight * self.ReducedGoldenRatio );
end

function Theme:WordWrap( sText, iWidth, sFont )
	sText = Format( "<font=%s>%s</font>", sFont or self.DefaultFont, sText );
	local tbl = {};
	for k,v in ipairs( string.Explode( sText, "\n" ) ) do
		for key, value in pairs(markup.Parse(sText, iWidth).blocks) do
			table.insert(tbl, value.text);
		end
	end
	return tbl;
end

function Theme:DrawText( sText, sFont, x, y, color, xAlign, yAlign, iWidth, iFontHeight )
	if ( not iFontHeight ) then iFontHeight = self:GetFontHeight( sFont ) end
	local LineHeight = self:CalculateLineHeight( iFontHeight )
	local WordWrap = self:WordWrap( sText, iWidth, sFont );
	for _, Text in ipairs( WordWrap ) do
		draw.SimpleText( Text, sFont, x, y + (_-1)*LineHeight, color, xAlign or TEXT_ALIGN_LEFT, yAlign or TEXT_ALIGN_BOTTOM );
	end
end
-----------------------------------------
--	In case the file is reloaded, this fixes that
-----------------------------------------
if ( LuaReloaded ) then
	MUI.ThemeLoader.RegisterTable( Theme, Theme.FileName );
	Theme = nil;
end
