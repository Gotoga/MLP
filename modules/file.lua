file = {}

function file.Open(...)
	return fileOpen(...) 
end

function file.Write(strName, strContent)
	local hFile = fileCreate(strName)
	if hFile then
		fileWrite(hFile, strContent) 
		fileClose(hFile) 
	end
end

function file.Read(strName)
	local hFile = fileOpen(strName)             
	if hFile then                                 
		local buffer
		while not fileIsEOF(hFile) do         
			buffer = fileRead(hFile, 500)
			return buffer
		end
		fileClose(hFile)
	end
end

function file.Exists(strName)
	local exists = fileExists(strName)
	return exists
end

function file.Size(strName)
	local hFile = fileOpen(strName)
	return fileGetSize(hFile)
end

function file.Delete(strName)
	local hFile = fileOpen(strName)
	if hFile then
		fileDelete(hFile)
	end
end