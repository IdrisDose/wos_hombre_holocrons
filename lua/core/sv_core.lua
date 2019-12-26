-- CRUD Operations go here ...
wOS = wOS or {}
wOS.hcrons = wOS.hcrons or {}


wOS.hcrons.serverLoaded = false
wOS.hcrons.dataLoaded = false


local function wOS.hcrons:SaveHcrons()
  for k,v in pairs(wOS.hcrons.holocrons) do
      if(v.persistent) then
        wOS.hcrons.data:SaveHcron(v)
      end
  end
end

local function wOS.hcrons:ServerStartTimer()
  timer.Create("wos_hcrons_savetimer", wOS.hcrons.config.RefreshTime, 0, function()
    wOS.hcrons:SaveHcrons()
  end)
end


function wOS.hcrons:ServerInit()
  if not GetConVar("wos_hcrons_refreshtime") then
    CreateConVar("wos_hcrons_refreshtime", "300", flags=nil, "Set the time between saves")
  end

  wOS.hcrons:LoadHolocrons()

  wOS.hcrons:ServerStartTimer()

  wOS.hcrons:Print("Server Loaded")

end

--[[ HCron Load
  -- Loop through data create at pos
  -- Load Data from file for each hcron ???
]]--
function wOS.hcrons:LoadHolocrons()

  local dataLoaded = wOS.hcrons.data:LoadData()

  if dataLoaded then
    wOS.hcrons.dataLoaded = true
  end


end

--[[ Console command Setup ??
  -- setup needed console commands
]]--

function wOS.hcrons:addXP(ply,ent)

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

function wOS.hcrons:addHCron(data)

  local holocron = ents.Create("ent_hombrecron")
  holocron:SetPos(data.trace.HitPos)
  holocron.XPToGive = data.xp
  holocron.CustomModel = data.CustomModel
  holocron.SingleUse = tobool(data.SingleUse)
  holocron:Spawn()

  undo.Create( "ent_hombrecron" )
    undo.AddEntity( holocron )
    undo.SetPlayer( data.ply )
  undo.Finish()

end

function wOS.hcrons:updateHCron(data)

  local holocron = data.trace.Entity
  holocron.XPToGive = data.XP
  holocron.CustomModel = data.CustomModel
  holocron.SingleUse = tobool(data.SingleUse)
  holocron:Spawn()

  undo.Create( "ent_hombrecron" )
    undo.AddEntity( holocron )
    undo.SetPlayer( data.ply )
  undo.Finish()

end


-- After File Loaded if not failed
-- wOS.hcrons.serverLoaded = true;
-- If Server Loaded var is true print loaded else print server failed

wOS.hcrons:ServerInit()


-- Leave this here
if wOS.hcrons.dataLoaded then
  wOS.hcrons:Print("Data Loaded")
else
  wOS.hcrons:Print("Data Failed")
end