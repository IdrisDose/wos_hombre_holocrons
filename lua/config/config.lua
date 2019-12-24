-- idk some config stuff goes here????
wOS = wOS or {}
wOS.hcrons = wOS.hcrons or {}
wOS.hcrons.config = wOS.hcrons.config or {}


-- If you want the holocrons to have a default
wOS.hcrons.config.OneTimeUse = true


wOS.hcrons.config.UseMySQL = false

wOS.hcrons.config.MySQL = {
  host = "localhost",
  port = "3306",
  username = "root",
  password = "root"
}



--[[
  DO NOT TOUCH ANYTHING BELOW THIS LINE kthix
]]--


print("[wOS] HCron Sys: CONFIG LOADED")