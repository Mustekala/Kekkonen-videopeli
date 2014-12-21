--[[
	Yleinen lataustiedosto, jossa kaikki kama ladataan.
	Tein talle oman tiedoston, koska se nayttaa siistimmalta.
--]]

-- Asetetaan hiiren osoitin nakymattomaksi
love.mouse.setVisible( false )

love.graphics.setDefaultFilter( "nearest", "nearest", 1 ) --Poistetaan filter skaalatessa = pikselit näkyvät

print( "Asetetaan tiedostopolut" )

-- Luodaan latausta helpottavat polut ja asetetaan ne muuttujiin
AANI_POLKU = "media/aanet/"
TEHOSTE_POLKU = AANI_POLKU.."tehosteet/"
FONTTI_POLKU = "media/fontit/"
KUVA_POLKU = "media/kuvat_jne/"
TASO_POLKU = "media/tasot/"

KIRJASTO_POLKU = "src/kirjastot/"
LUOKKA_POLKU = "src/luokat/"
TILA_POLKU = "src/tilat/"
HAHMO_POLKU = LUOKKA_POLKU .. "hahmot/"

print("Ladataan valmiit kirjastot")

-- Ladataan valmiit kirjastot
require( KIRJASTO_POLKU .. "TEsound" )

require( KIRJASTO_POLKU .. "camera" )
Scale=0
kameranKayttokerrat=0
nykKamera="tavallinen"
print("Kamera:"..nykKamera)

require( KIRJASTO_POLKU .. "animations" )
Menu = require( KIRJASTO_POLKU .. "menu" )
Gamestate = require( KIRJASTO_POLKU .. "gamestate" )
loader = require(KIRJASTO_POLKU.."AdvTiledLoader.Loader")
loader.path = TASO_POLKU
HC = require( KIRJASTO_POLKU .. "HC" )
Timer = require ( KIRJASTO_POLKU .. "timer" )
bump = require ( KIRJASTO_POLKU .. 'bump')
cron = require ( KIRJASTO_POLKU .. 'cron')
lume = require ( KIRJASTO_POLKU .. "/lume/lume")
helpFunctions = require ( KIRJASTO_POLKU .. "helpFunctions")

print("Ladataan omat tilat, yms.")

require( TILA_POLKU .. "avausRuutu" )
require( TILA_POLKU .. "asetukset" )
require( TILA_POLKU .. "valikko" )
require( TILA_POLKU .. "tasovalikko" )
require( TILA_POLKU .. "peli" )

require( LUOKKA_POLKU .. "botti" )

require( LUOKKA_POLKU .. "pelaaja" )
require( HAHMO_POLKU .. "kekkonen" )


require ( TILA_POLKU .. "avausRuutu" )
require	( TILA_POLKU .. "voittoRuutu" )
require ( TILA_POLKU .. "asetukset" )
require ( TILA_POLKU .. "valikko" )
require ( TILA_POLKU .. "tasovalikko" )
require ( TILA_POLKU .. "hahmovalikko" )
require ( TILA_POLKU .. "paussivalikko" )
require ( TILA_POLKU .. "peli" )
require ( TILA_POLKU .. "lopputekstit" )


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
for _, kuva in ipairs( love.filesystem.getDirectoryItems( KUVA_POLKU ) ) do
	kuvat[kuva] = love.graphics.newImage( KUVA_POLKU .. kuva )
	print( "Ladataan " .. kuva )
end

hahmoVarasto = {
	
	"Kekkonen"
	
}

hahmot = {}


for _, hahmo in ipairs( hahmoVarasto ) do
	table.insert(hahmot, hahmo)
	print( "Ladataan " ..hahmo )
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

--Animaatiot
print("Ladataan animaatiot")
		
	kavely_kuva={
		blu = kuvat["kekkonen_kavely_blu.png"],
		red = kuvat["kekkonen_kavely.png"]
	}
	kavely_anim={
		blu=newAnimation(kavely_kuva.blu,32,61,0.07,7),
		red=newAnimation(kavely_kuva.red,32,61,0.07,7)
	}

	lyonti_kuva={
		blu = kuvat["kekkonen_lyonti_blu.png"],
		red = kuvat["kekkonen_lyonti.png"]
	}
	lyonti_anim={
		blu = newAnimation(lyonti_kuva.blu,42,64,0.045,10),
		red = newAnimation(lyonti_kuva.red,42,64,0.045,10)
	}
	
	heitto_kuva={
		blu = kuvat["kekkonen_heitto_blu.png"],
		red = kuvat["kekkonen_heitto.png"]
	}
	heitto_anim={
		blu = newAnimation(heitto_kuva.blu,40,65,0.04,7),
		red = newAnimation(heitto_kuva.red,40,65,0.04,7)
	}
	heitto_anim.blu:setMode("bounce")
	heitto_anim.red:setMode("bounce")
	
	paikallaan_kuva={
		blu	= kuvat["kekkonen_paikallaan_blu.png"],
		red	= kuvat["kekkonen_paikallaan.png"]
	}
	paikallaan_anim={
		blu=newAnimation(paikallaan_kuva.blu,42,64,0.5,2),
		red=newAnimation(paikallaan_kuva.red,42,64,0.5,2),
		korjaus=5
	}
		
	torjunta_kuva={
		blu = kuvat["kekkonen_torjunta_blu.png"],
		red = kuvat["kekkonen_torjunta.png"]
	}
	torjunta_anim={
		blu = newAnimation(torjunta_kuva.blu,32,61,0.04,6),
		red = newAnimation(torjunta_kuva.red,32,61,0.04,6),	
	}
	torjunta_anim.blu:setMode("once")
	torjunta_anim.red:setMode("once")
	
	putoaminen_kuva={
		blu = kuvat["kekkonen_putoaminen_blu.png"],
		red = kuvat["kekkonen_putoaminen.png"]
	}
	putoaminen_anim={
		blu = newAnimation(putoaminen_kuva.blu,35,62,0.2,2),
		red = newAnimation(putoaminen_kuva.red,35,62,0.2,2)
	}	
	
	laskeutuminen_kuva={
	    blu = kuvat["kekkonen_laskeutuminen_blu.png"],
		red = kuvat["kekkonen_laskeutuminen.png"]
	}
	laskeutuminen_anim={
		blu = newAnimation(laskeutuminen_kuva.blu,42,65,0.05,6),
		red = newAnimation(laskeutuminen_kuva.red,42,65,0.05,6)	
	}
    laskeutuminen_anim.blu:setMode("once")
	laskeutuminen_anim.red:setMode("once")
	
	hyppy_kuva={
		blu=kuvat["kekkonen_hyppy_blu.png"],
		red=kuvat["kekkonen_hyppy.png"]
	}
	hyppy_anim={
		blu = newAnimation(hyppy_kuva.blu,42,65,0.05,6),
		red = newAnimation(hyppy_kuva.red,42,65,0.05,6),		
	}	
	hyppy_anim.blu:setMode("once")
	hyppy_anim.red:setMode("once")
	
	vahinko_kuva={
		blu = kuvat["kekkonen_taintunut_blu.png"],
		red = kuvat["kekkonen_taintunut.png"]
	}
	vahinko_anim={
		blu=newAnimation(vahinko_kuva.blu,32,62,0.1,7),
		
		red=newAnimation(vahinko_kuva.red,32,62,0.1,7),
		
	}
	vahinko_anim.blu:setMode("bounce")
	vahinko_anim.red:setMode("bounce")

print("Ladataan aanet")

vahinkoAanet = {TEHOSTE_POLKU.."Hurt2.ogg", TEHOSTE_POLKU.."Hurt3.ogg", TEHOSTE_POLKU.."Hurt4.ogg"}

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
	