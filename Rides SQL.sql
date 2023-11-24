#create data base CYCLE
#IMPORT DATA TRIP_DATA 2012
#CHECK FOR UNIQUE VALUES
select distinct count(*) from trip_data; -- total values were 131400
#REMOVE NULL VALUES
delete from trip_data
where ride_id is null or rideable_type is null or started_at is null or ended_at is null or start_station_id is null
	or start_station_name is null or end_station_name or end_station_id is null or start_lat is null
    or start_lng is null or end_lat is null or end_lng is null or member_casual is null;
#DELETEING ALL EMPTY VALUES 
delete from trip_data
where trim(start_station_name) = ' ';
select * from trip_data
#ADDING NEW COLUMN TO FIND THE DIFFERNCE BETWEEN START AND END TIME
ALTER table trip_data
add column ride_length timestamp;

	SELECT started_at as starttime,
	ended_at as endtime,
	timediff(ended_at,started_at) as differnce from trip_data;
    
    update trip_data
    set ride_length = timediff(ended_at,started_at);

ALTER table trip_data
modify COLUMN ride_length TIME;
#ADDING COLOUMN OF WEEK STARTED_AT
select started_at, dayname(started_at) from trip_data;
alter table trip_data
add column day_of_week varchar(20);
update trip_data
set day_of_week = dayname(started_at);

#mean of avergae ride_length
select ride_length, round(avg(ride_length),5) AS average_length from trip_data
group by ride_length
order by  average_length desc;

select * from trip_data;

alter table trip_data
add column average_lenght int;

UPDATE trip_data
SET average_lenght = (
    SELECT AVG(ride_length)
    FROM (
        SELECT ride_length
        FROM trip_data
        WHERE ride_length IS NOT NULL
    ) AS subquery);

#calculating most riders for a weekday
select day_of_Week, max(day_of_week),count(day_of_week) from trip_data
group by day_of_Week
order by count(day_of_week) desc;

alter table trip_data
add column most_ride_weekday varchar(50);

UPDATE trip_data
SET most_ride_weekday = CONCAT(MAX(day_of_week), COUNT(day_of_week));

UPDATE trip_data
SET most_ride_weekday = (
    SELECT CONCAT(day_of_week, day_count)
    FROM (
        SELECT day_of_week, COUNT(day_of_week) as day_count
        FROM trip_data
        GROUP BY day_of_week
        ORDER BY day_count DESC
        LIMIT 1
    ) AS subquery
);

#Statistical summary

SELECT
    COUNT(*) AS total_records,
    
    COUNT(DISTINCT ride_id) AS distinct_ride_id_count,
    MIN(ride_id) AS min_ride_id,
    MAX(ride_id) AS max_ride_id,
    AVG(ride_id) AS avg_ride_id,
    
    COUNT(DISTINCT rideable_type) AS distinct_rideable_type_count,
    MIN(rideable_type) AS min_rideable_type,
    MAX(rideable_type) AS max_rideable_type,
    AVG(rideable_type) AS avg_rideable_type,
    
    COUNT(DISTINCT started_at) AS distinct_started_at_count,
    MIN(started_at) AS min_started_at,
    MAX(started_at) AS max_started_at,
    AVG(started_at) AS avg_started_at,
    
    COUNT(DISTINCT ended_at) AS distinct_ended_at_count,
    MIN(ended_at) AS min_ended_at,
    MAX(ended_at) AS max_ended_at,
    AVG(ended_at) AS avg_ended_at,
    
    COUNT(DISTINCT start_station_id) AS distinct_start_station_id_count,
    MIN(start_station_id) AS min_start_station_id,
    MAX(start_station_id) AS max_start_station_id,
    AVG(start_station_id) AS avg_start_station_id,
    
    COUNT(DISTINCT start_station_name) AS distinct_start_station_name_count,
    MIN(start_station_name) AS min_start_station_name,
    MAX(start_station_name) AS max_start_station_name,
    AVG(start_station_name) AS avg_start_station_name,
    
    COUNT(DISTINCT end_station_name) AS distinct_end_station_name_count,
    MIN(end_station_name) AS min_end_station_name,
    MAX(end_station_name) AS max_end_station_name,
    AVG(end_station_name) AS avg_end_station_name,
    
    COUNT(DISTINCT end_station_id) AS distinct_end_station_id_count,
    MIN(end_station_id) AS min_end_station_id,
    MAX(end_station_id) AS max_end_station_id,
    AVG(end_station_id) AS avg_end_station_id,
    
    COUNT(DISTINCT start_lat) AS distinct_start_lat_count,
    MIN(start_lat) AS min_start_lat,
    MAX(start_lat) AS max_start_lat,
    AVG(start_lat) AS avg_start_lat,
    
    COUNT(DISTINCT start_lng) AS distinct_start_lng_count,
    MIN(start_lng) AS min_start_lng,
    MAX(start_lng) AS max_start_lng,
    AVG(start_lng) AS avg_start_lng,
    
    COUNT(DISTINCT end_lat) AS distinct_end_lat_count,
    MIN(end_lat) AS min_end_lat,
    MAX(end_lat) AS max_end_lat,
    AVG(end_lat) AS avg_end_lat,
    
    COUNT(DISTINCT end_lng) AS distinct_end_lng_count,
    MIN(end_lng) AS min_end_lng,
    MAX(end_lng) AS max_end_lng,
    AVG(end_lng) AS avg_end_lng,
    
    COUNT(DISTINCT member_casual) AS distinct_member_casual_count
FROM
    trip_data;
