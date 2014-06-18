player = {}

local META = Object.Create()

function META:Nick()
	return getPlayerName(self.__object)
end

META.GetName = META.Nick
META.Name	= META.Nick

function META:__tostring()
	return string.format("player[%s][%i]", self:GetName(), self:GetID())
end

function META:GetMoney()
	return getPlayerMoney(self.__object)
end

function META:SetMoney(numMoney)
	return setPlayerMoney(self.__object, numMoney)
end

function META:GiveMoney(numMoney)
	return givePlayerMoney(self.__object, numMoney)
end

function META:TakeMoney(numMoney)
	return takePlayerMoney(self.__object, numMoney)
end

function META:GetVersion()
	return getPlayerVersion(self.__object)
end

function META:Ping()
	return getPlayerPing(self.__object)
end

function META:GetWantedLevel()
	return getPlayerWantedLevel(self.__object)
end

function META:GetAFKTime()
	return getPlayerIdleTime(self.__object)
end

function player.Create(realPlayer)
	local playerNew = setmetatable({}, META)
	playerNew.__object = realPlayer
	return playerNew
end

function player.GetAll()
	local tbl = {}
	for k,v in pairs(getElementsByType("player")) do
		tbl[k] = player.Create(v)
		tbl[k].__id = k
	end
	return tbl
end

function player.GetByID(numID)
	return player.GetAll()[numID]
end

if CLIENT then
	function LocalPlayer()
		return player.GetByID(1) -- Need fix
	end
end