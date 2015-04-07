layerTest = {}

--layerTest pelille. Kertoo nerokkaan taustatarinan (kesken) 
function layerTest:init()
	
	layers:addLayer(100, 0, 1, kuvat["eduskuntaAloitus.png"], 2, 1)	
	layers:addLayer(100, 0, 1, kuvat["eduskuntaAloitus.png"], 3, 1)
	
end

function layerTest:update(dt)
	layers:update(dt)
end

function layerTest:draw()
	layers:draw()
end

function layerTest:keypressed( nappain )

	if nappain == "return" then

	end

end