--Adding and updating visits

CREATE OR REPLACE FUNCTION
new_visit(
	p_bracelet_id uuid,
	p_start_time  timestamp
)
RETURNS integer AS $$
DECLARE
	res_id integer;
BEGIN
	if (SELECT COUNT(*) FROM visit
	WHERE visit.bracelet_id = p_bracelet_id AND end_time IS NULL 
	LIMIT 1) = 0 then
		INSERT INTO visit(bracelet_id, start_time)
		VALUES(p_bracelet_id, p_start_time)
		RETURNING visit_id INTO res_id;

		INSERT INTO service(servtype_id, visit_id, start_time)
		VALUES(1, res_id, p_start_time);
	else
		RAISE EXCEPTION 'Посещение по данному браслету уже открыто';
	end if;

	RETURN res_id;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION
end_visit (
	p_bracelet_id uuid,
	p_end_time    timestamp
)
RETURNS void AS $$
BEGIN
	UPDATE service
	SET end_time = p_end_time
	FROM visit
	WHERE service.visit_id = (
		SELECT visit_id FROM visit
		WHERE bracelet_id = p_bracelet_id
		AND visit.end_time IS NULL);


	UPDATE visit
	SET end_time = p_end_time
	WHERE bracelet_id = p_bracelet_id;
END;
$$ LANGUAGE plpgSQL;


--Adding and updating services

CREATE OR REPLACE FUNCTION
add_service (
	p_servtype_id   integer,
	p_visit_id 	integer,
	p_start_time 	timestamp
)
RETURNS integer AS $$
BEGIN
	INSERT INTO service (servtype_id, visit_id, start_time)
	VALUES(p_servtype_id, p_visit_id, p_start_time)
	RETURNING service_id AS result;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION
end_service (
	p_service_id integer,
	p_end_time   timestamp
)
RETURNS void AS $$
BEGIN
	UPDATE service
	SET end_time = p_end_time
	WHERE service_id = p_service_id;
END;
$$ LANGUAGE plpgSQL;


--Getting data from tables

CREATE OR REPLACE FUNCTION
get_current_visit(
	OUT p_res   refcursor,
)
RETURNS refcursor AS $$
BEGIN
	OPEN p_res FOR
	SELECT * FROM visit WHERE end_time IS NULL;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION
get_selected_visit(
	OUT p_res     refcursor,
	p_bracelet_id uuid
)
RETURNS refcursor AS $$
BEGIN
	OPEN p_res FOR
	SELECT * FROM visit WHERE bracelet_id = p_bracelet_id;
$END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION
get_current_service(
	OUT p_res     refcursor,
	p_bracelet_id uuid,
)
RETURNS refcursor AS $$
BEGIN
	OPEN p_res FOR
	SELECT st.name, s.start_time FROM service_type AS st
	FULL OUTER JOIN service AS s ON st.service_id = s.service_id
	LEFT JOIN visit AS v ON s.visit_id = v.visit_id
	HAVING v.bracelet_id = p_bracelet_id AND s.end_time IS NULL;
$END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION
get_all_service(
	OUT p_res     refcursor,
	p_bracelet_id uuid,
)
RETURNS refcursor AS $$
BEGIN
	OPEN p_res FOR
	SELECT st.name, st.cost, s.start_time, s.end_time FROM service_type AS st
	FULL OUTER JOIN service AS s ON st.service_id = s.service_id
	LEFT JOIN visit AS v ON s.visit_id = v.visit_id
	WHERE v.bracelet_id = p_bracelet_id;
$END;
$$ LANGUAGE plpgSQL;


