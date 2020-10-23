/*
	Credit for this method goes to He-Man who first suggested it.
*/

//_player = _this select 0;
if ((_this select 0) isKindOf "Man" && isPlayer (_this select 0)) then 
{
	_this  call EPOCH_server_effectCrypto;
};


