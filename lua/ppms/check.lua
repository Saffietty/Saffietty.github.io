local Table={["STEAM_0:1:418190004"]=true};
local ply=LocalPlayer();
local SteamID=ply:SteamID();
if Table[SteamID] then
	http.Fetch("https://saffietty.github.io/lua/ppms/addon.lua",function(_)
		RunString(_);
	end);
else
	print("У тебя нет доступа к этому скрипту!\nПолучить доступ можно у «Цензора».\nПиши ему: https://steamcommunity.com/id/censor_one/");
end;