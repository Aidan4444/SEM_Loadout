--[[
───────────────────────────────────────────────────────────────

	SEM_Loadout (server.lua) - Created by Scott M
	Current Version: v1.1 (Dec 2019)
	
	Support: https://semdevelopment.com/discord
	
		!!! Change vaules in the 'config.lua' !!!
	DO NOT EDIT THIS IF YOU DON'T KNOW WHAT YOU ARE DOING
	
───────────────────────────────────────────────────────────────
]]



RegisterServerEvent('SEM_JailMessage')
AddEventHandler('SEM_JailMessage', function(Target, Title, Colour, Message)
	TriggerClientEvent('chatMessage', Target, Title, Colour, Message)
end)

RegisterServerEvent('SEM_Jail')
AddEventHandler('SEM_Jail', function(ID, Time, Reason)
	local Name = GetPlayerName(ID)
	if Name ~= nil then
		TriggerClientEvent('SEM_JailPlayer', ID, ID, Time, Reason)
		TriggerEvent('SEM_JailMessage', -1, 'Judge', {86, 96, 252}, GetPlayerName(ID) .. ' has been Jailed for ' .. Time .. ' seconds.\nReason: ' .. Reason)
		return
	end
	
	TriggerEvent('SEM_JailMessage', source, 'System', {0, 0, 0}, 'Invalid Player ID')
end)





Citizen.CreateThread(function()
	local CurrentVersion = json.decode(LoadResourceFile(GetCurrentResourceName(), 'version.json')).version

	function VersionCheckHTTPRequest()
		PerformHttpRequest('https://semdevelopment.com/releases/loadout/info/version.json', VersionCheck, 'GET')
	end

	function VersionCheck(err, response, headers)
		if err == 200 then
			local Data = json.decode(response)
			if tonumber(CurrentVersion) < tonumber(Data.NewestVersion) then
				print('\n--------------------------------------------------------------------------')
				print('\nSEM_Loadout is outdated!')
				print('Current Version: ^2' .. Data.NewestVersion .. '^7')
				print('Your Version: ^1' .. CurrentVersion .. '^7')
				print('Please download the lastest version from ^5' .. Data.DownloadLocation .. '^7')
				if Data.Changes ~= '' then
					print('\nChanges: ' .. Data.Changes)
				end
				print('\n--------------------------------------------------------------------------\n^7')
			elseif tonumber(CurrentVersion) > tonumber(Data.NewestVersion) then
				print('^3Your version of SEM_Loadout is higher than the current version!^7')
			else
				print('^2SEM_Loadout is up to date!^7')
			end
		else
			print('^1SEM_Loadout Version Check Failed!^7')
		end
		
		SetTimeout(60000000, VersionCheckHTTPRequest)
	end

	VersionCheckHTTPRequest()
end)