-- Gui if any goes here ???
wOS = wOS or {}
wOS.hcrons = wOS.hcrons or {}
wOS.hcrons.clientLoaded = false


-- After File Loaded if not failed
wOS.hcrons.clientLoaded = true




-- If Client Files laoded properly print loaded else print failed
if wOS.hcrons.clientLoaded then
  wOS.hcrons:Print("Client Loaded")
else
  wOS.hcrons:Print("Client Failed")
end