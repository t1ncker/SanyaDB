BEGIN

CREATE TABLE service_type (
	servtype_id    SERIAL PRIMARY KEY,
	name           VARCHAR(128) NOT NULL UNIQUE,
	cost           MONEY,
	duration_start TIMESTAMP,
	duration_end   TIMESTAMP
);

CREATE TABLE service (
	service_id  SERIAL PRIMARY KEY,
	servtype_id INTEGER REFERENCES service_type (servtype_id),
	visit_id    INTEGER REFERENCES visit (visit_id),
	start_time  TIMESTAMP,
	end_time    TIMESTAMP
);

CREATE TABLE discount_type (
	disctype_id SERIAL PRIMARY KEY,
	name        VARCHAR(128) NOT NULL UNIQUE,
	value       NUMERIC
);

CREATE TABLE discounts (
	discount_id SERIAL PRIMARY KEY,
	disctype_id INTEGER REFERENCES discount_type (disctype_id),
	visit_id    INTEGER REFERENCES visit (visit_id)
);

CREATE TABLE visit (
	visit_id    SERIAL PRIMARY KEY,
	bracelet_id UUID,
	start_time  TIMESTAMP,
	end_time    TIMESTAMP
);

COMMIT;
