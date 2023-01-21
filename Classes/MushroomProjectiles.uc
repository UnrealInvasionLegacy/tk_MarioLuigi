class MushroomProjectiles extends MarioProjectiles;

var array<Texture> MushroomSkins;

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
    Skins[0] = MushroomSkins[Rand(MushroomSkins.Length)];

    if (Skins[0] == MushroomSkins[0])
    {
        SetDrawScale(1.300000);
        SetCollisionSize(45.000000, 45.000000);
    }
    else if (skins[0] == MushroomSkins[1])
    {
        SetDrawScale(0.800000);
        SetCollisionSize(30.000000, 30.000000);
    }
    else if (skins[0] == MushroomSkins[2])
    {
        SetDrawScale(0.300000);
        SetCollisionSize(10.000000, 10.000000);
    }

	if (FRand() < 0.5)
		RotationRate.Pitch = Rand(180000);
	if ( (RotationRate.Pitch == 0) || (FRand() < 0.8) )
		RotationRate.Roll = Max(0, 50000 + Rand(200000) - RotationRate.Pitch);
}

defaultproperties
{
	 ProjectileMesh(0)=StaticMesh'tk_MarioLuigi.MarioLuigi.MarioMushroom'
	 ProjectileMesh(1)=StaticMesh'tk_MarioLuigi.MarioLuigi.MarioMushroom'
     MushroomSkins(0)=Texture'tk_MarioLuigi.MarioLuigi.RedMushroomTex'
     MushroomSkins(1)=Texture'tk_MarioLuigi.MarioLuigi.GreenMushroomTex'
     MushroomSkins(2)=Texture'tk_MarioLuigi.MarioLuigi.BlueMushroomTex'
     DrawScale=1.300000
     CollisionRadius=45.000000
     CollisionHeight=45.000000
}