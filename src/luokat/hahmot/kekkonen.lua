--[[

--]]


kekkonen = {

	xNopeusMaksimi = 400,
	yNopeusMaksimi = 1000,

	kestavyys = 100,

	juoksuNopeus = 200,
	
	hyppyNopeus = -625,

	-- isku, torjunta, heitto, potku, heittoase
}

function kekkonen:enter()

end

function kekkonen:update(dt,tila,suunta)
	

end

function kekkonen:draw(nykAnim, x, y ,suunta)
	


end


function kekkonen:haeOsumaLaatikot( x, y )

	return {
		{ x - 10, y - 0, h = 11, w = 13 },
		{ x - 1, y - 11, h = 18, w = 30 },
		{ x - 6, y - 29, h = 12, w = 20 },
		{ x - 3, y - 41, h = 20, w = 26 }
	}

end
