class MarioProjectiles extends Projectile
	config(tk_Monsters);

var byte Bounces;
var array<StaticMesh> ProjectileMesh;
var array<Texture> ProjectileSkin;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        Bounces;
}

simulated function PostBeginPlay()
{
	local vector Dir;
	if ( bDeleteMe || IsInState('Dying') )
		return;

	Dir = vector(Rotation);
	Velocity = (speed+Rand(MaxSpeed-speed)) * Dir;

	DesiredRotation.Pitch = Rotation.Pitch + Rand(2000) - 1000;
	DesiredRotation.Roll = Rotation.Roll + Rand(2000) - 1000;
	DesiredRotation.Yaw = Rotation.Yaw + Rand(2000) - 1000;

	SetStaticMesh(ProjectileMesh[Rand(ProjectileMesh.Length)]);

	if (StaticMesh == ProjectileMesh[0]) //Coin
	{
		Skins[0] = ProjectileSkin[0];
		SetDrawScale(1.300000);
		SetCollisionSize(45.000000, 45.000000);
	}
	else if (StaticMesh == ProjectileMesh[1]) //PowBlock
	{
		Skins[0] = ProjectileSkin[1];
		SetDrawScale(1.300000);
		SetCollisionSize(45.000000, 45.000000);
	}
	else if (StaticMesh == ProjectileMesh[2]) //PowerStar
	{
		Skins[0] = ProjectileSkin[2];
		SetDrawScale(1.300000);
		SetCollisionSize(45.000000, 45.000000);
	}
	else if (StaticMesh == ProjectileMesh[3]) //QuestionBlock
	{
		Skins[0] = ProjectileSkin[3];
		SetDrawScale(1.300000);
		SetCollisionSize(45.000000, 45.000000);
	}
	else if (StaticMesh == ProjectileMesh[4]) //Mushroom
	{
		Skins[0] = ProjectileSkin[(Rand(3)+4)];

		if (Skins[0] == ProjectileSkin[4]) //Red Mushroom
		{
			SetDrawScale(1.300000);
			SetCollisionSize(45.000000, 45.000000);
		}
		else if (Skins[0] == ProjectileSkin[5]) //Green Mushroom
		{
			SetDrawScale(0.800000);
        	SetCollisionSize(30.000000, 30.000000);
		}
		else if (Skins[0] == ProjectileSkin[6]) //Blue Mushroom
		{
			SetDrawScale(0.300000);
        	SetCollisionSize(10.000000, 10.000000);
		}
	}

	if (FRand() < 0.5)
		RotationRate.Pitch = Rand(180000);
	if ( (RotationRate.Pitch == 0) || (FRand() < 0.8) )
		RotationRate.Roll = Max(0, 50000 + Rand(200000) - RotationRate.Pitch);
}

function ProcessTouch (Actor Other, Vector HitLocation)
{
	local int hitdamage;

	if (Other==none || Other == instigator )
		return;

	PlaySound(ImpactSound, SLOT_Interact, DrawScale/10);

	if(Projectile(Other)!=none)
		Other.Destroy();
	else if (MarioProjectiles(Other) == None)
	{
		Hitdamage = Damage * 0.00002 * (DrawScale**3) * speed;
		if ( (HitDamage > 3) && (speed > 150) && ( Role == ROLE_Authority ))
			Other.TakeDamage(hitdamage, instigator,HitLocation, (35000.0 * Normal(Velocity)*DrawScale), MyDamageType );
	}
}

simulated function Landed(vector HitNormal)
{
    SetPhysics(PHYS_None);
    LifeSpan = 2.0;
}

simulated function HitWall (vector HitNormal, actor Wall)
{
	local vector RealHitNormal;
	local int HitDamage;

	if ( !Wall.bStatic && !Wall.bWorldGeometry && ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
	{
		if ( Level.NetMode != NM_Client )
		{
			Hitdamage = Damage * 0.00002 * (DrawScale**3) * speed;
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController( InstigatorController );
			Wall.TakeDamage( Hitdamage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
	}

	speed = VSize(velocity);
	if (Bounces > 0 && speed > 100)
	{
		MakeSound();
		SetPhysics(PHYS_Falling);
		RealHitNormal = HitNormal;
		if ( FRand() < 0.5 )
			RotationRate.Pitch = Max(RotationRate.Pitch, 100000);
		else
			RotationRate.Roll = Max(RotationRate.Roll, 100000);
		HitNormal = Normal(HitNormal + 0.5 * VRand());
		if ( (RealHitNormal Dot HitNormal) < 0 )
			HitNormal.Z *= -0.7;
		Velocity = 0.7 * (Velocity - 2 * HitNormal * (Velocity Dot HitNormal));
		DesiredRotation = rotator(HitNormal);

		Bounces = Bounces - 1;
		return;
	}
	bFixedRotationDir=false;
	bBounce = false;
}

function MakeSound()
{
	local float soundRad;
	if ( Drawscale > 5.0 )
		soundRad = 80 * DrawScale;
	else
		soundRad = 40* DrawScale;
	PlaySound(ImpactSound, SLOT_Misc, DrawScale/20,,soundRad);
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	if(instigatedBy==none)
		return;

	if(Damage<10)
		return;

	Velocity += Momentum/(DrawScale * 10);
	if (Physics == PHYS_None )
	{
		SetPhysics(PHYS_Falling);
		Velocity.Z += 0.4 * VSize(momentum);
	}
}

function InitFrag(MarioProjectiles myParent, float Pscale)
{
	RotationRate = RotRand();
	Pscale *= (0.5 + FRand());
	SetDrawScale(Pscale * myParent.DrawScale);
	if ( DrawScale <= 2 )
	{
		SetCollisionSize(0,0);
		RemoteRole=ROLE_None;
		bNotOnDedServer=True;
	}
	else
		SetCollisionSize(CollisionRadius * DrawScale/Default.DrawScale, CollisionHeight * DrawScale/Default.DrawScale);

	Velocity = Normal(VRand() + myParent.Velocity/myParent.speed) * (myParent.speed * (0.4 + 0.3 * (FRand() + FRand())));
}

defaultproperties
{
	 ProjectileMesh(0)=StaticMesh'tk_MarioLuigi.MarioLuigi.Coin'
	 ProjectileMesh(1)=StaticMesh'tk_MarioLuigi.MarioLuigi.PowBlock'
	 ProjectileMesh(2)=StaticMesh'tk_MarioLuigi.MarioLuigi.PowerStar'
	 ProjectileMesh(3)=StaticMesh'tk_MarioLuigi.MarioLuigi.QuestionBlock'
	 ProjectileMesh(4)=StaticMesh'tk_MarioLuigi.MarioLuigi.MarioMushroom'
	 ProjectileSkin(0)=Texture'tk_MarioLuigi.MarioLuigi.CoinTex'
     ProjectileSkin(1)=Texture'tk_MarioLuigi.MarioLuigi.PowBlockTex'
     ProjectileSkin(2)=Texture'tk_MarioLuigi.MarioLuigi.PowerStarTex'
     ProjectileSkin(3)=Texture'tk_MarioLuigi.MarioLuigi.QuestionBlockTex'
	 ProjectileSkin(4)=Texture'tk_MarioLuigi.MarioLuigi.RedMushroomTex'
     ProjectileSkin(5)=Texture'tk_MarioLuigi.MarioLuigi.GreenMushroomTex'
     ProjectileSkin(6)=Texture'tk_MarioLuigi.MarioLuigi.BlueMushroomTex'
     Bounces=5
     Speed=1300.000000
     MaxSpeed=2000.000000
     Damage=1000.000000
     MyDamageType=Class'tk_MarioLuigi.DamTypeMarioBlock'
	 ImpactSound=Sound'tK_BaseM.Titan.Rockhit'
	 DrawType=DT_StaticMesh
	 Physics=PHYS_Falling
     LifeSpan=20.000000
     DrawScale=1.300000
     CollisionRadius=45.000000
     CollisionHeight=45.000000
	 bBounce=True
     bFixedRotationDir=True
}
