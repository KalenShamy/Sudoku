local sudokus = require("sudokus")

local WIDTH, HEIGHT = love.window.getDesktopDimensions()

function love.load()
    love.window.setMode(WIDTH, HEIGHT, {
        fullscreen = true,
        resizable = false,
        vsync = true
    })
end

local nunitoButton = love.graphics.newFont("nunito.ttf",HEIGHT*0.1)
local nunitoTitle = love.graphics.newFont("nunito.ttf",HEIGHT*0.125)
local nunitoNumber = love.graphics.newFont("nunito.ttf",HEIGHT*0.055)
local nunitoNumButton = love.graphics.newFont("nunito.ttf",HEIGHT*0.09)

local screen = "Main" -- "Main" // "Game"

local difficulty = "ERROR"
local selectedSq = {}
local groups = {{11,12,13,21,22,23,31,32,33},{14,15,16,24,25,26,34,35,36},{17,18,19,27,28,29,37,38,39},{41,42,43,51,52,53,61,62,63},{44,45,46,54,55,56,64,65,66},{47,48,49,57,58,59,67,68,69},{71,72,73,81,82,83,91,92,93},{74,75,76,84,85,86,94,95,96},{77,78,79,87,88,89,97,98,99}}
local board = {{},{},{},{},{},{},{},{},{}}
local boardSolution = {{},{},{},{},{},{},{},{},{}}
local startSecond = 0
local mistakes = 0

local numbers = {true,true,true,true,true,true,true,true,true}

local x, y = 0,0

local arrowPressed = false

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

function love.update(deltatime)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    x, y = love.mouse.getPosition()
    if love.mouse.isDown(1) then
        if screen == "Main" then
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
        elseif screen == "Game" then
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
                if numbers[num] and board[selectedSq[1]][selectedSq[2]] ~= boardSolution[selectedSq[1]][selectedSq[2]] then
                    board[selectedSq[1]][selectedSq[2]] = num
                end
            else
                selectedSq = {}
            end
        end
    end
    if screen == "Game" and selectedSq[1] ~= nil then
        for num, visible in ipairs(numbers) do
            if love.keyboard.isDown(tostring(num)) and board[selectedSq[1]][selectedSq[2]] ~= boardSolution[selectedSq[1]][selectedSq[2]] then
                board[selectedSq[1]][selectedSq[2]] = num
            end
        end
        if love.keyboard.isDown("backspace") and board[selectedSq[1]][selectedSq[2]] ~= 0 and board[selectedSq[1]][selectedSq[2]] ~= boardSolution[selectedSq[1]][selectedSq[2]] then
            board[selectedSq[1]][selectedSq[2]] = 0
        end
    end
    if screen == "Game" then
        if arrowPressed ~= false then
            if not (love.keyboard.isDown("up") == false and love.keyboard.isDown("down") == false and love.keyboard.isDown("left") == false and love.keyboard.isDown("right") == false) then
                -- arrows not pressed
                if arrowPressed == true then
                    arrowPressed = 5
                elseif arrowPressed > 0 then
                    arrowPressed = arrowPressed - deltatime*100
                else
                    arrowPressed = false
                end
            end
        else
            if selectedSq[1] == nil then
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
    end
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

function inSelectedBox(col,row)
    for _, group in ipairs(groups) do
        isSelected = intInArray(group,tonumber(tostring(selectedSq[1])..tostring(selectedSq[2])))
        if isSelected then
            return intInArray(group,tonumber(tostring(col)..tostring(row)))
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
        info = centeredInfo(WIDTH*0.5,HEIGHT*0.5,HEIGHT*0.65,HEIGHT*0.65)
        love.graphics.rectangle("fill", info[1], info[2], info[3], info[4])
        -- vertical lines
        love.graphics.setColor(0,0,0,1)
        love.graphics.rectangle("fill", info[1], info[2], 3, info[4])
        love.graphics.rectangle("fill", info[1]+HEIGHT*0.65/3, info[2], 3, info[4])
        love.graphics.rectangle("fill", info[1]+HEIGHT*0.65*2/3, info[2], 3, info[4])
        love.graphics.rectangle("fill", info[1]+HEIGHT*0.65, info[2], 3, info[4])
        -- horizontal lines
        love.graphics.rectangle("fill", info[1], info[2], info[3], 3)
        love.graphics.rectangle("fill", info[1], info[2]+HEIGHT*0.65/3, info[3], 3)
        love.graphics.rectangle("fill", info[1], info[2]+HEIGHT*0.65*2/3, info[3], 3)
        love.graphics.rectangle("fill", info[1], info[2]+HEIGHT*0.65, info[3], 3)
        -- board
        if board[1][1] ~= nil then
            info = centeredInfo(WIDTH*0.5,HEIGHT*0.5,HEIGHT*0.65,HEIGHT*0.65)
            for column,vals in ipairs(board) do
                for row,val in ipairs(vals) do
                    if val ~= 0 then
                        love.graphics.setColor(0,0,0,1)
                        love.graphics.rectangle("line", info[1]+(info[3]*(column-1)/9), info[2]+(info[4]*(row-1)/9), info[3]/9, info[4]/9)
                        love.graphics.setColor(0,0,0,1)
                        if selectedSq[1] ~= nil then
                            if (selectedSq[1] == column and selectedSq[2] == row) or val == board[selectedSq[1]][selectedSq[2]] then
                                love.graphics.setColor(0,0,0,0.35)
                                love.graphics.rectangle("fill", info[1]+(info[3]*(column-1)/9), info[2]+(info[4]*(row-1)/9), info[3]/9, info[4]/9)
                                love.graphics.setColor(0,0,0,1)
                            elseif selectedSq[1] == column or selectedSq[2] == row or inSelectedBox(column,row) then
                                love.graphics.setColor(0,0,0,0.125)
                                love.graphics.rectangle("fill", info[1]+(info[3]*(column-1)/9), info[2]+(info[4]*(row-1)/9), info[3]/9, info[4]/9)
                                love.graphics.setColor(0,0,0,1)
                            end
                        end
                        if boardSolution[column][row] ~= val then
                            love.graphics.setColor(1,0,0,0.25)
                            love.graphics.rectangle("fill", info[1]+(info[3]*(column-1)/9), info[2]+(info[4]*(row-1)/9), info[3]/9, info[4]/9)
                            love.graphics.setColor(1,0,0,1)
                        end
                        love.graphics.setFont(nunitoNumber)
                        love.graphics.printf(val, info[1]+(info[3]*(column-1)/9), info[2]+(info[4]*(row-1)/9), info[3]/9, "center")
                    else
                        love.graphics.setColor(0,0,0,1)
                        love.graphics.rectangle("line", info[1]+(info[3]*(column-1)/9), info[2]+(info[4]*(row-1)/9), info[3]/9, info[4]/9)
                        if selectedSq[1] ~= nil then
                            if selectedSq[1] == column and selectedSq[2] == row then
                                love.graphics.setColor(0,0,0,0.35)
                                love.graphics.rectangle("fill", info[1]+(info[3]*(column-1)/9), info[2]+(info[4]*(row-1)/9), info[3]/9, info[4]/9)
                            elseif selectedSq[1] == column or selectedSq[2] == row or inSelectedBox(column,row) then
                                love.graphics.setColor(0,0,0,0.125)
                                love.graphics.rectangle("fill", info[1]+(info[3]*(column-1)/9), info[2]+(info[4]*(row-1)/9), info[3]/9, info[4]/9)
                                love.graphics.setColor(0,0,0,1)
                            end
                        end
                    end
                end
            end
        else
            board, boardSolution = setupBoard()
        end
        -- numbers
        love.graphics.setColor(1,1,1,1)
        info = centeredInfo(WIDTH*0.5,HEIGHT*0.917,HEIGHT*0.125*9,HEIGHT*0.125)
        love.graphics.rectangle("fill", info[1], info[2], info[3], info[4])
        love.graphics.setColor(100/255,100/255,1,1)
        love.graphics.setFont(nunitoNumButton)
        for num, visible in ipairs(numbers) do
            if visible then
                love.graphics.printf(tostring(num), info[1]+info[3]*(num-1)/9, info[2], info[3]/9, "center")
            end
        end
    end
end