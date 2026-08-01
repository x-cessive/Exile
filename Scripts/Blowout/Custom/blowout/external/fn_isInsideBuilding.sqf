private["_unit1","_building","_type","_relPos","_boundingBox","_min","_max","_myX","_myY","_myZ","_inside"];
diag_log "BLOWOUT - BUILDING CHECK";
_unit1 = _this select 0;
_startPosition = getPosASL _unit1;
_endPosition = [_startPosition select 0, _startPosition select 1, (_startPosition select 2 ) + 20];
_intersections = lineIntersectsSurfaces [_startPosition, _endPosition, _unit1, objNull, false, 1, "GEOM", "VIEW"];
_inside = !(_intersections isEqualTo []);
if!(_inside)then
{
	_inside = false;
}
else
{
	_inside = true;
};
diag_log _inside;
_inside