--CRUD Operations

--CREATE
--	1. Databases, Tables and View
--	2. Users, Permissions and Security Groups - Database administrators
--READ
--	1. Example : SELECT statements
--UPDATE
--	1. Amend existing database records
--DELETE
--	1. [Depends on permissions]

-- Create a table named 'results' with 3 VARCHAR columns called track, artist, and album, 
-- with lengths 200, 120, and 160, respectively.
-- Create the table
CREATE TABLE results(
	-- Create track column
	track VARCHAR(200),
    -- Create artist column
	artist VARCHAR(120),
    -- Create album column
	album VARCHAR(160),);


-- Create one integer column called track_length_mins
-- Create the table
CREATE TABLE results (
	-- Create track column
	track VARCHAR(200),
    -- Create artist column
	artist VARCHAR(120),
    -- Create album column
	album VARCHAR(160),
	-- Create track_length_mins
	track_length_mins INT,
	);


-- SELECT all the columns from your new table. No rows will be returned,
-- but you can confirm that the table has been created.
-- Create the table
CREATE TABLE results (
	-- Create track column
	track VARCHAR(200),
    -- Create artist column
	artist VARCHAR(120),
    -- Create album column
	album VARCHAR(160),
	-- Create track_length_mins
	track_length_mins INT,
	);

-- Select all columns from the table
SELECT 
  track, 
  artist, 
  album, 
  track_length_mins 
FROM 
  results;


-- Create a table called tracks with 2 VARCHAR columns named track and album, and
-- one integer column named track_length_mins. Then SELECT all columns from your
-- new table using the * shortcut to verify the table structure.
-- Create the table
CREATE TABLE tracks(
	-- Create track column
	track VARCHAR(200),
    -- Create album column
  	album VARCHAR(160),
	-- Create track_length_mins column
	track_length_mins INT
);
-- Select all columns from the new table
SELECT 
  * 
FROM 
  tracks;


-- Insert the track 'Basket Case', from the album 'Dookie', with a track length of 3, into
-- the appropriate columns. Then perform the SELECT * once more to view your newly inserted row.
-- Create the table
CREATE TABLE tracks(
  -- Create track column
  track VARCHAR(200), 
  -- Create album column
  album VARCHAR(160), 
  -- Create track_length_mins column
  track_length_mins INT
);
-- Complete the statement to enter the data to the table         
INSERT INTO tracks
-- Specify the destination columns
(track, album, track_length_mins)
-- Insert the appropriate values for track, album and track length
VALUES
  ('Basket Case', 'Dookie', 3);
-- Select all columns from the new table
SELECT 
  *
FROM 
  tracks;


-- Select the title column from the album table where the album_id is 213.
-- Select the album
SELECT 
  title
FROM 
  album
WHERE 
  album_id = 213;


-- Use an UPDATE statement to modify the title to 'Pure Cult: The Best Of The Cult'
-- Run the query
SELECT 
  title 
FROM 
  album 
WHERE 
  album_id = 213;
-- UPDATE the album table
UPDATE
  album
-- SET the new title    
SET
  title = 'Pure Cult: The Best Of The Cult'
WHERE album_id = 213;


-- DELETE the record from album where album_id is 1 and then hit 'Submit Answer'.
-- Run the query
SELECT 
  * 
FROM 
  album 
  -- DELETE the record
DELETE FROM 
  album
WHERE 
  album_id = 1
  -- Run the query again
SELECT 
  * 
FROM 
  album;


-- DECLARE VARIABLES

-- DECLARE the variable @region, which has a data type of VARCHAR and length of 10.
DECLARE @region VARCHAR(10)


-- SET your newly defined variable to 'RFC'.
-- Declare the variable @region
DECLARE @region VARCHAR(10)

-- Update the variable value
SET @region = 'RFC'


-- Declare the variable @region
DECLARE @region VARCHAR(10)

-- Update the variable value
SET @region = 'RFC'

SELECT description,
       nerc_region,
       demand_loss_mw,
       affected_customers
FROM grid
WHERE nerc_region = @region;


-- Declare a new variable called @start of type DATE.
-- Declare @start
DECLARE @start DATE

-- SET @start to '2014-01-24'
SET @start = '2014-01-24'


-- Declare a new variable called @stop of type DATE.
-- Declare @start
DECLARE @start DATE

-- Declare @stop
DECLARE @stop DATE

-- SET @start to '2014-01-24'
SET @start = '2014-01-24'

-- SET @stop to '2014-07-02'
SET @stop = '2014-07-02';


-- Declare a new variable called @affected of type INT.
-- Declare @start @stop
DECLARE @start DATE
DECLARE @stop DATE
-- Declare @affected
DECLARE @affected INT

-- SET @start to '2014-01-24'
SET @start = '2014-01-24'
-- SET @stop to '2014-07-02'
SET @stop  = '2014-07-02'
-- Set @affected to 5000
SET @affected = 5000


-- Retrieve all rows where event_date is BETWEEN @start and @stop and
-- affected_customers is greater than or equal to @affected.
-- Declare your variables
DECLARE @start DATE
DECLARE @stop DATE
DECLARE @affected INT;
-- SET the relevant values for each variable
SET @start = '2014-01-24'
SET @stop  = '2014-07-02'
SET @affected =  5000 ;

SELECT 
  description,
  nerc_region,
  demand_loss_mw,
  affected_customers
FROM 
  grid
-- Specify the date range of the event_date and the value for @affected
WHERE event_date BETWEEN @start AND @stop
AND affected_customers >= @affected;


-- Create a temporary table called maxtracks. Make sure the table name starts with #.
-- Join album to artist using artist_id, and track to album using album_id.
-- Run the final SELECT statement to retrieve all the columns from your new table.
SELECT  album.title AS album_title,
  artist.name as artist,
  MAX(track.milliseconds / (1000 * 60) % 60 ) AS max_track_length_mins
-- Name the temp table #maxtracks
INTO #maxtracks
FROM album
-- Join album to artist using artist_id
INNER JOIN artist ON album.artist_id = artist.artist_id
-- Join track to album using album_id
INNER JOIN track ON track.album_id = album.album_id
GROUP BY artist.artist_id, album.title, artist.name,album.album_id
-- Run the final SELECT query to retrieve the results from the temporary table
SELECT album_title, artist, max_track_length_mins
FROM  #maxtracks
ORDER BY max_track_length_mins DESC, artist;

