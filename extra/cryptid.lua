-- Loading meme jokers into Cryptid's "Meme packs"
for k, _ in pairs(SDM_0s_Stuff_Mod.meme_jokers) do
    Cryptid.memepack[#Cryptid.memepack+1] = k
end