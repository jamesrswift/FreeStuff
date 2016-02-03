-- Radio/vgui/vradio.lua

PANEL = {}

function PANEL:Init()
	
	self:SetSize( 280, 70 )
	
	self.timebar = vgui.Create( "vtimebar", self )
	self.timebar:Dock( TOP )
	self.timebar:DockMargin( 5, 5, 5, 5 )
	self.timebar:SetSize( 270, 30);
	self.timebar:SetPaused(Radio.CurrentSong.Length == 0);
	self.timebar:SetMaxTime(Radio.CurrentSong.Length);
	if ( Radio.CurrentSong.Started != 0) then
		self.timebar:SetStartTime(Radio.CurrentSong.Started);
	else
		self.timebar:SetStartTime(0);
	end
	
	self.VolumeSlider = vgui.Create("DNumSlider", self)
	self.VolumeSlider:Dock( RIGHT )
	self.VolumeSlider:DockMargin( 5, 5, 5, 5 )
	self.VolumeSlider:SetSize(200, 20)
	self.VolumeSlider:SetText("Volume")
	self.VolumeSlider:SetMin(0)
	self.VolumeSlider:SetMax(100)
	self.VolumeSlider:SetDecimals(0)
	self.VolumeSlider:SetValue( Radio.Volume*100)
	
	function self.VolumeSlider:ValueChanged()
		Radio.SetVolume( self:GetValue()/100 )
		self:SetValue( Radio.Volume*100)
	end
	
	self.StopButton = vgui.Create( "DButton", self )
	self.StopButton:Dock(LEFT)
	self.StopButton:DockMargin(5,5,5,5)
	self.StopButton:SetText( "Stop" )
	self.StopButton:SetSize( 30,30 )
	self.StopButton.DoClick = function()
		Radio.EndSong_Personal()
	end
	
	self.MenuButton = vgui.Create( "DButton", self )
	self.MenuButton:Dock(LEFT)
	self.MenuButton:DockMargin(5,5,5,5)
	self.MenuButton:SetText( "Menu" )
	self.MenuButton:SetSize( 30,30 )
	self.MenuButton.DoClick = function()
		Radio.AdminMenu()
	end
	
end

function PANEL:Paint( w, h )
	surface.SetDrawColor(Color(0,0,0,100))
	surface.DrawRect( 0, 0, w, h)
end

function PANEL:Think()

end

function PANEL:Remove()
	self.timebar:Remove()
	self.VolumeSlide:Remove()
	self.StopButton:Remove()
end

function PANEL:UpdateTimeBar(length, started)

	if (!self.timebar) then return end
	self.timebar:UpdateTimeBar(length, started)

end

vgui.Register( "vradio", PANEL, "Panel" )