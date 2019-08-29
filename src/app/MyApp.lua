
require("config")
require("cocos.init")
require("framework.init")
require("app.data.ObjectModel")
require("app.data.ObjectPool")
require("app.enum.BulletEnum")
require("app.enum.MonsterEnum")
require("app.objects.Hero")
require("app.objects.Monster")
require("app.objects.Bullet")
require("app.objects.BoomBullet")
require("app.layers.BackgroundLayer")
require("app.layers.MonsterLayer")
require("app.layers.BulletLayer")
require("app.layers.HeroLayer")

local AppBase = require("framework.AppBase")
local MyApp = class("MyApp", AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()

    audio.loadFile("res/sound/beep.ogg",function()
        print("load beep.ogg succeed!")
       
    end)

    audio.loadFile("res/sound/boom.ogg",function()
        print("load boom.ogg succeed!")
    end)

    audio.loadFile("res/sound/bk.ogg",function()
        audio.playBGM("res/sound/bk.ogg", true)
    end)



    cc.FileUtils:getInstance():addSearchPath("res/")
    self:enterScene("MainScene")
end

return MyApp
