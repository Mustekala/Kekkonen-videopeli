sade={}

--[[
Tama "kirjasto" tekee sadetta. Pisarat pomppivat kartan pinnoilta. Taustalla satunnaisia salamia 
Lainausmerkit siksi, etta tama tarvitsee toimiakseen ATL-kartan, jossa on layer "seinat". Taman voisi korvata parametrilla. 
Parametrit: kartta, x = aloitus x-aste, y = aloitus y-aste, leveys = sateen leveys, maara = kerroin pisaroiden maarälle
--]]
function sade:uusi(kartta, x, y, leveys, maara)
	math.randomseed( os.time() * math.random() )
	sade.kartta = kartta
	sade.x = x
	sade.y = y
	sade.leveys = leveys
	sade.maara = maara
	pisarat={}
	salama_anim = newAnimation(kuvat["Salama.png"],50,100,0.05,13)
	salama_x = 0
	salama_anim:setMode("once")
	salamaLaskuri = 0
end

function sade:update(dt)
	salamaLaskuri = salamaLaskuri + 1
	if math.random(0,2000 / self.maara) == 1 then
		TEsound.play(TEHOSTE_POLKU.."salama.ogg")
		salama_anim:reset()
		salama_x = math.random(self.x,self.leveys)
	end	
	salama_anim:update(dt)
	
	local laskuri = 0
	repeat
		table.insert(pisarat, {x =math.random(self.x, self.leveys), y = self.y, yNopeus = 5, yNopeusMax = 10, xNopeus = 1, kimmonnut = 0})
		laskuri = laskuri+1 
	until laskuri == self.maara
	for i,pisara in ipairs(pisarat) do
		if pisara.yNopeus < pisara.yNopeusMax then pisara.yNopeus = pisara.yNopeus + 1 end 
		pisara.y = pisara.y + pisara.yNopeus
		pisara.x = pisara.x + pisara.xNopeus
		if self:tarkistaTormays(self.kartta, pisara.x, pisara.y) then
			self:kimpoa(pisara)
		end
		if pisara.kimmonnut > 5 or pisara.y > 2000 then --Jos pisara on kimmonnut jo yli 5 kertaa tai pudonnut, poista se
			table.remove(pisarat, i)
		end
		
    end
end

function sade:kimpoa(pisara)
	pisara.kimmonnut = pisara.kimmonnut + 1  
	pisara.yNopeus = -pisara.yNopeus * 0.75
end

function sade:tarkistaTormays(map, x, y)

    local kerros = map.layers["seinat"]

	local laattaX, laattaY = math.floor(x / 32), math.floor(y / 32)
   
    local laatta = map("Seinat")(laattaX, laattaY)

    return not(laatta == nil)
	
end

function sade:draw()
	for i,pisara in ipairs(pisarat) do
		local r, g, b, a = love.graphics.getColor() 
		love.graphics.setColor(28,107,160)
        love.graphics.circle("fill", pisara.x, pisara.y, 2)
		love.graphics.setColor(r, g, b, a)
    end
	salama_anim:draw(salama_x, -300, 0, 10, 10)
end