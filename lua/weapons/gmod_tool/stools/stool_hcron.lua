TOOL.Category = "Holocrons"
TOOL.Name = "Holocron Tool"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.ClientConVar[ "name" ] = "Default Holocron"
TOOL.ClientConVar[ "model" ] = "models/props_vehicles/car005a_physics.mdl"
TOOL.ClientConVar[ "xp" ] = 100
TOOL.ClientConVar[ "singleuse" ] = 1
TOOL.ClientConVar[ "is_persistent" ] = 1


  function TOOL:LeftClick( trace )
    if ( CLIENT ) then return true end
    if ( (self:GetOwner():IsAdmin() == false) and (self:GetOwner():IsSuperAdmin() == false) ) then return false end
    if ( trace.HitSky || !trace.HitPos ) then return false end
    if ( IsValid( trace.Entity ) && ( trace.Entity:GetClass() == "ent_hombrecron" ) ) then return false end


    local data = {}
    data["trace"] = trace
    data["ply"] = self:GetOwner()
    data["XP"] = self:GetClientNumber("xp", 100)
    data["CustomModel"] = self:GetClientInfo("model")
    data["SingleUse"] = self:GetClientNumber("singleuse")
    data["IsPersistent"] = self:GetClientNumber("is_persistent")
    data["Name"] = self:GetClientInfo('name')


    wOS.HCS:addHCron(data)
  end

  function TOOL:RightClick(trace)
    if ( CLIENT ) then return true end
    if ( (self:GetOwner():IsAdmin() == false) and (self:GetOwner():IsSuperAdmin() == false) ) then return false end
    if ( trace.HitSky || !trace.HitPos ) then return false end
    if ( trace.Entity:GetClass() != "ent_hombrecron" || !IsValid(trace.Entity)) then return false end
    if not trace.Entity:IsValid() then return false end

    wOS.HCS:deleteHCron(trace.Entity)
  end

  function TOOL:Reload(trace)
    if ( CLIENT ) then return true end
    if ( (self:GetOwner():IsAdmin() == false) and (self:GetOwner():IsSuperAdmin() == false) ) then return false end
    if ( trace.HitSky || !trace.HitPos ) then return false end
    if ( trace.Entity:GetClass() != "ent_hombrecron" ) then return false end


    local data = {}
    data["trace"] = trace
    data["ply"] = self:GetOwner()
    data["XP"] = self:GetClientNumber("xp", 100)
    data["CustomModel"] = self:GetClientInfo("model")
    data["SingleUse"] = tobool(self:GetClientNumber("singleuse"))
    data["IsPersistent"] = tobool(self:GetClientNumber("is_persistent"))
    data["Name"] = self:GetClientInfo('name')

    wOS.HCS:updateHCron(data)


  end

if CLIENT then

  language.Add( "tool.stool_hcron", "Holocron Tool" )
  language.Add( "tool.stool_hcron.name", "Holocron Tool" )
  language.Add( "tool.stool_hcron.desc", "Spawn special holocrons" )
  language.Add( "tool.stool_hcron.0", "Left click to create a holocron. Right click to Delete Holocron. Reload to update a holocron." ) -- Not sure why I keep this


  function TOOL.BuildCPanel(panel)
    panel:AddControl("Header", { Text = "Holocron Tool", Description = "Configure ya holocron scrub"})

    panel:AddControl("textbox", {
      Label = "Holocron Unique Name",
      Command = "stool_hcron_name"
    })

    panel:AddControl("textbox", {
      Label = "Holocron Model",
      Command = "stool_hcron_model"
    })



    panel:AddControl("CheckBox", {
      Label = "Is Single Use?",
      Command = "stool_hcron_singleuse"
    })

    panel:AddControl("CheckBox", {
      Label = "Persistent?",
      Command = "stool_hcron_is_persistent"
    })

    panel:AddControl("Slider", {
      Label = "XP",
      Type = "Integer",
      Min = "0",
      Max = "10000",
      Command = "stool_hcron_xp"
    })

  end

end
