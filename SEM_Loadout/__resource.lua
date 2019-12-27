--[[
──────────────────────────────────────────────────────────────────

	SEM_Loadout (__resource.lua) - Created by Scott M
	Current Version: v1.1 (Dec 2019)
	
	Support: https://semdevelopment.com/discord
	
		!!! Change vaules in the 'config.lua' !!!
	!!! DO NOT EDIT THIS IF YOU DON'T KNOW WHAT YOU ARE DOING !!!

──────────────────────────────────────────────────────────────────
]]



resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

title 'SEM_Loadout'
description 'LEO & Fire Loadout Locations'
author 'Scott M [SEM Development]'
version 'v1.1'

client_scripts {
	'dependencies/NativeUI.lua',
    'client.lua',
    'config.lua',
    'functions.lua',
}

server_scripts {
    'server.lua'
}