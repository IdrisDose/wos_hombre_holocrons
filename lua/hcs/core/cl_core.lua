-- Gui if any goes here ???
wOS = wOS or {}
wOS.HCS = wOS.HCS or {}
wOS.HCS.clientLoaded = false


-- After File Loaded if not failed
wOS.HCS.clientLoaded = true




-- If Client Files laoded properly print loaded else print failed
if wOS.HCS.clientLoaded then
  wOS.HCS:Print("Client Loaded")
else
  wOS.HCS:Print("Client Failed")
end