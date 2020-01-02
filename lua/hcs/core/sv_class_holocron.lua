wOS = wOS or {}
wOS.HCS = wOS.HCS or {}

local function HolocronClass(id,data)
  local result = {}
  result["ID"] = id
  result["Name"] = data.Name
  result["XP"] = data.XP
  result["CustomModel"] = data.CustomModel
  result["SingleUse"] = data.SingleUse
  result["IsPersistent"] = data.IsPersistent
  result["POS"] = data.POS or data.trace.HitPos
  return result
end

function wOS.HCS:AddHolocron(data,holocronTable)
  local id = wOS.HCS.Data:GetNewID()
  local holocron = HolocronClass(id,data)
  return holocron
end

function wOS.HCS:UpdateHolocron(data)
  print("CLASS: ")
  PrintTable(data)
  local id = data.ID
  local nHolocron = HolocronClass(id,data)
  return nHolocron
end


function wOS.HCS:GetHolocron(id)
  local holocrons = wOS.HCS.Holocrons or {}
  return holocrons[id]
end