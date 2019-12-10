--[[
───────────────────────────────────────────────────────────────

	SEM_Loadout (server.lua) - Created by Scott M
	Current Version: v1.0 (Dec 2019)
	
	Support: https://semdevelopment.com/discord
	
		!!! Change vaules in the 'config.lua' !!!
	DO NOT EDIT THIS IF YOU DON'T KNOW WHAT YOU ARE DOING
	
───────────────────────────────────────────────────────────────
]]



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
				print('\n--------------------------------------------------------------------------\n')
			elseif tonumber(CurrentVersion) > tonumber(Data.NewestVersion) then
				print('^3Your version of SEM_Loadout is higher than the current version!^7')
			else
				print('^2SEM_Loadout is up to date!')
			end
		else
			print('^1SEM_Loadout Version Check Failed!^7')
		end
		
		SetTimeout(60000000, VersionCheckHTTPRequest)
	end

	VersionCheckHTTPRequest()
end)