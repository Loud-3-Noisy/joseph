JosephMod = RegisterMod("Joseph", 1)

if REPENTOGON then
    include("joseph_scripts.characters.joseph")
else
    JosephMod:AddCallback(ModCallbacks.MC_POST_RENDER, function ()
        local pos = 50
        local scale = 0.5
        local warning = "REPENTOGON is required to use Joseph mod and is not installed! Check out repentogon.com for more information!"
        Isaac.RenderScaledText(warning, pos, pos, scale, scale, 1, 0, 0 ,1)
    end)
end