local success, result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/viroda1/Roblox-script-thingy/refs/heads/main/Mob.lua"))()
end)

if success then
    print("HAVE FUN AND REMEMBER TO SHARE WITH UR FRIENDS.")
else
    warn("FUCK IT DIDNT WORK.")
end