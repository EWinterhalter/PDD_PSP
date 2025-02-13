local json_loader = require("json_loader")
local white = Color.new(255, 255, 255)   
local currentQuestion = 1     
local selectedAnswer = 1      
local isAnswerChecked = false 
local ticketData = json_loader.getTicketData(selectedTicket)
local limit = 470 
local questionImages = {}


local function loadQuestionImage(questionData)
    if questionData.image and not questionImages[currentQuestion] then
        questionImages[currentQuestion] = Image.load(questionData.image)
    end
end

function drawQuestionScreen()
    local questionData = ticketData[currentQuestion]
    local textheight, textlength = 170, 10
    local curstr = "" 
    local curlength = 0
    

    print(0, 0, colors.black, currentQuestion, 1, deFfont)

    if questionImages[currentQuestion] then
        if questionData.image == "./images/no_image.jpg" then
            print(130, 50, colors.black, "Вопрос без изображения", 1, deFfont)
            textheight = 120
        else 
            Image.draw(questionImages[currentQuestion], 40, 10)
            textheight = 170
        end
        
    end
    for i = 1, #questionData.question do
        local char = questionData.question:sub(i, i)  
        local nextCurstr = curstr .. char  
        local nextCurlength = intraFont.textW(deFfont, nextCurstr)  
    
        
        if nextCurlength > limit then
            print(textlength, textheight, colors.black, curstr, 0.9, deFfont)  
            textheight = textheight + 10  
            curlength = 0
            curstr = char  
        else
            curstr = nextCurstr  
            curlength = nextCurlength  
        end
    end
    

    if curstr ~= "" then
        print(textlength, textheight, colors.black, curstr, 0.9, deFfont)
        curstr = ""
    end
    y_answ = textheight + 15
    for i, answer in ipairs(questionData.answers) do
        colorQ_answ = colors.black
        if i == selectedAnswer then
            colorQ_answ = colors.grey
        end

        if isAnswerChecked then
            if answer.is_correct then
                colorQ_answ = colors.green
            elseif i == selectedAnswer and not answer.is_correct then
                colorQ_answ = colors.red
            end
        end

        for i = 1, #answer.answer_text do
            local char = answer.answer_text:sub(i, i)  
            local nextCurstr = curstr .. char  
            local nextCurlength = intraFont.textW(deFfont, nextCurstr)  
            if nextCurlength > limit then
                print(textlength, y_answ + 10, colorQ_answ, curstr, 0.85, deFfont)  
                y_answ = y_answ + 10 
                curlength = 0
                curstr = char  
            else
                curstr = nextCurstr  
                curlength = nextCurlength  
            end
        end
        
       
        if curstr ~= "" then
            print(textlength, y_answ + 10, colorQ_answ, curstr, 0.85, deFfont)
            y_answ = y_answ + 10
            curstr = ""
        end
    end
end
local delay = 10  
local counter = 0 
points = 0
while true do
    local pad = buttons.read()
    screen.clear(white)
    counter = counter + 1
    if currentQuestion == 1 then
        loadQuestionImage(ticketData[currentQuestion])
    end
    if currentQuestion == 20 then
        if pressed["right"](pad) then
            dofile("samples/final.lua")
          --  screen.flip()
        end
    end
    if pressed["start"](pad) then
        break 
    end
    if pressed["cross"](pad) and not isAnswerChecked then
        isAnswerChecked = true
        local selectedAnswerData = ticketData[currentQuestion].answers[selectedAnswer]
        if selectedAnswerData.is_correct then
            points = points + 1

        end
    elseif pressed["right"](pad) and isAnswerChecked then
        currentQuestion = currentQuestion + 1
        if currentQuestion > #ticketData then
            currentQuestion = 1 
        end
        selectedAnswer = 1
        isAnswerChecked = false

        loadQuestionImage(ticketData[currentQuestion])
    elseif pressed["up"](pad) and not isAnswerChecked  and counter >= delay then
        selectedAnswer = selectedAnswer - 1
        if selectedAnswer < 1 then
            selectedAnswer = #ticketData[currentQuestion].answers
        end
        counter = 0
    elseif pressed["down"](pad) and not isAnswerChecked and counter >= delay then
        selectedAnswer = selectedAnswer + 1
        if selectedAnswer > #ticketData[currentQuestion].answers then
            selectedAnswer = 1
        end
        counter = 0
    end
    drawQuestionScreen()
    screen.flip()
end