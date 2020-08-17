--[[
──────────────────────────────────────────────────────────────────

	SEM_Loadout (fxmanifest.lua) - Created by Scott M
	Current Version: v1.2 (Feb 2020)
	
	Support: https://semdevelopment.com/discord
	
		!!! Change vaules in the 'config.lua' !!!
	!!! DO NOT EDIT THIS IF YOU DON'T KNOW WHAT YOU ARE DOING !!!

──────────────────────────────────────────────────────────────────
]]



fx_version 'bodacious'
games {'gta5'}

title 'SEM_Loadout'
description 'LEO & Fire Loadout Locations'
author 'Scott M [SEM Development]'
version 'v1.2'

client_scripts {
    'dependencies/NativeUI.lua',
    'client.lua',
    'config.lua',
    'functions.lua',
}

server_scripts {
    'server.lua'
}
