pickup = {}

local META = {}

META.__index = META
META.Pos  = {x = 0, y = 0, z = 0}

function META:Spawn()
	local x, y, z = self.Pos.x, self.Pos.y, self.Pos.z
	self.Pickup = createPickup(x, y, z, self.Type)
end

function META:SetPos(posPosition)
	self.Pos = posPosition
end

function META:GetPos()
	return self.Pos
end

function META:SetType(numType)
	self.Type = numType
	return self:IsValid() and setPickupType(numType)
end

function META:GetType()
	return self.Type
end

function META:IsValid()
	return self.Pickup and isPickupSpawned(self.Pickup)
end

function pickup.Create(varType)
	local pickupNew = setmetatable({}, META)
	pickupNew.Type = varType or 0
	return pickupNew
end

--local test = pickup.Create(0)
--test:SetPos(player.GetByID(1))
--test:Spawn()

