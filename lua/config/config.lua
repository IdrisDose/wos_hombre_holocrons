-- idk some config stuff goes here????
wOS = wOS or {}
wOS.hcrons = wOS.hcrons or {}
wOS.hcrons.config = wOS.hcrons.config or {}


-- wOS.hcrons.config.UseMySQL = false

-- wOS.hcrons.config.MySQL = {
--   host = "localhost",
--   port = "3306",
--   username = "root",
--   password = "root"
-- }

wOS.hcrons.config.RefreshTime = GetConVar("wos_hcrons_refreshtime"):GetInt() or 300

--[[
  DO NOT TOUCH ANYTHING BELOW THIS LINE kthix
]]--


print("[wOS] HCron Sys: CONFIG LOADED")