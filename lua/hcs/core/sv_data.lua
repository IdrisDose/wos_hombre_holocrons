-- Data crapo goes here....
wOS = wOS or {}
wOS.HCS = wOS.HCS or {}
wOS.HCS.Data = wOS.HCS.Data or {}
wOS.HCS.Config = wOS.HCS.Config or {}
wOS.HCS.Holocrons = wOS.HCS.Holocrons or {}

--[[

     _                     _     _                   _                         _   _     _               _          _                 _
  __| | ___    _ __   ___ | |_  | |_ ___  _   _  ___| |__     __ _ _ __  _   _| |_| |__ (_)_ __   __ _  | |__   ___| | _____      __ | |__   ___ _ __ ___
 / _` |/ _ \  | '_ \ / _ \| __| | __/ _ \| | | |/ __| '_ \   / _` | '_ \| | | | __| '_ \| | '_ \ / _` | | '_ \ / _ \ |/ _ \ \ /\ / / | '_ \ / _ \ '__/ _ \
| (_| | (_) | | | | | (_) | |_  | || (_) | |_| | (__| | | | | (_| | | | | |_| | |_| | | | | | | | (_| | | |_) |  __/ | (_) \ V  V /  | | | |  __/ | |  __/
 \__,_|\___/  |_| |_|\___/ \__|  \__\___/ \__,_|\___|_| |_|  \__,_|_| |_|\__, |\__|_| |_|_|_| |_|\__, | |_.__/ \___|_|\___/ \_/\_/   |_| |_|\___|_|  \___|
                                                                         |___/                   |___/
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
]]--

--[[ Load Data from file X
  -- Grab data or create new file
]]--


local function hcsQuery(query)
  sql.Begin()
  result = sql.Query(query)

  sql.Commit()
  if IsValid(result) or result == false then
    wOS.HCS:Print(sql.LastError(result))
  end
  return result
end

local function setupSQLiteTables()
  --Setup tables
  sql.Begin()

  sql.Query([[CREATE TABLE `wos_hcrons` (
	`id`	INTEGER PRIMARY KEY,
	`name`	TEXT NOT NULL,
  `model` TEXT NOT NULL,
  `map` TEXT NOT NULL,
	`xp`	INTEGER DEFAULT 10,
	`pos_x`	REAL NOT NULL,
	`pos_y`	REAL NOT NULL,
	`pos_z`	REAL NOT NULL,
	`singleuse`	NUMERIC DEFAULT 0,
	`enabled`	NUMERIC DEFAULT 1,
  `persistent` NUMERIC DEFAULT 0
  );]])


  sql.Query([[CREATE TABLE `wos_hcrons_pdata` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`ply_id`	INTEGER,
	`hcron_id`	INTEGER
  );]])

  --[[
    not used atm

  local create_teams_table = sql.Query("");
  if not IsValid(create_teams_table) then
    return false
  end
  ]]--

  sql.Commit()

  if (not sql.TableExists("wos_hcrons")) or (not sql.TableExists("wos_hcrons_pdata")) then
    wOS.HCS:Print("table creation failed")
    return false
  end

  return true
end

function wOS.HCS.Data:LoadData()
  wOS.HCS:Print("Loading Data")
  -- Start some SQL BS
  if (not sql.TableExists("wos_hcrons")) or (not sql.TableExists("wos_hcrons_pdata")) then
    if(setupSQLiteTables()) then
      wOS.HCS:Print("TABLES SETUP")
    else
      wOS.HCS:Print("TABLES FAILED")
      return false
    end
  end

  sql.Begin()
  local crons = sql.Query("SELECT * FROM wos_hcrons WHERE map='"..game.GetMap().."';")
  sql.Commit()

  if crons != nil and crons != false then
    for k,v in ipairs(crons) do
      local data = {}
      data["ID"] = v.id
      data["Name"] = v.name
      data["IsPersistent"] = v.persistent
      data["POS"] = Vector(v.pos_x, v.pos_y, v.pos_z)
      data["SingleUse"] = v.singleuse
      data["XP"] = v.xp
      data["CustomModel"] = v.model

      wOS.HCS:LoadHCron(data)
    end
  else
    if(IsValid(sql.LastError())) then wOS.HCS:Print(sql.LastError()) end
    wOS.HCS:Print("Table is EMPTY")
  end
  return true
end

function wOS.HCS.Data:SaveHolocron(holocron)

  local foundHCron = wOS.HCS.Data:LoadHolocron(holocron.ID)
  local x = holocron.POS.x
  local y = holocron.POS.y
  local z = holocron.POS.z
  local res = "broke"

  if(!IsValid(foundHCron) or foundHCron==false) then
    wOS.HCS:Print("Creating new holocron: ".. tostring(holocron.ID))
    queryStr = string.format([['%d','%s','%s','%s',%d,%f,%f,%f,%d,%d]],holocron.ID,holocron.Name,holocron.CustomModel,game.GetMap(),holocron.XP,x,y,z,holocron.SingleUse,holocron.IsPersistent)
    res = hcsQuery("INSERT INTO wos_hcrons(id,name,model,map,xp,pos_x,pos_y,pos_z,singleuse,persistent) VALUES ("..queryStr..");")
  else
    wOS.HCS:Print("SaveHolocron: Updating Holocron ID: "..tostring(holocron.ID))
    queryStr([[name='%s', model='%s', map="%s",xp=%d, pos_x=%f, pos_y=%f, pos_z=%f, singleuse=%d, persistent=%d]],holocron.Name,holocron.CustomModel,game.GetMap(),holocron.XP,x,y,z,holocron.SingleUse,holocron.IsPersistent)
    res=hcsQuery("UPDATE wos_hcrons SET "..queryStr.." WHERE id="..holocron.ID..";")
  end

end

function wOS.HCS.Data:DeleteHolocron(id)
  local foundHCron = wOS.HCS.Data:LoadHolocron(id)
  if(IsValid(foundHCron) or foundHCron!=false) then
      hcsQuery("DELETE FROM wos_hcrons WHERE id = "..id..";")
  end

end


function wOS.HCS.Data:LoadHolocron(id)
  sql.Begin()
  local holocron = sql.Query("SELECT * FROM wos_hcrons WHERE ID = '"..id.."';")
  sql.Commit()
  return holocron
end

function wOS.HCS.Data:GetNewID()
  local ID = tonumber(sql.QueryValue("SELECT MAX(id) FROM wos_hcrons;"))
	if not ID then ID = 1 else ID = ID + 1 end
  return ID
end

