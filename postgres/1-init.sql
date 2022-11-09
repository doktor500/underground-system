CREATE TABLE TRIPS (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  start_station VARCHAR(100) NOT NULL,
  start_time INTEGER NOT NULL,
  end_station VARCHAR(100),
  end_time INTEGER
);

ALTER TABLE TRIPS REPLICA IDENTITY FULL;

INSERT INTO TRIPS (user_id, start_station, start_time, end_station, end_time) VALUES (1, 'origin', 0, 'destination', 1);
INSERT INTO TRIPS (user_id, start_station, start_time, end_station, end_time) VALUES (1, 'origin', 1, 'destination', 4);
