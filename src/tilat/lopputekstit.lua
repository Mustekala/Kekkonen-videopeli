
lopputekstit = {}

function lopputekstit:enter( taso )
    rotation=0	
	TEsound.pause("musiikki")
	TEsound.play("media/aanet/musiikki/StockSounds.ogg","lopputekstit")
	
	
	teksti=[[
	Kekkonen 
	 Videopeli  
	
	Powered by:
	LOVE2D
	
	
	
	Ohjelmointi: 
	
	Petrus Peltola 
	
	Eero Lumijarvi 
	
	
	
	Animointi: 
	
	Eero Lumijarvi
	
	Petrus Peltola   
	
	
	
	musiikki:
	
	tahan musiikkilahteet
	
	
	
	aanitehosteet: 
	
	Eero Lumijarvi
	
	
	
	Taustat:
	
	Eduskunta: sky1.png 
	by opengameart.org/users/bart 
	
	
	
	Fontti: 
	
	Boxy Bold by Clint Bellanger
	
	
	
	valmiit kirjastot: 
	
	Simple Menu Library 
	by nkorth
	
	AdvTiledLoader
	by Kadoba
	
	AnimationsAndLove 
	by bartbes 
	
	HUMP-utilities 
	by Matthias Richter 
	
	TEsound 
	by Ensayia & Taehl
	
	]]

	tekstinY=650
	x=0
	y=1
	kekkoset = {}
	ajastin=0
end


function lopputekstit:update( dt )
	
	ajastin = ajastin+1
	if ajastin % 10 == 0 then
		
	  table.insert(kekkoset, {anim = kekkonen_blu.putoaminen_anim, x=math.random(1, 800), y=-100, nopeus=1+math.random()})
	end
    
	for _, nykyinen in pairs(kekkoset) do
		if nykyinen.y < 600 then
			nykyinen.y = nykyinen.y + nykyinen.nopeus
		end
	end	
	kekkonen_blu.putoaminen_anim:update(dt)
	
	if love.keyboard.isDown("return") then

		tekstinY=tekstinY-5

	else

		tekstinY=tekstinY-2

	end
    
	if tekstinY < -3500 then Gamestate.pop() end --Lopetetaan tekstit
	
end


function lopputekstit:draw()
    love.graphics.draw( kuvat[ "ukk_tausta.png" ], 600, 300 , rotation, 2,2, 400, 300)
	for _, nykyinen in pairs(kekkoset) do	      
	 nykyinen.anim:draw(nykyinen.x, nykyinen.y, 0 , 0.5*nykyinen.nopeus, 0.5*nykyinen.nopeus) --Nopeus on myos skaalaus: mita nopeampi, sita suurempi kuva
	end
	love.graphics.printf(teksti,150,tekstinY,500, "center")

end


function lopputekstit:keypressed( nappain )

	if nappain == "escape" then
		Gamestate.pop()
		print("Paavalikko")
	end

end

function lopputekstit:leave()
	TEsound.stop("lopputekstit")
	TEsound.resume("musiikki")

end