-- Radio/cl_vgui.lua

surface.CreateFont("vTimeBarFont", {
	font = "Trebuchet24", 
	size = 24, 
	weight = 800, 
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

include("vgui/vtimebar.lua");
include("vgui/vradio.lua");

function Radio.AdminMenu()
	local RadioAdminMenuWindow = vgui.Create( "DFrame" )
	RadioAdminMenuWindow:SetPos( 100, 100 )
	RadioAdminMenuWindow:SetSize( 300, 500 )
	RadioAdminMenuWindow:SetTitle( "Radio.AdminMenu" )
	RadioAdminMenuWindow:SetDraggable( true )
	RadioAdminMenuWindow:MakePopup()
	
	local vTimeBar = vgui.Create( "vtimebar", RadioAdminMenuWindow );
	vTimeBar:Dock(TOP)
	vTimeBar:DockMargin(5,5,5,5)
	vTimeBar:SetPaused(Radio.CurrentSong.Length == 0);
	vTimeBar:SetMaxTime(Radio.CurrentSong.Length);
	if ( Radio.CurrentSong.Started != 0) then
		vTimeBar:SetStartTime(Radio.CurrentSong.Started);
	else
		vTimeBar:SetStartTime(0);
	end
	
	local music = "Caravan Palace - Rock it for Me";
	
	local ControlPanel = vgui.Create( "DPanel", RadioAdminMenuWindow )
	ControlPanel:Dock(LEFT)
	ControlPanel:DockMargin(5,5,5,5)
	
	local DButtonPlay = vgui.Create( "DButton", ControlPanel )
	DButtonPlay:Dock(TOP)
	DButtonPlay:DockMargin(5,5,5,5)
	DButtonPlay:SetText( "Play" )
	DButtonPlay.DoClick = function()
		Radio.RequestSong( music )
	end
	
	local DButtonStop = vgui.Create( "DButton", ControlPanel )
	DButtonStop:Dock(TOP)
	DButtonStop:DockMargin(5,5,5,5)
	DButtonStop:SetText( "Stop" )
	DButtonStop.DoClick = function()
		Radio.EndSong_Personal()
	end
	
	local DButtonStopAll = vgui.Create( "DButton", ControlPanel )
	DButtonStopAll:Dock(TOP)
	DButtonStopAll:DockMargin(5,5,5,5)
	DButtonStopAll:SetText( "Stop All" )
	DButtonStopAll.DoClick = function()
		Radio.RequestStopAll()
	end
	
	local DButtonUpdate = vgui.Create( "DButton", ControlPanel )
	DButtonUpdate:Dock(TOP)
	DButtonUpdate:DockMargin(5,5,5,5)
	DButtonUpdate:SetText( "Update" )
	DButtonUpdate.DoClick = function()
		Radio.RequestSongList()
	end
	
	local VolumeSlider = vgui.Create("DNumSlider", RadioAdminMenuWindow)
	VolumeSlider:Dock(BOTTOM)
	VolumeSlider:DockMargin(5,5,5,5)
	VolumeSlider:SetText("Volume") // Set the text above the slider
	VolumeSlider:SetMin(0)				 // Set the minimum number you can slide to
	VolumeSlider:SetMax(100)				// Set the maximum number you can slide to
	VolumeSlider:SetDecimals(0)			 // Decimal places - zero for whole number
	VolumeSlider:SetValue( Radio.Volume*100)
	function VolumeSlider:ValueChanged()
		Radio.SetVolume( self:GetValue()/100 )
		VolumeSlider:SetValue( Radio.Volume*100)
	end
	
	local SongList = vgui.Create( "DListView", RadioAdminMenuWindow )
	SongList:SetMultiSelect( false )
	SongList:AddColumn( "SongName" )
	SongList:AddColumn( "Length" ):SetMaxWidth( 60 )
	SongList:Dock(FILL)
	SongList:DockMargin(5,5,5,5)

	for k,v in pairs(Radio.SongList) do
		SongList:AddLine( k, Radio.AntiTimeConversion(v) )
	end
	
	function SongList:OnRowSelected( rowIndex, row )
		music = row:GetColumnText(1)
	end
	
	hook.Add("Radio.SongPlayed", "UpdatedVTimeBar", function( name, length, started )
		if (!vTimeBar) then return end
		vTimeBar:SetMaxTime(length)
		vTimeBar:SetStartTime(started)
		vTimeBar:Play();

	end)
	
	hook.Add("Radio.SongEnded", "UpdatedVTimeBar"..tostring(self), function( )
		vTimeBar:UpdateTimeBar( 0, 0)
		vTimeBar:SetPaused(true)
	end)

end

--[[
	Radio panel at bottom of the screen
--]]

AccessorFunc( Radio, "RadioPanelIsShowing", "RadioPanelShowing", FORCE_BOOL )

hook.Add("Radio.SongPlayed", "UpdatedVTimeBar"..tostring(self), function( name, length, started )
	if (!Radio.RadioPanel) then return end
	Radio.RadioPanel:UpdateTimeBar( length, started)
	Radio.RadioPanel.timebar:SetPaused(false)
end)

hook.Add("Radio.SongEnded", "UpdatedVTimeBar"..tostring(self), function( )
	if (!Radio.RadioPanel) then return end
	Radio.RadioPanel:UpdateTimeBar( 0, 0)
	Radio.RadioPanel.timebar:SetPaused(true)
end)

function Radio.InitializeRadioPanel()
	print("Created Radio Panel")
	Radio.RadioPanel = vgui.Create( "vradio" );
	Radio.RadioPanel:SetSize( Radio.Config.RadioPanelSizeX, Radio.Config.RadioPanelSizeY ) 
	Radio.RadioPanel:SetPos( (ScrW() - Radio.Config.RadioPanelSizeX)/2, ScrH()+10 )
end

hook.Add( "Think" , "Radio.ShowRadioPanel", function()
	if (!Radio.RadioPanel) then return end
	local x, y = Radio.RadioPanel:GetPos();
	if Radio:GetRadioPanelShowing() then
		Radio.RadioPanel:SetPos( x , Lerp( 0.2, y, ScrH() - Radio.Config.RadioPanelSizeY ) )
	else
		Radio.RadioPanel:SetPos( x , Lerp( 0.2, y, ScrH()+10) )
	end
end)

concommand.Add( "+radio_show", function() if (!Radio.RadioPanel) then Radio.InitializeRadioPanel() end Radio:SetRadioPanelShowing(true) gui.EnableScreenClicker( true ) end)
concommand.Add( "-radio_show", function() Radio:SetRadioPanelShowing(false) gui.EnableScreenClicker( false ) end)