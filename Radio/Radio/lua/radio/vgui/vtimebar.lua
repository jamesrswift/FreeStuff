-- Radio/vgui/vtimebar.lua

PANEL = {}

AccessorFunc( PANEL, "_MaxTime", "MaxTime", FORCE_NUMBER )
AccessorFunc( PANEL, "_CurrentTime", "CurrentTime", FORCE_NUMBER )
AccessorFunc( PANEL, "_StartTime", "StartTime", FORCE_NUMBER )
AccessorFunc( PANEL, "_Paused", "Paused", FORCE_BOOL )

function PANEL:Init()

	self:SetSize( 270, 30 )

	self._CurrentTime = 0;
	self._MaxTime = 0;
	self._Paused = true;
	self._StartTime = os.time() - self:GetCurrentTime();
	
	self.DProgress = vgui.Create( "DProgress", self )
	self.DProgress:Dock(FILL)
	self.DProgress:SetSize( self:GetSize() )
	self.DProgress:SetFraction( 1 )
	
	function self.DProgress:PaintOver( w, h )
		local t = "No song playing"
		if self:GetParent():GetCurrentTime() != 0 then t = Radio.AntiTimeConversion(self:GetParent():GetCurrentTime()) end
		draw.SimpleText( t, "vTimeBarFont", (w/2)-1, (h/2)-1, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( t, "vTimeBarFont", (w/2)+1, (h/2)-1, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( t, "vTimeBarFont", (w/2)-1, (h/2)+1, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( t, "vTimeBarFont", (w/2)+1, (h/2)+1, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( t, "vTimeBarFont", w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
end

function PANEL:Play()
	self:SetPaused(false);
end

function PANEL:UpdateTimeBar(length, started)

	self:SetMaxTime(length)
	self:SetStartTime(started)
	self:Play();

end

function PANEL:Think()
	if (not self:GetPaused()) then -- Problem
		if ( self._StartTime != 0 ) then
			self:SetCurrentTime( math.floor(os.time()) - self._StartTime );
			self.DProgress:SetFraction( self:GetCurrentTime() / self:GetMaxTime() )
			if (self:GetCurrentTime() == self:GetMaxTime()) then
				self:SetPaused(true)
			end
		else
			self:SetCurrentTime( 0 );
			self.DProgress:SetFraction( 1 )
			self:SetPaused(true)
		end
	end

end

vgui.Register( "vtimebar", PANEL, "Panel" )