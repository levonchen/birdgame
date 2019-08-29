--
-- Author: Rich
-- Date: 2015-04-22 22:13:51
--
ObjectPool = {}

function ObjectPool:new(  _type, max )
	max = max or 20

	local _objectPool = {}
	_objectPool._pool = {}

	function _objectPool:pushPool( target )
		if( max > #self._pool ) then
			table.insert(self._pool,target)
			target:resert()
			target:setVisible(false)
		else
			target:removeFromParent()
		end
		
	end
	function _objectPool:getTargetForPool()
		local len = #self._pool
		if( len <= 0 )then
			return _type.new()
		end
		local target = table.remove(self._pool)
		target:setVisible(true)
		return target
	end
	return _objectPool
end
