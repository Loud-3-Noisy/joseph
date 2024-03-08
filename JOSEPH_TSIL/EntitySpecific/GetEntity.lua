

function TSIL.EntitySpecific.GetEffects(effectVariant, subType)
	local entities = TSIL.Entities.GetEntities(EntityType.ENTITY_EFFECT, effectVariant, subType)

	local effects = {}

	for _, v in pairs(entities) do
		local effect = v:ToEffect()
		if effect then
			table.insert(effects, effect)
		end
	end

	return effects
end










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





