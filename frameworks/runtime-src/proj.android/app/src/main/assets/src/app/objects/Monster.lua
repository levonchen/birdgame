--
-- Author: Rich
-- Date: 2015-04-01 16:30:21
--
Monster = class( "Monster",function ()
	return display.newNode()
end )

function Monster:ctor()
	self.move = nil
	self.tint = nil
end

function Monster:initView( data )
	self.data = data
	self.isAttack = false;
	self._time = 0
	self._type = data.type
	self.sprite = display.newSprite(self.data.skin):addTo(self)
	self:setState( "Normal" )
	local size = self.sprite:getContentSize();
	self:setContentSize( size )
end

function Monster:getMonsterType()
	return self._type
end

function Monster:onEnter()
	-- body
end

function Monster:onExit()
	-- body
end

function Monster:setHurtHp( value )
	if  not(self.tint) then
		local x = cc.TintBy:create(0.2, 0, -1, -1)

	
		
		self.tint = transition.execute(self.sprite,cc.Sequence:create({ x,x:reverse()}),{onComplete=function (target)
			self.tint = nil
		end})
	end
	local hp = self.data.hp - value
	if( hp <= 0 ) then 
		hp = 0
		self:setState( "Dead" )
		return true
	end
	self.data.hp = hp
	return false
end

function Monster:resert()
	self:stopAllActions()
	self:removeAllChildren()
	self:ctor()
end

function Monster:isCanConllision()
	return self.data.state == "Normal"
end

function Monster:setState( state )
	if self.sprite == nil then error("sprite is nil,by remove or not init!",2) end
	self.data.state = state
	if state == "Normal" then
		if( self.data.normalSkin )then
			transition.stopTarget(self.sprite)
			transition.playAnimationForever(self.sprite,display.newAnimation(display.newFrames(self.data.normalSkin,1,2), 0.1))
		end
	elseif state == "Dead" then
		transition.stopTarget(self.sprite)
		transition.removeAction(self.move)
		transition.playAnimationOnce(self.sprite,display.newAnimation(
			display.newFrames(self.data.deadSkin,1,4), 0.15), false, self.deadComplete )
	end
end

function Monster:setTargetPoint( point )

	local selfp = cc.p( self:getPositionX(),self:getPositionY() )
	local distance = cc.pGetDistance( selfp, point )
	local time = distance*self.data.spend
	self.move = transition.moveTo(self, { x= point.x, y=point.y,time=time,onComplete= function ( target )
			MonsterLayer:getInstance():popMonsterList( target )
		end })
end

function Monster:updateAttack( dt )

	if( self.data.state ~= "Normal" or self.isAttack ~= true )then return end

	self._time = self._time + dt
	if( self._time > 2 ) then
		self._time = 0
		BulletLayer:getInstance():createBullet( BulletEnum.MONSTER_BULLET,cc.p( self:getPositionX(),
				self:getPositionY()- self:getContentSize().height/2),
				 false)
	end
end

function Monster:deadComplete()
	MonsterLayer:getInstance():popMonsterList( self:getParent() )
end

function Monster:startRotation()
	transition.execute(self.sprite, cca.repeatForever( cc.Sequence:create({ cc.ScaleBy:create(1,-1,1),cc.ScaleBy:create(1,-1,1)})))
end