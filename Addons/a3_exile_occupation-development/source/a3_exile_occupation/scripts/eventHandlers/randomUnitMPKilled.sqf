// Get the variables from the event handler
_unit 			= _this select 0;

_group = group _unit;
_selectedPlayer = _group getVariable "SC_huntedPlayer";

if((count (units _group)) == 0) then
{
	// Remove the group
	SC_liveRandomGroups = SC_liveRandomGroups - _group;  
};