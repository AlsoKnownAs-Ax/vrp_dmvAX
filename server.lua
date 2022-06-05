-------------------------------------------------------------------------
------------[ Script realizat de --Ax- inspirat de pe Bio ]--------------
---[ Acest script a fost facut de la 0, desi ideea nu este originala]---
------------------------[ Discord: --Ax-#0018 ]--------------------------
-------------------------------------------------------------------------



local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_dmvAX")
vRPCax = Tunnel.getInterface("vrp_dmvAX","vrp_dmvAX")


vRPax = {}
Tunnel.bindInterface("vrp_dmvAX",vRPax)
Proxy.addInterface("vrp_dmvAX",vRPax)

function dmv_ch_permis(player,choice)
	local user_id = vRP.getUserId({player})
		if user_id ~= nil then
			vRPclient.teleport(player,{492.97750854492,-998.16302490234,27.774002075195})
			vRPax.executeDMVSchool(player)
		end 
end

local dmv_menu = {name="DMV Menu",css={top="75px", header_color="rgba(0,255,125,0.75)"}}

dmv_menu["Incepe Testul Auto"] = {dmv_ch_permis}

local function build_DMV_test(source)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local function dmv_enter()
			if user_id ~= nil then
				vRP.openMenu({source,dmv_menu})
			end
		end
		local function dmv_leave()
			vRP.closeMenu({source})
		end
		vRPclient.addBlip(source,{441.89694213867,-979.52386474609,30.689487457275,60,38,"Permis"})
		vRPclient.addMarkerNames(source,{441.89694213867,-979.52386474609,30.689487457275+0.350, "~o~Permis AUTO", fontId, 1.1})
		vRPclient.addMarkerSign(source,{36,441.89694213867,-979.52386474609,30.689487457275-1.45,0.50,0.60,0.60,255,127,80,150,150,1,true,0})

		vRP.setArea({source,"vRP:dmv",441.89694213867,-979.52386474609,30.689487457275,1,1.5,dmv_enter,dmv_leave})
	end
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	if first_spawn then
		build_DMV_test(source)
	end
end)