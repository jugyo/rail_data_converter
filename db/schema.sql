CREATE TABLE rail_load_sections (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
  "section_id" varchar(40) DEFAULT NULL, 
  "curve_id" varchar(40) DEFAULT NULL, 
  "rail_way_class" INTEGER DEFAULT NULL, 
  "institution_type" INTEGER DEFAULT NULL, 
  "line_name" varchar(40) DEFAULT NULL, 
  "operation_company" varchar(40) DEFAULT NULL
);

CREATE TABLE rail_stations (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
  "station_id" varchar(40) DEFAULT NULL, 
  "curve_id" varchar(40) DEFAULT NULL, 
  "rail_way_class" INTEGER DEFAULT NULL, 
  "institution_type" INTEGER DEFAULT NULL, 
  "line_name" varchar(40) DEFAULT NULL, 
  "operation_company" varchar(40) DEFAULT NULL, 
  "station_name" varchar(40) DEFAULT NULL, 
  "rail_load_section_id" varchar(40) DEFAULT NULL
);

CREATE TABLE rail_curves (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
  "curve_id" varchar(255) DEFAULT NULL, 
  "curve" varchar(255) DEFAULT NULL
);

CREATE TABLE rail_points (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
  "point_id" varchar(255) DEFAULT NULL, 
  "lat" DOUBLE DEFAULT NULL, 
  "lng" DOUBLE DEFAULT NULL
);

