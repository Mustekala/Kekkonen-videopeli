botti = {}
botit = {}
--Botti ottaa komentoonsa pelaajan, jonka numeron se saa parametrina
--Aika pahasti viela kesken
function botti:luo(numero)
	table.insert(botit, {
		numero = numero, --Botin ohjattava pelaaja
		numero2 = numero % 2 + 1, --toinen pelaaja
		tila = "puolustava",
		laskuri = 0 
		})
end

function botti:update(dt)
	for i, bot in ipairs(botit) do

		--Jos oma terveys on alle toisen pelaajan terveys/1.5, puolustava
		if pelaajat[bot.numero].terveys < pelaajat[bot.numero2].terveys / 1.5 then 
			bot.tila = "puolustava" --Puolustava pitaa etaisyytta
		else	
			bot.tila = "hyokkaava"  --Hyokkaava pyrkii lahelle
		end
		local haluttuEtaisyys
		if bot.tila == "hyokkaava" then 
			haluttuEtaisyys = 50
		else
			haluttuEtaisyys = 200
		end

		--Jos toinen pelaaja ei ole halutulla etaisyydella tai putoamassa, seuraa sitä
		if pelaajat[bot.numero].x < pelaajat[bot.numero2].x -haluttuEtaisyys and pelaajat[bot.numero2].yNopeus < 400 then
			pelaajat[bot.numero]:liikuOikealle()
			liikkumisSuunta = 1	
		elseif	pelaajat[bot.numero].x > pelaajat[bot.numero2].x +haluttuEtaisyys and pelaajat[bot.numero2].yNopeus < 400 then
			pelaajat[bot.numero]:liikuVasemmalle()
			liikkumisSuunta = -1
		else pelaajat[bot.numero]:pysahdy()	
		end
			
		--Hyppää kuilujen yli
		if not pelaajat[bot.numero]:tarkistaTormays(nykyinenTaso, pelaajat[bot.numero].x + 10 *liikkumisSuunta, pelaajat[bot.numero].y+60) then
			--Mutta vain jos toisella puolella on taso
			if pelaajat[bot.numero]:tarkistaTormays(nykyinenTaso, pelaajat[bot.numero].x+250*liikkumisSuunta, pelaajat[bot.numero].y+60) then 
				pelaajat[bot.numero]:hyppaa()			
			--Muuten pysahdy, paitsi jos ilmassa	
			elseif pelaajat[bot.numero].tila ~= "hyppy" and pelaajat[bot.numero].tila ~=  "putoaminen" then
				pelaajat[bot.numero]:pysahdy()
			end	
		end
	
		--Jos edessa seina, hyppaa
		if pelaajat[bot.numero]:tarkistaTormays(nykyinenTaso, pelaajat[bot.numero].x+33*liikkumisSuunta, pelaajat[bot.numero].y) then
			if pelaajat[bot.numero].tila == "liikuOikealle" or pelaajat[bot.numero].tila == "liikuVasemmalle" then
				pelaajat[bot.numero]:hyppaa()	
			end	
		end
	
		bot.laskuri = bot.laskuri + math.random(1,2)
		
		--Botti kaantyy toisen pelaajan suuntaan, mutta ei heti (liian op)
		if bot.laskuri > 60 then 
			if pelaajat[bot.numero].x - pelaajat[bot.numero2].x < 0 then 
				pelaajat[bot.numero].suunta = "oikea"
			else	
				pelaajat[bot.numero].suunta = "vasen"
			end	
		end
		
		--Pikkuisen satunnaisuutta botin toimiin
		if bot.laskuri > 120 then bot.laskuri = 0 end	
	
		if math.dist(pelaajat[bot.numero].x,pelaajat[bot.numero2].x ) < 50 then

			if bot.laskuri<60 then
				pelaajat[bot.numero]:lyonti() 
			else if bot.laskuri<120 then
				pelaajat[bot.numero]:torjunta() 
			else if bot.laskuri==120 then	
				pelaajat[bot.numero]:heitto()
			else 
				pelaajat[bot.numero]:pysahdy()
			end
		
		end

	  end	
	 end
	end
end