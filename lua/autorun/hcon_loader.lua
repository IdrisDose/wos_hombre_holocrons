wOS = wOS or {}
wOS.HCS = wOS.HCS or {}

-- AddCSLuaFile('config/config.lua')
-- AddCSLuaFile('core/sh_core.lua')


-- include('config/config.lua')
-- include('core/sh_core.lua')

if SERVER then
  -- Do dirty loading
  AddCSLuaFile('hcs/config/config.lua')
  AddCSLuaFile('hcs/core/sh_core.lua')
  AddCSLuaFile('hcs/core/cl_core.lua')
  AddCSLuaFile('hcs/core/cl_net.lua')

  include('hcs/config/config.lua')
  include('hcs/core/sh_core.lua')
  include('hcs/core/sv_class_holocron.lua')
  include('hcs/core/sv_data.lua')
  include('hcs/core/sv_core.lua')
  include('hcs/core/sv_net.lua')

end


if CLIENT then
  -- Do dirt client loading
  include('hcs/config/config.lua')
  include('hcs/core/sh_core.lua')

  include('hcs/core/cl_core.lua')
  include('hcs/core/cl_net.lua')
end