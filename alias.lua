gui = {}
game = {}

GetHostName = getServerName
Msg			= print
MsgN 		= print
Error 		= error

function FrameTime()
	return 20 -- Epic
end

game.GetMap = getMapName

gui.ConsoleActive = isConsoleActive

if CLIENT then
	function Msg(strMsg)
		outputDebugString(tostring(strMsg), 0)
	end
end

function ErrorNoHalt(strMsg)
	outputDebugString(tostring(strMsg), 2)
end

local tonumber 	= tonumber
local min		= math.min
local type		= type

local function hex_to_rgb(hex)
    hex = hex:gsub("#","")
    return { 
		r = tonumber("0x"..hex:sub(1,2)),
		g = tonumber("0x"..hex:sub(3,4)),
		b = tonumber("0x"..hex:sub(5,6)),
		a = tonumber("0x"..hex:sub(7,8)) or 0xFF
	}
end

function Color(r, g, b, a)
	
	if type(r) == "string" then
	
		return hex_to_rgb(r)
	
	else
	
		a = a or 0xFF
		return {
			r =  min( tonumber(r), 0xFF ),
			g =  min( tonumber(g), 0xFF ),
			b =  min( tonumber(b), 0xFF ),
			a =  min( tonumber(a), 0xFF )
		}
	
	end
	
end

function Vector(x, y, z) -- ToDo: Metatables
	return {
		x =  x or 0,
		y =  y or 0,
		z =  z or 0
	}	
end

function Angle(p, y, r)
	return {
		p =  p or 0,
		y =  y or 0,
		r =  r or 0
	}	
end

function tobool(anyVal)
	if anyVal == nil or anyVal == false or anyVal == 0 or anyVal == "0" or anyVal == "false" then return false end
	return true
end

function MsgC(tblColor, strMsg)
	outputDebugString(strMsg, 0, tblColor.r, tblColor.g, tblColor.b)
end

function ScrW()
	local w, h = guiGetScreenSize()
	return w
end

function ScrH()
	local w, h = guiGetScreenSize()
	return h
end

function PrintTable(tblTable, numIndent)
	done = done or {}
	numIndent = numIndent or 0
	
	for key, value in pairs(tblTable) do
		Msg(string.rep("\t", numIndent))

		if type(value) == "table" and not done[value] then

			done[value] = true
			Msg(tostring(key)..":".."\n")
			PrintTable(value, numIndent + 2, done)

		else

			Msg(tostring(key).."\t = \t"..tostring(value))

		end
	end
end

VERSION = getVersion().mta

util = {}
base64 = {}

base64.Encode = base64Encode
base64.Decode = base64Decode

hook.Add("FixesLoaded", "Print", function()
	if SERVER then
		Msg("[Fixes] G!ua Standalone port loaded")
	end
end)

-- Concommand module

concommand = {}

concommand.Add = addCommandHandler 
concommand.Remove = removeCommandHandler 


hook.Call("FixesLoaded")