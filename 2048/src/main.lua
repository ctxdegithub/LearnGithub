require "Cocos2d"
require "Cocos2dConstants"


-- cclog
cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

local visibleSize
local origin


-- create farm
function createLayer()
	-- 自定义类
	require "src/BlockLayer"
	blockLayer = BlockLayer:create()
	blockLayer:setPosition(cc.p(0,0))

	return blockLayer
end

 function createMenu()
	local layerMenu = cc.Layer:create()
	-- close menu
	local function menuCallback()
		cc.Director:getInstance():endToLua()
	end
	local closeMenuItem = cc.MenuItemImage:create("CloseNormal.png", "CloseSelected.png")
	closeMenuItem:setPosition(cc.p(0,0))
	closeMenuItem:registerScriptTapHandler(menuCallback)
	menu = cc.Menu:create(closeMenuItem)
	
	menu:setPosition(cc.p(origin.x + visibleSize.width - 20, origin.y + visibleSize.height - 20))
	cclog("%d", visibleSize.width)
	layerMenu:addChild(menu)
	
	return layerMenu
end


function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
	cc.FileUtils:getInstance():addSearchResolutionsOrder("src");
	cc.FileUtils:getInstance():addSearchResolutionsOrder("res");
	local schedulerID = 0
    --support debug
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or 
       (cc.PLATFORM_OS_ANDROID == targetPlatform) or (cc.PLATFORM_OS_WINDOWS == targetPlatform) or
       (cc.PLATFORM_OS_MAC == targetPlatform) then
        cclog("result is ")
		--require('debugger')()
        
    end
	visibleSize = cc.Director:getInstance():getVisibleSize()
	origin = cc.Director:getInstance():getVisibleOrigin()
  
	local cache = cc.SpriteFrameCache:getInstance()
    cache:addSpriteFrames("res/paizhi0.plist")
	cache:addSpriteFrames("res/number0.plist")
	-- run
	run()
end

function run()
    -- run
    local sceneGame = cc.Scene:create()
    sceneGame:addChild(createLayer())
	sceneGame:addChild(createMenu())
	
	if cc.Director:getInstance():getRunningScene() then
		cc.Director:getInstance():replaceScene(sceneGame)
	else
		cc.Director:getInstance():runWithScene(sceneGame)
	end
end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
