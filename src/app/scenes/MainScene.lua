
local CommonUtils = require("app.utils.CommonUtils")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)



function MainScene:ctor()
    display.newTTFLabel({text = "Hello, World", size = 64})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)
    
    self.start = false;
    self.background = nil;
    self.startButton = nil;
    self.boomLabel = 0
    self.score = 0

    self:initSrc()
    self:initView()

    local csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("MainScene.csb")
    csbNode:addTo(self)

    self:initEvent(csbNode)
end

function MainScene:initSrc()
    display.addSpriteFrames("shoot.plist", "shoot.png")
    display.addSpriteFrames("BM.plist","BM.png")
    display.addSpriteFrames("shoot_background.plist","shoot_background.png")
    display.addSpriteFrames("herolist.plist","herolist.png")

    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.updateMain))
	self:scheduleUpdate()
end

function MainScene:updateMain( dt )

    --print("update")

    if(self.start == false) then
        return
    end

	self:updateCollision()
	HeroLayer:getInstance():updateLayer( dt )
    MonsterLayer:getInstance():updateLayer( dt )
    
    self.background:updateBackground(dt)

    self.ScoreLabel:setString(self.score)
end

function MainScene:initView()
	math.newrandomseed()
    self.background = BackgroundLayer.new()
    self.background:addTo(self)
	BulletLayer:getInstance():addTo(self)
	MonsterLayer:getInstance():addTo(self)
	HeroLayer:getInstance():addTo(self)
	HeroLayer:getInstance():createHero()
	
	local boom = display.newSprite("#bomb.png", display.left+50, 30):addTo(self)
	boom:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.touchBoom))
    boom:setTouchEnabled(true)
    
    self.boomLabel = display.newTTFLabel({text = "0", size = 32})
        :align(display.CENTER, display.left+50, 30)
        :addTo(self)

    --设置boom 的label
    HeroLayer:getInstance():setBoomCountLabel(self.boomLabel)

	local buttle = display.newSprite("#ufo1.png", display.left+130, 50):addTo(self)
	buttle:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.touchButtle))
    buttle:setTouchEnabled(true)
    
    self.ScoreLabel = display.newTTFLabel({text = "0", size = 32})
    :align(display.CENTER, display.left+180, 30)
    :addTo(self)
end


function MainScene:touchBoom( event )
	if( event.name == "began" ) then
		return true
	end

    if( event.name == "ended" ) then
    
        if (HeroLayer:getInstance():getHero():canUseBoom()) then

            HeroLayer:getInstance():boomattack()
            audio.playEffect("res/sound/boom.ogg", false)
            HeroLayer:getInstance():getHero():consumeBoom()
        end
	end
end

function MainScene:touchButtle( event )
	if( event.name == "began" ) then
		return true
	end
	if( event.name == "ended" ) then
		HeroLayer:getInstance():addHeroButtle()
	end
end

function MainScene:initEvent(uiRoot)
    local button = uiRoot:getChildByName("Button_1")

    self.startButton = button
    if button then
        button:addTouchEventListener(function (event,type)

            if type == ccui.TouchEventType.began then
                print("点击按钮开始")
                print(cc.PACKAGE_NAME .. ".scheduler")

                
            end

            if type == ccui.TouchEventType.ended then 
                print("点击按钮结束")

                self.start = not self.start

                if(self.start) then
                    button:setVisible(false)

                    if(not HeroLayer.getInstance():isHeroShow()) then
                        HeroLayer.getInstance():resetHero()
                    end

                    audio.playEffect("res/sound/beep.ogg", true)

                    self.score = 0
                end



                print(self.start)

                -- local scene = require("app/scenes/HomeScene.lua")
                -- local gameScene = scene:create()
                
                -- if cc.Director:getInstance():getRunningScene() then
                --     cc.Director:getInstance():replaceScene(gameScene)
                -- else
                --     cc.Director:getInstance():runWithScene(gameScene)
                -- end
            end
        end)
    end
end

function MainScene:HeroDead()
    self.start = false                   
    MonsterLayer:getInstance():clearLayer()
    --BulletLayer:getInstance():clearLayer()
    self.startButton:setVisible(true)
    audio.stopEffect()
end


function MainScene:updateCollision()
	local list = MonsterLayer:getInstance().monsterList
	for key,value in ipairs(list) do
		if( key == nil ) then break end
		if( value == nil ) then print("updateMain value is nil") break end
		if( value:isCanConllision() == false ) then break end

		if( BulletLayer:getInstance():isBoomCollision( value,BulletEnum.HERO_BOOM_BULLET ) == false ) then
			local isDead = false
			if( BulletLayer:getInstance():isCollision( value,BulletEnum.HERO_BULLET ) ) then
                isDead = value:setHurtHp( HeroLayer:getInstance():getPower() )                
            
                if(isDead) then
                    local monType = value:getMonsterType() 
                    --print("Monster Type:" .. monType)
                    if  ( MonsterEnum.Boom_Monster == monType ) then
                        print("add boom count")
                        HeroLayer:getInstance():getHero():acquireBoom()
                    end

                    self.score =  self.score + 1
                end

            end
            
            if( not(isDead) and HeroLayer:getInstance():isCollision( value ) ) then
                local heroDead = HeroLayer:getInstance():setHurtHp(1) 

                if( heroDead ) then                    
                    self:HeroDead()
                    break                    
                end
			end
		else
            value:setState("Dead")

            --local monType = value:getMonsterType() 
            --print("Monster Type:" .. monType)
            --if  ( MonsterEnum.Boom_Monster == monType ) then
            --    print("add boom count")
            --    HeroLayer:getInstance():getHero():acquireBoom()
            --end
		end

		
	end

	if( BulletLayer:getInstance():isCollision( HeroLayer:getInstance():getHero(),BulletEnum.MONSTER_BULLET ) ) then
        local heroDead = HeroLayer:getInstance():setHurtHp(1)
        if( heroDead ) then
            self:HeroDead()
        end
	end
end

function MainScene:onEnter()
      --只需要设置一次，不用每个scene都设置
      CommonUtils.setupBackKeyForAndroid()
end

function MainScene:onExit()

end

return MainScene
