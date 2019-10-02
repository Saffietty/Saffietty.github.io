local Check=function()
	local Table={["STEAM_0:1:418190004"]=true};
	local ply=LocalPlayer();
	local SteamID=ply:SteamID();
	if !Table[SteamID] then
		MsgC(Color(255,255,0),"У Вас ",Color(255,127,0),"нет доступа",Color(255,255,0)," к этому скрипту!","\n");
		MsgC(Color(255,255,0),"Получить доступ можно у ",Color(0,255,255),"«Цензора»",Color(255,255,0),".","\n");
		MsgC(Color(0,127,255),"http://steamcommunity.com/profiles/76561198796645737","\n");
	else
		MsgC(Color(255,255,0),"Доступ получен, загрузка скрипта...","\n");
		http.Fetch("https://saffietty.github.io/lua/ppms/addon.lua",function(body,_,_,code)
			if code==200 then
				RunString(body);
			end;
		end);
	end;
end;
Check();