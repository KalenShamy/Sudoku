local sudokus = require("sudokus")

local WIDTH, HEIGHT = love.window.getDesktopDimensions()

local nunitoButton
local nunitoTitle
local nunitoNumber
local nunitoPencil
local nunitoNumButton
local nunitoTinyText

local pencilImage

function love.load()
    love.window.setMode(WIDTH, HEIGHT, {
        fullscreen = true,
        resizable = false,
        vsync = true
    })

    pencilImage = love.graphics.newImage("pencil.png")

    nunitoButton = love.graphics.newFont("nunito.ttf",HEIGHT*0.1125)
    nunitoTitle = love.graphics.newFont("nunito.ttf",HEIGHT*0.125)
    nunitoNumber = love.graphics.newFont("nunito.ttf",HEIGHT*0.055)
    nunitoPencil = love.graphics.newFont("nunito.ttf",HEIGHT*0.055/3)
    nunitoPencilBold = love.graphics.newFont("nunito_bold.ttf",HEIGHT*0.055/3)
    nunitoNumButton = love.graphics.newFont("nunito.ttf",HEIGHT*0.09)
    nunitoTinyText = love.graphics.newFont("nunito.ttf",HEIGHT*0.02)
end

local screen = "Main" -- "Main" // "Game"

local difficulty = "ERROR"
local isPencil = false
local selectedSq = {}
local groups = {{11,12,13,21,22,23,31,32,33},{14,15,16,24,25,26,34,35,36},{17,18,19,27,28,29,37,38,39},{41,42,43,51,52,53,61,62,63},{44,45,46,54,55,56,64,65,66},{47,48,49,57,58,59,67,68,69},{71,72,73,81,82,83,91,92,93},{74,75,76,84,85,86,94,95,96},{77,78,79,87,88,89,97,98,99}}
local pencilOffsets = {{1,1},{2,1},{3,1},{1,2},{2,2},{3,2},{1,3},{2,3},{3,3}}
local board = {{},{},{},{},{},{},{},{},{}}
local boardSolution = {{},{},{},{},{},{},{},{},{}}
local startSecond = 0
local mistakes = 0
local currentMistakes = {}
local gameEnd = 0
local endScreen = 0

local pencilMarkings = {{},{},{},{},{},{},{},{},{}}
local numbers = {true,true,true,true,true,true,true,true,true}

local x, y = 0,0

local arrowPressed = false
local pencil_down = false
local ESC_PRESSED = false

function splitString(inputString, separator)
    if separator == "" then
        local table_ = {}
        for str in string.gmatch(inputString,".") do
            table.insert(table_, str)
        end
        return table_
    else
        if separator == nil then
            separator = "%s"
        end
        if inputString == nil then
            inputString = ""
        end
        local table_ = {}
        for str in string.gmatch(inputString..separator,"(.-)"..separator) do
            table.insert(table_, str)
        end
        return table_
    end
end

function pointInBox(point,x,y,width,height)
    return (point[1] > x and point[2] > y) and point[1] < (x+width) and point[2] < (y+height)
end

function pointInCircle(point,x,y,r)
    return math.sqrt((point[1]-x)^2 + (point[2]-y)^2) <= r
end

function randomizeSudoku(sudoku)
    local sudokuTable_ = {{},{},{},{},{},{},{},{},{}} -- start
    local sudokuSolution_ = {{},{},{},{},{},{},{},{},{}} -- start
    local sudokuTable = {{},{},{},{},{},{},{},{},{}} -- result
    local sudokuSolution = {{},{},{},{},{},{},{},{},{}} -- result

    local rowsToRows = {row1 = 0, row2 = 0, row3 = 0}
    local subrowsToSubrows = {subrow1 = 0, subrow2 = 0, subrow3 = 0}
    local rowsTaken = {false,false,false}
    local subrowsTaken = {false,false,false}

    for i=1,3,1 do
        local randNum = love.math.random(1,3)
        while rowsTaken[randNum] == true do
            randNum = love.math.random(1,3)
        end
        rowsTaken[randNum] = true
        rowsToRows["row" .. i] = randNum
    end

    for i=1,3,1 do
        local randNum = love.math.random(1,3)
        while subrowsTaken[randNum] == true do
            randNum = love.math.random(1,3)
        end
        subrowsTaken[randNum] = true
        subrowsToSubrows["subrow" .. i] = randNum
    end

    -- parse sudoku to proper tables
    local defSudoku = splitString(splitString(sudoku," || ")[1], "")
    local solSudoku = splitString(splitString(sudoku," || ")[2], "")

    for i,num in ipairs(defSudoku) do
        local row = math.ceil(i/9)
        local column = i%9
        if column == 0 then
            column = 9
        end
        sudokuTable_[row][column] = tonumber(num)
    end

    for i,num in ipairs(solSudoku) do
        local row = math.ceil(i/9)
        local column = i%9
        if column == 0 then
            column = 9
        end
        sudokuSolution_[row][column] = tonumber(num)
    end

    -- randomize puzzles
    for i=1,9 do
        local row = math.ceil(i/3)
        local subrow = i%3
        if subrow == 0 then subrow = 3 end

        local dRow = rowsToRows["row" .. row]
        local dSubrow = subrowsToSubrows["subrow"..subrow]

        local finalRow = 3*(dRow-1)+dSubrow
        sudokuTable[finalRow] = sudokuTable_[i]
        sudokuSolution[finalRow] = sudokuSolution_[i]
    end
    -- converge back to string format to return
    local returnVal = ""

    for _,row in ipairs(sudokuTable) do
        for _,num in ipairs(row) do
            returnVal = returnVal .. num
        end
    end

    returnVal = returnVal .. " || "

    for _,row in ipairs(sudokuSolution) do
        for _,num in ipairs(row) do
            returnVal = returnVal .. num
        end
    end

    return returnVal
end

function setupBoard()
    local charsToNums = {a = 0, b = 0, c = 0, d = 0, e = 0, f = 0, g = 0, h = 0, i = 0}
    local numsTaken = {false,false,false,false,false,false,false,false,false}
    local sudokuTable = {{},{},{},{},{},{},{},{},{}}
    local sudokuSolution = {{},{},{},{},{},{},{},{},{}}
    for char,_ in pairs(charsToNums) do
        local randNum = love.math.random(1,9)
        while numsTaken[randNum] == true do
            randNum = love.math.random(1,9)
        end
        numsTaken[randNum] = true
        charsToNums[char] = randNum
    end

    -- randomize sudoku puzzle
    local longSudokuStr = ""
    local longSudokuStr_ = splitString(sudokus:getPuzzle(difficulty),"")

    for i,num in ipairs(longSudokuStr_) do
        if charsToNums[num] then
            num = charsToNums[num]
        end
        longSudokuStr = longSudokuStr .. num
    end

    longSudokuStr = randomizeSudoku(longSudokuStr)

    local currentSudoku_ = splitString(splitString(longSudokuStr," || ")[1], "")
    local currentSudokuSolution_ = splitString(splitString(longSudokuStr," || ")[2], "")
    for i,num in ipairs(currentSudoku_) do
        local row = math.ceil(i/9)
        local column = i%9
        if column == 0 then
            column = 9
        end
        sudokuTable[row][column] = tonumber(num)
    end
    for i,num in ipairs(currentSudokuSolution_) do
        local row = math.ceil(i/9)
        local column = i%9
        if column == 0 then
            column = 9
        end
        sudokuSolution[row][column] = tonumber(num)
    end

    numbers = {true,true,true,true,true,true,true,true,true}

    startSecond = os.time()

    return sudokuTable, sudokuSolution
end

function updateNums()
    nCount = {0,0,0,0,0,0,0,0,0}
    local currentMistakes_ = {}
    for column,vals in ipairs(board) do
        for row,val in ipairs(vals) do
            if val ~= 0 and val == boardSolution[column][row] then
                nCount[val] = nCount[val] + 1
                if nCount[val] == 9 then
                    numbers[val] = false
                end
            elseif val ~= 0 and val ~= boardSolution[column][row] then
                if currentMistakes[tostring(column) .. tostring(row)] ~= val then
                    mistakes = mistakes + 1
                end
                currentMistakes_[tostring(column) .. tostring(row)] = val
            end
        end
    end
    currentMistakes = currentMistakes_
end

function checkWin()
    pass = true
    for column,vals in ipairs(board) do
        for row,val in ipairs(vals) do
            if val ~= boardSolution[column][row] then
                pass = false
            end
        end
    end
    return pass
end

function centeredInfo(x, y, width, height)
    return {x-(width/2),y-(height/2),width,height}
end

function intInArray(array, int)
    for i, num in ipairs(array) do
        if num == int then
            return i
        end
    end

    return false
end

function inSameBox(c1,r1,c2,r2)
    for _, group in ipairs(groups) do
        isGroup = intInArray(group,tonumber(tostring(c1)..tostring(r1)))
        if isGroup then
            return intInArray(group,tonumber(tostring(c2)..tostring(r2)))
        end
    end
end

function getTime()
    local secondsPassed = os.time() - startSecond
    if gameEnd ~= 0 then
        secondsPassed = gameEnd - startSecond
    end
    local timeStr = ""
    local hours = math.floor(secondsPassed/60/60)
    local minutes = math.floor((secondsPassed/60)%60)
    local seconds = secondsPassed%60

    if hours < 10 and hours ~= 0 then
        hours = "0" .. hours
    end

    if minutes < 10 then
        minutes = "0" .. minutes
    end

    if seconds < 10 then
        seconds = "0" .. seconds
    end

    if tonumber(hours) > 0 then
        timeStr = hours .. ":" .. minutes .. ":" .. seconds
    else
        timeStr = minutes .. ":" .. seconds
    end
    return timeStr
end

function setModeColor(alpha)
    if difficulty == "Easy" then
        love.graphics.setColor(50/255,125/255,50/255,alpha)
    elseif difficulty == "Medium" then
        love.graphics.setColor(50/255,50/255,125/255,alpha)
    else
        love.graphics.setColor(125/255,50/255,50/255,alpha)
    end
end

function resetGame()
    screen = "Main" -- "Main" // "Game"
    difficulty = "ERROR"
    isPencil = false
    selectedSq = {}
    groups = {{11,12,13,21,22,23,31,32,33},{14,15,16,24,25,26,34,35,36},{17,18,19,27,28,29,37,38,39},{41,42,43,51,52,53,61,62,63},{44,45,46,54,55,56,64,65,66},{47,48,49,57,58,59,67,68,69},{71,72,73,81,82,83,91,92,93},{74,75,76,84,85,86,94,95,96},{77,78,79,87,88,89,97,98,99}}
    board = {{},{},{},{},{},{},{},{},{}}
    boardSolution = {{},{},{},{},{},{},{},{},{}}
    startSecond = 0
    mistakes = 0
    currentMistakes = {}
    gameEnd = 0
    endScreen = 0
    numbers = {true,true,true,true,true,true,true,true,true}
    arrowPressed = false
end

function insertNumber(number, column, row)
    if isPencil then
        if number ~= 0 and pencil_down == false then
            board[column][row] = 0
            pencilMarkings[column][row][number] = not pencilMarkings[column][row][number]
            pencil_down = true
        end
    elseif number == 0 or numbers[number] then
        board[column][row] = number
        if board[column][row] == boardSolution[column][row] then
            for c, vals in ipairs(pencilMarkings) do
                for r, marks in ipairs(vals) do
                    if c == column or r == row or inSameBox(c, r, column, row) then
                        pencilMarkings[c][r][number] = false
                    end
                end
            end
        end
    end
end

function love.update(deltatime)
    if love.keyboard.isDown("escape") and (love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")) then
        love.event.quit()
    elseif love.keyboard.isDown("escape") and ESC_PRESSED == false then
        ESC_PRESSED = true
        if screen == "Main" then
            love.event.quit()
        else
            resetGame()
        end
    elseif ESC_PRESSED ~= false and not love.keyboard.isDown("escape") then
        if ESC_PRESSED == true then
            ESC_PRESSED = 10
        elseif ESC_PRESSED > 0 then
            ESC_PRESSED = ESC_PRESSED - deltatime*100
        else
            ESC_PRESSED = false
        end
    end
    x, y = love.mouse.getPosition()
    if love.mouse.isDown(1) then
        if screen == "Main" and ESC_PRESSED == false then
            easy = centeredInfo(WIDTH*0.5,HEIGHT*0.35,WIDTH*0.45,HEIGHT*0.15)
            medium = centeredInfo(WIDTH*0.5,HEIGHT*0.55,WIDTH*0.45,HEIGHT*0.15)
            hard = centeredInfo(WIDTH*0.5,HEIGHT*0.75,WIDTH*0.45,HEIGHT*0.15)
            if pointInBox({x,y}, easy[1], easy[2], easy[3], easy[4]) then
                -- easy pressed
                screen = "Game"
                difficulty = "Easy"
            elseif pointInBox({x,y}, medium[1], medium[2], medium[3], medium[4]) then
                -- medium pressed
                screen = "Game"
                difficulty = "Medium"
            elseif pointInBox({x,y}, hard[1], hard[2], hard[3], hard[4]) then
                -- hard pressed
                screen = "Game"
                difficulty = "Hard"
            end
        elseif screen == "Game" and gameEnd == 0 then
            local grid = centeredInfo(WIDTH*0.5,HEIGHT*0.5,HEIGHT*0.65,HEIGHT*0.65)
            local nums = centeredInfo(WIDTH*0.5,HEIGHT*0.917,HEIGHT*0.125*9,HEIGHT*0.125)
            if pointInBox({x,y}, grid[1], grid[2], grid[3], grid[4]) then
                relX = x-grid[1]
                relY = y-grid[2]
                col = math.floor(9*(relX/grid[3]))+1
                row = math.floor(9*(relY/grid[3]))+1
                selectedSq = {col,row}
            elseif selectedSq[1] ~= nil and pointInBox({x,y}, nums[1], nums[2], nums[3], nums[4]) then
                relX = x-nums[1]
                num = math.floor(9*(relX/nums[3]))+1
                if (numbers[num] or isPencil) and board[selectedSq[1]][selectedSq[2]] ~= boardSolution[selectedSq[1]][selectedSq[2]] then
                    insertNumber(num, selectedSq[1], selectedSq[2])
                end
            elseif pointInCircle({x,y}, boardInfo[1]-HEIGHT*0.1, boardInfo[2]+boardInfo[4]-HEIGHT*0.125/2, HEIGHT*0.125/2) then
                if pencil_down == false then
                    pencil_down = true
                    isPencil = not isPencil
                end
            else
                selectedSq = {}
            end
        end
    end
    if screen == "Game" and selectedSq[1] ~= nil and gameEnd == 0 then
        for num, visible in ipairs(numbers) do
            if love.keyboard.isDown(tostring(num)) and board[selectedSq[1]][selectedSq[2]] ~= boardSolution[selectedSq[1]][selectedSq[2]] then
                insertNumber(num, selectedSq[1], selectedSq[2])
            end
        end
        if love.keyboard.isDown("backspace") and board[selectedSq[1]][selectedSq[2]] ~= 0 and board[selectedSq[1]][selectedSq[2]] ~= boardSolution[selectedSq[1]][selectedSq[2]] then
            insertNumber(0, selectedSq[1], selectedSq[2])
        end
    end
    if screen == "Game" and gameEnd == 0 and board[1][1] ~= nil then
        if love.keyboard.isDown("p") and pencil_down == false then
            pencil_down = true
            isPencil = not isPencil
        elseif pencil_down ~= false then
            if pencil_down == true then
                pencil_down = 25
            elseif pencil_down > 0 then
                pencil_down = pencil_down - deltatime*100
            else
                pencil_down = false
            end
        end
        if arrowPressed ~= false then
            if arrowPressed == true then
                arrowPressed = 15
            elseif arrowPressed > 0 then
                arrowPressed = arrowPressed - deltatime*100
            else
                arrowPressed = false
            end
        else
            if selectedSq[1] == nil and (love.keyboard.isDown("up") or love.keyboard.isDown("down") or love.keyboard.isDown("left") or love.keyboard.isDown("right")) then
                selectedSq = {1,1}
            else
                if love.keyboard.isDown("up") and selectedSq[2] > 1 then
                    arrowPressed = true
                    selectedSq = {selectedSq[1], selectedSq[2]-1}
                end
                if love.keyboard.isDown("down") and selectedSq[2] < 9 then
                    arrowPressed = true
                    selectedSq = {selectedSq[1], selectedSq[2]+1}
                end
                if love.keyboard.isDown("left") and selectedSq[1] > 1 then
                    arrowPressed = true
                    selectedSq = {selectedSq[1]-1, selectedSq[2]}
                end
                if love.keyboard.isDown("right") and selectedSq[1] < 9 then
                    arrowPressed = true
                    selectedSq = {selectedSq[1]+1, selectedSq[2]}
                end
            end
        end
        updateNums()
        if checkWin() == true then
            gameEnd = os.time()
        end
    elseif screen == "Game" and board[1][1] ~= nil and love.mouse.isDown(1) then
        resetButton = centeredInfo(WIDTH*0.5,HEIGHT*0.75,WIDTH*0.45,HEIGHT*0.15)
        if pointInBox({x,y}, resetButton[1], resetButton[2], resetButton[3], resetButton[4]) then
            resetGame()
            ESC_PRESSED = true
        end
    end
end

function love.draw()
    love.graphics.clear(216/255,240/255,255/255,1)
    if screen == "Main" then
        -- sudoku title
        love.graphics.setColor(0,0,0,1)
        love.graphics.setFont(nunitoTitle)
        love.graphics.printf("Sudoku", 0, HEIGHT*0.1-(HEIGHT*0.125)/2, WIDTH, "center")

        -- easy button
        love.graphics.setColor(0,0,0,0.25)
        info = centeredInfo(WIDTH*0.5,HEIGHT*0.35,WIDTH*0.45,HEIGHT*0.15)
        love.graphics.rectangle("fill", info[1], info[2], info[3], info[4])
        love.graphics.setColor(1,1,1,1)
        love.graphics.setFont(nunitoButton)
        love.graphics.printf("Easy", info[1], info[2], info[3], "center")

        -- medium button
        love.graphics.setColor(0,0,0,0.25)
        info = centeredInfo(WIDTH*0.5,HEIGHT*0.55,WIDTH*0.45,HEIGHT*0.15)
        love.graphics.rectangle("fill", info[1], info[2], info[3], info[4])
        love.graphics.setColor(1,1,1,1)
        love.graphics.setFont(nunitoButton)
        love.graphics.printf("Medium", info[1], info[2], info[3], "center")

        -- hard button
        love.graphics.setColor(0,0,0,0.25)
        info = centeredInfo(WIDTH*0.5,HEIGHT*0.75,WIDTH*0.45,HEIGHT*0.15)
        love.graphics.rectangle("fill", info[1], info[2], info[3], info[4])
        love.graphics.setColor(1,1,1,1)
        love.graphics.setFont(nunitoButton)
        love.graphics.printf("Hard", info[1], info[2], info[3], "center")
    elseif screen == "Game" then
        -- sudoku title
        love.graphics.setColor(0,0,0,1)
        love.graphics.setFont(nunitoTitle)
        love.graphics.printf("Sudoku", 0, HEIGHT*0.05-(HEIGHT*0.125)/2, WIDTH, "center")
        -- sudoku board
        love.graphics.setColor(1,1,1,1)
        boardInfo = centeredInfo(WIDTH*0.5,HEIGHT*0.5,HEIGHT*0.65,HEIGHT*0.65)
        love.graphics.rectangle("fill", boardInfo[1], boardInfo[2], boardInfo[3], boardInfo[4])
        -- mistakes
        love.graphics.setColor(75/255,75/255,125/255,1)
        love.graphics.setFont(nunitoTinyText)
        love.graphics.printf("Mistakes: " .. tostring(mistakes), boardInfo[1]+15, HEIGHT*0.145, boardInfo[3]/2-15, "center")
        -- time
        love.graphics.setColor(75/255,75/255,125/255,1)
        love.graphics.setFont(nunitoTinyText)
        love.graphics.printf("Time: " .. getTime(), boardInfo[1]-15+boardInfo[3]/2, HEIGHT*0.145, boardInfo[3]/2, "center")
        -- vertical lines
        love.graphics.setColor(0,0,0,1)
        love.graphics.rectangle("fill", boardInfo[1], boardInfo[2], 3, boardInfo[4])
        love.graphics.rectangle("fill", boardInfo[1]+HEIGHT*0.65/3, boardInfo[2], 3, boardInfo[4])
        love.graphics.rectangle("fill", boardInfo[1]+HEIGHT*0.65*2/3, boardInfo[2], 3, boardInfo[4])
        love.graphics.rectangle("fill", boardInfo[1]+HEIGHT*0.65, boardInfo[2], 3, boardInfo[4])
        -- horizontal lines
        love.graphics.rectangle("fill", boardInfo[1], boardInfo[2], boardInfo[3], 3)
        love.graphics.rectangle("fill", boardInfo[1], boardInfo[2]+HEIGHT*0.65/3, boardInfo[3], 3)
        love.graphics.rectangle("fill", boardInfo[1], boardInfo[2]+HEIGHT*0.65*2/3, boardInfo[3], 3)
        love.graphics.rectangle("fill", boardInfo[1], boardInfo[2]+HEIGHT*0.65, boardInfo[3], 3)
        -- fill board
        if board[1][1] ~= nil then
            for column,vals in ipairs(board) do
                for row,val in ipairs(vals) do
                    boxX = boardInfo[1]+(boardInfo[3]*(column-1)/9)
                    boxY = boardInfo[2]+(boardInfo[4]*(row-1)/9)
                    boxW = boardInfo[3]/9
                    boxH = boardInfo[4]/9
                    if val ~= 0 then
                        love.graphics.setColor(0,0,0,1)
                        love.graphics.rectangle("line", boxX, boxY, boxW, boxH)
                        love.graphics.setColor(0,0,0,1)
                        if selectedSq[1] ~= nil then
                            if (selectedSq[1] == column and selectedSq[2] == row) then
                                love.graphics.setColor(125/255,125/255,1,0.35)
                                love.graphics.rectangle("fill", boxX, boxY, boxW, boxH)
                                love.graphics.setColor(0,0,0,1)
                            elseif val == board[selectedSq[1]][selectedSq[2]] then
                                love.graphics.setColor(125/255,125/255,1,0.25)
                                love.graphics.rectangle("fill", boxX, boxY, boxW, boxH)
                                love.graphics.setColor(0,0,0,1)
                            elseif selectedSq[1] == column or selectedSq[2] == row or inSameBox(selectedSq[1], selectedSq[2], column,row) then
                                love.graphics.setColor(125/255,125/255,1,0.125)
                                love.graphics.rectangle("fill", boxX, boxY, boxW, boxH)
                                love.graphics.setColor(0,0,0,1)
                            end
                        end
                        if boardSolution[column][row] ~= val then
                            love.graphics.setColor(1,0,0,0.25)
                            love.graphics.rectangle("fill", boxX, boxY, boxW, boxH)
                            love.graphics.setColor(1,0,0,1)
                        end
                        love.graphics.setFont(nunitoNumber)
                        love.graphics.printf(val, boxX, boxY, boxW, "center")
                    else
                        love.graphics.setColor(0,0,0,1)
                        love.graphics.rectangle("line", boxX, boxY, boxW, boxH)
                        if selectedSq[1] ~= nil then
                            if selectedSq[1] == column and selectedSq[2] == row then
                                love.graphics.setColor(125/255,125/255,1,0.35)
                                love.graphics.rectangle("fill", boxX, boxY, boxW, boxH)
                            elseif selectedSq[1] == column or selectedSq[2] == row or inSameBox(selectedSq[1], selectedSq[2], column,row) then
                                love.graphics.setColor(125/255,125/255,1,0.125)
                                love.graphics.rectangle("fill", boxX, boxY, boxW, boxH)
                            end
                        end
                        love.graphics.setColor(125/255,125/255,125/255,1)
                        for n, visible in ipairs(pencilMarkings[column][row]) do
                            love.graphics.setFont(nunitoPencil)
                            if selectedSq[1] ~= nil and board[selectedSq[1]][selectedSq[2]] == n then
                                love.graphics.setFont(nunitoPencilBold)
                            end
                            if visible then
                                love.graphics.printf(tostring(n),boxX+boxW*(pencilOffsets[n][1]-1)/3, boxY+boxH*(pencilOffsets[n][2]-1)/3, boxW/3, "center")
                            end
                        end
                    end
                end
            end
        else
            board, boardSolution = setupBoard()
            for column, vals in ipairs(board) do
                for row, _ in ipairs(vals) do
                    pencilMarkings[column][row] = {false,false,false,false,false,false,false,false,false}
                end
            end
        end
        -- numbers
        love.graphics.setColor(1,1,1,1)
        info = centeredInfo(WIDTH*0.5,HEIGHT*0.917,HEIGHT*0.125*9,HEIGHT*0.125)
        love.graphics.rectangle("fill", info[1], info[2], info[3], info[4])
        love.graphics.setColor(125/255,125/255,1,1)
        if isPencil then
            love.graphics.setColor(125/255,125/255,125/255,1)
        end
        love.graphics.setFont(nunitoNumButton)
        for num, visible in ipairs(numbers) do
            if visible or isPencil then
                love.graphics.printf(tostring(num), info[1]+info[3]*(num-1)/9, info[2], info[3]/9, "center")
            end
        end
        -- pencil button
        love.graphics.setColor(125/255,125/255,1,1)
        if isPencil then
            love.graphics.setColor(125/255,125/255,125/255,1)
        end
        love.graphics.circle("fill", boardInfo[1]-HEIGHT*0.1,boardInfo[2]+boardInfo[4]-HEIGHT*0.125/2,HEIGHT*0.125/2)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(pencilImage, boardInfo[1]-HEIGHT*0.1-HEIGHT*0.125/2,boardInfo[2]+boardInfo[4]-HEIGHT*0.125,0,HEIGHT*0.125/pencilImage:getWidth())
        -- end screen
        if gameEnd ~= 0 then
            if endScreen < 75 then
                endScreen = endScreen + 1
            end
            setModeColor(endScreen/100)
            love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
            love.graphics.setColor(1,1,1,endScreen/100)
            love.graphics.setFont(nunitoTitle)
            love.graphics.printf("Game Over", 0, HEIGHT*0.25-(HEIGHT*0.125/2), WIDTH, "center")
            love.graphics.setFont(nunitoNumber)
            love.graphics.printf("Time: " .. getTime(), 0, HEIGHT*0.45-(HEIGHT*0.055/2), WIDTH, "center")
            love.graphics.printf("Mistakes: " .. mistakes, 0, HEIGHT*0.55-(HEIGHT*0.055/2), WIDTH, "center")
            resetInfo = centeredInfo(WIDTH*0.5,HEIGHT*0.75,WIDTH*0.45,HEIGHT*0.15)
            love.graphics.rectangle("fill", resetInfo[1], resetInfo[2], resetInfo[3], resetInfo[4])
            setModeColor(endScreen/100)
            love.graphics.setFont(nunitoButton)
            love.graphics.printf("New Game", resetInfo[1], resetInfo[2], resetInfo[3], "center")
        end
    end
end