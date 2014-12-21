
lopputekstit = {}

function lopputekstit:enter( taso )
    rotation=0	
	TEsound.pause("musiikki")
	TEsound.play("media/aanet/musiikki/StockSounds.ogg","lopputekstit")
	
	
	teksti=[[
	Videopeli  
	
	
	
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
	  print("Lisattiin kekkonen")
	  table.insert(kekkoset, {anim=putoaminen_anim.blu, x=math.random(1, 800), y=-100, nopeus=1+math.random()})
	end
    
	for _, nykyinen in pairs(kekkoset) do
	 nykyinen.y = nykyinen.y+nykyinen.nopeus
	end
	putoaminen_anim.blu:update(dt)
	
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
	 nykyinen.anim:draw(nykyinen.x, nykyinen.y)
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