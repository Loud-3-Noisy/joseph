function TSIL.GridSpecific.GetCrawlSpaces(crawlSpaceVariant)
    if not crawlSpaceVariant then
        crawlSpaceVariant = -1
    end

    local crawlSpaces = TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_STAIRS)

    if crawlSpaceVariant == -1 then
        return crawlSpaces
    else
        return TSIL.Utils.Tables.Filter(crawlSpaces, function (_, crawlSpace)
            return crawlSpace:GetVariant() == crawlSpaceVariant
        end)
    end
end















