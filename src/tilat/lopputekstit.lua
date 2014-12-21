
lopputekstit = {}

function lopputekstit:enter( taso )
    rotation=0	
	TEsound.pause("musiikki")
	TEsound.play("media/aanet/musiikki/StockSounds.ogg","lopputekstit")

	teksti="Videopeli \n\n\n\n\n\n\n\n Ohjelmointi: \n\n\n Petrus Peltola \n\n Eero Lumijarvi \n\n\n\n\n\n\n Animointi: \n\n\n Eero Lumijarvi \n\n Petrus Peltola \n\n\n\n\n\n\n"..   --Joo, ei ehka siistein tapa
	"musiikki: \n\n\n tahan musiikkilahteet\n\n\n\n\n\n\n aanitehosteet: \n\n\n Eero Lumijarvi\n\n\n\n\n\n\n Fontti: \n\n\n Boxy Bold \n by Clint Bellanger\n\n\n\n\n\n\n valmiit kirjastot: \n\n\n Simple Menu Library \n by nkorth"..
	"\n\n AdvTiledLoader \n by Kadoba \n\n AnimationsAndLove by bartbes \n\n HUMP-utilities by Matthias Richter \n\n TEsound \n by Ensayia & Taehl \n\n "

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
    
	if tekstinY < -4000 then Gamestate.pop() end
	
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