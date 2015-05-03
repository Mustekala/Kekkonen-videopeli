camera = {}
camera._x = -10
camera._y = 0
local abs, min, max = math.abs, math.min, math.max
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0

 
function camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
  love.graphics.translate(-self._x, -self._y)
end
 
function camera:unset()
  love.graphics.pop()
end
 
function camera:move(dx, dy)
if self._x<dx then
  self._x = self._x + 0.1
end
if self._x>dx then 
  self._x = self._x - 0.01
end

end
 
function camera:rotate(dr)
  self.rotation = self.rotation + dr
end
 
function camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end
 
function camera:setX(value)
  if self._bounds then
    self._x = math.clamp(value, self._bounds.x1, self._bounds.x2)
  else
    self._x = value
  end
end
 
function camera:setY(value)
  if self._bounds then
    self._y = math.clamp(value, self._bounds.y1, self._bounds.y2)
  else
    self._y = value
  end
end
 
function camera:setPosition(x, y)
  if x then self:setX(x) end
  if y then self:setY(y) end
end
 
function camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end
 
function camera:getBounds()
  return unpack(self._bounds)
end
 
function camera:setBounds(x1, y1, x2, y2)
  self._bounds = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
end

function camera:getX()
return self._x
end
function camera:getY()
return self._y
end

function camera:newLayer(scale, func)
  table.insert(self.layers, { draw = func, scale = scale })
  table.sort(self.layers, function(a, b) return a.scale < b.scale end)
end

--Liikkuu tasaisesti, seuraa huonosti
function camera:kuolemaKamera(px,py,p2x,p2y, voittajaKamera) 
	
	voittajaKamera = voittajaKamera or false
	
	Etaisyys = math.realDist(px,py, p2x, p2y) / 600
	
	if not voittajaKamera then
		
		if Scale>1.5 then	
			Scale=1.5
		else		
			if Scale<0.5 then			
				Scale=0.5
			else
				if Scale>Etaisyys then	 
					Scale=Scale-0.01	
				elseif Scale<Etaisyys then
					Scale=Scale+0.01
				end
			end
		end
		
		camera:setScale(Scale,Scale)
		
	else 
	
		Scale = self.scaleX	
		
	end
	
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()

	cameraKohdeX = 0
	cameraKohdeY = 0

	if px>p2x then

		cameraKohdeX=math.floor(px - math.dist(px,p2x)/2 - width / 2*Scale)

	else
	
		cameraKohdeX=math.floor(p2x - math.dist(px,p2x)/2 - width / 2*Scale)
			
	end	
	
	if py>p2y then 
	 
		cameraKohdeY=math.floor(py - math.dist(py,p2y)/2 - height / 2*Scale)
	 
	else
	 
		cameraKohdeY=math.floor(py + math.dist(py,p2y)/2 - height / 2*Scale)
	 
    end
	
	if cameraKohdeX < camera:getX() then
		if cameraKohdeX<camera:getX()-100 then
			camera:setX(camera:getX()-4)		
		else
			camera:setX(camera:getX()-1)	  	  
		end
	end
	
	if cameraKohdeX>camera:getX() then
		if cameraKohdeX>camera:getX()+100 then
			camera:setX(camera:getX()+4)		
		else
			camera:setX(camera:getX()+1)  
		end
	end
	
	if cameraKohdeY<camera:getY() then	
		camera:setY(camera:getY()-2)	
	end
	
	if cameraKohdeY>camera:getY() then
		camera:setY(camera:getY()+2)
	end
	
	--Jos kamera on liikkunut about oikeaan kohtaan, palauta true (joka vaihtaa takaisin tavalliseen kameraan)
	if math.isAbout(camera:getX(), cameraKohdeX, 5) and math.isAbout(camera:getY(), cameraKohdeY, 5) then
		return true	
	end
		
end

function camera:voittajaKamera(x, y)
	
	camera:scale(0.99)
	if not self:kuolemaKamera(x, y, x + 10, y + 10, true)==true then
		self:kuolemaKamera(x, y, x + 10, y + 10, true)
	end	
	
end

function camera:draw()
  local bx, by = self._x, self._y
  
  for _, v in ipairs(self.layers) do
    self._x = bx * v.scale
    self._y = by * v.scale
    camera:set()
    v.draw()
    camera:unset()
  end
end

function camera:shake(px,py,p2x,p2y)
	
	self:liikkuvaKamera(px+math.random(-5,5),py+math.random(-5,5),p2x+math.random(-5,5),p2y+math.random(-5,5))
	
	kameranKayttokerrat=kameranKayttokerrat+1

	if kameranKayttokerrat>20 then
		kameranKayttokerrat=0
		nykKamera="tavallinen"
	end	
end

function camera:liikkuvaKamera(px,py,p2x,p2y) --Seuraa tasaisesti pelaajia

Scale= math.realDist(px,py, p2x, p2y) /600
	
	if Scale>1.5 then
	Scale=1.5
	
	end
	if Scale<0.5 then
	
	Scale=0.5
	
	end

	camera:setScale(Scale,Scale)

local width= love.graphics.getWidth()
local height= love.graphics.getHeight()

if px>p2x then
	 if py>p2y then 
	 self:setPosition(math.floor(px - math.dist(px,p2x)/2 - width / 2*Scale),math.floor(py - math.dist(py,p2y)/2 - height / 2*Scale))
	 else
	 self:setPosition(math.floor(px - math.dist(px,p2x)/2 - width / 2*Scale),math.floor(py + math.dist(py,p2y)/2 - height / 2*Scale))
	 end
	 
	 else
	 if py>p2y then 
	 self:setPosition(math.floor(px + math.dist(px,p2x)/2 - width / 2*Scale),math.floor(py - math.dist(py,p2y)/2 - height / 2*Scale))
	 else
	 self:setPosition(math.floor(px + math.dist(px,p2x)/2 - width / 2*Scale),math.floor(py + math.dist(py,p2y)/2 - height / 2*Scale))
    end
end
end

