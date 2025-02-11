local json = require("json") 

function loadJson(filename)
    local file = io.open(filename, "r")
    if not file then
        error("Не удалось открыть файл: " .. filename)
    end
    local content = file:read("*a")
    file:close()
    return json.decode(content)
end

function getTicketData(ticketNumber)
    local filename = "assets/tickets/ticket_" .. ticketNumber .. ".json"
    return loadJson(filename)
end

return {
    loadJson = loadJson,
    getTicketData = getTicketData
}
