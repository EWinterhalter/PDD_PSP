local json_loader = require("json_loader")
local white = Color.new(255, 255, 255)   
local currentQuestion = 1     
local selectedAnswer = 1      
local isAnswerChecked = false 
local ticketData = json_loader.getTicketData(selectedTicket)

limit = 470
textheight, textlength = 165, 10
curstr = "" 
curlength = 0 


-- Таблица для хранения загруженных изображений
local questionImages = {}

-- Функция для загрузки изображения, если оно еще не загружено
local function loadQuestionImage(questionData)
    if questionData.image and not questionImages[currentQuestion] then
        questionImages[currentQuestion] = Image.load(questionData.image)
    end
end

function drawQuestionScreen()
    local questionData = ticketData[currentQuestion]
    
    -- Отрисовка изображения, если оно есть
    if questionImages[currentQuestion] then
        Image.draw(questionImages[currentQuestion], 40, 10)
    end
    -- for i = 1, #questionData.question do
    --     local char = questionData.question:sub(i, i)  -- Получаем текущий символ
    --     local nextCurstr = curstr .. char  -- Временная строка для проверки длины
    --     local nextCurlength = intraFont.textW(deFfont, nextCurstr)  -- Длина временной строки
    
    --     -- Если добавление символа превышает лимит, выводим текущую строку и начинаем новую
    --     if nextCurlength > limit then
    --         print(textlength, textheight, colors.black, curstr, 1, deFfont)  -- Выводим текущую строку
    --         textheight = textheight + 10  -- Переход на новую строку
    --         curlength = 0
    --         curstr = char  -- Начинаем новую строку с текущего символа
    --     else
    --         curstr = nextCurstr  -- Добавляем символ к текущей строке
    --         curlength = nextCurlength  -- Обновляем длину текущей строки
    --     end
    -- end
    
    -- -- После цикла выводим оставшуюся строку, если она есть
    -- if curstr ~= "" then
    --     print(textlength, textheight, colors.black, curstr, 1, deFfont)
    -- end
    print(10, 165, colors.black, questionData.question, 1, deFfont)
    print(0, 0, colors.black, currentQuestion, 1, deFfont)
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
        print(10, y, colorQ, answer.answer_text, 1, deFfont)
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
        break -- Выход из цикла
    end
    if pressed["cross"](pad) and not isAnswerChecked then
        isAnswerChecked = true
        local selectedAnswerData = ticketData[currentQuestion].answers[selectedAnswer]
        if selectedAnswerData.is_correct then
            points = points + 1
            -- Увеличиваем счетчик очков за правильный ответ
        end
    elseif pressed["right"](pad) and isAnswerChecked then
        currentQuestion = currentQuestion + 1
        if currentQuestion > #ticketData then
            currentQuestion = 1 
        end
        selectedAnswer = 1
        isAnswerChecked = false
        -- Загрузка изображения для нового вопроса
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