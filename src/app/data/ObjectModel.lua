--
-- Author: Rich
-- Date: 2015-04-16 10:22:51
--
ObjectModel = class("ObjectModel")

function ObjectModel:getMonsterData()
	return {
	hp = 1,
	spend = 0.01,
	state = nil,
	skin = "#enemy1.png",
	normalSkin = nil,
	deadSkin = "enemy1_down%d.png",
	type = MonsterEnum.Small_Monster
	}
end

function ObjectModel:getQuickMonsterData()
	return {
	hp = 1,
	spend = 0.005,
	state = nil,
	skin = "#enemy1.png",
	normalSkin = nil,
	deadSkin = "enemy1_down%d.png",
	type = MonsterEnum.Small_Monster
	}
end

function ObjectModel:getMonsterBigData()
	return {
	hp = 5,
	spend = 0.01,
	state = nil,
	skin = "#enemy2.png",
	normalSkin = nil,
	deadSkin = "enemy2_down%d.png",
	type = MonsterEnum.Big_Monster
	}
end

--往下跌落的炸弹伞包
function ObjectModel:getBoomMosterData()
	return {
		hp = 1,
		spend = 0.005,
		state = nil,
		skin = "#ufo2.png",
		normalSkin = nil,
		deadSkin = "enemy1_down%d.png",
		type = MonsterEnum.Boom_Monster
		}

end

function ObjectModel:getMonsterBossData()
	return {
	hp = 10,
	spend = 0.02,
	state = nil,
	skin = "#enemy3_n1.png",
	normalSkin = "enemy3_n%d.png",
	deadSkin = "enemy3_down%d.png",
	type = MonsterEnum.Boss_Monster
	}
end

function ObjectModel:getHeroData()
	return {
	power = 1,
	hp = 5,
	state = nil,
	skin = "#hero1.png",
	normalSkin = "hero%d.png",
	deadSkin = "hero_blowup_n%d.png"
	}
end