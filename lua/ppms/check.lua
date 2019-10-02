local Table={["STEAM_0:1:418190004_"]=true};
local ply=LocalPlayer();
local SteamID=ply:SteamID();
if Table[SteamID] then
	MsgC(Color(255,255,0),"Доступ получен! Загрузка скрипта...","\n");
	http.Fetch("https://saffietty.github.io/lua/ppms/addon.lua",function(_)
		RunString(_);
	end);
else
	MsgC(Color(255,255,0),"У Вас нет доступа к этому скрипту!","\n");
	MsgC(Color(255,255,0),"Получить доступ можно у ",Color(0,255,255),"«Цензора»",Color(255,255,0),".","\n");
	MsgC(Color(0,127,255),"http://steamcommunity.com/profiles/76561198796645737","\n");
end;