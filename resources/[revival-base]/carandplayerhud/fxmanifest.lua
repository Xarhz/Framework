fx_version 'cerulean'
games {'gta5'}

shared_script "@mka-array/Array.lua"
shared_script "@revival_library/shared/sh_cacheable.lua"

client_script "@revival_library/client/cl_infinity.lua"
server_script "@revival_library/server/sv_infinity.lua"

client_script 'carhud.lua'
client_script 'cl_playerbuffs.lua'
server_script 'carhud_server.lua'
server_script 'sr_autoKick.lua'


exports {
	"playerLocation",
	"playerZone"
}

