function love.conf( t )

	-- Poistetaan joystick-ohjain kaytosta (boolean)
    t.modules.joystick = false

	-- Avataan myos konsoli-ikkuna (boolean, vain Windows)
    t.console = true

	-- Peli-ikkunan nimi (merkkijono)
    t.title = "KEKKONEN-VIDEOPELI"

	-- Asetetaan fulscreen-tila pois (boolean)
    t.window.fullscreen = false
	--Fullscreen-tila normaaliksi, eli resoluutio sailyy fullscreenissa
	t.window.fullscreentype = "normal" 
	
	--Ikoni ikkunalle
	t.window.icon = "/media/kuvat_jne/muut/Kekkonen_ikoni.png" 
	
	-- Asetetaan vsync-tila paalle (boolean)
    t.window.vsync = true

	-- Peli-ikkunan leveys (numero)
    t.window.width = 800

	-- Peli-ikkunan korkeus (numero)
    t.window.height = 600

end
