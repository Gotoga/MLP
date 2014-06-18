setFarClipDistance(5000)
setCloudsEnabled(false)

map = {}

function map.Create(strPath)
	local xmlMap = xmlLoadFile(strPath)
	local numObjectSumm = #xmlNodeGetChildren(xmlMap)
	
	if not xmlMap then
		Error("Missing Map!")
		return false
	end
	
	for i = 0, numObjectSumm do
		local nodeObject = xmlFindChild(xmlMap, "object", i)
	
		if nodeObject then
		
			local tblArgs = xmlNodeGetAttributes(nodeObject)
			
			createObject(
				tblArgs.model,
				tblArgs.posX,
				tblArgs.posY,
				tblArgs.posZ,
				tblArgs.rotX,
				tblArgs.rotY,
				tblArgs.rotZ,
			true) -- LOD Creation
			
		end
	end

	hook.Run("PostMapLoad")
	
	xmlUnloadFile(xmlMap)
end

map.Create("maps/testmap.map")