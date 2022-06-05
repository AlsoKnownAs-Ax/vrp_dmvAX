-------------------------------------------------------------------------
------------[ Script realizat de --Ax- inspirat de pe Bio ]--------------
---[ Acest script a fost facut de la 0, desi ideea nu este originala]----
------------------------[ Discord: --Ax-#0018 ]--------------------------
-------------------------------------------------------------------------
--[[

	CarSpawnLocs = Locul de unde iei masina pentru testul auto
	CarLoadLocs = Locul unde sunt CK pentru DMV ( false inseamna ca nu este semafor ,implicit true inseamna ca trb sa astepti la semafor)
	finishCarPoint = Locul unde termini

]]


CarSpawnLocs = {
	[1] = {492.97750854492,-998.16302490234,27.774002075195},
}

CarLoadLocs = {
	{497.00674438477,-1066.9968261719,28.629110336304, false},
	{497.35360717773,-1114.8674316406,29.299428939819, true},
	{421.68716430664,-1129.2751464844,29.414939880371, true},--
	{332.31930541992,-1132.0993652344,29.457851409912, false},--
	{283.76245117188,-1130.5377197266,29.425590515137, false},
	{237.27124023438,-1128.8990478516,29.305522918701, true},--
	{206.42422485352,-1166.8842773438,29.356512069702, false},--
	{212.75025939941,-1226.8088378906,29.361232757568, false},--
	{213.09156799316,-1269.6158447266,29.354290008545, true},--
	{185.74633789062,-1337.3812255859,29.322595596313, false},--
	{164.74044799805,-1371.6650390625,29.349742889404, true},--
	{129.5658416748,-1420.7673339844,29.341485977173, false},--
	{76.106422424316,-1487.2490234375,29.341924667358, true},--
	{92.74681854248,-1533.8260498047,29.33424949646, false},--
	{139.82830810547,-1573.654296875,29.325805664062, false},--
	{210.08546447754,-1579.4735107422,29.341779708862, false},--
	{255.29835510254,-1554.6733398438,29.338182449341, false},--
	{302.15502929688,-1528.8236083984,29.226493835449, true},--
	{304.31378173828,-1487.1928710938,29.287857055664, false},--
	{256.77880859375,-1448.0487060547,29.297597885132, false},--
	{202.0924987793,-1409.859375,29.288751602173, false},--
	{187.50543212891,-1371.2232666016,29.292724609375, false},--
	{220.42573547363,-1328.1223144531,29.25461769104, false},--
	{273.39181518555,-1317.3487548828,29.764738082886, false},--
	{325.46597290039,-1321.2242431641,32.089698791504, true},--
	{363.24740600586,-1302.1903076172,32.411430358887, false},--
	{402.84927368164,-1264.8000488281,32.509693145752, false},--
	{486.37329101562,-1261.0122070312,29.348752975464, false},--
	{504.18533325195,-1215.5219726562,29.355884552002, true},--
	{503.20327758789,-1146.3093261719,29.359996795654, true},--
	{479.45745849609,-1119.4133300781,29.298896789551, false},--
}

finishCarPoint = {484.84582519531,-1102.5083007812,29.200798034668}

CarDrivers = {}

started = {}

okoknotify = AxConfig.UseOkOkNotify

function vRPax.executeDMVSchool(thePlayer)
	local user_id = vRP.getUserId({thePlayer})
	vRPCax.CarPopulateData(thePlayer, {CarSpawnLocs, CarLoadLocs, finishCarPoint})
	started[user_id] = 1
end

function vRPax.spawnTheCar()
	local thePlayer = source
	local user_id = vRP.getUserId({thePlayer})
	if(started[user_id] == 1)then
		if(CarDrivers[user_id] == nil)then
			CarDrivers[user_id] = 0
			vRPCax.spawnTheCar(thePlayer, {})
		else
			if okoknotify then
				TriggerClientEvent('okokNotify:Alert', thePlayer, "[DMV]", "Ai deja o masina spawnata!", 3000, 'error')
			else
				vRPclient.notify(thePlayer, {"[DMV] ~r~Ai deja o masina spawnata!"})
			end
		end
	else
		if okoknotify then
			TriggerClientEvent('okokNotify:Alert', thePlayer, "[DMV]", "Nu ai inceput Testul Practic", 3000, 'error')
		else
			vRPclient.notify(thePlayer, {"[DMV] ~r~Nu ai inceput ~y~Testul Practic"})
		end
	end
end

function vRPax.stopCarRoute()
	local thePlayer = source
	local user_id = vRP.getUserId({thePlayer})
	if(started[user_id] == 1) and (CarDrivers[user_id] ~= nil)then
		CarDrivers[user_id] = nil
		started[user_id] = nil
	end
end

function vRPax.DaiPermisuMosule(routesDone)
	local thePlayer = source
	local user_id = vRP.getUserId({thePlayer})
    vRP.giveInventoryItem({user_id,AxConfig.DriverLicenseItem,1,false})
	if okoknotify then
		TriggerClientEvent('okokNotify:Alert', thePlayer, "[DMV]", "Ai primit Permisul !", 3000, 'success')
	else
		vRPclient.notify(thePlayer, {"[DMV] ~g~Ai primit ~o~Permisul !"})
	end
	CarDrivers[user_id] = nil
	started[user_id] = nil
end

AddEventHandler("vRP:playerLeave",function(user_id, source)
	if(started[user_id] == 1 )then
		CarDrivers[user_id] = nil
		vRPCax.deleteTheCar(source, {})
		started[user_id] = nil
	end
end)



