RevivalCore = RevivalCore or {}
RevivalCore["SQL"] = {}
function SaveCharacter(source, identifier, cid, position, needs)
	exports['revival_database']:execute('UPDATE characters SET position = @position WHERE identifier = @identifier AND cid = @cid', {
		['@identifier'] = identifier,
		['@cid'] = cid,
		['@position'] = json.encode(position)
	})

	exports['revival_database']:execute('UPDATE characters SET metaData = @dickhead WHERE identifier = @identifier AND cid = @cid', {
		['@identifier'] = identifier,
		['@cid'] = cid,
		['@dickhead'] = json.encode(needs)
	})


	print('[^4revival-base^0] '..GetPlayerName(source)..' was saved successfully!')
end

function Await(pPromise)
    return Citizen.Await(pPromise)
end

RevivalCore["SQL"]["execute"] = function(query,param)
    local par
    if param == nil then
        par = {}
    else
        par = param
    end
    local psql = promise.new()
    exports["revival_database"]:execute(query,par,function(result)
        psql:resolve(result)
    end)
    return Await(psql)
end

RevivalCore["SQL"]["execute_dynamic"] = function(query, ...)
    local psql = promise.new()
    exports["revival_database"]:execute(query,{...},function(result)
        psql:resolve(result)
    end)
    return psql
end