AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName		= "Katana Zero"
	SWEP.Author			= "BeyondSoul"
	SWEP.Purpose 		= "Slam the ground with the power of 1000 fists"
	SWEP.Instructions 	= "Click on a player then land on them"

	SWEP.Slot 				= 1
	SWEP.SlotPos 			= 1
	SWEP.ViewModelFOV		= 54

	
	SWEP.BounceWeaponIcon	= false
	
	SWEP.ShowViewModel 		= false
	SWEP.ShowWorldModel 	= false
	
end

	SWEP.Spawnable			= true
	SWEP.AdminSpawnable		= true

SWEP.Category				= "BSC"

SWEP.HoldType 				= "normal"

SWEP.ViewModel 				= "models/weapons/c_arms.mdl"
SWEP.WorldModel 			= ""
SWEP.UseHands				= true

SWEP.Primary.DefaultClip 	= -1
SWEP.Primary.ClipSize 		= -1
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 			= "none"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= true
SWEP.Secondary.Ammo 		= "none"

local function MyCalcView( ply, pos, angles, fov )
	local view = {}

	view.origin = pos-( angles:Forward()*200 )
	view.angles = angles
	view.fov = fov
	view.drawviewer = true

	return view
end

function SWEP:ReloadReady(time)
    self.ReloadReadyTimer = time
end

function SWEP:Cooldown(time)
    self.Cooldowntimer = time
end

function SWEP:Recharge(time)
    self.RechargeTimer = time
end

function SWEP:Revive(time)
    self.ReviveTimer = time
end
	
function SWEP:Roll(time)
    self.RollTimer = time
end

function OnNPCKilled( ply, npc, weapon)
end

function SWEP:DrawHUD()
	draw.RoundedBox( 5, 12, 12, 350*( self.Owner:Armor() /  8 ), 50, Color(25, 150, 255, 180) );
	draw.RoundedBox( 5, 12, 12, 350, 50, Color(0, 0, 0, 120) );
	draw.RoundedBox( 5, 310, 12, 5, 50, Color(12, 125, 255, 120) );
	draw.RoundedBox( 5, 267, 12, 5, 50, Color(12, 125, 255, 120) );
	draw.RoundedBox( 5, 224, 12, 5, 50, Color(12, 125, 255, 120) );
	draw.RoundedBox( 5, 181, 12, 5, 50, Color(12, 125, 255, 120) );
	draw.RoundedBox( 5, 138, 12, 5, 50, Color(12, 125, 255, 120) );
	draw.RoundedBox( 5, 95, 12, 5, 50, Color(12, 125, 255, 120) );
	draw.RoundedBox( 5, 52, 12, 5, 50, Color(12, 125, 255, 120) );
	draw.RoundedBox( 0, 12, 60, 350, 5, Color(0, 0, 0, 255) );
	draw.RoundedBox( 0, 12, 10, 350, 5, Color(0, 0, 0, 255) );
	draw.RoundedBox( 0, 12, 66, 350, 5, Color(0, 0, 0, 255) );
	draw.RoundedBox( 0, 12, 79, 350, 5, Color(0, 0, 0, 255) );
	draw.RoundedBox( 0, 12, 67, 350, 13, Color(0, 0, 0, 170) );
	
	draw.RoundedBox( 0, 12, 70, 350 *( Kills /  1200 ), 10, Color(178, 102, 255, 180) );
	draw.RoundedBox( 0, 12, 70, 350 *( Shadow /  1200 ), 10, Color(127, 0, 255, 255) );
	draw.RoundedBox( 0, 12, 70, 350 *( Shadow2 /  1200 ), 10, Color(0, 128, 255, 255) );
end
function SWEP:HUDShouldDraw( element )
	//return false to hide an item
	if (element == "CHudHealth") or (element == "CHudBattery") then
		return false
	else
		return true
	end
end

function SWEP:Think()
			local owner = self:GetOwner()
			local Frags = owner:Frags()
			local Deaths = owner:Deaths()
			if SERVER then
			
			if owner:Crouching() and (not self.RollTimer or self.RollTimer <= CurTime()) then
			if owner:KeyPressed( IN_USE ) then
			if owner:OnGround() then
			self:Roll(CurTime() + .5)
			self.Owner:SetVelocity(self.Owner:GetForward() * 11500 + Vector(1,0,0))
				owner:EmitSound( "weapons/KZ/Dash.wav", 100, 100 , 1)
				timer.Create("Roll1", .001, 0, function()
				owner:SetVelocity(owner:GetUp() * 1 + Vector(0, 0,-300))
			end)
					timer.Create("Roll2", .001, 0, function()
					timer.Destroy("Roll1")
					timer.Destroy("Roll2")
			end)
		end
	end
end
	
	if Kills < 0 and not self.Finished then
	owner:Kill()
	end
	
	
	
	if owner:Frags() < 0 then
	owner:SetFrags(0)
	end
	
	if owner:Frags() == 3 and not self.Finished then
	owner:PrintMessage( HUD_PRINTCENTER, "That should work." )
	owner:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 1, 1.6 )
	self.Finished = true
	owner:SetFrags(0)
	end
	
	owner:SetHealth(0)
	
	
	    if owner:Armor() == 0 and self.SlowDownTime then
	owner:SetWalkSpeed( Walk )
	owner:SetRunSpeed( Run )
	owner:SetJumpPower( Jump )
		self:Recharge(CurTime() + 1.5)
		timer.Destroy("ReDo")
		owner:EmitSound( "weapons/KZ/Resume.wav", 150, 200 , 1)
	self:Cooldown(CurTime() + 1.5)
	game.SetTimeScale(1)
	self.SlowDownTime = false
	for k, v in pairs(player.GetAll()) do
	v:ScreenFade( SCREENFADE.PURGE, Color( 255, 255, 255, 10 ), 0, 0 )
	v:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 200 ), 1, .3 )
	v:SetRenderMode(RENDERMODE_TRANSALPHA)
	end
	timer.Create("Color1", .1, 1, function()
		self.Owner:SetColor( Color( 75, 210, 255, 230 ) )
	end)
		timer.Create("Color2", .2, 1, function()
		self.Owner:SetColor( Color( 150, 250, 255, 240 ) )
	end)
			timer.Create("Color3", .3, 1, function()
					self.Owner:SetColor( Color( 255, 255, 255, 255 ) )
	self.Owner:SetMaterial("")
	end)
	end
	
	if (not self.ReviveTimer or self.ReviveTimer <= CurTime()) then
	self:Revive(CurTime() + 25)
	Home = owner:GetPos()
	MaxArmor = owner:Armor()
	end
	
	if not self.SlowDownTime and owner:Armor() < 8 and (not self.RechargeTimer or self.RechargeTimer <= CurTime()) then
	self.Owner:SetArmor(math.min(owner:Armor() + 1))
	self:Recharge(CurTime() + 1.5)
	end
	
	if owner:Armor() > 8 then
		self.Owner:SetArmor(math.min(owner:Armor() - 1))
		end
	
	if self.Fixed and owner:KeyDown( IN_RELOAD ) then
	self:Cooldown(CurTime() + .1)
	self.Fixed = false
	end
	
	if (not self.Cooldowntimer or self.Cooldowntimer <= CurTime()) then
    if owner:Armor() > 1 then
if owner:KeyPressed( IN_RELOAD ) and not self.SlowDownTime and (not self.ReloadReadyTimer or self.ReloadReadyTimer <= CurTime()) and not self.Fixed then
	Walk = owner:GetWalkSpeed()
	Run = owner:GetRunSpeed()
	Jump = owner:GetJumpPower()
	owner:SetWalkSpeed( Walk + 175 )
	owner:SetRunSpeed( Run + 175 )
	owner:SetJumpPower( Jump + 100 )
    self.Fixed = true
	self.Owner:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.Owner:SetColor( Color( 55, 170, 255, 220 ) )
	self.Owner:SetMaterial("models/player/shared/ice_player")
	owner:EmitSound( "weapons/KZ/SlowDown.wav", 100, 120 , 1)
	timer.Create("ReDo", .4, 0, function()
    if owner:Armor() > 0 then
		self.Owner:SetArmor(math.min(owner:Armor() - 1))
		end
end)
	end
	end
	end
if owner:KeyReleased( IN_RELOAD ) and self.SlowDownTime then
	owner:SetWalkSpeed( Walk )
	owner:SetRunSpeed( Run )
	owner:SetJumpPower( Jump )
	self:Recharge(CurTime() + 1.5)
	timer.Destroy("ReDo")
	owner:EmitSound( "weapons/KZ/Resume.wav", 150, 200 , 1)
	self:Cooldown(CurTime() + 1.5)
	game.SetTimeScale(1)
	    self.Fixed = false
	self.SlowDownTime = false
	for k, v in pairs(player.GetAll()) do
	v:ScreenFade( SCREENFADE.PURGE, Color( 255, 255, 255, 10 ), 0, 0 )
	v:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 200 ), 1, .3 )
	v:SetRenderMode(RENDERMODE_TRANSALPHA)
	end
	timer.Create("Color1", .1, 1, function()
		self.Owner:SetColor( Color( 75, 210, 255, 230 ) )
	end)
		timer.Create("Color2", .2, 1, function()
		self.Owner:SetColor( Color( 150, 250, 255, 240 ) )
	end)
			timer.Create("Color3", .3, 1, function()
					self.Owner:SetColor( Color( 255, 255, 255, 255 ) )
	self.Owner:SetMaterial("")
	end)
	end
	end
	local owner = self:GetOwner()
	if SERVER then
		owner:SetMaxHealth(100)
	end
end

function SWEP:Initialize()
	local owner = self:GetOwner()
	Kills = 1200
	Shadow = 800
	Shadow2 = 400
	CountNumber = 1

	if not self.Finished then
		timer.Create("Revive3", .125, 0, function()
			Kills = Kills - CountNumber
			Shadow = Shadow - CountNumber
			Shadow2 = Shadow2 - CountNumber
		end)
	end
end

function SWEP:Equip()
end

function SWEP:Deploy()
	local owner = self:GetOwner()
		if (CLIENT) then
		end
	return true
end

function SWEP:Holster()
	local owner = self:GetOwner()
	
	if self.SlowDownTime then
		timer.Destroy("ReDo")
		game.SetTimeScale(1)
		self:SetRenderMode(RENDERMODE_TRANSALPHA)
		self.Owner:SetColor(Color(255, 255, 255, 255))
		self.Owner:SetMaterial("")
		
		for k, v in pairs(player.GetAll()) do
			v:ScreenFade(SCREENFADE.PURGE, Color(255, 255, 255, 10), 0, 0)
		end
	end
	
	if (CLIENT) then
	end
	
	return true
end

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()
    local entity = self.Owner:GetEyeTrace().Entity
    
    self:SetNextPrimaryFire(CurTime() + .9)
    
    if SERVER then
        if self.Owner:OnGround() then
            self.Owner:SetVelocity(self.Owner:GetForward() * 500 + Vector(1,1,1))
            self.Owner:EmitSound("weapons/KZ/Sword" .. math.random(1, 2, 3) .. ".wav")
            if (self.Owner:GetPos():Distance(entity:GetPos()) < 225) then
                if SERVER then
                    if entity and IsValid(entity) then
                        entity:TakeDamage(100,owner,weapon_katanazero)
                    end
                end
            end
        end
        if not self.Owner:OnGround() then
            self.Owner:SetVelocity(self.Owner:GetForward() * 550 + Vector(1,1,1))
            self.Owner:EmitSound("weapons/KZ/Sword" .. math.random(1, 2, 3) .. ".wav")
            if (self.Owner:GetPos():Distance(entity:GetPos()) < 225) then
                if SERVER then
                    if entity and IsValid(entity) then
                        entity:TakeDamage(100,entity,entity:GetActiveWeapon())
                    end
                end
            end
        end
    end
end

function SWEP:SecondaryAttack()
end

function SWEP:SlowDown(time)
    self.SlowDownTimer = time
end

function SWEP:UltCD(time)
    self.UltCDTimer = time
end

function SWEP:Reload()
	if SERVER then
		local owner = self:GetOwner()
		if (not self.Cooldowntimer or self.Cooldowntimer <= CurTime()) and self.Fixed then
			if owner:Armor() > 1 then
				self:Cooldown(CurTime() + 1.5)
				if owner:KeyDown(IN_RELOAD) and not self.SlowDownTime then
					game.SetTimeScale(.3)
					self.SlowDownTime = true
					for k, v in pairs(player.GetAll()) do
						v:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 200), 1, 999)
					end
				end
			end
		end
	end
end

function SWEP:OnRemove()
local owner = self:GetOwner()

if self.SlowDownTime then
	timer.Destroy("ReDo")
	game.SetTimeScale(1)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.Owner:SetColor(Color(255, 255, 255, 255))
	self.Owner:SetMaterial("")
	
	for k, v in pairs(player.GetAll()) do
		v:ScreenFade(SCREENFADE.PURGE, Color(255, 255, 255, 10), 0, 0)
	end
end

if SERVER and not self.Finished then
		owner:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 240), 1, 999)
		owner:SetFrags(0)
		owner:PrintMessage(HUD_PRINTCENTER, "That Won't work.")
		util.ScreenShake(owner:GetPos(), 100, 20, .3, 100)
		owner:Freeze(true)
		owner:EmitSound("weapons/KZ/Death.wav", 100, 100, 1)
		
		timer.Create("Revive3", 2.4, 1, function()
			owner:EmitSound("weapons/KZ/Reloop.wav", 100, 100, 1)
			util.ScreenShake(owner:GetPos(), 50, 50, 1.6, 100)
		end)
		
		timer.Create("Revive2", 3.5, 1, function()
			owner:EmitSound("weapons/KZ/Start.wav", 100, 100, 1)
			owner:Spawn()
			owner:SetPos(Vector(Home))
			owner:Freeze(false)
			owner:SetArmor(math.min(owner:Armor() + MaxArmor))
			owner:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), .5, .3)
			local w = owner:Give("weapon_katanazero", true)
			timer.Simple(0, function() owner:SelectWeapon("weapon_katanazero") end)
		end)
	end
end

function SWEP:GetViewModelPosition(pos, ang)
	pos = pos - ang:Up() * 3
	return pos, ang
end