-------------------------------------------------------------------------
------------[ Script realizat de --Ax- inspirat de pe Bio ]--------------
---[ Acest script a fost facut de la 0, desi ideea nu este originala]----
------------------------[ Discord: --Ax-#0018 ]--------------------------
-------------------------------------------------------------------------


fx_version 'adamant'

game 'gta5'

description "vRP DMV School by Ax"

author '--Ax-#0018'

dependencies {
	"vrp",
	"ghmattimysql",
}

client_scripts{
	-- [[ AX-DMV Client Scripts ]] --
	"lib/Tunnel.lua",
	"lib/Proxy.lua",
	"client.lua",
	"dmv/c_dmv.lua",
}

server_scripts{
	-- [[ AX-DMV Server Scripts ]] --
	"@vrp/lib/utils.lua",
	"server.lua",
	"dmv/s_dmv.lua",
}

shared_scripts {
    -- [[ AX-DMV Shared Script ]] --
    'config.lua',
}