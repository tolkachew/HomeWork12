CREATE DATABASE music_store;

USE music_store;

CREATE TABLE musicians (
  musician_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  musician_name VARCHAR(255) NOT NULL,
  musician_type VARCHAR(255) NOT NULL
);

CREATE TABLE ensembles (
  ensemble_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  ensemble_name VARCHAR(255) NOT NULL,
  ensemble_type VARCHAR(255) NOT NULL
);

CREATE TABLE albums (
  album_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  album_name VARCHAR(255) NOT NULL,
  release_date DATE NOT NULL,
  label_name VARCHAR(255) NOT NULL,
  distributor_address VARCHAR(255) NOT NULL
);

CREATE TABLE tracks (
  track_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  track_name VARCHAR(255) NOT NULL,
  duration INT NOT NULL,
  composer VARCHAR(255) NOT NULL,
  performer_id INT NOT NULL,
  album_id INT NOT NULL,
  FOREIGN KEY (performer_id) REFERENCES musicians(musician_id),
FOREIGN KEY (album_id) REFERENCES albums(album_id)
);

CREATE TABLE copies (
  copy_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  album_id INT NOT NULL,
  copy_number INT NOT NULL,
  purchase_date DATE NOT NULL,
  wholesale_price DECIMAL(10, 2) NOT NULL,
  retail_price DECIMAL(10, 2) NOT NULL,
  sold_last_year INT NOT NULL,
  sold_this_year INT NOT NULL,
  remaining_copies INT NOT NULL,
  FOREIGN KEY (album_id) REFERENCES albums(album_id)
);

--Количество музыкальных произведений заданного ансамбля:
CREATE FUNCTION count_songs_by_band(band_name varchar(255))
RETURNS INT
BEGIN
    DECLARE song_count INT;
    SELECT COUNT(*) INTO song_count
    FROM songs
    WHERE band = band_name;
    RETURN song_count;
END;

--Выводит название всех компакт-дисков заданного ансамбля:
CREATE PROCEDURE get_albums_by_band(band_name varchar(255))
BEGIN
SELECT album_name
FROM albums
WHERE band = band_name;
END;

--Показать лидеров продаж текущего года:
CREATE PROCEDURE get_top_selling_albums()
BEGIN
SELECT album_name
FROM sales
WHERE year = YEAR(CURDATE())
GROUP BY album_name
ORDER BY COUNT(*) DESC
LIMIT 5;
END;

--Изменения данных о компакт-дисках и ввод новых данных:
-- Изменение названия альбома
CREATE PROCEDURE update_album_name(album_id INT, new_album_name varchar(255))
BEGIN
UPDATE albums
SET album_name = new_album_name
WHERE id = album_id;
END;
-- Изменение цены альбома
CREATE PROCEDURE update_album_price(album_id INT, new_price DECIMAL(10,2))
BEGIN
UPDATE albums
SET price = new_price
WHERE id = album_id;
END;
-- Ввод нового альбома
CREATE PROCEDURE add_new_album(band_name varchar(255), album_name varchar(255), price DECIMAL(10,2))
BEGIN
INSERT INTO albums (band, album_name, price)
VALUES (band_name, album_name, price);
END;

--Ввод новых данных об ансамблях:
CREATE PROCEDURE add_new_band(band_name varchar(255), description varchar(255))
BEGIN
INSERT INTO bands (band_name, description)
VALUES (band_name, description);
END;