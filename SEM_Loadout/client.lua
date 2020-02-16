--[[
──────────────────────────────────────────────────────────────

	SEM_Loadout (client.lua) - Created by Scott M
	Current Version: v1.2 (Feb 2020)
	
	Support: https://semdevelopment.com/discord
	
		!!! Change vaules in the 'config.lua' !!!
	DO NOT EDIT THIS IF YOU DON'T KNOW WHAT YOU ARE DOING

──────────────────────────────────────────────────────────────
]]



_MenuPool = NativeUI.CreatePool()

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		if Config.LEOMarkers then
			if Config.DisplayArmoury and LEOArmouryRestrict() then
				for _, Location in pairs(Config.ArmouryLocations) do
					if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  Config.DisplayDistance) then
						Marker(Location.x, Location.y, Location.z - 1)
					
						if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  0.75) then
							NotifyHelp('~b~Armoury~w~, Press ' .. Config.ButtonHelp ..' to Access')

							_MenuPool:MouseControlsEnabled(false)
							_MenuPool:ControlDisablingEnabled(false)
							_MenuPool:ProcessMenus()

							if IsControlJustReleased(1, Config.Button) and GetLastInputMethod(2) then
								local ArmouryMenu = NativeUI.CreateMenu('Armoury', GetResourceMetadata(GetCurrentResourceName(), 'title', 0) .. ' ~y~' .. GetResourceMetadata(GetCurrentResourceName(), 'version', 0), MenuOri)
								_MenuPool:Add(ArmouryMenu)
								ArmouryMenu:SetMenuWidthOffset(Config.MenuWidth)
								for Name, Category in pairs(Config.ArmouryContents) do
									local ArmouryItem = NativeUI.CreateItem(Name, '')
									ArmouryMenu:AddItem(ArmouryItem)
									ArmouryItem.Activated = function(ParentMenu, SelectedItem)
										SetEntityHealth(GetPlayerPed(-1), 200)
										RemoveAllPedWeapons(GetPlayerPed(-1), true)
										AddArmourToPed(GetPlayerPed(-1), 100)

										for _, Weapon in pairs(Category) do
											GiveWeapon(Weapon.weapon)
												
											for _, Component in pairs(Weapon.components) do
												AddWeaponComponent(Weapon.weapon, Component)
											end
										end

										Notify('~b~Loadout Spawned: ~g~' .. Name)
									end
								end

								local ClearWeapons = NativeUI.CreateItem('Return Weapons', '')
								ArmouryMenu:AddItem(ClearWeapons)
								ClearWeapons.Activated = function(ParentMenu, SelectedItem)
									RemoveAllPedWeapons(GetPlayerPed(-1), true)
									Notify('~r~Weapons Returned')
								end

								ArmouryMenu:Visible(not ArmouryMenu:Visible())
								_MenuPool:RefreshIndex()
							end
						end
					end
				end
			end



			if Config.DisplayLocker and LEOLockerRestrict() then
				for _, Location in pairs(Config.LockerLocations) do
					if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  Config.DisplayDistance) then
						Marker(Location.x, Location.y, Location.z - 1)
						
						if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  0.75) then
							NotifyHelp('~b~Locker Room~w~, Press ' .. Config.ButtonHelp .. ' to Access')

							_MenuPool:MouseControlsEnabled(false)
							_MenuPool:ControlDisablingEnabled(false)
							_MenuPool:ProcessMenus()

							if IsControlJustReleased(1, Config.Button) and GetLastInputMethod(2) then
								local LockerMenu = NativeUI.CreateMenu('Locker Room', GetResourceMetadata(GetCurrentResourceName(), 'title', 0) .. ' ~y~' .. GetResourceMetadata(GetCurrentResourceName(), 'version', 0), MenuOri)
								_MenuPool:Add(LockerMenu)
								LockerMenu:SetMenuWidthOffset(Config.MenuWidth)
								for _, Uniform in pairs(Config.LockerContents) do
									local LockerItem = NativeUI.CreateItem(Uniform.name, '')
									LockerMenu:AddItem(LockerItem)
									LockerItem.Activated = function(ParentMenu, SelectedItem)
										SetEntityHealth(GetPlayerPed(-1), 200)
										RemoveAllPedWeapons(GetPlayerPed(-1), true)
										AddArmourToPed(GetPlayerPed(-1), 100)

										SpawnPed(Uniform.uniform)

										Notify('~b~Uniform Spawned: ~g~' .. Uniform.name)
									end
								end

								LockerMenu:Visible(not LockerMenu:Visible())
								_MenuPool:RefreshIndex()
							end
						end
					end
				end
			end



			if Config.DisplayGarage and LEOGarageRestrict() then
				for _, Location in pairs(Config.GarageLocations) do
					if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.Marker.x, Location.Marker.y, Location.Marker.z - 1) <  Config.DisplayDistance) then
						Marker(Location.Marker.x, Location.Marker.y, Location.Marker.z - 1)
						
						if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.Marker.x, Location.Marker.y, Location.Marker.z - 1) <  0.75) then
							NotifyHelp('~b~Garage~w~, Press ' .. Config.ButtonHelp .. ' to Access')

							_MenuPool:MouseControlsEnabled(false)
							_MenuPool:ControlDisablingEnabled(false)
							_MenuPool:ProcessMenus()

							if IsControlJustReleased(1, Config.Button) and GetLastInputMethod(2) then
								local GarageMenu = NativeUI.CreateMenu('Garage', GetResourceMetadata(GetCurrentResourceName(), 'title', 0) .. ' ~y~' .. GetResourceMetadata(GetCurrentResourceName(), 'version', 0), MenuOri)
								_MenuPool:Add(GarageMenu)
								GarageMenu:SetMenuWidthOffset(Config.MenuWidth)
								for Name, Category in pairs(Config.GarageContents) do
									local GarageSubMenu = _MenuPool:AddSubMenu(GarageMenu, Name, '', true)
									GarageSubMenu:SetMenuWidthOffset(Config.MenuWidth)

									for _, Vehicle in pairs(Category) do
										local GarageItem = NativeUI.CreateItem(Vehicle.name, '')
										GarageSubMenu:AddItem(GarageItem)
										GarageItem.Activated = function(ParentMenu, SelectedItem)
											SpawnVehicle(Vehicle.spawncode, Vehicle.name, Vehicle.extras, Location.Spawn.x, Location.Spawn.y, Location.Spawn.z, Location.Spawn.h)
											_MenuPool:CloseAllMenus()
										end
									end
								end

								GarageMenu:Visible(not GarageMenu:Visible())
								_MenuPool:RefreshIndex()
							end
						end
					end
				end
			end



			if Config.DisplayVehicleDeleters and LEODeleterRestrict() then
				for _, Location in pairs(Config.VehicleDeleterLocations) do
					if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  Config.DisplayDistance * 2) then
						if IsPedInAnyVehicle(PlayerPedId()) then
							Marker(Location.x, Location.y, Location.z - 1)
							
							if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  1.50) then
								NotifyHelp('~b~Delete Vehicle~w~, Press ' .. Config.ButtonHelp .. ' to Delete')

									if IsControlJustReleased(1, Config.Button) then
										
										if (IsPedSittingInAnyVehicle(PlayerPedId())) then 
											local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
							
											if (GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId()) then 
												SetEntityAsMissionEntity(Vehicle, true, true)
												DeleteVehicle(Vehicle)
							
												if not (DoesEntityExist(vehicle)) then 
													Notify('~r~Vehicle Deleted')
												end 
											else 
												Notify('You must be in the driver\'s seat!')
											end 
										end
									end
							end
						end
					end
				end
			end



			if Config.DisplayJail and LEOJailRestrict() then
				for _, Location in pairs(Config.JailLocations) do
					if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  Config.DisplayDistance) then
						Marker(Location.x, Location.y, Location.z - 1)
						
						if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  1.50) then
							NotifyHelp('~b~Jail~w~, Press ' .. Config.ButtonHelp .. ' to Access')

							if IsControlJustReleased(1, Config.Button) then
								local ID = 0
								local RawID = KeyboardInput('Player ID:', 5)
								if RawID == nil or RawID == '' then
									Notify('~r~No ID Provided!')
									break
								else
									ID = tonumber(RawID)
								end
								
								
								
								if Config.JailTimes.Min == 0 then
									JailMinTime = 'None'
								end
								if Config.JailTimes.Max == 0 then
									JailMaxTime = 'None'
								end
								local Time = 0
								local RawTime = KeyboardInput('Time: (Seconds) - Max Time: ' .. Config.JailTimes.Max .. ' | Default Time: ' .. Config.JailTimes.Min)
								if RawTime == nil or RawTime == '' then
									Notify('~r~No Time Specified - Default Time Used')
									Time = Config.JailTimes.Min
								elseif tonumber(RawTime) > Config.JailTimes.Max then
									Notify('~y~Exceeded Max Time\nMax Time: ' .. Config.JailTimes.Max .. '\n\n~g~Jail Time = ' .. Config.JailTimes.Max)
									Time = Config.JailTimes.Max
								else
									Time = tonumber(RawTime)
								end
								
								
								
								local Reason = ''
								local RawReason = KeyboardInput('Reason:', 256)
								if RawReason == nil or RawReason == '' then
									Notify('~r~No Reason Specified!')
									Reason = 'None Specified'
								else
									Reason = RawReason
								end
								
								
								
								TriggerServerEvent('SEM_Jail', ID, Time, Reason)
							end
						end
					end
				end
			end
		end

		
		
		
		
		
		


		if Config.FireMarkers then
			if Config.DisplayLoadout and FireLoadoutRestrict() then
				for _, Location in pairs(Config.LoadoutLocations) do
					if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  Config.DisplayDistance) then
						Marker(Location.x, Location.y, Location.z - 1)
						
						if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  1.50) then
							NotifyHelp('~b~Equipment & Uniforms~w~, Press ' .. Config.ButtonHelp .. ' to Access')

							_MenuPool:MouseControlsEnabled(false)
							_MenuPool:ControlDisablingEnabled(false)
							_MenuPool:ProcessMenus()

							if IsControlJustReleased(1, Config.Button) and GetLastInputMethod(2) then
								local EquipmentMenu = NativeUI.CreateMenu('Equipment Room', GetResourceMetadata(GetCurrentResourceName(), 'title', 0) .. ' ~y~' .. GetResourceMetadata(GetCurrentResourceName(), 'version', 0), MenuOri)
								_MenuPool:Add(EquipmentMenu)
								EquipmentMenu:SetMenuWidthOffset(Config.MenuWidth)
								for Name, Equipment in pairs(Config.LoadoutContents) do
									local EquipmentItem = NativeUI.CreateItem(Name, '')
									EquipmentMenu:AddItem(EquipmentItem)
									EquipmentItem.Activated = function(ParentMenu, SelectedItem)
										SetEntityHealth(GetPlayerPed(-1), 200)
										RemoveAllPedWeapons(GetPlayerPed(-1), true)
										AddArmourToPed(GetPlayerPed(-1), 100)

										for _, Item in pairs(Equipment) do
											if Item.uniform then
												SpawnPed(Item.uniform)
												print('Uniform: ' .. tostring(Item.uniform))
											end

											if Item.weapon then
												Citizen.Wait(100)
												GiveWeapon(Item.weapon)
											end
										end

										Notify('~b~Equipment Spawned: ~g~' .. Name)
									end
								end

								EquipmentMenu:Visible(not EquipmentMenu:Visible())
								_MenuPool:RefreshIndex()
							end
						end
					end
				end
			end

			if Config.DisplayFireGarage and FireGarageRestrict() then
				for _, Location in pairs(Config.FireGarageLocations) do
					if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.Marker.x, Location.Marker.y, Location.Marker.z - 1) <  Config.DisplayDistance) then
						Marker(Location.Marker.x, Location.Marker.y, Location.Marker.z - 1)
						
						if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.Marker.x, Location.Marker.y, Location.Marker.z - 1) <  0.75) then
							NotifyHelp('~b~Garage~w~, Press ' .. Config.ButtonHelp .. ' to Access')

							_MenuPool:MouseControlsEnabled(false)
							_MenuPool:ControlDisablingEnabled(false)
							_MenuPool:ProcessMenus()

							if IsControlJustReleased(1, Config.Button) and GetLastInputMethod(2) then
								local GarageMenu = NativeUI.CreateMenu('Garage', GetResourceMetadata(GetCurrentResourceName(), 'title', 0) .. ' ~y~' .. GetResourceMetadata(GetCurrentResourceName(), 'version', 0), MenuOri)
								_MenuPool:Add(GarageMenu)
								GarageMenu:SetMenuWidthOffset(Config.MenuWidth)
								for _, Vehicle in pairs(Config.FireGarageContents) do
									local GarageItem = NativeUI.CreateItem(Vehicle.name, '')
									GarageMenu:AddItem(GarageItem)
									GarageItem.Activated = function(ParentMenu, SelectedItem)
										SpawnVehicle(Vehicle.spawncode, Vehicle.name, Vehicle.extras, Location.Spawn.x, Location.Spawn.y, Location.Spawn.z, Location.Spawn.h)
										_MenuPool:CloseAllMenus()
									end
								end

								GarageMenu:Visible(not GarageMenu:Visible())
								_MenuPool:RefreshIndex()
							end
						end
					end
				end
			end



			if Config.DisplayFireVehicleDeleters and FireDeleterRestrict() then
				for _, Location in pairs(Config.FireVehicleDeleterLocations) do
					if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  Config.DisplayDistance * 2) then
						if IsPedInAnyVehicle(PlayerPedId()) then
							Marker(Location.x, Location.y, Location.z - 1)
							
							if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  1.50) then
								NotifyHelp('~b~Delete Vehicle~w~, Press ' .. Config.ButtonHelp .. ' to Delete')

								if IsControlJustReleased(1, Config.Button) then
										
									if (IsPedSittingInAnyVehicle(PlayerPedId())) then 
										local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
							
										if (GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId()) then 
											SetEntityAsMissionEntity(Vehicle, true, true)
											DeleteVehicle(Vehicle)
							
											if not (DoesEntityExist(vehicle)) then 
												Notify('~r~Vehicle Deleted')
											end 
										else 
											Notify('You must be in the driver\'s seat!')
										end 
									end
								end
							end
						end
					end
				end
			end
		end
    end
end)



local CurrentlyJailed = false
local OriginalJailTime = 0

RegisterNetEvent('SEM_JailPlayer')
AddEventHandler('SEM_JailPlayer', function(ID, Time, Reason)
	if CurrentlyJailed then
		return
	end
	
	OriginalJailTime = Time
	
	local Player = GetPlayerPed(-1)
	if DoesEntityExist(Player) then
		Citizen.CreateThread(function()
			Citizen.Wait(0)
            SetEntityCoords(Player, 1670.34, 2640.40, 45.56)
            SetEntityHeading(Player, 39.11)
			CurrentlyJailed = true
			
			while Time > 0 do
				RemoveAllPedWeapons(Player, true)
				SetEntityInvincible(Player, true)
				if IsPedInAnyVehicle(Player, false) then
					local Vehicle = GetVehiclePedIsIn(Player, false)
					DeleteVehicle(Vehicle)
					ClearPedTasksImmediately(Player)
				end
				Citizen.Wait(1000)
				local Location = GetEntityCoords(Player, true)
				local Distance = Vdist(1670.34, 2640.40, 45.56, Location['x'], Location['y'], Location['z'])
				if Distance > 100 then
					SetEntityCoords(Player, 1670.34, 2640.40, 45.56)
                    SetEntityHeading(Player, 39.11)
				end
				
				Time = Time - 1
			end
			
			SetEntityCoords(Player, 1855.807, 2601.949, 45.323)
            SetEntityHeading(Player, 265.61)
			CurrentlyJailed = false
			SetEntityInvincible(Player, false)
			
			TriggerServerEvent('SEM_JailMessage', -1, 'Judge', {86, 96, 252}, GetPlayerName(PlayerId()) ..' was released from Jail after ' .. OriginalJailTime .. ' seconds.')
		end)
	end
end)



RegisterCommand('coords', function(source, args, rawCommands)
    local Coords = GetEntityCoords(PlayerPedId())
    local Heading = GetEntityHeading(PlayerPedId())

    TriggerEvent('chatMessage', 'Coords', {255, 255, 0}, '\nX: ' .. Coords.x .. '\nY: ' .. Coords.y .. '\nZ: ' .. Coords.z .. '\nHeading: ' .. Heading)
end)

Citizen.CreateThread(function()
	TriggerEvent('chat:AddSuggestion', '/coords', 'Shows Current Player Coords and Heading')
end)



-- Permissions --
ArmouryAce = false
TriggerServerEvent('SEM_ArmouryPerms')
RegisterNetEvent('SEM_ArmouryPermsResult')
AddEventHandler('SEM_ArmouryPermsResult', function(Allowed)
    ArmouryAce = Allowed
end)

LockerAce = false
TriggerServerEvent('SEM_LockerPerms')
RegisterNetEvent('SEM_LockerPermsResult')
AddEventHandler('SEM_LockerPermsResult', function(Allowed)
    LockerAce = Allowed
end)

GarageAce = false
TriggerServerEvent('SEM_GaragePerms')
RegisterNetEvent('SEM_GaragePermsResult')
AddEventHandler('SEM_GaragePermsResult', function(Allowed)
    GarageAce = Allowed
end)

DeleterAce = false
TriggerServerEvent('SEM_DeleterPerms')
RegisterNetEvent('SEM_DeleterPermsResult')
AddEventHandler('SEM_DeleterPermsResult', function(Allowed)
    DeleterAce = Allowed
end)

JailAce = false
TriggerServerEvent('SEM_JailPerms')
RegisterNetEvent('SEM_JailPermsResult')
AddEventHandler('SEM_JailPermsResult', function(Allowed)
    JailAce = Allowed
end)

LoadoutAce = false
TriggerServerEvent('SEM_LoadoutPerms')
RegisterNetEvent('SEM_LoadoutPermsResult')
AddEventHandler('SEM_LoadoutPermsResult', function(Allowed)
    LoadoutAce = Allowed
end)

FireGarageAce = false
TriggerServerEvent('SEM_FireGaragePerms')
RegisterNetEvent('SEM_FireGaragePermsResult')
AddEventHandler('SEM_FireGaragePermsResult', function(Allowed)
    FireGarageAce = Allowed
end)

FireDeleterAce = false
TriggerServerEvent('SEM_FireDeleterPerms')
RegisterNetEvent('SEM_FireDeleterPermsResult')
AddEventHandler('SEM_FireDeleterPermsResult', function(Allowed)
    FireDeleterAce = Allowed
end)