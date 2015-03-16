--[[
	Yleinen lataustiedosto, jossa kaikki kama ladataan.
	Tein talle oman tiedoston, koska se nayttaa siistimmalta.
--]]

-- Asetetaan hiiren osoitin nakymattomaksi
love.mouse.setVisible( false )

love.graphics.setDefaultFilter( "nearest", "nearest", 1 ) --Poistetaan filter = pikselit näkyvät

print( "Asetetaan tiedostopolut" )

-- Luodaan latausta helpottavat polut ja asetetaan ne muuttujiin
AANI_POLKU = "media/aanet/"
MUSIIKKI_POLKU = AANI_POLKU.."musiikki/"
TEHOSTE_POLKU = AANI_POLKU.."tehosteet/"
FONTTI_POLKU = "media/fontit/"
KUVA_POLKU = "media/kuvat_jne/"
TASO_POLKU = "media/tasot/"

KIRJASTO_POLKU = "src/kirjastot/"
LUOKKA_POLKU = "src/luokat/"
TILA_POLKU = "src/tilat/"
HAHMO_POLKU = LUOKKA_POLKU .. "hahmot/"
POWERUP_POLKU = LUOKKA_POLKU .. "powerupit/"

print("Ladataan valmiit kirjastot")

-- Ladataan valmiit kirjastot
require( KIRJASTO_POLKU .. "TEsound" ) --Aanikirjasto

require( KIRJASTO_POLKU .. "camera" )  --Kamerakirjasto (muokattu) + pari siihen liittyvaa muuttujaa
Scale=0
kameranKayttokerrat=0
nykKamera="tavallinen"
print("Kamera:"..nykKamera)

require( KIRJASTO_POLKU .. "animations" ) --AnimationsAndLove
Menu = require( KIRJASTO_POLKU .. "menu" )--SimpleMenuLibrary
Gamestate = require( KIRJASTO_POLKU .. "gamestate" ) --Hump-gamestate
loader = require(KIRJASTO_POLKU.."AdvTiledLoader.Loader") --ATL
loader.path = TASO_POLKU
--Kumpikaan ei viela kaytossa, collision perustuu etaisyyksiin
HC = require( KIRJASTO_POLKU .. "HC" ) --Hardon collider (monimutkaisempi collision)
bump = require ( KIRJASTO_POLKU .. 'bump') --Yksinkertaisempi collision
Timer = require ( KIRJASTO_POLKU .. "timer" ) --Hump timer
cron = require ( KIRJASTO_POLKU .. 'cron')
lume = require ( KIRJASTO_POLKU .. "/lume/lume") --Hyodyllisia funktioita
helpFunctions = require ( KIRJASTO_POLKU .. "helpFunctions") --Hyodyllisia funktioita

require ( KIRJASTO_POLKU .. "sade") --Yksinkertainen sade-kirjasto

print("Ladataan omat tilat, yms.")
--luokat
require( LUOKKA_POLKU .. "botti" )
require( LUOKKA_POLKU .. "pelaaja" )
require( LUOKKA_POLKU .. "powerup" )

--Tilat
for _, tila in ipairs( love.filesystem.getDirectoryItems( TILA_POLKU ) ) do --Hakee kaikki tilat tilapolusta
	require(TILA_POLKU..string.gsub(tila,".lua","")) --Leikkaa tiedostonimista .lua-paatteen, require ei halua sita
end	
hudTila = "sydan" --Hudin ulkonako

print("Ladataan fontit")

-- Ladataan fontit
comicSans = love.graphics.newFont( FONTTI_POLKU .. "comicsans.ttf", 15 )
laatikkoFontti = love.graphics.newFont( FONTTI_POLKU .. "boxybold.ttf", 36 )

-- Asetetaan fontti
love.graphics.setFont( laatikkoFontti )


-- Luodaan taulukko, johon laitetaan kaikkien ladattavien kuvien tiedostonimet
--kuvaVarasto = love.filesystem.getDirectoryItems( KUVA_POLKU )

-- Ladataan kaikki kuvat kayttaen asken luotua taulukkoa
kuvat = {}
for _, kuva in ipairs( love.filesystem.getDirectoryItems( KUVA_POLKU.."/muut/" ) ) do
	kuvat[kuva] = love.graphics.newImage( KUVA_POLKU .."/muut/".. kuva )
	print( "Ladataan " .. kuva )
end
--Ladataan kaikki taustat
for _, tausta in ipairs( love.filesystem.getDirectoryItems( KUVA_POLKU.."/taustat/" ) ) do
	kuvat[tausta] = love.graphics.newImage( KUVA_POLKU .."/taustat/".. tausta )
	print( "Ladataan tausta: " .. tausta )
end

powerup:lataa() --Ladataan kaikki powerupit
powerupYleisyys = 1

hahmot = {}
--Ladataan kaikki hahmot
for _, hahmo in ipairs( love.filesystem.getDirectoryItems( HAHMO_POLKU )) do
	local nykyinenHahmo = string.gsub(hahmo,".lua","") --Leikkaa tiedostonimista .lua-paatteen, require ei halua sita
	--Haetaan hahmon kuvat	
	for _, kuva in ipairs( love.filesystem.getDirectoryItems( KUVA_POLKU..nykyinenHahmo.."/" ) ) do
		kuvat[kuva] = love.graphics.newImage( KUVA_POLKU ..nykyinenHahmo.."/".. kuva )
		print( "Ladataan " .. kuva )
	end
	--Ladataan hahmon luokka
	require (HAHMO_POLKU .. nykyinenHahmo) 
	table.insert(hahmot, nykyinenHahmo)
	print( "Ladataan animaatiot: " ..nykyinenHahmo )
	_G[nykyinenHahmo]:lataaAnimaatiot() --Kutsutaan luokkaa lataamaan animaatiot
end

tasoVarasto = {
	"Testitaso",
	"Aavikko",
	"Pilvenpiirtaja",
	"Eduskunta"
}

--Hyodylisia matemaattisia funktioita
math.randomseed(os.time())
function math.clamp(low, n, high)
	return math.min(math.max(n, low), high)
end
--Kahden x-pisteen etaisyys
function math.dist(x1,x2) return ((x2-x1)^2)^0.5 end
--Kahden pisteen etaisyys
function math.realDist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
--Onko luku lähes sama kuin luku2, tarkuus-tarkkudella
function math.isAbout(luku, luku2, tarkkuus) return math.abs(luku - luku2) < tarkkuus end 

pelaajienKontrollit = {

	{
		YLOS = "w",
		VASEMMALLE = "a",
		ALAS = "s",
		OIKEALLE = "d",

		LYONTI = "b",
		TORJUNTA = "n",
		HEITTO = "m",
		HEITTOASE = "h", --TODO
		POTKU = "j"      --TODO
	},

	{
		YLOS = "up",
		VASEMMALLE = "left",
		ALAS = "down",
		OIKEALLE = "right",

		LYONTI = "kp1",
		TORJUNTA = "kp2",
		HEITTO = "kp3",
		HEITTOASE = "kp4",   --TODO
		POTKU = "kp5"        --TODO
	}
}

--[[
tasot = {}

for _, taso in ipairs( tasoVarasto ) do
	tasot[taso] = STI.new( TASO_POLKU .. taso )
	print( "Ladataan " .. taso )
end
--]]

print("Ladataan aanet")

vahinkoAanet = {TEHOSTE_POLKU.."Hurt2.ogg", TEHOSTE_POLKU.."Hurt3.ogg", TEHOSTE_POLKU.."Hurt4.ogg"}
kavelyAanet = {TEHOSTE_POLKU.."footstep.ogg", TEHOSTE_POLKU.."footstep2.ogg"}
kavelyAanetAjastin = 0
hyppyAanet = {TEHOSTE_POLKU.."Jump1.ogg", TEHOSTE_POLKU.."Jump2.ogg", TEHOSTE_POLKU.."Jump3.ogg", TEHOSTE_POLKU.."Jump4.ogg"}
	
onkoAani=true
peliAlkanut=false

	--(Vielä) turha
	world = bump.newWorld() --Bump on tormaystunnistus
	
	 pelaaja1={name="pelaaja1"} 	
	
	 pelaaja2={name="pelaaja2"}
	
	world:add(pelaaja1, 0,0, 64, 128)
	world:add(pelaaja2, 0,0, 64, 128)
	
print( "\nKaikki kama ladattu\n" )
	