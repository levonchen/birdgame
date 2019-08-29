

local HomeScene = class("HomeScene",function()
    return cc.Scene:create()
end)

function HomeScene:ctor()
    self.winsize = cc.Director:getInstance():getWinSize()
    local csbNode = cc.CSLoader:createNode("HomeScene.csb")
    csbNode:setAnchorPoint(0.5,0.5)
    csbNode:setPosition(self.winsize.width/2,self.winsize.height/2)
    self:addChild(csbNode)
end

function HomeScene:create()
    local scene = HomeScene.new()
    scene:addChild(scene:init())
    return scene
end

function HomeScene:init()
    local layer = cc.LayerColor:create()

    local label=cc.Label:createWithSystemFont("PlaneGame","宋体",45)
    label:setString("PlaneGame")
    label:setScale(3)
    label:setPosition(self.winsize.width/2,self.winsize.height-100)
    layer:addChild(label)
    return layer
end


return HomeScene