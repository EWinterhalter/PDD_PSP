local json_loader = require("json_loader")


deFfont = intraFont.load('assets/regular.pgf')
local bg = Image.load('assets/bg.png')

pad, oldpad, currentfile, alpha = '', '', '', 0
lang = System.getLang()
if lang ~= 'Russian' then lang = 'English' end

dofile('samples/asyncCycle.lua')



function print(x, y, color, text, size, font)

	if font == nil then font = deFfont end
	if size == nil then size = 0.9 end

	intraFont.size(font, size)

	y = y + intraFont.textH(font)
	intraFont.printColored(font, x, y, text, color, size)
end

function press(button)
	if pressed[button](pad) and not pressed[button](oldpad) then
		oldpad = pad
		return true
	end
end

function held(button)
	if pressed[button](pad) then
		return true
	end
end




colors = {
	white = Color.new(255,255,255),
	black = Color.new(0,0,0),
	clear = Color.new(0,0,0,0),
	green = Color.new(107,157,118),
	blue = Color.new(76, 102, 240),
	pink = Color.new(255, 0, 127),
	grey = Color.new(200,200,200),
	red = Color.new(120, 0, 24)
}


selectedTicket = LUA.getRandom(40)
local menu = {
	num = 1,
	time = '',

	Russian = {
		{name = 'Случайный билет', file = 'samples/ticket.lua', desc = 'Тестирование случайным\nбилетом'},
		{name = 'Выбрать билет', file = 'samples/image.lua', desc = 'Возможность выбрать билет \nиз списка'},
		
	},
	
	English = {

	},
}

lines = {
	Russian = {

	},
	
	English = {
	}
}




function blinkUPD()
	if alpha == 0 then
		asyncCycle:new(0,255,3,10,function(i) alpha = i end)
	elseif alpha == 255 then
		asyncCycle:new(255,0,-3,10,function(i) alpha = i end)
	end
end


while true do

	screen.clear()

	asyncCycle:update()

	pad = buttons.read()
	
	
	
	
	Image.draw(bg,0,0)
	blinkUPD()

	
	for i, v in ipairs(menu[lang]) do
		print(50,30 + i*12,(i == menu.num and colors.pink) or colors.black,v.name)
		if menu.num == i then
			currentfile = v.file
			print(260,150,colors.black,v.desc)
		end
	end
	
	if press('up') and menu.num > 1 then menu.num = menu.num - 1 end
	if press('down') and menu.num < #menu[lang] then menu.num = menu.num + 1 end
	if press('cross') then sound.stop(sound.MP3) dofile(currentfile) end
	if press('start') then LUA.quit() end
	

	oldpad = pad

	screen.flip()
end