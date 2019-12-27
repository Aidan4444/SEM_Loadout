--[[
─────────────────────────────────────────────────────────────────

	SEM_Loadout (functions.lua) - Created by Scott M
	Current Version: v1.1 (Dec 2019)
	
	Support: https://semdevelopment.com/discord
	
		!!! Change vaules in the 'config.lua' !!!
	DO NOT EDIT THIS IF YOU DON'T KNOW WHAT YOU ARE DOING

─────────────────────────────────────────────────────────────────
]]



function Notify(Text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(Text)
    DrawNotification(true, true)
end

function NotifyHelp(Text)
	SetTextComponentFormat('STRING')
	AddTextComponentString(Text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function KeyboardInput(TextEntry, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
	DisplayOnscreenKeyboard(1, 'FMMC_KEY_TIP1', '', '', '', '', '', MaxStringLenght)
	BlockInput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local Result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		BlockInput = false
		return Result
	else
		Citizen.Wait(500)
		BlockInput = false
		return nil
	end
end

function Marker(x, y, z)
	DrawMarker(1, x, y, z, 0, 0, 0, 0, 0, 0, Config.Size.w, Config.Size.w, Config.Size.h, Config.Colour.r, Config.Colour.g, Config.Colour.b, Config.Colour.a, 0, 0, 0, 0)
end

function GiveWeapon(Hash)
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(Hash), 999, false)
end

function AddWeaponComponent(WeaponHash, Component)
    if HasPedGotWeapon(GetPlayerPed(-1), GetHashKey(WeaponHash), false) then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(WeaponHash), GetHashKey(Component))
    end
end

function SpawnPed(Hash)
    Citizen.CreateThread(function()
        local Model = GetHashKey(Hash)
            RequestModel(Model)
        while not HasModelLoaded(Model) do
            Wait(0)
        end
        if HasModelLoaded(Model) then
            SetPlayerModel(PlayerId(), Model)
        else
	        Notify('The model could not load - please contact development.')
        end
    end)
end

function SpawnVehicle(Veh, Name, Extras, x, y, z, h)
    local Ped = GetPlayerPed( -1 )

    local WaitTime = 0
    local Model = GetHashKey(Veh)
    RequestModel(Model)
    while not HasModelLoaded(Model) do
        CancelEvent()
        RequestModel(Model)
        Citizen.Wait(100)

        WaitTime = WaitTime + 1

        if WaitTime == 200 then
            CancelEvent()
            Notify('~r~Unable to load vehicle, please contact development!')
            return
        end
    end
    local Vehicle = CreateVehicle(Model, x, y, z + 1, h, true, false)
    SetPedIntoVehicle(PlayerPedId(), Vehicle, -1)
    SetEntityAsNoLongerNeeded(Vehicle)
    SetModelAsNoLongerNeeded(Vehicle)
    SetVehicleDirtLevel(Vehicle, 0)

    if Name then
        Notify('~b~Vehicle Spawned: ~g~' .. Name)
    else
        Notify('~b~Vehicle Spawned!')
	end
	
	for _, Extra in pairs(Extras) do
		SetVehicleExtra(Vehicle, tonumber(Extra), 0)
	end
end

function DeleteVehicle(entity)
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized(entity))
end