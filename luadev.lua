luadev = {}

local rootElement = getRootElement()

function luadev.RunString(commandstring, outputTo, source)
	if source then
		sourceName = getPlayerName(source)
	else
		sourceName = "Console"
	end
	outputChatBox(sourceName.." executed command: "..commandstring, outputTo, true)
	local notReturned

	local commandFunction,errorMsg = loadstring("return "..commandstring)
	if errorMsg then

		notReturned = true
		commandFunction, errorMsg = loadstring(commandstring)
	end
	if errorMsg then
		outputChatBox("Error: "..errorMsg, outputTo)
		return
	end

	results = { pcall(commandFunction) }
	if not results[1] then
		outputChatBox("Error: "..results[2], outputTo)
		return
	end
	if not notReturned then
		local resultsString = ""
		local first = true
		for i = 2, #results do
			if first then
				first = false
			else
				resultsString = resultsString..", "
			end
			local resultType = type(results[i])
			if isElement(results[i]) then
				resultType = "element:"..getElementType(results[i])
			end
			resultsString = resultsString..tostring(results[i]).." ["..resultType.."]"
		end
	elseif not errorMsg then
		outputChatBox("Command executed!", outputTo)
	end
end

function luadev.RunOnServer(player, command, ...)
	local commandstring = table.concat({...}, " ")
	return luadev.RunString(commandstring, rootElement, player)
end

function luadev.RunOnClients(player, command, ...)
	local commandstring = table.concat({...}, " ")
	if player then
		return triggerClientEvent(player, "doCrun", rootElement, commandstring)
	else
		return luadev.RunString(commandstring, false, false)
	end
end

addCommandHandler("l", luadev.RunOnServer)
addCommandHandler("lua_run", luadev.RunOnServer)

addCommandHandler("lc", luadev.RunOnClients)
addCommandHandler("lua_run_cl", luadev.RunOnClients)