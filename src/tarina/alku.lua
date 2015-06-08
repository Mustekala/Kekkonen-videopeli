--[[Tarina alkaa]]--

alku = {}

function alku:init()

end

function alku:enter()
	
	TEsound.stop("musiikki")
	ajastin = 0
	
end

function alku:update( dt )
	ajastin = ajastin + dt

end

function alku:draw()
	
	love.graphics.draw(kuvat["alku.png"])
	
	if ajastin < 3 then
		love.graphics.print(
		[[
		Kekkonen on matkalla
		  pitamaan puhetta
			Eduskuntatalolle
		  ]]
		)
	elseif ajastin < 4 then
		print("GAMESTATE VAIHTUU")
		Gamestate.push(peli)
	end
	
end

function alku:keypressed()

end