fx_version 'cerulean'
game 'gta5'

author 'Loreose'
description 'ROSE ATM Robbery'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    -- '@qbx_core/modules/lib.lua',    -- If you are using qbox enabled this
    -- '@es_extended/imports.lua'      -- If you are using esx enabled this
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    -- '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

dependencies {
    'bd-minigames'
}

lua54 'yes'
use_fxv2_oal 'yes'
