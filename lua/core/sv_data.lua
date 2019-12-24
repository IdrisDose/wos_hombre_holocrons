-- Data crapo goes here....
wOS = wOS or {}
wOS.hcrons = wOS.hcrons or {}
wOS.hcrons.data = wOS.hcrons.data or {}
wOS.hcrons.config = wOS.hcrons.config or {}
wOS.hcrons.holocrons = wOS.hcrons.holocrons or {}

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



local function setupSQLiteTables()
  --Setup tables
  sql.Begin()

  sql.Query([[CREATE TABLE `wos_hcrons` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`name`	TEXT NOT NULL,
	`xp`	INTEGER DEFAULT 10,
	`pos_x`	REAL NOT NULL,
	`pos_y`	REAL NOT NULL,
	`pos_z`	REAL NOT NULL,
	`singleuse`	NUMERIC DEFAULT 0,
	`enabled`	NUMERIC DEFAULT 1
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
    wOS.hcrons:Print("table creation failed")
    return false
  end

  return true
end

function wOS.hcrons.data:LoadData()
  wOS.hcrons:Print("Loading Data")

  if wOS.hcrons.config.UseMySQL then
    if loadMySQL then
      wOS.hcrons:Print("Loaded from MYSQL")
    else
      wOS.hcrons:Print("Failed from MYSQL")
    end
  else
      -- Start some SQL BS
      if (not sql.TableExists("wos_hcrons")) or (not sql.TableExists("wos_hcrons_pdata")) then
        if(setupSQLiteTables()) then
          wOS.hcrons:Print("TABLES SETUP")
        else
          wOS.hcrons:Print("TABLES FAILED")
        end
      end


      --sql.Begin()

      --sql.Commit()

  end

  return true
end


local function loadMySQL()
  -- Do MySQL Magicc
  local mysql = wOS.hcrons.config.MySQL

  return true

end