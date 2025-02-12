local white = Color.new(255, 255, 255)  


while true do
	screen.clear(white) 
	pad = buttons.read()
	
    print(90, 140, colors.black, "Верно", 1, deFfont)
    print(150, 140, colors.black, points, 1, deFfont)
    print(200, 140, colors.black, "из 20",1, deFfont)
	if press('start') then break; end
	color = colors.black
	oldpad = pad
	screen.flip()
end

color = nil
-- clear the RAM
System.GC()