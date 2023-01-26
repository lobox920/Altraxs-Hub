if game.PlaceId == 2534724415 then
  if  game.PlaceVersion ~= 2384 then
        game.Players.LocalPlayer:Kick("Game updated tell Awaken report to https://discord.gg/3dPPvsVAy4 or Awaken#6636  ")
        rconsoleinfo("\n Game updated please report to Awaken#6636 or in discord")
elseif game.PlaceVersion == 2384 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/IceMinisterq/Altraxs-Hub/main/ER%3ALC", true))()
end
end

if game:GetService("CoreGui"):FindFirstChild("DevConsoleMaster") then 
      game:GetService("CoreGui").DevConsoleMaster:Destroy()
end
