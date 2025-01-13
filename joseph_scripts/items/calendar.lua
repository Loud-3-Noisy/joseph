local Calendar = {}

local enums = JosephMod.enums
local utility = JosephMod.utility

local CALENDAR = Isaac.GetItemIdByName("Calendar")
local weekday --1 is sunday, 2 is monday and so on



function Calendar:UpdateCache(player, flag)
    if flag == CacheFlag.CACHE_DAMAGE then
        if player:HasCollectible(CALENDAR) and (weekday == 1 or weekday == 3) then
            player.Damage = player.Damage + (1 * player:GetCollectibleNum(CALENDAR))
        end
    elseif flag == CacheFlag.CACHE_FIREDELAY then
        if player:HasCollectible(CALENDAR) and (weekday == 2 or weekday == 7) then
            utility:AddTears(player, (0.7 * player:GetCollectibleNum(CALENDAR)))
        end
    elseif flag == CacheFlag.CACHE_SPEED then
        if player:HasCollectible(CALENDAR) and (weekday == 4) then
            player.MoveSpeed = player.MoveSpeed + (0.3 * player:GetCollectibleNum(CALENDAR))
        end
    end
end
JosephMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Calendar.UpdateCache)


function Calendar:AddCalendar(_, _, firstTime, _, _, player)
    if not firstTime then return end
    if weekday == 5 or weekday == 6 then
        player:AddMaxHearts(2)
        player:AddHearts(4)
    end

end
JosephMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Calendar.AddCalendar, CALENDAR)


function Calendar:PreAddCalendar(_, _, firstTime, _, _, player)
    if not firstTime then return end
    if weekday == nil then
        weekday = os.date("*t").wday
    end

end
JosephMod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, Calendar.PreAddCalendar, CALENDAR)