function TSIL.GridEntities.GetGridEntities(...)
	local gridEntityTypes = {...}
	local gridEntityTypesDict = TSIL.Utils.Tables.ConstructDictionaryFromTable(gridEntityTypes)

	local gridEntities = {}

	local room = Game():GetRoom()

	for i = 0, room:GetGridSize() - 1, 1 do
		local gridEntity = room:GetGridEntity(i)

		if #gridEntityTypes == 0 or (gridEntity and gridEntityTypesDict[gridEntity:GetType()]) then
			gridEntities[#gridEntities+1] = gridEntity
		end
	end

	return gridEntities
end

