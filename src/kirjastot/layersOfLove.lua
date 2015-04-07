layers={layerStack = {}}

function layers:addLayer(xPosition, yPosition, scaleToAdd, imageToAdd, speedOfLayer, moveDirection)
	table.insert(self.layerStack, {x=xPosition, y=yPosition, scale=scaleToAdd, image=imageToAdd, speed=speedOfLayer, direction=moveDirection})
end

function layers:update(dt)
	for i, layer in ipairs(layers.layerStack) do
		layer.x = layer.x + layer.speed * layer.direction
	end
end

function layers:draw()
	for i, layer in ipairs(layers.layerStack) do
		love.graphics.draw(layer.image, layer.x, layer.y, 0, layer.scale, layer.scale)
	end
end
