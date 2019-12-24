wOS = wOS or {}
wOS.hcrons = wOS.hcrons or {}

-- AddCSLuaFile('config/config.lua')
-- AddCSLuaFile('core/sh_core.lua')


-- include('config/config.lua')
-- include('core/sh_core.lua')

if SERVER then
  -- Do dirty loading
  AddCSLuaFile('config/config.lua')
  AddCSLuaFile('core/sh_core.lua')
  AddCSLuaFile('core/cl_core.lua')
  AddCSLuaFile('core/cl_net.lua')

  include('config/config.lua')
  include('core/sh_core.lua')
  include('core/sv_data.lua')
  include('core/sv_core.lua')
  include('core/sv_net.lua')
end


if CLIENT then
  -- Do dirt client loading
  include('config/config.lua')
  include('core/sh_core.lua')

  include('core/cl_core.lua')
  include('core/cl_net.lua')
end