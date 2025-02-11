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
       Image.draw(image,0,0)
    end
    intraFont.print(deFfont, 10, 200, questionData.question)

    for i, answer in ipairs(questionData.answers) do
        local y = 100 + (i - 1) * 30
        local color = black
        if i == selectedAnswer then
            color = grey
        end

        if isAnswerChecked then
            if answer.is_correct then
                color = green
            elseif i == selectedAnswer and not answer.is_correct then
                color = red
            end
        end

        intraFont.print(deFfont, 10, y, answer.answer_text)
    end

    screen.flip()
end

while true do
    local pad = buttons.read()
    screen.clear(white)
        if pressed["left"](pad) then
            currentQuestion = currentQuestion - 1
            if currentQuestion < 1 then currentQuestion = 20 end
            selectedAnswer = 1
            isAnswerChecked = false
        elseif pressed["right"](pad) then
            currentQuestion = currentQuestion + 1
            if currentQuestion > 20 then currentQuestion = 1 end
            selectedAnswer = 1
            isAnswerChecked = false
        end

        if pressed["up"](pad) then
            selectedAnswer = selectedAnswer - 1
            if selectedAnswer < 1 then selectedAnswer = #ticketData[currentQuestion].answers end
        elseif pressed["down"](pad) then
            selectedAnswer = selectedAnswer + 1
            if selectedAnswer > #ticketData[currentQuestion].answers then selectedAnswer = 1 end
        end

        if pressed["circle"](pad) and not isAnswerChecked then
            isAnswerChecked = true
        end

        drawQuestionScreen()
end
