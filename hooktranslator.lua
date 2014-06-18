local hooks = {}

hooks["onClientPreRender"] = "PrePaint"
hooks["onClientResourceStart"] = "ResourceStart"
hooks["onClientResourceStop"] = "ResourceEnd"

hooks["onClientPlayerVoiceStart"] = "PlayerStartVoice"
hooks["onClientPlayerVoiceStop"] = "PlayerEndVoice"

hooks["onPlayerVoiceStart"] = "PlayerStartVoice"
hooks["onPlayerVoiceStop"] = "PlayerEndVoice"

hooks["onPlayerQuit"] = "PlayerDisconnected"
hooks["onClientPlayerQuit"] = "PlayerDisconnected"

hooks["onPlayerJoin"] = "PlayerConnected"
hooks["onClientPlayerJoin"] = "PlayerConnected"

hooks["onPlayerSpawn"] = "PlayerSpawn"
hooks["onClientPlayerSpawn"] = "PlayerSpawn"

hooks["onClientPlayerDamage"] = "EntityTakeDamage"
hooks["onPlayerDamage"] = "EntityTakeDamage"

addEventHandler("onClientResourceStart", resourceRoot, function()
	for k,v in pairs(hooks) do
		addEventHandler(k, root, function()
			hook.Run(v)
		end)
	end
	addEventHandler("onClientRender", root, function()
		hook.Run("HUDPaint")
		surface._DrawColor = Color(255, 255, 255)
		surface._TextColor = Color(255, 255, 255)
		surface._TextFont = "pricedown"
		surface._Texture = nil
		surface._TextPos = {x = 0, y = 0}
		hook.Run("HUDPostPaint")
	end)
end)