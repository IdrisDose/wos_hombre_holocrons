wOS = wOS or {}
wOS.hcrons = wOS.hcrons or {}


AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include( 'shared.lua' )


ENT.DespawnTime = false -- Does this do anything??? invesigate later
ENT.CustomModel = "models/props_vehicles/car005a_physics.mdl"
ENT.XPToGive = 100
ENT.SingleUse = false
ENT.UsedBy = {}

function ENT:Initialize()

	self:DrawShadow(false)
	self:SetModel(self.CustomModel)

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )


	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(false)
	end

end

function ENT:Think()


end

function ENT:Use( ply )
	-- Add The xp to player????????
	wOS.hcrons:addXP(ply,self)
end