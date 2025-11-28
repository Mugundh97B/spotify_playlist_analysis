show databases;
create database spotify_analysis;
use spotify_analysis;
show tables;
ALTER TABLE sounds_eng MODIFY COLUMN duration_min FLOAT;
alter table sounds_eng modify column popularity int;
desc sounds_eng;

select * from sounds_eng where track_name in ('After Hours' , 'Without Me', 'Dirty Paws');

-- 1 Most Popular Song
select track_name, popularity from sounds_eng order by popularity desc limit 1;

-- 2 Top 5 Artists with Highest Average Popularity
select artist, avg(popularity) as avg_popularity from sounds_eng group by artist order by avg_popularity desc limit 5;

SELECT artist, COUNT(*) AS song_count, AVG(popularity) AS avg_popularity FROM sounds_eng
GROUP BY artist
ORDER BY song_count DESC, avg_popularity DESC
LIMIT 5;

-- 3 Longest Song in the Playlist
select * from sounds_eng order by duration_min desc limit 1;

-- 4 Total & Average Duration of Songs per Artist
select artist , count(track_name), avg(duration_min) as avg_song_time from sounds_eng
group by artist order by avg_song_time desc;

-- 5 Find Artists with More Than 5 Songs in Playlist
select artist, count(track_name) as total_songs from sounds_eng 
group by artist having total_songs > 4 order by total_songs desc;

-- 6 Using Subquery – Songs With Above Average Popularity
select * from sounds_eng where popularity > (select avg(popularity) from sounds_eng)
order by popularity desc limit 10;

-- 7 Find Top 3 Longest Songs Per Artist (Window Function)
with ranked_songs as (
select artist, track_name, duration_min, row_number() over (partition by artist order by duration_min desc)as long_songs
from sounds_eng
)
select * from ranked_songs where long_songs <=3 order by artist;

-- 8 Category Songs based on Duration
select artist, track_name, duration_min,
case 
when duration_min < 2.5 then 'short'
when 2.5<= duration_min <4.5 then 'medium'
else 'long'
end as song_lenghth_type
from sounds_eng where artist = 'The weeknd';

-- 9 Which Album Has the Most Popularity?
with ranked_album as(
select artist, album,avg(popularity)as avg_popularity , row_number() over(partition by album order by avg(popularity) desc )as album_rank
from sounds_eng group by artist, album
)
select * from ranked_album where album_rank = 1 order by avg_popularity desc ;

-- 10 Total Songs, Avg Popularity, Max Duration – Full Summary
select album , count(track_name) as total_songs, avg(popularity) as avg_popularity, max(duration_min)as the_long_song from sounds_eng group by album;