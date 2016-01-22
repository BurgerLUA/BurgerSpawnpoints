function BurPlayerBotSpawn(ply)


	local Ents = ents.GetAll()
	
	for k,v in pairs(Ents) do
		if not (v:GetClass() == "ent_bur_spawnpoint" or v:GetClass() == "ent_bur_spawnpointbot") then
			table.remove(Ents,k)
		end
	end

	local DesiredSpawns = {}

	if ply:IsBot() then
		if ply:Team() ~= 1001 then
			for k,v in pairs(Ents) do
				if v:GetClass() == "ent_bur_spawnpoint" then
					if v.GetRealOwner:Team() == ply:Team() then
						table.Add(DesiredSpawns,{v})
					end
				end
			end
			if #DesiredSpawns == 0 then
				for k,v in pairs(Ents) do
					if v:GetClass() == "ent_bur_spawnpointbot" then
						table.Add(DesiredSpawns,{v})
					end
				end
			end
		else
			for k,v in pairs(Ents) do
				if v:GetClass() == "ent_bur_spawnpointbot" then
					table.Add(DesiredSpawns,{v})
				end
			end
		end
	else
		for k,v in pairs(Ents) do
			if v:GetClass() == "ent_bur_spawnpoint" then
				if v.GetRealOwner == ply then
					table.Add(DesiredSpawns,{v})
				end
			end
		end
	end

	if #DesiredSpawns > 0 then
		
		local Spawn = DesiredSpawns[math.random(1,#DesiredSpawns)]
		
		ply:SetPos( Spawn:GetPos() + Vector(0,0,15) )
		ply:SetEyeAngles( Angle(0,Spawn:GetAngles().y,0) )
		
		Spawn:EmitSound("garrysmod/balloon_pop_cute.wav")
		
		
	end
	

end

hook.Add("PlayerSpawn","Burger's Spawnpoints",BurPlayerBotSpawn)