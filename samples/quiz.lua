local white = Color.new(255, 255, 255)  


while true do
	screen.clear(white) 
	pad = buttons.read()
	selectedTicket = LUA.getRandom(40)
    dofile("samples/ticket.lua")
	if press('start') then break; end
	oldpad = pad
	screen.flip()
end

color = nil
-- clear the RAM
System.GC()
sound.play('assets/bg.mp3', sound.MP3, false, true)