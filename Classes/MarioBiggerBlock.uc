class MarioBiggerBlock Extends MarioBigBlock
	config(tk_Monsters);

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Speed = UUSpeed;
	MaxSpeed = UUMaxSpeed;
	SaveConfig();
}

function MakeSound()
{
	local float soundRad;
	soundRad = 90 * DrawScale;

	PlaySound(ImpactSound, SLOT_Misc, DrawScale/20,,soundRad);
}
simulated function HitWall (vector HitNormal, actor Wall)
{
	Velocity = 0.95 * (Velocity - 2 * HitNormal * (Velocity Dot HitNormal));
	SetRotation(rotator(HitNormal));
	setDrawScale( DrawScale* 0.27);
	SpawnChunks(4);
	Destroy();
}

defaultproperties
{
	 UUSpeed=1300.000000
	 UUMaxSpeed=2000.000000
     Speed=1900.000000
     MaxSpeed=1900.000000
     StaticMesh=StaticMesh'tk_MarioLuigi.MarioLuigi.Pickups'
     DrawScale=0.500000
     CollisionRadius=65.000000
     CollisionHeight=65.000000
}
