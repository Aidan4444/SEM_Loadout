--[[
──────────────────────────────────────────────────────────────

	SEM_Loadout (client.lua) - Created by Scott M
	Current Version: v1.0 (Dec 2019)
	
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
			if Config.DisplayArmoury then
				for _, Location in pairs(Config.ArmouryLocations) do
					if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  Config.DisplayDistance) then
						Marker(Location.x, Location.y, Location.z - 1)
					
						if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  0.75) then
							NotifyHelp('~b~Armoury~w~, Press ~INPUT_PICKUP~ to Access')

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

								ArmouryMenu:Visible(not ArmouryMenu:Visible())
							end
						end
					end
				end
			end



			if Config.DisplayLocker then
				for _, Location in pairs(Config.LockerLocations) do
					if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  Config.DisplayDistance) then
						Marker(Location.x, Location.y, Location.z - 1)
						
						if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  0.75) then
							NotifyHelp('~b~Locker Room~w~, Press ~INPUT_PICKUP~ to Access')

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
							end
						end
					end
				end
			end



			if Config.DisplayGarage then
				for _, Location in pairs(Config.GarageLocations) do
					if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.Marker.x, Location.Marker.y, Location.Marker.z - 1) <  Config.DisplayDistance) then
						Marker(Location.Marker.x, Location.Marker.y, Location.Marker.z - 1)
						
						if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.Marker.x, Location.Marker.y, Location.Marker.z - 1) <  0.75) then
							NotifyHelp('~b~Garage~w~, Press ~INPUT_PICKUP~ to Access')

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
										end
									end
								end

								GarageMenu:Visible(not GarageMenu:Visible())
							end
						end
					end
				end
			end



			if Config.DisplayVehicleDeleters then
				for _, Location in pairs(Config.VehicleDeleterLocations) do
					if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  Config.DisplayDistance) then
						Marker(Location.x, Location.y, Location.z - 1)
						
						if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  1.50) then
							NotifyHelp('~b~Delete Vehicle~w~, Press ~INPUT_PICKUP~ to Delete')

							if IsPedInAnyVehicle(PlayerPedId()) then

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

								Notify('You need to be in a vehicle!')
							end
						end
					end
				end
			end
		end



		if Config.FireMarkers then
			if Config.DisplayLoadout then
				for _, Location in pairs(Config.LoadoutLocations) do
					if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  Config.DisplayDistance) then
						Marker(Location.x, Location.y, Location.z - 1)
						
						if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.x, Location.y, Location.z - 1) <  1.50) then
							NotifyHelp('~b~Equipment & Uniforms~w~, Press ~INPUT_PICKUP~ to Access')

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
							end
						end
					end
				end
			end

			if Config.DisplayFireGarage then
				for _, Location in pairs(Config.FireGarageLocations) do
					if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.Marker.x, Location.Marker.y, Location.Marker.z - 1) <  Config.DisplayDistance) then
						Marker(Location.Marker.x, Location.Marker.y, Location.Marker.z - 1)
						
						if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.Marker.x, Location.Marker.y, Location.Marker.z - 1) <  0.75) then
							NotifyHelp('~b~Garage~w~, Press ~INPUT_PICKUP~ to Access')

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
									end
								end

								GarageMenu:Visible(not GarageMenu:Visible())
							end
						end
					end
				end
			end
		end
    end
end)



RegisterCommand('coords', function(source, args, rawCommands)
    local Coords = GetEntityCoords(PlayerPedId())
    local Heading = GetEntityHeading(PlayerPedId())

    TriggerEvent('chatMessage', 'Coords', {255, 255, 0}, '\nX: ' .. Coords.x .. '\nY: ' .. Coords.y .. '\nZ: ' .. Coords.z .. '\nH: ' .. Heading)
end)

Citizen.CreateThread(function()
	TriggerEvent('chat:AddSuggestion', '/coords', 'Shows Current Player Coords and Heading')
end)