fx_version "cerulean"

description "Pluto - Hud"
author "pluto"
version '0.0.1'

lua54 'yes'

game "gta5"

ui_page 'web/build/index.html'

client_scripts {
  "@revival_library/client/cl_rpc.lua",
  "client/cl_exports.lua",
  "client/cl_main.lua",
  "client/cl_utils.lua",
  "client/cl_context.lua",
  "client/cl_input.lua",
  "client/model/cl_*.lua"
}

server_scripts {
  "@revival_library/server/sv_rpc.lua",
  "@revival_library/server/sv_sql.lua",
  "server/sv_*.lua"
}

files {
  'web/build/index.html',
  'web/build/**/*'
}

exports {
	'BuffIntel',
	'BuffStress',
	'BuffLuck',
	'BuffHunger',
    'BuffThirst',
	'BuffAlert',
}