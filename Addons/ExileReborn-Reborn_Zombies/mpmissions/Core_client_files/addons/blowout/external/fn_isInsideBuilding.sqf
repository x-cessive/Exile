/* Property of DayZ modification - http://www.dayzmod.com/ */
private["_unit1","_building","_type","_relPos","_boundingBox","_min","_max","_myX","_myY","_myZ","_inside"];
diag_log "BLOWOUT - BUILDING CHECK";
_unit1 = _this select 0;
//_building = _this select 1;
_building = nearestObject [_unit1, "HouseBase"];
 
_type = typeOf _building;

_relPos = _building worldToModel (getPosATL _unit1);
_boundingBox = boundingBox _building;
//diag_log ("DEBUG: Building: " + str(_building) );
//diag_log ("DEBUG: Building Type: " + str(_type) );
//diag_log ("DEBUG: BoundingBox: " + str(_boundingBox) );

_min = _boundingBox select 0;
_max = _boundingBox select 1;
			 
//diag_log ("Min: " + str(_min) );
//diag_log ("Max: " + str(_max) );
			 
_myX = _relPos select 0;
_myY = _relPos select 1;
_myZ = _relPos select 2;
			 
//diag_log ("X: " + str(_myX) );
//diag_log ("Y: " + str(_myY) );
//diag_log ("Z: " + str(_myZ) );
	
if ((_myX > (_min select 0)) and (_myX < (_max select 0))) then {
		if ((_myY > (_min select 1)) and (_myY < (_max select 1))) then {
				if ((_myZ > (_min select 2)) and (_myZ < (_max select 2))) then {
						_inside = true;
				} else { _inside = false; };
		} else { _inside = false; };
} else { 
_inside = false; 
};

_inside