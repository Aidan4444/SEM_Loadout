--[[
─────────────────────────────────────────────────────────────────

	SEM_Loadout (functions.lua) - Created by Scott M
	Current Version: v1.2 (Feb 2020)
	
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
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(entity))
end





function LEOArmouryRestrict()
    if Config.ArmouryAccess == 0 then
        return true
    elseif Config.ArmouryAccess == 1 then
        local Ped = GetEntityModel(GetPlayerPed(-1))

        for _, LEOPeds in pairs(Config.LockerContents) do
            local AllowedPed = GetHashKey(LEOPeds.uniform)

            if Ped == AllowedPed then
                return true
            end
        end
    elseif Config.ArmouryAccess == 2 then
        return ArmouryAce
    else
        return true
    end
end

function LEOLockerRestrict()
    if Config.LockerAccess == 0 then
        return true
    elseif Config.LockerAccess == 1 then
        return LockerAce
    else
        return true
    end
end

function LEOGarageRestrict()
    if Config.GarageAccess == 0 then
        return true
    elseif Config.GarageAccess == 1 then
        local Ped = GetEntityModel(GetPlayerPed(-1))

        for _, LEOPeds in pairs(Config.LockerContents) do
            local AllowedPed = GetHashKey(LEOPeds.uniform)

            if Ped == AllowedPed then
                return true
            end
        end
    elseif Config.GarageAccess == 2 then
        return GarageAce
    else
        return true
    end
end

function LEODeleterRestrict()
    if Config.DeleterAccess == 0 then
        return true
    elseif Config.DeleterAccess == 1 then
        local Ped = GetEntityModel(GetPlayerPed(-1))

        for _, LEOPeds in pairs(Config.LockerContents) do
            local AllowedPed = GetHashKey(LEOPeds.uniform)

            if Ped == AllowedPed then
                return true
            end
        end
    elseif Config.DeleterAccess == 2 then
        return DeleterAce
    else
        return true
    end
end

function LEOJailRestrict()
    if Config.JailAccess == 0 then
        return true
    elseif Config.JailAccess == 1 then
        local Ped = GetEntityModel(GetPlayerPed(-1))

        for _, LEOPeds in pairs(Config.LockerContents) do
            local AllowedPed = GetHashKey(LEOPeds.uniform)

            if Ped == AllowedPed then
                return true
            end
        end
    elseif Config.JailAccess == 2 then
        return JailAce
    else
        return true
    end
end


function FireLoadoutRestrict()
    if Config.LoadoutAccess == 0 then
        return true
    elseif Config.LoadoutAccess == 1 then
        return LoadoutAce
    else
        return true
    end
end

function FireGarageRestrict()
    if Config.FireGarageAccess == 0 then
        return true
    elseif Config.FireGarageAccess == 1 then
        local Ped = GetEntityModel(GetPlayerPed(-1))

        for _, FireAreas in pairs(Config.LoadoutContents) do
            for _, FirePeds in pairs(FireAreas) do
                local AllowedPed = GetHashKey(FirePeds.uniform)
    
                if Ped == AllowedPed then
                    return true
                end
            end
        end
    elseif Config.FireGarageAccess == 2 then
        return FireGarageAce
    else
        return true
    end
end

function FireDeleterRestrict()
    if Config.DeleterAccess == 0 then
        return true
    elseif Config.DeleterAccess == 1 then
        local Ped = GetEntityModel(GetPlayerPed(-1))

        for _, FireAreas in pairs(Config.LoadoutContents) do
            for _, FirePeds in pairs(FireAreas) do
                local AllowedPed = GetHashKey(FirePeds.uniform)
    
                if Ped == AllowedPed then
                    return true
                end
            end
        end
    elseif Config.DeleterAccess == 2 then
        return FireDeleterAce
    else
        return true
    end
end