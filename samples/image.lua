
local white = Color.new(255, 255, 255)  
local black = Color.new(0, 0, 0)      
local select = Color.new(255, 0, 127)  
local grey = Color.new(200,200,200)
local selectedColor = Color.new(255, 0, 127)  


local squareSize = 40  
local gap = 5          
local startX = 10      
local startY = 10      
local selectedX = 1    
local selectedY = 1    

local numbers = {}
for i = 1, 40 do
    numbers[i] = tostring(i)
end


local delay = 10  
local counter = 0  
selectedTicket = 1

function drawTable()
    screen.clear(white)  

    for i = 1, 40 do

        local row = math.floor((i - 1) / 10)  
        local col = (i - 1) % 10              
        local x = startX + col * (squareSize + gap)
        local y = startY + row * (squareSize + gap)


        if col + 1 == selectedX and row + 1 == selectedY then
            screen.drawRect(x, y, squareSize, squareSize, selectedColor)  
        else
            screen.drawRect(x, y, squareSize, squareSize, grey)  
        end

        intraFont.print(deFfont, x + squareSize / 2, y + squareSize / 2 - 10, numbers[i])
    end
end


while true do
	screen.clear(white) 
	pad = buttons.read()
	
    print(0, 0, colors.black, "Выбор билета", 1, deFfont)


  


    pad = buttons.read() 

    counter = counter + 1

	if press('cross') then
        selectedTicket = (selectedY - 1) * 10 + selectedX
        dofile("samples/ticket.lua")
    end
    if counter >= delay then
        if press('up') then
            selectedY = selectedY - 1
            if selectedY < 1 then selectedY = 4 end  
            counter = 0  
        elseif press('down') then
            selectedY = selectedY + 1
            if selectedY > 4 then selectedY = 1 end  
            counter = 0  
        elseif press('left') then
            selectedX = selectedX - 1
            if selectedX < 1 then selectedX = 10 end  
            counter = 0  
        elseif press('right') then
            selectedX = selectedX + 1
            if selectedX > 10 then selectedX = 1 end  
            counter = 0  
        end
    end
    drawTable() 


	if press('start') then break; end
	color = colors.black
	oldpad = pad
	screen.flip()
end

color = nil
System.GC()