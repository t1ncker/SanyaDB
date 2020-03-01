--Adding and updating visits

CREATE OR REPLACE FUNCTION
new_visit(
	p_bracelet_id uuid,
	p_start_time  timestamp
)
RETURNS integer AS $$
	INSERT INTO visit(bracelet_id, start_time)
	VALUES(p_bracelet_id, p_start_time)
	RETURNING visit_id AS result;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION
end_visit (
	p_visit_id integer,
	p_end_time timestamp
)
RETURNS void AS $$
	UPDATE visit
	SET end_time = p_end_time
	WHERE visit_id = p_visit_id;
$$ LANGUAGE SQL;


--Adding and updating services

CREATE OR REPLACE FUNCTION
add_service (
	p_servtype_id   integer,
	p_visit_id 	integer,
	p_start_time 	timestamp
)
RETURNS integer AS $$
	INSERT INTO service (servtype_id, visit_id, start_time)
	VALUES(p_servtype_id, p_visit_id, p_start_time)
	RETURNING service_id AS result;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION
end_service (
	p_service_id integer,
	p_end_time   timestamp
)
RETURNS integer AS $$
	UPDATE service
	SET end_time = p_end_time
	WHERE service_id = p_service_id;
$$ LANGUAGE SQL;


--Getting data from tables

CREATE OR REPLACE FUNCTION
get_current_visit(
	OUT p_res   refcursor,
)
RETURNS refcursor AS $$
	OPEN p_res FOR
	SELECT * FROM visit WHERE end_time IS NULL;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION
get_ford_mustang_visit(
	OUT p_res   refcursor,
)
RETURNS refcursor AS $$
	OPEN p_res FOR
	SELECT ford_mustanf FROM visit WHERE ;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION
get_service(
	OUT p_res refcursor,

)
RETURNS AS $$

$$ LANGUAGE SQL;

