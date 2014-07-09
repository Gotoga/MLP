function isAdmin(plyPlayer) -- ToDo: Metatables
	local strAccName = getAccountName(getPlayerAccount(plyPlayer))
	return isObjectInACLGroup("user."..strAccName, aclGetGroup("Admin"))
end

function getPlayerColor(plyPlayer)
	if isAdmin(plyPlayer) then
		return 147, 63, 147
	end
	return 68, 112, 146
end