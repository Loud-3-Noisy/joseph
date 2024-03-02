











function TSIL.EntitySpecific.GetPickups(pickupVariant, subType)
	local entities = TSIL.Entities.GetEntities(EntityType.ENTITY_PICKUP, pickupVariant, subType)
	local pickups = {}

	for _, v in pairs(entities) do
		local pickup = v:ToPickup()
		if pickup then
			table.insert(pickups, pickup)
		end
	end

	return pickups
end





