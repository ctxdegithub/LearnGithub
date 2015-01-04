require "extern"
require "Constant"

Block = class("Block", 
	function()
		local sp = cc.Sprite:createWithSpriteFrameName("05.png")
--		sp:setAnchorPoint(cc.p(0,0))
		return sp
	end
)



Block.__index = Block
Block.num = 2
Block.row = -1
Block.col = -1
Block.numPng = {
	"05.png",
	"06.png",
	"08.png",
	"09.png",
	"010.png",
	"011.png",
	"019.png",
	"020.png",
	"021.png",
	"022.png",
	"048.png",
	"055.png",
	"056.png",
	"058.png",
	"093.png",
	
}
function Block:create()
	local Block = Block.new()
	return Block
end


function Block:moveTo(col, row)
	local pos = cc.p(LEFT_DIS + col * (BLOCK_WIDTH + BLOCK_DIS), 
						TOP_DIS + row * (BLOCK_HEIGHT + BLOCK_DIS))
	self.row = row
	self.col = col
	self:setScale(1.0)
	local moveTo = cc.MoveTo:create(0.15, pos)
	self:stopAllActions()
	self:runAction(moveTo)
end

function Block:doubleNumber()
	self.num = self.num * 2
	local num = self.num


	local count = 0
	while (num >= 2) do
		count = count + 1
		num = num / 2
	end
	
	self:setSpriteFrame(self.numPng[count])
	
	-- action
	
	local scaleTo = cc.ScaleTo:create(0.15, 0.1, 1.0)
	local scaleTo2 = cc.ScaleTo:create(0.15, 1.0, 1.0)
	local scaleTo3 = cc.ScaleTo:create(0.15, 1.2)
	local scaleTo4 = cc.ScaleTo:create(0.15, 1.0)
	local seq = cc.Sequence:create(scaleTo, scaleTo2, scaleTo3, scaleTo4)
	self:runAction(seq)
	
end

function Block:showAt(col, row)
	local pos = cc.p(LEFT_DIS + col * (BLOCK_WIDTH + BLOCK_DIS), 
						TOP_DIS + row * (BLOCK_HEIGHT + BLOCK_DIS))
	self:setPosition(pos)
	
	self:setScale(0.2)
	local scaleTo = cc.ScaleTo:create(0.2, 1.0)
	self:runAction(scaleTo)
	
end