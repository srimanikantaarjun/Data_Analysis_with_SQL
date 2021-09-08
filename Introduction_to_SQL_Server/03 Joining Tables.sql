
-- Perform an inner join between album and track using the album_id column.
SELECT 
  track_id,
  name AS track_name,
  title AS album_title
FROM track
  -- Complete the join type and the common joining column
INNER JOIN album on track.album_id = album.album_id;


-- We'll use the album table as last time, but will join it to a new table - artist - 
-- which consists of two columns: artist_id and name.
-- Select album_id and title from album, and name from artist
SELECT 
  album.album_id,
  album.title,
  artist.name AS artist
  -- Enter the main source table name
FROM album
  -- Perform the inner join
INNER JOIN artist on artist.artist_id = album.artist_id;


SELECT track_id,
-- Enter the correct table name prefix when retrieving the name column from the track table
  track.name AS track_name,
  title as album_title,
  -- Enter the correct table name prefix when retrieving the name column from the artist table
  artist.name AS artist_name
FROM track
  -- Complete the matching columns to join album with track, and artist with album
INNER JOIN album on track.album_id = album.album_id 
INNER JOIN artist on album.artist_id = artist.artist_id;


SELECT 
  invoiceline_id,
  unit_price, 
  quantity,
  billing_state
  -- Specify the source table
FROM invoiceline
  -- Complete the join to the invoice table
LEFT JOIN invoice
ON invoiceline.invoice_id = invoice.invoice_id;


-- SELECT the fully qualified album_id column from the album table
SELECT 
  album.album_id,
  title,
  album.artist_id,
  -- SELECT the fully qualified name column from the artist table
  artist.name as artist
FROM album
-- Perform a join to return only rows that match from both tables
INNER JOIN artist ON album.artist_id = artist.artist_id
WHERE album.album_id IN (213,214)


SELECT 
  album.album_id,
  title,
  album.artist_id,
  artist.name as artist
FROM album
INNER JOIN artist ON album.artist_id = artist.artist_id
-- Perform the correct join type to return matches or NULLS from the track table
RIGHT JOIN track on album.album_id = track.album_id
WHERE album.album_id IN (213,214)


SELECT 
  album_id AS ID,
  title AS description,
  'Album' AS Source
  -- Complete the FROM statement
FROM album
 -- Combine the result set using the relevant keyword
UNION
SELECT 
  artist_id AS ID,
  name AS description,
  'Artist'  AS Source
  -- Complete the FROM statement
FROM artist;