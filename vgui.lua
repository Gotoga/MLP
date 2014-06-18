vgui = {}

vgui.PanelFactory = {}

local META = {}

META.__index = META
META.ClassName = "Unknown Class"

function META:__tostring()
	return "Panel"
end

function META:Init()
	
end

function META:Paint()
	
end

function META:SetSize(numW, numH)
	guiSetSize(self.Panel, numW, numH, true)
end

function META:GetSize()
	return guiGetSize(self.Panel, true)
end

function META:SetPos(numX, numY)
	guiSetPosition(self.Panel, numX, numY, true)
end

function META:GetPos()
	return guiGetPosition(self.Panel, true)
end

function META:GetVisible()
	return guiGetVisible(self.Panel)
end

function META:SetVisible(boolVisible)
	return guiSetVisible(self.Panel, boolVisible)
end

function vgui.Create(strName, panelParent)
	if vgui.PanelFactory[strName] then
		local panelNew = setmetatable({}, META)
		panelNew.Panel = guiCreateWindow(0, 0, 0.5, 0.4, "Information", true)
		
		return panelNew
	end
end

function vgui.Register(strName, tblPanel, strBase)
	PANEL = nil

	tblPanel.Base = strBase or "Panel"	
	
	vgui.PanelFactory[strName] = tblPanel

	return tblPanel
end

vgui.Register("Frame", {"228"}, nil)


--local window = vgui.Create("Frame")
--window:SetPos(0.5, 0.5)
--window:SetSize(0.05, 0.05)


--[[

local myWindow = guiCreateWindow ( 0, 0, 0.5, 0.4, "Information", true )
local tabPanel = guiCreateTabPanel ( 0, 0.1, 1, 1, true, myWindow )
local tabMap = guiCreateTab( "Map Information", tabPanel )
local tabHelp = guiCreateTab( "Help", tabPanel )

guiCreateLabel(0.02,0.04,0.94,0.2,"This is information about the current map",true,tabMap)
guiCreateLabel(0.02,0.04,0.94,0.92,"This is help text.",true,tabHelp)]]