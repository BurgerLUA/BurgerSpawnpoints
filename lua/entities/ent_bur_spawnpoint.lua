AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "base_entity"
ENT.PrintName 			= "Player Spawnpoint"
ENT.Author 				= ""
ENT.Information 		= ""

ENT.Spawnable 			= true
ENT.AdminOnly			= false
ENT.Category			= "Spawnpoints"


function ENT:Initialize()

	if SERVER then
	
		self:SetModel("models/props_combine/combine_mine01.mdl")

		local Size = 10
		
		self:PhysicsInitBox( Vector(-Size,-Size,-1), Vector(Size,Size,80) )
		self:SetCollisionBounds( Vector( -Size, -Size, -1 ), Vector( Size, Size, 80 ) )
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

		self:SetUseType(SIMPLE_USE)
		
		

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetBuoyancyRatio(0)
			phys:SetMass(100000)
		end
		
	end
	
	self:EmitSound("common/stuck1.wav")
	
end

function ENT:Think()

	if SERVER then
		local CurrentAngles = self:GetAngles()
		
		if self:GetVelocity():Length() < 1 then
			self:SetAngles(Angle(0,CurrentAngles.y,0))
			self:GetPhysicsObject():EnableMotion(true)
		end
		
		self:NextThink(CurTime() + 1)
		return true
	else
		self:SetNextClientThink(CurTime() + 1)
		return true
	end

end


function ENT:Use(activator,caller,useType,value)

	if activator ~= self.GetRealOwner then
		activator:EmitSound("common/stuck2.wav")
		SafeRemoveEntity(self)
	end


end



function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end
	if not ply:Alive() then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 16

	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	ent.GetRealOwner = ply

	return ent

end

function ENT:Draw()

	self:DrawModel()

	local settings = {}

	settings["model"] = "models/editor/playerstart.mdl"
	settings["pos"] = self:GetPos() + self:GetUp()*10
	settings["angle"] = self:GetAngles()

	render.Model(settings)

end
