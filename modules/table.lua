function table.Inherit(t, base)

	for k, v in pairs(base) do 
		if t[k] == nil then	t[k] = v end
	end
	
	t["BaseClass"] = base
	
	return t

end

function table.Copy(t, lookup_table)
	if t == nil then return nil end
	
	local copy = {}
	setmetatable(copy, debug.getmetatable(t))
	for i,v in pairs(t) do
		if not istable(v) then
			copy[i] = v
		else
			lookup_table = lookup_table or {}
			lookup_table[t] = copy
			if lookup_table[v] then
				copy[i] = lookup_table[v]
			else
				copy[i] = table.Copy(v,lookup_table)
			end
		end
	end
	return copy
end

function table.Empty(tab)
	for k, v in pairs(tab) do
		tab[k] = nil
	end
end

function table.CopyFromTo(FROM, TO)
	table.Empty(TO)
	table.Merge(TO, FROM)
end

function table.Merge(dest, source)
	for k,v in pairs(source) do
	
		if (type(v) == "table" and type(dest[k]) == "table") then
			table.Merge(dest[k], v)
		else
			dest[k] = v
		end
	end
	return dest	
end

function table.HasValue(t, val)
	for k,v in pairs(t) do
		if v == val then return true end
	end
	return false
end

table.InTable = HasValue

function table.Add( dest, source )
	if type(source) ~= "table" then return dest end
	
	if type(dest) ~= "table" then dest = {} end

	for k,v in pairs(source) do
		table.insert( dest, v )
	end
	
	return dest
end

function table.SortDesc(Table)
	return table.sort(Table, function(a, b) return a > b end)
end

function table.SortByKey( Table, Desc )

	local temp = {}

	for k, v in pairs(Table) do table.insert(temp, k) end
	if Desc then
		table.sort(temp, function(a, b) return Table[a] < Table[b] end)
	else
		table.sort(temp, function(a, b) return Table[a] > Table[b] end)
	end

	return temp
end

function table.Count(t)
  local i = 0
  for k in pairs(t) do i = i + 1 end
  return i
end

function table.Random (t) 
	local rk = math.random(1, table.Count(t))
	local i = 1
	for k, v in pairs(t) do 
		if i == rk then return v, k end
		i = i + 1 
	end
end

function table.IsSequential(t)
	local i = 1
	for key, value in pairs (t) do
		if not tonumber(i) or key ~= i then return false end
		i = i + 1
	end
	return true
end

function table.Sanitise(t, done)
	local done = done or {}
	local tbl = {}

	for k, v in pairs(t) do
		if istable(v) and not done[v] then
			done[ v ] = true
			tbl[ k ] = table.Sanitise(v, done)
		else
			if type(v) == "Vector" then
				local x, y, z = v.x, v.y, v.z
				if y == 0 then y = nil end
				if z == 0 then z = nil end
				tbl[k] = {__type = "Vector", x = x, y = y, z = z}
			elseif type(v) == "Angle" then
				local p,y,r = v.pitch, v.yaw, v.roll
				if p == 0 then p = nil end
				if y == 0 then y = nil end
				if r == 0 then r = nil end
				tbl[k] = {__type = "Angle", p = p, y = y, r = r}
			elseif type(v) == "boolean" then			
				tbl[k] = {__type = "Bool", tostring(v)}
			else			
				tbl[k] = tostring(v)
			end		
		end				
	end	
	return tbl	
end

function table.DeSanitise(t, done)

	local done = done or {}
	local tbl = {}

	for k, v in pairs (t) do	
		if istable(v) and not done[v] then		
			done[v] = true
			if v.__type then			
				if v.__type == "Vector" then				
					tbl[k] = Vector(v.x, v.y, v.z)				
				elseif v.__type == "Angle" then				
					tbl[k] = Angle(v.p, v.y, v.r)					
				elseif v.__type == "Bool" then					
					tbl[k] = v[1] == "true"					
				end			
			else			
				tbl[k] = table.DeSanitise( v, done )				
			end			
		else		
			tbl[k] = v			
		end
	end
	return tbl	
end

function table.ForceInsert( t, v )

	if ( t == nil ) then t = {} end
	
	table.insert( t, v )
	
	return t
	
end


--[[---------------------------------------------------------
   Name: table.SortByMember( table )
   Desc: Sorts table by named member
-----------------------------------------------------------]]
function table.SortByMember( Table, MemberName, bAsc )

	local TableMemberSort = function( a, b, MemberName, bReverse ) 
	
		--
		-- All this error checking kind of sucks, but really is needed
		--
		if ( not istable(a) ) then return not bReverse end
		if ( not istable(b) ) then return bReverse end
		if ( not a[MemberName] ) then return not bReverse end
		if ( not b[MemberName] ) then return bReverse end

		if ( type( a[MemberName] ) == "string" ) then

			if ( bReverse ) then
				return a[MemberName]:lower() < b[MemberName]:lower()
			else
				return a[MemberName]:lower() > b[MemberName]:lower()
			end

		end
	
		if ( bReverse ) then
			return a[MemberName] < b[MemberName]
		else
			return a[MemberName] > b[MemberName]
		end
		
	end

	table.sort( Table, function(a, b) return TableMemberSort( a, b, MemberName, bAsc or false ) end )
	
end


--[[---------------------------------------------------------
   Name: table.LowerKeyNames( table )
   Desc: Lowercase the keynames of all tables
-----------------------------------------------------------]]
function table.LowerKeyNames( Table )

	local OutTable = {}

	for k, v in pairs( Table ) do
	
		-- Recurse
		if ( istable( v ) ) then
			v = table.LowerKeyNames( v )
		end
		
		OutTable[ k ] = v
		
		if ( isstring( k ) ) then
	
			OutTable[ k ]  = nil
			OutTable[ string.lower( k ) ] = v
		
		end		
	
	end
	
	return OutTable
	
end


--[[---------------------------------------------------------
   Name: table.LowerKeyNames( table )
   Desc: Lowercase the keynames of all tables
-----------------------------------------------------------]]
function table.CollapseKeyValue( Table )

	local OutTable = {}
	
	for k, v in pairs( Table ) do
	
		local Val = v.Value
	
		if ( istable( Val ) ) then
			Val = table.CollapseKeyValue( Val )
		end
		
		OutTable[ v.Key ] = Val
	
	end
	
	return OutTable

end

--[[---------------------------------------------------------
   Name: table.ClearKeys( table, bSaveKey )
   Desc: Clears the keys, converting to a numbered format
-----------------------------------------------------------]]
function table.ClearKeys( Table, bSaveKey )

	local OutTable = {}
	
	for k, v in pairs( Table ) do
		if ( bSaveKey ) then
			v.__key = k
		end
		table.insert( OutTable, v )	
	end
	
	return OutTable

end



local function fnPairsSorted( pTable, Index )

	if ( Index == nil ) then
	
		Index = 1
	
	else
	
		for k, v in pairs( pTable.__SortedIndex ) do
			if ( v == Index ) then
				Index = k + 1
				break
			end
		end
		
	end
	
	local Key = pTable.__SortedIndex[ Index ]
	if not Key then
		pTable.__SortedIndex = nil
		return
	end
	
	Index = Index + 1
	
	return Key, pTable[ Key ]

end

--[[---------------------------------------------------------
   A Pairs function

		Sorted by TABLE KEY
		
-----------------------------------------------------------]]
function SortedPairs( pTable, Desc )

	pTable = table.Copy( pTable )
	
	local SortedIndex = {}
	for k, v in pairs( pTable ) do
		table.insert( SortedIndex, k )
	end
	
	if ( Desc ) then
		table.sort( SortedIndex, function(a,b) return a>b end )
	else
		table.sort( SortedIndex )
	end
	pTable.__SortedIndex = SortedIndex

	return fnPairsSorted, pTable, nil
	
end

--[[---------------------------------------------------------
   A Pairs function

		Sorted by VALUE
		
-----------------------------------------------------------]]
function SortedPairsByValue( pTable, Desc )

	pTable = table.ClearKeys( pTable )
	
	if ( Desc ) then
		table.sort( pTable, function(a,b) return a>b end )
	else
		table.sort( pTable )
	end

	return ipairs( pTable )
	
end

--[[---------------------------------------------------------
   A Pairs function

		Sorted by Member Value (All table entries must be a table!)
		
-----------------------------------------------------------]]
function SortedPairsByMemberValue( pTable, pValueName, Desc )

	Desc = Desc or false
	
	local pSortedTable = table.ClearKeys( pTable, true )
	
	table.SortByMember( pSortedTable, pValueName, not Desc )
	
	local SortedIndex = {}
	for k, v in ipairs( pSortedTable ) do
		table.insert( SortedIndex, v.__key )
	end
	
	pTable.__SortedIndex = SortedIndex

	return fnPairsSorted, pTable, nil
	
end

--[[---------------------------------------------------------
   A Pairs function		
-----------------------------------------------------------]]
function RandomPairs( pTable, Desc )

	local Count = table.Count( pTable )
	pTable = table.Copy( pTable )
	
	local SortedIndex = {}
	for k, v in pairs( pTable ) do
		table.insert( SortedIndex, { key = k, val = math.random( 1, 1000 ) } )
	end
	
	if ( Desc ) then
		table.sort( SortedIndex, function(a,b) return a.val>b.val end )
	else
		table.sort( SortedIndex, function(a,b) return a.val<b.val end )
	end
	
	for k, v in pairs( SortedIndex ) do
		SortedIndex[ k ] = v.key;
	end
	
	pTable.__SortedIndex = SortedIndex

	return fnPairsSorted, pTable, nil
	
end

--[[---------------------------------------------------------
	GetFirstKey
-----------------------------------------------------------]]
function table.GetFirstKey( t )

	local k, v = next( t )
	return k
	
end

function table.GetFirstValue( t )

	local k, v = next( t )
	return v
	
end

function table.GetLastKey( t )

	local k, v = next( t, table.Count(t) - 1 )
	return k
	
end

function table.GetLastValue( t )

	local k, v = next( t, table.Count(t) - 1 )
	return v
	
end

function table.FindNext( tab, val )
	
	local bfound = false
	for k, v in pairs( tab ) do
		if ( bfound ) then return v end
		if ( val == v ) then bfound = true end
	end
	
	return table.GetFirstValue( tab )	
	
end

function table.FindPrev( tab, val )
	
	local last = table.GetLastValue( tab )
	for k, v in pairs( tab ) do
		if ( val == v ) then return last end
		last = v
	end
	
	return last
	
end

function table.GetWinningKey( tab )
	
	local highest = -10000
	local winner = nil
	
	for k, v in pairs( tab ) do
		if ( v > highest ) then 
			winner = k
			highest = v
		end
	end
	
	return winner
	
end

function table.KeyFromValue( tbl, val )
	for key, value in pairs( tbl ) do
		if ( value == val ) then return key end
	end
end

function table.RemoveByValue( tbl, val )

	local key = table.KeyFromValue( tbl, val )
	if ( not key ) then return false end
	
	table.remove( tbl, key )
	return key;
	
end

function table.KeysFromValue( tbl, val )
	local res = {}
	for key, value in pairs( tbl ) do
		if ( value == val ) then table.insert( res, key ) end
	end
	return res
end

function table.Reverse( tbl )

	 local len = #tbl;
	 local ret = {};
	 
	 for i = len, 1, -1 do
		  ret[len-i+1] = tbl[i];
	 end

	 return ret;
  
end

function table.ForEach( tab, funcname )

	for k, v in pairs( tab ) do
		funcname( k, v )
	end

end

function table.GetKeys( tab )
	
	local keys = {}
	local id = 1

	for k, v in pairs( tab ) do
		keys[ id ] = k
		id = id + 1
	end
	
	return keys

end
