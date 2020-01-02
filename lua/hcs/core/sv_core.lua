-- CRUD Operations go here ...
wOS = wOS or {}
wOS.HCS = wOS.HCS or {}
wOS.HCS.Holocrons = wOS.HCS.Holocrons or {}
wOS.HCS.Ents = wOS.HCS.Ents or {}

wOS.HCS.serverLoaded = false
wOS.HCS.DataLoaded = false
wOS.HCS.RefreshTime = 300


function wOS.HCS:SaveHolocrons()
  for k,v in pairs(wOS.HCS.Holocrons) do
      if(v.persistent) then
        wOS.HCS.Data:SaveHolocron(v)
      end
  end
end

function wOS.HCS:ServerStartTimer()
  wOS.HCS:Print("Saving every " .. tostring(wOS.HCS.RefreshTime/60) .. " mins")

  timer.Create("wos_hcrons_savetimer", wOS.HCS.RefreshTime, 0, function()
    wOS.HCS:SaveHolocrons()
    wOS.HCS:ReloadHCrons()
    wOS.HCS.RefreshTime = GetConVar("wos_hcs_refreshtime"):GetInt()
  end)
end


function wOS.HCS:ServerInit()
  if !IsValid(GetConVar("wos_hcs_refreshtime")) then
    CreateConVar("wos_hcs_refreshtime", "300", nil, "Set the time between saves")
  end

  wOS.HCS:LoadHolocrons()

  hook.Add("wOS.ALCS.PostLoaded", 'wos_hcs_gamestart', function()
    wOS.HCS.RefreshTime = GetConVar("wos_hcs_refreshtime"):GetInt()
    wOS.HCS:InitialSpawn()
    wOS.HCS:ServerStartTimer()
  end)

  wOS.HCS:Print("Server Loaded")

end

--[[ HCron Load
  -- Loop through data create at pos
  -- Load Data from file for each hcron ???
]]--
function wOS.HCS:LoadHolocrons()

  local dataLoaded = wOS.HCS.Data:LoadData()

  if dataLoaded then
    wOS.HCS.DataLoaded = true
  end

end

--[[ Console command Setup ??
  -- setup needed console commands
]]--

function wOS.HCS:addXP(ply,ent)

  if ent.SingleUse then
    if ent.UsedBy[ply:SteamID64()] then return end
      -- Check to see if DarkRP Teams is Active
      if _G.DarkRP and IsValid(DarkRP) then
        if (ent.AllowedTeams != false) then
          if(ent.AllowedTeams[ply:Team()] == true) then
            ply:AddSkillXP(ent.XPToGive)
          end
        end
      else
         ply:AddSkillXP(ent.XPToGive)
      end
      -- End of DarkRP Job Check

      ent.UsedBy[ply:SteamID64()] = true
  else
    ply:AddSkillXP(ent.XPToGive)
  end

end

function wOS.HCS:addHCron(data)

  local cron = wOS.HCS:AddHolocron(data,wOS.HCS.Holocrons)
  local hitpos = data.trace.HitPos

  local holocron = ents.Create("ent_hombrecron")
  holocron:HCSSetData(cron)

  holocron:SetPos(hitpos)
  holocron:Spawn()

  -- Do Next Level Maths
  local collisions = holocron.Entity:GetModelBounds()
  local newZ = hitpos.z - (collisions.z)
  hitpos.z = newZ

  holocron:SetPos(hitpos)

  if(not tobool(cron.IsPersistent)) then
    undo.Create( "ent_hombrecron" )
      undo.AddEntity( holocron )
      undo.SetPlayer( data.ply )
    undo.Finish()
  else
    wOS.HCS.Holocrons[cron.ID] = cron
    wOS.HCS.Data:SaveHolocron(wOS.HCS:GetHolocron(cron.ID))
  end
end

function wOS.HCS:updateHCron(data)
  local holocron = data.trace.Entity
  print("update cron: ")
  PrintTable(holocron:HCSGetData(holocron))

  local cron = wOS.HCS:UpdateHolocron(data,wOS.HCS.Holocrons)

  local holocron = data.trace.Entity
  print("broken" .. tostring(cron.ID))
  holocron:HCSSetData(cron)
  holocron:Spawn()

  if(not data.IsPersistent) then
    undo.Create( "ent_hombrecron" )
      undo.AddEntity( holocron )
      undo.SetPlayer( data.ply )
    undo.Finish()
  else
    table.insert(wOS.HCS.Holocrons,cron.ID,cron)
    wOS.HCS.Data:SaveHolocron(wOS.HCS:GetHolocron(cron.ID))

  end

end

function wOS.HCS:deleteHCron(entity)
  local holocron = wOS.HCS.Holocrons[entity.ID]

  if holocron != nil and holocron.IsPersistent then
    wOS.HCS.Data:DeleteHolocron(holocron.ID)
  end
  table.remove(wOS.HCS.Holocrons, entity.ID)
  for k,v in ipairs(wOS.HCS.Ents) do
    if v.ID == entity.ID then
      table.remove(wOS.HCS.Ents,k)
    end
  end
  entity:Remove()
end

function wOS.HCS:LoadHCron(data)
  local cron = wOS.HCS:UpdateHolocron(data)
  table.insert(wOS.HCS.Holocrons,cron.ID,cron)
end

function wOS.HCS:InitialSpawn()
  wOS.HCS:Print("Initial Spawning of Holorons")
  for k,data in ipairs(wOS.HCS.Holocrons) do
    local holocron = ents.Create("ent_hombrecron")
    holocron.HID = data.ID
    holocron.CustomModel = data.CustomModel
    holocron.XPToGive = data.XP
    holocron.SingleUse = data.SingleUse
	  holocron.IsPersistent = data.IsPersistent
    holocron:SetPos(data.POS)
    holocron:Spawn()
    table.insert(wOS.HCS.Ents, data.ID, holocron.Entity)
  end
end

function wOS.HCS:ReloadHCrons()
  wOS.HCS:Print("Respawning Holocrons")
  for k,v in ipairs(wOS.HCS.Ents) do
    v.UsedBy = {}
    if !IsValid(v) then
      table.remove(wOS.HCS.Ents,k)
    end
  end
end

-- After File Loaded if not failed
-- wOS.HCS.serverLoaded = true;
-- If Server Loaded var is true print loaded else print server failed

wOS.HCS:ServerInit()


-- Leave this here
if wOS.HCS.DataLoaded then
  wOS.HCS:Print("Data Loaded")
else
  wOS.HCS:Print("Data Failed")
end