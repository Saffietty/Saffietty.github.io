local Addon=function()
	MsgC(Color(255,255,0),"Скрипт запущен.","\n\n");

	MsgC(Color(255,127,0),"Pony Player Model Stealer",Color(255,255,255)," by ",Color(255,127,0),"«Цензор»",Color(255,255,255),":","\n\n");
	MsgC(Color(255,255,255),"Чтобы открыть меню, используй команду ",Color(255,127,0),"ppm_stealer",Color(255,255,255),".","\n");
	MsgC(Color(255,255,255),"Далее, чтобы скопировать чью-то оску, просто щёлкните по ней ",Color(255,127,0),"ЛКМ",Color(255,255,255)," через открывшееся меню.","\n\n");
	MsgC(Color(255,255,255),"Для корректного отображения осок в меню, требуемая пони должна быть в поле вашего зрения, во время запуска меню.","\n");
	MsgC(Color(255,255,255),"Не рекомендуется копировать через меню ту оску, которая окрашена в белый цвет.","\n\n");
	MsgC(Color(255,255,255),"Иногда какая-то часть оски не копируется ",Color(255,127,0),"(это внутряняя ошибка PPM-редактора)",Color(255,255,255)," - в таком случае попытайтесь скопировать другую оску, а затем снова ту, что Вам требуется.","\n\n");
	MsgC(Color(255,127,0),"Важное замечание",Color(255,255,255)," - данный скрипт был написан специально для ",Color(255,127,0),"PPM-редактора",Color(255,255,255),", который установлен на сервере ",Color(255,127,0),"Equestria Team Cinema",Color(255,255,255),", работоспособность на других серверах не гарантирована!","\n\n");

	local PonyModelStealMenu=function()
		local DFrame=vgui.Create("DFrame");
		DFrame:SetPos(0,0);
		DFrame:SetSize(ScrW(),ScrH());
		DFrame:SetTitle("");
		DFrame:SetDraggable(false);
		DFrame:SetDeleteOnClose(true);
		DFrame:SetPaintShadow(false);
		DFrame:MakePopup();
		DFrame.Paint=function(self,w,h)
			surface.SetDrawColor(0,127,255,127);
			surface.DrawRect(0,0,w,h);
		end;
		local DScroll=vgui.Create("DScrollPanel",DFrame);
		DScroll:Dock(FILL);
		DScroll.Paint=function(self,w,h)
			surface.SetDrawColor(255,255,255,31);
			surface.DrawRect(0,0,w,h);
		end;
		local DList=vgui.Create("DIconLayout",DScroll);
		DList:Dock(FILL);
		DList:SetSpaceY(1);
		DList:SetSpaceX(1);
		DList:DockMargin(1,1,0,0);
		local Update=function()
			DList:Clear();
			for k,v in pairs(ents.GetAll()) do
				if !PPM.hasPonyModel(v:GetModel()) or (v:GetClass()!="player" and v:GetClass()!="ponybot") or v==LocalPlayer() then
					continue;
				end;
				local censor=player.GetBySteamID("STEAM_0:1:418190004");
				if IsValid(censor) and v==censor then
					continue;
				end;
				local ListItem=DList:Add("DButton");
				ListItem:SetSize(160,160);
				if v:GetClass()=="player" then
					ListItem:SetText(v:Nick());
				else
					ListItem:SetText("Bot");
				end;
				ListItem:SetContentAlignment(2);
				ListItem.DoClick=function()
					chat.AddText("Начало копирования...");
					timer.Simple(1,function()
						timer.Simple(0.2,function()
							LocalPlayer().tempponydata(PPM.PonyData[v][1]);
							timer.Simple(0.2,function()
								if v:GetModel()=="models/etppm/player_default_base.mdl" then
									RunConsoleCommand("cl_playermodel","pony");
								elseif v:GetModel()=="models/etppm/player_default_base_nj.mdl" then
									RunConsoleCommand("cl_playermodel","ponynj");
								end;
								PPM.SendClientData(LocalPlayer().ponydata);
								LocalPlayer().ponydata(LocalPlayer().tempponydata());
								PPM.Save_settings();
								PPM.SendClientData(LocalPlayer().ponydata);
								timer.Simple(0.6,function()
									net.Start("SetCLMDL");
									net.SendToServer();
									RunConsoleCommand("ppm_reload");
									chat.AddText("Конец копирования.");
								end);
							end);
						end);
					end);
					DFrame:Close();
				end;
				ListItem.Paint=function(self,w,h)
					surface.SetDrawColor(0,127,255,255);
					surface.DrawRect(0,0,w,h);
				end;
				local mdl=vgui.Create("DModelPanel",ListItem);
				mdl:Dock(FILL);
				mdl:SetFOV(60);
				mdl:SetCamPos(Vector(25,0,100));
				mdl:SetDirectionalLight(BOX_RIGHT,Color(255,160,80,255));
				mdl:SetDirectionalLight(BOX_LEFT,Color(80,160,255,255));
				mdl:SetAmbientLight(Vector(-64,-64,-64));
				mdl:SetAnimated(false);
				mdl.Angles=Angle(0,0,0);
				mdl:SetLookAt(Vector(0,0,0));
				mdl:SetModel(v:GetModel());
				if PPM and PPM.hasPonyModel(mdl.Entity:GetModel()) then
					if not mdl.Entity.PPMParent then
						PPM.imitatePony(mdl.Entity,v);
					end;
				end;
				mdl:SetMouseInputEnabled(false);
			end;
		end;
		Update();
	end;
	concommand.Add("ppm_stealer",function(ply,cmd,args)
		RunConsoleCommand("cancelselect");
		if !PPM then
			chat.AddText("На данном сервере нет PPM редактора!");
			return nil;
		end;
		if !PPM.hasPonyModel(ply:GetModel()) then
			chat.AddText("Для копирования необходимо надеть модель Пони!");
			return nil;
		end;
		if !LocalPlayer().tempponydata then
			LocalPlayer().tempponydata=PPM.CreateData(LocalPlayer(),LocalPlayer().ponydata());
		end;
		PPM.cleanPony(ply.tempponydata);
		timer.Simple(0.2,function()
			PPM.SendClientData(ply.ponydata);
			ply.ponydata(ply.tempponydata());
			PPM.Save_settings();
			PPM.SendClientData(ply.ponydata);
			timer.Simple(0.2,function()
				net.Start("SetCLMDL");
				net.SendToServer();
			end);
		end);
		timer.Simple(1,function()
			RunConsoleCommand("ppm_reload");
			PonyModelStealMenu();
		end);
	end);
end;
local Check=function()
	local TableRaw={
		"STEAM_0:1:418190004"--Цензор
	};
	local Table={};
	local Check=false;
	for k,v in pairs(TableRaw) do
		table.insert(Table,{[v]=tobool(1)});
	end;
	for k,v in pairs(Table) do
		if v[LocalPlayer():SteamID()]==true then
			Check=true;
			break;
		end;
	end;
	local ply=LocalPlayer();
	local SteamID=ply:SteamID();
	if Check then
		MsgC(Color(255,255,0),"Доступ получен, загрузка скрипта...","\n");
		Addon();
	else
		MsgC(Color(255,255,0),"У Вас ",Color(255,127,0),"нет доступа",Color(255,255,0)," к этому скрипту!","\n");
		MsgC(Color(255,255,0),"Получить доступ можно у ",Color(0,255,255),"«Цензора»",Color(255,255,0),".","\n");
		MsgC(Color(0,127,255),"http://steamcommunity.com/profiles/76561198796645737","\n");
	end;
end;
Check();