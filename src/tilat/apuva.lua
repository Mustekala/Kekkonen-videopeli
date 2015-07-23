--Apuva-tila tarjoaa apua esim. valikoiden kayttoon seka kontrolleihin

apuva = {}

function apuva:init( )
	
	self.printattava1 = ""
	self.printattava2 = ""
	
	--Kaikki tilat joissa saa apua
	hahmovalikko1 = 
	[[
	Valitkaa hahmonne. 
	
	Pelaaja 1 
	W & S (liiku) 
	SPACE (valitse)
	
	
	
	OK! (ENTER)
	]]
	hahmovalikko2 = 
	[[
	
	
    Pelaaja 2 
	UP & DOWN (liiku)
	ENTER     (valitse)
	]]
	muutValinnat1 = 
	[[
	Muut valinnat
	
	UP & DOWN (liiku)
	ENTER     (valitse)
	Elamien maara (<0 = loputon peli)
	Bottien maara (max 2)
	Poweruppien yleisyys (1-5)
	
	
	OK! (ENTER)
	]]
	muutValinnat2 = 
	[[
	
	]]
	
	tasovalikko1 = 
	[[
	Valitkaa taso. 
	
	UP & DOWN (liiku)
	ENTER     (valitse)
	]]
	tasovalikko2 = ""
	
	peli1 = 
	[[
	Peli
	
	Pelaaja 1
	
	Hyppy:  W
	Vasen:  A
	Oikea:  S
	Torjunta: N
	Lyonti: B 
	Heitto: H 
	]]
	peli2 = 
	[[
	
	
	Pelaaja 2
	
	Hyppy:  UP
	Vasen:  LEFT
	Oikea:  RIGHT
	Torjunta: 2
	Lyonti: 1 
	Heitto: 4 
	
	
	OK! (ENTER)
	]]
end

function apuva:enter( aiempi, tila , vaihe)
	
	self.tila = tila
	print(self.tila)
	--Jos vaihe maaritelty, se on printattava, jos ei, tila on printattava
	local printattava = vaihe or tila 
	self.printattava1 = _G[printattava.."1"]
	self.printattava2 = _G[printattava.."2"] 

end

function apuva:update( dt )

end

function apuva:draw( )

	_G[self.tila]:draw()
	love.graphics.draw( kuvat[ "paussi_tausta.png" ], 0, 0 ) --Paussitausta on 25% läpinäkyvä

	love.graphics.print(self.printattava1, 10, 200, 0, 0.7)
	love.graphics.print(self.printattava2, 400, 200, 0, 0.7)
	
end

function apuva:keypressed( nappain )

	if nappain == "return" or nappain == "f1" then
		Gamestate.pop()
	end

end