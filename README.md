## Visitor Count
  <img src="https://profile-counter.glitch.me/vrp_dmvAX/count.svg" />

## Last Update 19/08/2022: Updated the resource to 0.00% Resmon idle and Virtual World Config

## Put This in vrp/modules/police.lua

## Make sure you replace the vRP.getInventoryItemAmount(...,"permisc") with your driver license item name

# In order for this functions to work you need to download : https://github.com/plesalex100/plesIds


        local choice_askPermis = {function(player,choice)
          local user_id = vRP.getUserId(player)
          vRPclient.getNearestPlayer(player,{10},function(nplayer)
          local nuser_id = vRP.getUserId(nplayer)
          if nuser_id ~= nil then
            vRP.request(nplayer,"Vrei sa prezinti permisul?",15,function(nplayer2,ok)
            if ok then
              if vRP.getInventoryItemAmount(nuser_id,"permisc") > 0 then
                  vRP.getUserIdentity(nuser_id, function(identity)
                    if identity then
                      TriggerClientEvent("ples-id:showPermis", player, {
                        nume = identity.firstname, 
                        prenume = identity.name, 
                        target = nplayer
                      })
                    end
                  end)
              else
               vRPclient.notify(player,{"Jucatorul".."["..nuser_id.."] nu are permis de conducere!"})
                --TriggerClientEvent('okokNotify:Alert', player, "", "Jucatorul".."["..nuser_id.."] nu are permis de conducere!", 3000, 'info')
              end
            else
              vRPclient.notify(player,{"Jucatorul".."["..nuser_id.."] a refuzat sa prezinte permisul de conducere!"})
              --TriggerClientEvent('okokNotify:Alert', player, "", "Jucatorul".."["..nuser_id.."] a refuzat sa prezinte permisul de conducere!", 3000, 'error')
            end
            end)
          else
            vRPclient.notify(player,{lang.common.no_player_near()})
            --TriggerClientEvent('okokNotify:Alert', player, "", lang.common.no_player_near(), 3000, 'error')
          end
        end)
        end,"Verifica permisul jucatorului apropriat"}



        local choice_takePermis = {function(player,choice)
          local user_id = vRP.getUserId(player)
          vRPclient.getNearestPlayer(player,{10},function(nplayer)
          local nuser_id = vRP.getUserId(nplayer)
          if nuser_id ~= nil then
            vRP.request(player,"Esti sigur ca vrei sa anulezi permisul jucatorului: ["..nuser_id.."] ?",15,function(nplayer2,ok)
            if ok then
              if vRP.tryGetInventoryItem(nuser_id, "permisc", 1, true) then
                vRPclient.notify(nplayer,{"Un politist ti-a confiscat permisul de conducere!"})
                --TriggerClientEvent('okokNotify:Alert', nplayer, "", "Un politist ti-a confiscat permisul de conducere!", 3000, 'info')
                vRPclient.notify(player,{"I-ai Confiscat permisul lui!["..nuser_id.."]"})
                --TriggerClientEvent('okokNotify:Alert', player, "", "I-ai Confiscat permisul lui!["..nuser_id.."]", 3000, 'success')
              else
                vRPclient.notify(player,{"Jucatorul nu are permis de conducere"})
                --TriggerClientEvent('okokNotify:Alert', player, "", "Jucatorul nu are permis de conducere", 3000, 'info')
              end
            end
            end)
          else
            vRPclient.notify(player,{lang.common.no_player_near()})
            --TriggerClientEvent('okokNotify:Alert', player, "", lang.common.no_player_near(), 3000, 'error')
          end
        end)
        end,"Anuleaza permisul jucatorului apropriat"}


## Also add this to the choices in polce.lua from modules


              menu["Verifica Permis"] = choice_askPermis
              menu["Confisca Permis"] = choice_takePermis
