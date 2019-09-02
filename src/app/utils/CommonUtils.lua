
--local luaj

--if device.platform == "android" then
--    luaj = require("framework.platform.luaj")
--end

local CommonUtils = class("CommonUtils")

function CommonUtils.setupBackKeyForAndroid()

    local function onKeyReleased(keyCode,event)

        if keyCode == cc.KeyCode.KEY_ESCAPE then
            --show exit prompt first
            --android
            local function onExitCallback(event)
                if event ~= "ok" then return end

                --self:removeSelf()
                cc.Director:getInstance():endToLua()
            end
        
            local javaClassName = "org/cocos2dx/lua/AppActivity"
            local javaMethodName = "showExitDialog"
            local javaParams = {"", "您确定要退出游戏吗?", "确定", "取消",  onExitCallback}
            local javaMethodSig = nil
            luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        
        --[[
            local dialog = ExitDialogLayer:create():init()
            dialog:setPosition(display.center)
            local scene = display.getRunningScene()
            CommonUtils.showDialog(dialog, scene, false) --
            --]]
            --dialog:move(display.center):addTo(scene, LayerSettings.exitDialogZOrder)
        end
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyReleased,cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:removeEventListenersForType(cc.EVENT_KEYBOARD)
    eventDispatcher:addEventListenerWithFixedPriority(listener, 2)

end

return CommonUtils