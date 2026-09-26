1. Que musico ha pertenecidos a mas bandas?
SELECT
    mn.musician_name,
    COUNT(DISTINCT bm.band_id) AS total_bandas
FROM musician_name mn
JOIN band_musician bm
    ON mn.musician_id = bm.musician_id
GROUP BY mn.musician_id, mn.musician_name
ORDER BY total_bandas DESC
LIMIT 1;

2. Que músico ha participado en más álbumes?
SELECT
    mn.musician_name,
    COUNT(DISTINCT a.album_id) AS total_albumes
FROM musician_name mn
JOIN band_musician bm
    ON mn.musician_id = bm.musician_id
JOIN album a
    ON bm.band_id = a.band_id
GROUP BY mn.musician_id, mn.musician_name
ORDER BY total_albumes DESC
LIMIT 1;

3. Que banda ha hecho más discos?
SELECT
    b.band_name,
    COUNT(a.album_id) AS total_discos
FROM band b
JOIN album a
    ON b.band_id = a.band_id
GROUP BY b.band_id, b.band_name
ORDER BY total_discos DESC
LIMIT 1;
