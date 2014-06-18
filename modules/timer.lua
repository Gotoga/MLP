timer = {}

function timer.Create(strName, numInterval, numExecute, funcCallback)
	setTimer(funcCallback, numInterval * 50, numExecute, strName)
end

function timer.Destroy(strName)
	timerTimers = getTimers (6000000)
	for k, v in ipairs(timerTimers) do
		-- ToDo: Destroy
	end
end

function timer.Simple(numInterval, funcCallback)
	timer.Create(table.concat(getRealTime()), numInterval, 1, funcCallback)
end