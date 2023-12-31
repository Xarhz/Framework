fx_version 'cerulean'
games { 'gta5' }

ui_page 'client/html/index.html'

files {
  'client/html/*.html',
  'client/html/*.js',
  'client/html/*.css',
  'client/html/webfonts/*.eot',
  'client/html/webfonts/*.svg',
  'client/html/webfonts/*.ttf',
  'client/html/webfonts/*.woff',
  'client/html/webfonts/*.woff2',
  'client/html/css/*',
}
client_script "@revival-base/errors/client.lua"

client_scripts {
  '@revival_library/client/cl_rpc.lua',
  '@revival_library/client/cl_ui.lua',
  'client/cl_tattooshop.lua',
  'client/cl_*.lua',
  'client/js/cl_*.js',
}

server_scripts {
  '@revival_library/server/sv_rpc.lua',
  '@revival-base/database/db.lua',
  "server.lua",
}

export "CreateHashList"
export "GetTatCategs"
export "GetCustomSkins"
