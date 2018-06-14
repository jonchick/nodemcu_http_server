print("Setting up WIFI...")
wifi.setmode(wifi.STATION)
--modify according your wireless router settings
wifi.sta.config("HOMENET","xp15wifi")
wifi.sta.connect()
tmr.alarm(1, 1000, 1, function() 
	if wifi.sta.getip()== nil then 
		print("IP unavaiable, Waiting...") 
	else 
		tmr.stop(1)
		print("Config done, IP is "..wifi.sta.getip())

        pin = 5
        gpio.mode(pin,gpio.OUTPUT)
        gpio.write(pin,gpio.HIGH)

        srv=net.createServer(net.TCP, 5) 
        srv:listen(80,function(conn) 
            conn:on("receive",function(conn,payload) 
                -- print(payload) 

                local r = dofile("httpserver-request.lua")(payload)
                -- print(r.method)
                -- print(r.request)

                if r.request == "/set/" then
                    gpio.write(pin,gpio.HIGH)
                else 
                    if r.request == "/clear/" then
                        gpio.write(pin,gpio.LOW)
                    end
                end
                
                conn:send("<h1>Home automation system</h1>")
                conn:close()
            end) 
        end)
	end 
end)
