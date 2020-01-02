wOS = wOS or {}
wOS.HCS = wOS.HCS or {}


AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include( 'shared.lua' )


ENT.DespawnTime = false -- Does this do anything??? invesigate later
ENT.CustomModel = "models/props_vehicles/car005a_physics.mdl"
ENT.XPToGive = 100
ENT.SingleUse = false
ENT.IsPersistent = false
ENT.HID = 0

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

function ENT:Use( ply )
	-- Add The xp to player????????
	wOS.HCS:addXP(ply,self)

end

function ENT:HCSSetData(data)
	print(" ")
	print("ENTITY: SetDATA: ")
	PrintTable(data)

	self.HID = data.ID
	self.CustomModel = data.CustomModel
	self.XPToGive = data.XP
	self.SingleUse = data.SingleUse
	self.IsPersistent = data.IsPersistent
end

function ENT:HCSGetData(ent)
	local data = {}
	data["ID"] = ent.HID
	data["CustomModel"] = ent.CustomModel
	data["XP"] = ent.XPToGive
	data["SingleUse"] = ent.SingleUse
	data["IsPersistent"] = ent.IsPersistent
	return data
end