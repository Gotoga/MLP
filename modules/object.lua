Object = {}

local META = {}

META.__index = META

META.__object = nil

function META:GetID()
	return self.__id
end

function META:GetPos()
	return Vector(getElementPosition(self.__object))
end

function META:SetPos(posPosition)
	local x, y, z = posPosition.x, posPosition.y, posPosition.z
	setElementPosition(self.__object, x, y, z)
end

function META:Health()
	return getElementHealth(self.__object)
end

function META:SetHealth(numHealth)
	setElementHealth(self.__object, numHealth)
end

function META:Remove()
	destroyElement(self.__object)
end

function META:GetAngles()
	return Angle(getElementRotation(self.__object))
end

function META:SetAngles(angRotation)
	local p, y, r = angRotation.p, angRotation.y, angRotation.r
	setElementRotation(self.__object, p, y, r)
end

function Object.Create()
	return META
end