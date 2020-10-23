ALTER TABLE territory
ADD knocked varchar (640)
DEFAULT '["0"]' 
AFTER deleted_at;