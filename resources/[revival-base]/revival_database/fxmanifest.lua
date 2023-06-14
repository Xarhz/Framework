fx_version 'adamant'
game 'common'
name 'revival_database'
description 'revival_database for DB-Framework.'

server_scripts {
  'db-server.js',
  'db-server.lua',
}
client_script "@revival-base/errors/client.lua"
client_script 'db-client.js'

files {
  'ui/index.html',
  'ui/js/app.js',
  'ui/css/app.css',
  'ui/fonts/*.woff',
  'ui/fonts/*.woff2',
  'ui/fonts/*.eot',
  'ui/fonts/*.ttf',
}

ui_page 'ui/index.html'
