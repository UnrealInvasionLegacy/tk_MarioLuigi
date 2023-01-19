class M_MarioTest extends tk_Monster
	config(tk_Monsters);

var class<Projectile> ProjectileClass;
var int AimError;
var Name RangedAttacks[4];
var Name HitAnims[4];
var Sound FootStep[4];

function Notify_FireProjectile()
{
	local vector X, Y, Z, FireStart;
	local coords BoneLocation;

     log('FireProjectile Called', 'M_MarioTest');

	if (Controller != None)
	{
		BoneLocation = GetBoneCoords('Bone_weapon');
		FireStart = GetFireStart(X,Y,Z);
		Spawn(ProjectileClass,self,,BoneLocation.Origin,Controller.AdjustAim(SavedFireProperties,FireStart,AimError));
		PlaySound(FireSound,SLOT_Interact,255);
	}
}

function RangedAttack(Actor A)
{
     log('RangedAttack Called', 'M_MarioTest');

	if (bShotAnim)
     {
		log('bShotAnim True', 'M_MarioTest');
          return;
     }

	if (Physics == PHYS_Swimming)
	{
		SetAnimAction(IdleSwimAnim);
	}
	else
	{
		SetAnimAction(RangedAttacks[Rand(4)]);
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		bShotAnim = true;
	}
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	Super.PlayDirectionalDeath(HitLoc);
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
	PlayAnim(HitAnims[Rand(4)],, 0.1);
}

function PlayMoverHitSound()
{
	PlaySound(HitSound[0], SLOT_Interact);
}

simulated function RunStep()
{
	PlaySound(FootStep[Rand(4)], SLOT_Interact, 8);
}

defaultproperties
{
     Health=500
     ProjectileClass=Class'tk_BaseM.tK_TitanBigRock'
     AimError=400
     RangedAttacks(0)="gesture_halt"
     RangedAttacks(1)="Weapon_Switch"
     RangedAttacks(2)="gesture_cheer"
     RangedAttacks(3)="gesture_halt"
     HitAnims(0)="HitF"
     HitAnims(1)="HitB"
     HitAnims(2)="HitL"
     HitAnims(3)="HitR"
     Footstep(0)=Sound'tk_MarioLuigi.MarioLuigi.step1t'
     Footstep(1)=Sound'tk_MarioLuigi.MarioLuigi.step1t'
     Footstep(2)=Sound'tk_MarioLuigi.MarioLuigi.step1t'
     Footstep(3)=Sound'tk_MarioLuigi.MarioLuigi.step1t'
     bMeleeFighter=false
     bCanDodge=true
     bBoss=false
     DodgeSkillAdjust=1.000000
     HitSound(0)=Sound'tk_MarioLuigi.MarioLuigi.MarioCoin'
     HitSound(1)=Sound'tk_MarioLuigi.MarioLuigi.mariojump'
     HitSound(2)=Sound'tk_MarioLuigi.MarioLuigi.MarioCoin'
     HitSound(3)=Sound'tk_MarioLuigi.MarioLuigi.mariojump'
     DeathSound(0)=Sound'tk_MarioLuigi.MarioLuigi.Death'
     DeathSound(1)=Sound'tk_MarioLuigi.MarioLuigi.gameover'
     DeathSound(2)=Sound'tk_MarioLuigi.MarioLuigi.mariodie2'
     DeathSound(3)=Sound'tk_MarioLuigi.MarioLuigi.mariodie3'
     ChallengeSound(0)=Sound'tk_MarioLuigi.MarioLuigi.blueRoom'
     ChallengeSound(1)=Sound'tk_MarioLuigi.MarioLuigi.blueRoom'
     ChallengeSound(2)=Sound'tk_MarioLuigi.MarioLuigi.blueRoom'
     ChallengeSound(3)=Sound'tk_MarioLuigi.MarioLuigi.blueRoom'
     FireSound=Sound'tk_MarioLuigi.MarioLuigi.fireball'
     IdleHeavyAnim="Idle_Rifle"
     IdleRifleAnim="Idle_Rifle"
     FireHeavyRapidAnim="Biggun_Aimed"
     FireHeavyBurstAnim="Biggun_Burst"
     FireRifleRapidAnim="Rifle_Aimed"
     FireRifleBurstAnim="Rifle_Burst"
     ScoringValue=25
     bCanSwim=true
     MeleeRange=150.000000
     GroundSpeed=350.000000
     AccelRate=2000.000000
     JumpZ=500.000000
     MovementAnims(0)="WalkF"
     MovementAnims(1)="WalkB"
     MovementAnims(2)="WalkL"
     MovementAnims(3)="WalkR"
     TurnLeftAnim="TurnL"
     TurnRightAnim="TurnR"
     CrouchAnims(0)="CrouchF"
     CrouchAnims(1)="CrouchB"
     CrouchAnims(2)="CrouchL"
     CrouchAnims(3)="CrouchR"
     AirAnims(0)="JumpF_Mid"
     AirAnims(1)="JumpB_Mid"
     AirAnims(2)="JumpL_Mid"
     AirAnims(3)="JumpR_Mid"
     TakeoffAnims(0)="JumpF_Takeoff"
     TakeoffAnims(1)="JumpB_Takeoff"
     TakeoffAnims(2)="JumpL_Takeoff"
     TakeoffAnims(3)="JumpR_Takeoff"
     LandAnims(0)="JumpF_Land"
     LandAnims(1)="JumpB_Land"
     LandAnims(2)="JumpL_Land"
     LandAnims(3)="JumpR_Land"
     DoubleJumpAnims(0)="DoubleJumpF"
     DoubleJumpAnims(1)="DoubleJumpB"
     DoubleJumpAnims(2)="DoubleJumpL"
     DoubleJumpAnims(3)="DoubleJumpR"
     DodgeAnims(0)="DodgeF"
     DodgeAnims(1)="DodgeB"
     DodgeAnims(2)="DodgeL"
     DodgeAnims(3)="DodgeR"
     AirStillAnim="Jump_Mid"
     TakeoffStillAnim="Jump_Takeoff"
     CrouchTurnRightAnim="Crouch_TurnR"
     CrouchTurnLeftAnim="Crouch_TurnL"
     IdleCrouchAnim="Idle_Rifle"
     IdleSwimAnim="Idle_Rifle"
     IdleWeaponAnim="Idle_Rifle"
     IdleRestAnim="Idle_Rifle"
     IdleChatAnim="Idle_Rifle"
     LightHue=14
     LightSaturation=159
     LightRadius=8.000000
     Mesh=SkeletalMesh'tk_MarioLuigi.MarioLuigi.SuperMario'
     DrawScale=6.100000
     PrePivot=(Z=-35.000000)
     Skins(0)=Texture'tk_MarioLuigi.MarioLuigi.marioheadA'
     Skins(1)=Texture'tk_MarioLuigi.MarioLuigi.marioheadA'
     CollisionRadius=110.000000
     CollisionHeight=305.000000
}