local json_loader = require("json_loader")
local white = Color.new(255, 255, 255)   
local currentQuestion = 1     
local selectedAnswer = 1      
local isAnswerChecked = false 
local ticketData = json_loader.getTicketData(selectedTicket)




function drawQuestionScreen()
    local questionData = ticketData[currentQuestion]
   if questionData.image then
     local image = Image.load(questionData.image)
       Image.draw(image, 40,10)
    end
   print(10, 165, colors.black, questionData.question, 1, deFfont)

    for i, answer in ipairs(questionData.answers) do

        local y = 185 + (i - 1) * 15
        local colorQ = colors.black
        if i == selectedAnswer then
            colorQ = colors.grey
        end

        if isAnswerChecked then
            if answer.is_correct then
                colorQ = colors.green
            elseif i == selectedAnswer and not answer.is_correct then
                colorQ = colors.red
            end
        end
        print(10, y, colorQ, answer.answer_text, 1, deFfont )

    end
    screen.flip()
end

while true do
    local pad = buttons.read()
    screen.clear(white)
    if pressed["start"](pad) then
        dofile("samples/image.lua") 
    end
    if  pressed["cross"](pad) and not isAnswerChecked then
        isAnswerChecked = true
    elseif pressed["right"](pad)and isAnswerChecked then
        currentQuestion = currentQuestion + 1
        if currentQuestion > #ticketData then
            currentQuestion = 1 
        end
        selectedAnswer = 1
        isAnswerChecked = false
    elseif pressed["up"](pad) and not isAnswerChecked then
        selectedAnswer = selectedAnswer - 1
        if selectedAnswer < 1 then
            selectedAnswer = #ticketData[currentQuestion].answers
        end
    elseif pressed["down"](pad) and not isAnswerChecked then
        selectedAnswer = selectedAnswer + 1
        if selectedAnswer > #ticketData[currentQuestion].answers then
            selectedAnswer = 1
        end
        
    end
 --   System.GC()
  --  System.LowCPU()
    drawQuestionScreen()
    screen.flip()
end