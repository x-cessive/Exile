player addEventHandler ["WeaponAssembled",{params ["_unit", "_staticWeapon"];clearItemCargoGlobal _staticWeapon;_staticWeapon setVariable ["ExileOwnerUID", getPlayerUID player,true];_staticWeapon enableSimulationGlobal true;_staticWeapon setOwner (owner player);}];
//Add above line before the final "true"
true
