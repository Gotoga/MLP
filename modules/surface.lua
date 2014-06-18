surface = {}

surface._DrawColor = Color(255, 255, 255)
surface._TextColor = Color(255, 255, 255)

surface._TextFont = "pricedown"

surface._Texture = nil

surface._TextPos = {x = 0, y = 0}

surface.CreateFont = dxCreateFont

function surface.SetDrawColor(tblColor)
	surface._DrawColor = tblColor
end

function surface.SetTextColor(tblColor)
	surface._TextColor = tblColor
end

function surface.SetFont(strFont)
	surface._TextFont = strFont
end

function surface.GetTextureID(strPath)
	return dxCreateTexture(strPath)
end

function surface.SetTexture(texTexture) -- Not ID
	surface._Texture = texTexture
end

function surface.SetTextPos(numX, numY)
	surface._TextPos = {x = numX, y = numY}
end

function surface.DrawText(strString, numScale)
	local C = surface._TextColor
	local P = surface._TextPos
	dxDrawText(strString, P.x, P.y, ScrW(), ScrH(), tocolor(C.r, C.g, C.b, C.a), numScale, surface._TextFont)
end

function surface.DrawRect(numX, numY, numW, numH)
	local C = surface._DrawColor
	dxDrawRectangle(numX, numY, numW, numH, tocolor( C.r, C.g, C.b, C.a))
end

function surface.DrawTexturedRect(numX, numY, numW, numH)
	local C = surface._DrawColor
	local T = surface._Texture
	
	dxDrawImage(numX, numY, numW, numH, T, nil, nil, nil, tocolor( C.r, C.g, C.b, C.a))
end

function surface.DrawTexturedRectRotated(numX, numY, numW, numH, numAngle)
	local C = surface._DrawColor
	local T = surface._Texture
	
	dxDrawImage(numX, numY, numW, numH, T, numAngle, nil, nil, tocolor( C.r, C.g, C.b, C.a))
end

function surface.DrawLine(numX, numY, numX2, numY2, numWidth)
	local C = surface._DrawColor
	dxDrawLine(numX, numY, numX2, numY2, tocolor( C.r, C.g, C.b, C.a), numWidth or 1 )
end

function surface.ColorToDefault()
	surface._DrawColor = Color(255, 255, 255)
end

function surface.GetTextSize(strText, numFontSize)
	return dxGetTextWidth(strText, numFontSize, surface._TextFont), dxGetFontHeight(numFontSize, surface._TextFont)
end

--- Full Example --- 
--[[
--local texture = surface.GetTextureID("ProjectLogo.png")

hook.Add("HUDPaint", "DEBUG", function()
	surface.SetDrawColor(Color(0, 255, 255))
	surface.DrawRect(0, 0, 200, 200)
	surface.SetTextColor(Color(255, 0, 255))
	surface.DrawText("THIS IS TEST", 2)
	
	--surface.SetTexture(texture)
	--surface.DrawTexturedRect(200, 200, 100, 100)
	
	surface.DrawLine(0, 0, ScrW(), ScrH())
end)]]
