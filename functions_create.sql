CREATE OR REPLACE FUNCTION
new_visit(
	bracelet_id uuid,
	start_time  timestamp,
	end_time    timestamp
)
RETURNS integer AS $$

	INSERT INTO visit
	VALUES()
	RETURNING visit_id AS result;

$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION
name ()
RETURNS integer AS $$

	INSERT INTO table_name
	VALUES()
	RETURNING AS result;

$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION
name ()
RETURNS integer AS $$

	INSERT INTO table_name
	VALUES()
	RETURNING AS result;

$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION
name ()
RETURNS integer AS $$

	INSERT INTO table_name
	VALUES()
	RETURNING AS result;

$$ LANGUAGE SQL;


