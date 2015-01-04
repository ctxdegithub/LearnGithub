require "extern"
require "Constant"
require "Block"


BlockLayer = class("BlockLayer", 
	function()
		return cc.Node:create()
	end
)

BlockLayer.__index = BlockLayer
local blockLayer = nil

BlockLayer.map = {} -- map
BlockLayer.blockTable = {} -- block
BlockLayer.score = 0
BlockLayer.playing = true

local origin = cc.Director:getInstance():getVisibleOrigin()
local visibleSize = cc.Director:getInstance():getVisibleSize()


function moveLeft()
	-- cclog("moveLeft")
	local map = blockLayer.map
	local flag = false
	local clearFlag = false
	for row=1, ROW do
		clearFlag = false
		for col=1, COL do
			if (map[row][col] > 0) then
				for colm=col, 2, -1 do
					if (map[row][colm-1] == 0) then
						flag = true
						map[row][colm-1] = map[row][colm]
						map[row][colm] = 0
						blockLayer.blockTable[map[row][colm-1]]:moveTo(colm-1-1, row-1)
					elseif (clearFlag == false) then	-- 是否可消除
						
						local numCur = blockLayer.blockTable[map[row][colm]].num
						local numPrev = blockLayer.blockTable[map[row][colm-1]].num
						
						if (numCur == numPrev) then
							clearFlag = true
							flag = true
							blockLayer.blockTable[map[row][colm-1]]:doubleNumber()
							blockLayer.blockTable[map[row][colm]]:removeFromParent()
							local index = map[row][colm];
							table.remove(blockLayer.blockTable, index)
							
							for r=1, ROW do
								for c=1, COL do
									if (map[r][c] > index) then
										map[r][c] = map[r][c] - 1
									end
								end
							end
							map[row][colm] = 0
						end	
					end
				end	
			end
		end
	end
	if (flag == true) then
		blockLayer:produceBlock()
	end
end

function moveRight()
	-- cclog("moveRight")
	local map = blockLayer.map
	local flag = false
	local clearFlag = false
	for row=1,ROW do
		clearFlag = false
		for col=COL, 1, -1 do
			if (map[row][col] > 0) then
				for colm=col, COL-1 do
					if (map[row][colm+1] == 0) then
						-- cclog("%d,%d", row, colm+1)
						flag = true
						map[row][colm+1] = map[row][colm]
						map[row][colm] = 0
						blockLayer.blockTable[map[row][colm+1]]:moveTo(colm+1-1, row-1)
					elseif (clearFlag == false) then	-- 是否可消除
						
						local numCur = blockLayer.blockTable[map[row][colm]].num
						local numPrev = blockLayer.blockTable[map[row][colm+1]].num
						
						if (numCur == numPrev) then
							clearFlag = true
							flag = true
							blockLayer.blockTable[map[row][colm+1]]:doubleNumber()
							blockLayer.blockTable[map[row][colm]]:removeFromParent()
							local index = map[row][colm];
							table.remove(blockLayer.blockTable, index)
							
							for r=1, ROW do
								for c=1, COL do
									if (map[r][c] > index) then
										map[r][c] = map[r][c] - 1
									end
								end
							end
							map[row][colm] = 0
						end	
					end
				end	
			end
		end
	end
	if (flag == true) then
		blockLayer:produceBlock()
	end
end

function moveUp()
	-- cclog("moveUp")
	local map = blockLayer.map
	local flag = false
	local clearFlag = false
	for col=1,COL do
		clearFlag = false
		for row=ROW, 1, -1 do
			
			if (map[row][col] > 0) then
				for rowm=row, ROW-1 do
					if (map[rowm+1][col] == 0) then
						flag = true
						map[rowm+1][col] = map[rowm][col]
						map[rowm][col] = 0
						blockLayer.blockTable[map[rowm+1][col]]:moveTo(col-1, rowm+1-1)
					elseif (clearFlag == false) then	-- 是否可消除
						local numCur = blockLayer.blockTable[map[rowm][col]].num
						local numPrev = blockLayer.blockTable[map[rowm+1][col]].num
						
						if (numCur == numPrev) then
							clearFlag = true
							flag = true
							blockLayer.blockTable[map[rowm+1][col]]:doubleNumber()
							blockLayer.blockTable[map[rowm][col]]:removeFromParent()
							local index = map[rowm][col];
							table.remove(blockLayer.blockTable, index)
							
							for r=1, ROW do
								for c=1, COL do
									if (map[r][c] > index) then
										map[r][c] = map[r][c] - 1
									end
								end
							end
							map[rowm][col] = 0
						end	
					end
				end	
			end
		end
	end
	if (flag == true) then
		blockLayer:produceBlock()
	end
end

function moveDown()
	-- cclog("moveDown")
	local map = blockLayer.map
	local flag = false
	local clearFlag = false
	for col=1, COL do
		clearFlag = false
		for row=1, ROW do
			
			if (map[row][col] > 0) then
				for rowm=row, 2, -1 do
					if (map[rowm-1][col] == 0) then
						flag = true
						map[rowm-1][col] = map[rowm][col]
						map[rowm][col] = 0
						blockLayer.blockTable[map[rowm-1][col]]:moveTo(col-1, rowm-1-1)
					elseif (clearFlag == false) then	-- 是否可消除
						local numCur = blockLayer.blockTable[map[rowm][col]].num
						local numPrev = blockLayer.blockTable[map[rowm-1][col]].num
						
						if (numCur == numPrev) then
							clearFlag = true
							flag = true
							blockLayer.blockTable[map[rowm-1][col]]:doubleNumber()
							blockLayer.blockTable[map[rowm][col]]:removeFromParent()
							local index = map[rowm][col];
							table.remove(blockLayer.blockTable, index)
							
							for r=1, ROW do
								for c=1, COL do
									if (map[r][c] > index) then
										map[r][c] = map[r][c] - 1
									end
								end
							end
							map[rowm][col] = 0
						end	
					end
				end	
			end
		end
	end
	if (flag == true) then
		blockLayer:produceBlock()
	end
end

local dirMove = {
	[1] = moveLeft,	-- left
	[2] = moveRight,	-- right
	[3] = moveUp,		-- up
	[4] = moveDown, 	-- down
}

function BlockLayer:create()
	local BlockLayer = BlockLayer.new()
	BlockLayer:init()
	blockLayer = BlockLayer
	return BlockLayer
end

-- handing touch events
local touchBeginPoint = nil
local touchFlag = false
local function onTouchBegan(touch, event)
	local location = touch:getLocation()
	touchBeginPoint = location
	-- cclog("onTouchBegan: %0.2f, %0.2f", location.x, location.y)
	if (blockLayer.playing == true) then
		touchFlag = true
	end
	return true
end

local function onTouchMoved(touch, event)
	local location = touch:getLocation()
	local x = math.abs(location.x - touchBeginPoint.x)
	local y = math.abs(location.y - touchBeginPoint.y)

	if ((touchFlag == true) and (x > 20 or y > 20)) then
		touchFlag = false
		local direction = 1
		if (x > y) then
			if (location.x > touchBeginPoint.x) then	-- right
				direction = 2
			else	-- left
				direction = 1
			end
		else
			if (location.y > touchBeginPoint.y) then	-- up
				direction = 3
			else 	-- down
				direction = 4
			end
		end
		dirMove[direction]()	-- move
		
	end
end

local function onTouchEnded(touch, event)
	local location = touch:getLocation()

end

function BlockLayer:init()
	-- init map
	for i=1,ROW do
		self.map[i] = {}
		for j=1, COL do
			self.map[i][j] = 0
		end
	end
	local label = cc.Label:createWithTTF("2", "res/STXINGKA.TTF", 64)
	label:setTag(10)
	self:addChild(label)
	label:setPosition(cc.p(SCORE_X, SCORE_Y))

	self:setPosition(cc.p(0, 0))
	-- touch listener
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
	listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
	listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
	

	-- 加入空白块
	self:initBlank()
	
	-- 生成2Label
	self:produceBlock()
end

-- 初始化界面
function BlockLayer:initBlank()
	local bg = cc.Sprite:createWithSpriteFrameName("057.png")
	local pos = cc.p(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 2)
	bg:setPosition(pos)
	cclog("%d,%d", pos.x ,pos.y)
	self:addChild(bg)
	cclog("%d", cc.Director:getInstance():getVisibleSize().width)
end

-- 创建重玩菜单
function BlockLayer:createRestartMenu()
	self.playing = false
	local layerMenu = cc.Layer:create()
	-- close menu
	local function menuCallback()
		require "main"
		run()
	end
	
	local pos = cc.p(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 2)
	local loseSp = cc.Sprite:create("lose.jpg")
	loseSp:setPosition(pos)
	layerMenu:addChild(loseSp)
	
	local closeMenuItem = cc.MenuItemImage:create("B_close_N.png", "B_close_P.png")
	closeMenuItem:setPosition(cc.p(pos.x+loseSp:getContentSize().width/2 - 45, pos.y - 65))
	closeMenuItem:registerScriptTapHandler(menuCallback)
	menu = cc.Menu:create(closeMenuItem)
	menu:setPosition(cc.p(0,0))
	layerMenu:addChild(menu)
	
	return layerMenu
end

-- 产生数字块
function BlockLayer:produceBlock()
	local total = ROW*COL - #self.blockTable

	math.randomseed(os.time())
	local num = math.random(total)
	local row, col, bFind, count
	bFind = false
	count = 0
	for i=1, ROW do
		for j=1, COL do
			if (self.map[i][j] == 0) then
				count = count + 1
				if (count >= num) then
					bFind = true
					row = i
					col = j
					break
				end
			end
		end
		if (bFind == true) then
			break
		end
	end
	
	local block = Block:create() 
	table.insert(self.blockTable, #self.blockTable+1, block)
	self:addChild(block)
	block:showAt(col-1, row-1)
	
	self.map[row][col] = #self.blockTable
	self:addScore()		-- 增加分数
	
	-- 检测是否结束
	if (self:checkFailed() == true) then
		self:addChild(self:createRestartMenu())
	end
end

local dir = {
	{0,1},
	{0,-1},
	{1,0},
	{-1,0},
}

function BlockLayer:checkFailed()
	for row=1, ROW do
		for col=1, COL do
			local x, y
			for i=1, 4 do
				x = col + dir[i][1]
				y = row + dir[i][2]
				if (x >= 1 and x <= COL and y >= 1 and y <= ROW) then
					if (self.map[row][col] > 0 and self.map[y][x] > 0) then
						local numCur = self.blockTable[self.map[row][col]].num
						local numPrev = self.blockTable[self.map[y][x]].num
						
						if (numCur == numPrev) then
							return false
						end
					else
						return false
					end
				end
			end
		end
	end
	return true
end

-- 增加分数
function BlockLayer:addScore()
	self.score = self.score + 2
	local label = self:getChildByTag(10)
	label:setString(string.format(self.score))
end
