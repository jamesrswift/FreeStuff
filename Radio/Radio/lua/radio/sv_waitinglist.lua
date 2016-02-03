-- Radio/sv_waitinglist.lua

Radio.WaitingList = {};
util.AddNetworkString("Radio.UpdateWaitingList");
util.AddNetworkString("Radio.RequestWaitingList");

function Radio.AddToWaitingList( song )
	if (table.Count(Radio.WaitingList) == Radio.Config.MaxWaitingList) then
		print( "[Radio] Too many songs on the waiting list!" );
	else
		Radio.WaitingList[#Radio.WaitingList + 1] = song;
		
		if not Radio.GetCurrentSong() then
			local Bottom = Radio:GetBottomWaitingItem()
			if Bottom then
				Radio.PlaySong( Radio:GetBottomWaitingItem() );
				Radio.RemoveBottomWaitingItem();
			end
		end
		
		hook.Call( "Radio.SongAddedToWaitingList", GAMEMODE, song)
	end
end

function Radio.RemoveBottomWaitingItem()
	Radio.WaitingList[1] = nil;
	for i=2,#Radio.WaitingList do
		Radio.WaitingList[i-1] = Radio.WaitingList[i];
		Radio.WaitingList[i] = nil
	end
	hook.Call( "Radio.SongRemovedFromWaitingList", GAMEMODE, song)
end

function Radio.GetBottomWaitingItem()
	return Radio.WaitingList[1];
end

function Radio.SendWaitingList()
	net.Start( "Radio.UpdateWaitingList")
	net.WriteTable( Radio.WaitingList );
	net.Broadcast();
end

net.Receive( "Radio.RequestWaitingList", function()
	Radio.SendWaitingList()
end)
	