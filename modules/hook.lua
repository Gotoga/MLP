hook = {}
local hooks = {}

function hook.Add(strType, strName, funcCallback)
	if not hooks[strType] then
		hooks[strType] = {}
	end

	hooks[strType][strName] = funcCallback
end

function hook.Remove(strType, strName)
	if hooks[strType] and hooks[strType][strName] then
		hooks[strType][strName] = nil
	end
end

function hook.GetTable()
	return hooks
end

function hook.Call(strType, ...)
	if hooks[strType] then
		for k, fn in pairs(hooks[strType]) do
			local t = getTickCount()
			
			local ret = {fn(...)}

			if (getTickCount() - t) > 0.2 then
				print("Warning! Hook", strType, k, " has been running for " .. (getTickCount() - t) .. " seconds")
			end

			if #ret>0 then
				return unpack(ret)
			end
		end
	end
end

hook.Run = hook.Call

function hook.Panic()
	for global,v in pairs(hook.GetTable()) do
		for _, name in pairs(v) do
			hook.Remove(global, name)
		end
	end
end