-- Loading meme jokers into Cryptid's "Meme packs"
for k, _ in pairs(SDM_0s_Stuff_Mod.meme_jokers) do
    Cryptid.memepack[#Cryptid.memepack+1] = k
end

-- Loading food jokers into Cryptid's "://SPAGHETTI" pool
for k, _ in pairs(SDM_0s_Stuff_Mod.food_jokers) do
    Cryptid.food[#Cryptid.food+1] = k
end