--[[
───────────────────────────────────────────────────────────────

	SEM_Loadout (server.lua) - Created by Scott M
	Current Version: v1.2 (Feb 2020)
	
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





RegisterServerEvent('SEM_ArmouryPerms')
AddEventHandler('SEM_ArmouryPerms', function()
    if IsPlayerAceAllowed(source, 'sem.leo-armoury') then
		TriggerClientEvent('SEM_ArmouryPermsResult', source, true)
	else
		TriggerClientEvent('SEM_ArmouryPermsResult', source, false)
	end
end)

RegisterServerEvent('SEM_LockerPerms')
AddEventHandler('SEM_LockerPerms', function()
    if IsPlayerAceAllowed(source, 'sem.leo-locker') then
		TriggerClientEvent('SEM_LockerPermsResult', source, true)
	else
		TriggerClientEvent('SEM_LockerPermsResult', source, false)
	end
end)

RegisterServerEvent('SEM_GaragePerms')
AddEventHandler('SEM_GaragePerms', function()
    if IsPlayerAceAllowed(source, 'sem.leo-garage') then
		TriggerClientEvent('SEM_GaragePermsResult', source, true)
	else
		TriggerClientEvent('SEM_GaragePermsResult', source, false)
	end
end)

RegisterServerEvent('SEM_DeleterPerms')
AddEventHandler('SEM_DeleterPerms', function()
    if IsPlayerAceAllowed(source, 'sem.leo-deleter') then
		TriggerClientEvent('SEM_DeleterPermsResult', source, true)
	else
		TriggerClientEvent('SEM_DeleterPermsResult', source, false)
	end
end)

RegisterServerEvent('SEM_JailPerms')
AddEventHandler('SEM_JailPerms', function()
    if IsPlayerAceAllowed(source, 'sem.leo-jail') then
		TriggerClientEvent('SEM_JailPermsResult', source, true)
	else
		TriggerClientEvent('SEM_JailPermsResult', source, false)
	end
end)

RegisterServerEvent('SEM_LoadoutPerms')
AddEventHandler('SEM_LoadoutPerms', function()
    if IsPlayerAceAllowed(source, 'sem.fire-loadout') then
		TriggerClientEvent('SEM_LoadoutPermsResult', source, true)
	else
		TriggerClientEvent('SEM_LoadoutPermsResult', source, false)
	end
end)

RegisterServerEvent('SEM_FireGaragePerms')
AddEventHandler('SEM_FireGaragePerms', function()
    if IsPlayerAceAllowed(source, 'sem.fire-garage') then
		TriggerClientEvent('SEM_FireGaragePermsResult', source, true)
	else
		TriggerClientEvent('SEM_FireGaragePermsResult', source, false)
	end
end)

RegisterServerEvent('SEM_FireDeleterPerms')
AddEventHandler('SEM_FireDeleterPerms', function()
    if IsPlayerAceAllowed(source, 'sem.fire-deleter') then
		TriggerClientEvent('SEM_FireDeleterPermsResult', source, true)
	else
		TriggerClientEvent('SEM_FireDeleterPermsResult', source, false)
	end
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