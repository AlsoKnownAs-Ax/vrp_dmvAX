-------------------------------------------------------------------------
------------[ Script realizat de --Ax- inspirat de pe Bio ]--------------
---[ Acest script a fost facut de la 0, desi ideea nu este originala]----
------------------------[ Discord: --Ax-#0018 ]--------------------------
-------------------------------------------------------------------------
-- Permis telefon        440.66748046875,-981.12548828125,30.689867019653
-- spawn masina          492.97750854492,-998.16302490234,27.774002075195

CarSpawnLocs = nil
CarStopsLocs = nil
theBlips = {}
CarStopsBlip = nil
theCar = nil
hasCarRouteStarted = false
CarCheckpoint = 0
atCarStop = false
finishCarRoute = {}
finishBlip = nil
CarBlip = nil
CarStopsBlip2 = nil


okoknotify = AxConfig.UseOkOkNotify

function vRPaxC.deleteTheCar()
	if(DoesEntityExist(theCar))then
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(theCar))
		theCar = nil
	end
end

function vRPaxC.CarPopulateData(CarSpawns, CarLocs, finishTrash)
	CarSpawnLocs = CarSpawns
	CarStopsLocs = CarLocs
	finishCarRoute = finishTrash
end

function vRPaxC.spawnTheCar()
	if(theCar == nil)then
		coords = GetEntityCoords(PlayerPedId(), true)
		vehicle = GetHashKey(AxConfig.DmvCarId)
		RequestModel(vehicle)
		while not HasModelLoaded(vehicle) do
			Citizen.Wait(0)
		end
		theCar = CreateVehicle(vehicle, coords.x, coords.y, coords.z+0.5, 213.70028686523, true, false)
		SetVehicleOnGroundProperly(theCar)
		SetEntityInvincible(theCar, false)
		SetPedIntoVehicle(PlayerPedId(), theCar, -1)
		Citizen.InvokeNative(0xAD738C3085FE7E11, theCar, true, true) -- set as mission entity
		SetVehicleHasBeenOwnedByPlayer(theCar, true)
		SetModelAsNoLongerNeeded(vehicle)
	end
end


function vRPaxC.startCarRoute()
	hasCarRouteStarted = true
	for i, v in pairs(theBlips) do
		if(DoesBlipExist(v))then
			RemoveBlip(v)
			theBlips[i] = nil
		end
	end
	vRPaxC.nextCarStop()
	if okoknotify then
		exports['okokNotify']:Alert("[DMV]", "Mergi si asteapta la fiecare semafor pentru a lua permisul!", 3000, 'info')
	else
		vRP.notify({"[DMV] ~g~Mergi si asteapta la fiecare semafor pentru a lua permisul!"})
	end
end


function vRPaxC.nextCarStop()
	CarCheckpoint = CarCheckpoint + 1
	if(CarStopsLocs[CarCheckpoint][4] == true)then
		blipColor = 1
	else
		blipColor = 2
	end
	if(CarStopsBlip == nil) or (DoesBlipExist(CarStopsBlip))then
		if(DoesBlipExist(CarStopsBlip))then
			RemoveBlip(CarStopsBlip)
		end
		CarStopsBlip = AddBlipForCoord(CarStopsLocs[CarCheckpoint][1], CarStopsLocs[CarCheckpoint][2], CarStopsLocs[CarCheckpoint][3])
		SetBlipRoute(CarStopsBlip, true)
		SetBlipSprite(CarStopsBlip, 11)
		SetBlipColour(CarStopsBlip, blipColor)
		SetBlipRouteColour(CarStopsBlip, 2)
	end
	if(CarCheckpoint+1 <= #CarStopsLocs)then
		if(CarStopsBlip2 == nil) or (DoesBlipExist(CarStopsBlip2))then
			if(DoesBlipExist(CarStopsBlip2))then
				RemoveBlip(CarStopsBlip2)
			end
			CarStopsBlip2 = AddBlipForCoord(CarStopsLocs[CarCheckpoint+1][1], CarStopsLocs[CarCheckpoint+1][2], CarStopsLocs[CarCheckpoint+1][3])
			SetBlipSprite(CarStopsBlip2, 270)
			SetBlipColour(CarStopsBlip2, 1)
		end
	end
end



function vRPaxC.stopCarRoute()
	hasCarRouteStarted = false
	if okoknotify then
		exports['okokNotify']:Alert("[DMV]", "Ai picat testul pentru permis !", 3000, 'error')
	else
		vRP.notify({"[DMV] ~r~Ai picat testul pentru permis !"})
	end
	CarCheckpoint = 0
	if(DoesBlipExist(CarStopsBlip))then
		RemoveBlip(CarStopsBlip)
		CarStopsBlip = nil
	end
	if(DoesBlipExist(CarStopsBlip2))then
		RemoveBlip(CarStopsBlip2)
		CarStopsBlip2 = nil
	end
	if(DoesBlipExist(CarBlip))then
		RemoveBlip(CarBlip)
		CarBlip = nil
	end
	if(DoesBlipExist(finishBlip))then
		RemoveBlip(finishBlip)
		finishBlip = nil
	end
	vRPSax.stopCarRoute({})
	atCarStop = false
end


function vRPaxC.finishCarRoute(route)
	hasCarRouteStarted = false
	CarCheckpoint = 0
	if(DoesBlipExist(CarStopsBlip))then
		RemoveBlip(CarStopsBlip)
		CarStopsBlip = nil
	end
	if(DoesBlipExist(CarStopsBlip2))then
		RemoveBlip(CarStopsBlip2)
		CarStopsBlip2 = nil
	end
	if(DoesBlipExist(CarBlip))then
		RemoveBlip(CarBlip)
		CarBlip = nil
	end
	if(DoesBlipExist(finishBlip))then
		RemoveBlip(finishBlip)
		finishBlip = nil
	end
	atCarStop = false
	vRPaxC.deleteTheCar()
	vRPSax.DaiPermisuMosule({route})
end

function vRPaxC.stopAtCarStop(isCarStop)
	if(isCarStop == false)then
		vRPaxC.nextCarStop()
	else
		if(atCarStop == false)then
			atCarStop = true
			if okoknotify then
				exports['okokNotify']:Alert("[DMV]", "Asteapta la semafor!", 3000, 'info')
			else
				vRP.notify({"[DMV] ~g~Asteapta la semafor!"})
			end
			SetTimeout(8000, function()
				if(atCarStop)then
					atCarStop = false
					if(#CarStopsLocs > CarCheckpoint)then
						vRPaxC.nextCarStop()
						--vRP.notify({"[DMV] ~g~S-a facut verde! Poti merge mai departe!"})
						if okoknotify then
							exports['okokNotify']:Alert("[DMV]", "S-a facut verde! Poti merge mai departe!", 3000, 'success')
						else
							vRP.notify({"[DMV] ~g~S-a facut verde! Poti merge mai departe!"})
						end
						vRPSax.DaiPermisuMosuleAtStop({})
					else
						if(DoesBlipExist(CarStopsBlip))then
							RemoveBlip(CarStopsBlip)
							CarStopsBlip = nil
						end
						if okoknotify then
							exports['okokNotify']:Alert("[DMV]", "Bravo ! Ai trecut testul de permis", 3000, 'success')
						else
							vRP.notify({"[DMV] ~g~Bravo ! Ai trecut testul de permis"})
						end
					end
				else
					if okoknotify then
						exports['okokNotify']:Alert("[DMV]", "Trebuie sa astepti la semafor !", 3000, 'warning')
					else
						vRP.notify({"[DMV] ~r~Trebuie sa astepti la semafor !"})
					end
				end
			end)
		end
	end
end


Citizen.CreateThread(function()
	while true do
		Wait(0)
		local ped = PlayerPedId()	
		local pos = GetEntityCoords(ped, true)	
		if((not DoesEntityExist(theCar)) or (IsEntityDead(theCar))) and (hasCarRouteStarted)then
			vRPaxC.stopCarRoute()
			theCar = nil
		end
		if(atCarStop)then
			axdmv_drawTxt("~y~[DMV] ~g~Asteapta la semafor...",1,1,0.5,0.8,0.8,255,255,255,255)
		end
		if(theCar ~= nil)then
			if(GetVehiclePedIsIn(ped, false) == theCar) and (GetPedInVehicleSeat(theCar, -1) == ped) then
				if(hasCarRouteStarted == false)then
					vRPaxC.startCarRoute()
				end
				if(tonumber(#CarStopsLocs) > tonumber(CarCheckpoint))then
					if(#CarStopsLocs >= CarCheckpoint+1)then
						if(CarStopsLocs[CarCheckpoint+1][4] == true)then
							DrawMarker(1, CarStopsLocs[CarCheckpoint+1][1], CarStopsLocs[CarCheckpoint+1][2], CarStopsLocs[CarCheckpoint+1][3]-1.0, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 200.0, 0, 255, 0, 180, 0, 0, 0, 0)
						else
							DrawMarker(1, CarStopsLocs[CarCheckpoint+1][1], CarStopsLocs[CarCheckpoint+1][2], CarStopsLocs[CarCheckpoint+1][3]-1.0, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 200.0, 255, 255, 0, 180, 0, 0, 0, 0)
						end
					end
					if(CarStopsLocs[CarCheckpoint][4] == true)then
						DrawMarker(1, CarStopsLocs[CarCheckpoint][1], CarStopsLocs[CarCheckpoint][2], CarStopsLocs[CarCheckpoint][3]-1.0, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 200.0, 0, 255, 0, 180, 0, 0, 0, 0)
						if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, CarStopsLocs[CarCheckpoint][1], CarStopsLocs[CarCheckpoint][2], CarStopsLocs[CarCheckpoint][3], true) < 8.0)then
							if(atCarStop == false)then
								vRPaxC.stopAtCarStop(true)
							end
						else
							atCarStop = false
						end
					else
						DrawMarker(1, CarStopsLocs[CarCheckpoint][1], CarStopsLocs[CarCheckpoint][2], CarStopsLocs[CarCheckpoint][3]-1.0, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 200.0, 255, 255, 0, 180, 0, 0, 0, 0)
						if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, CarStopsLocs[CarCheckpoint][1], CarStopsLocs[CarCheckpoint][2], CarStopsLocs[CarCheckpoint][3], true) < 8.0)then
							vRPaxC.stopAtCarStop(false)
						end
					end
				end
				if(CarCheckpoint == #CarStopsLocs)then
					if(finishBlip == nil)then
						finishBlip = AddBlipForCoord(finishCarRoute[1], finishCarRoute[2], finishCarRoute[3])
						SetBlipSprite(finishBlip, 270)
						SetBlipColour(finishBlip, 15)
						SetBlipAsShortRange(finishBlip, false)
					end
					DrawMarker(1, finishCarRoute[1], finishCarRoute[2], finishCarRoute[3]-1.0, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 200.0, 0, 255, 0, 180, 0, 0, 0, 0)
					if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, finishCarRoute[1], finishCarRoute[2], finishCarRoute[3], true) < 5.0)then
						axdmv_DisplayHelpText("Apasa ~INPUT_CONTEXT~ pentru a termina ~o~Testul Auto")
						if(IsControlJustReleased(1, 51))then
							vRPaxC.finishCarRoute(CarCheckpoint)
						end
					end
				end
				if(DoesBlipExist(CarBlip))then
					RemoveBlip(CarBlip)
					CarBlip = nil
				end
			else
				axdmv_drawTxt("~y~[DMV] ~r~Intoarce-te la masina pentru a continua testul...",1,1,0.5,0.8,0.8,255,255,255,255)
				if(CarBlip == nil)then
					CarBlip = AddBlipForEntity(theCar)
					SetBlipSprite(CarBlip, 227)
					SetBlipColour(CarBlip, 1)
					SetBlipAsShortRange(CarBlip, false)
				end
			end
		else
			if(hasCarRouteStarted)then
				vRPaxC.stopCarRoute()
			end
			if(CarSpawnLocs ~= nil)then
				for i, v in pairs(CarSpawnLocs) do
					if(theBlips[i] == nil)then
						theBlips[i] = AddBlipForCoord(v[1], v[2], v[3])
						SetBlipSprite(theBlips[i], 227)
						SetBlipColour(theBlips[i], 2)
						SetBlipAsShortRange(theBlips[i], true)
					end
					if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v[1], v[2], v[3], true) < 30.0)then
						DrawText3D(v[1], v[2], v[3]+0.1, "~y~Test DMV", 1.2)
						DrawMarker(36, v[1], v[2], v[3]-0.5, 0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.7, 94, 94, 94, 255, 0, 0, 0, 1)
						if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v[1], v[2], v[3], true) < 2.0)then
							axdmv_DisplayHelpText("Apasa ~INPUT_CONTEXT~ pentru a incepe testul")
							if(IsControlJustReleased(1, 51))then
								vRPSax.spawnTheCar({})
							end
						end
					end
				end
			end
		end
	end
end)

