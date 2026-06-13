CREATE TABLE IF NOT EXISTS species (
    species_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS personalities (
    personality_id INTEGER PRIMARY KEY,
    personality TEXT NOT NULL CHECK (personality IN ('Big Sister', 'Cranky', 'Jock', 'Lazy', 'Normal', 'Peppy', 'Smug', 'Snooty')),
    attitude TEXT NOT NULL CHECK (attitude IN ('rude', 'bitter', 'energetic', 'relaxed', 'sweet', 'excited', 'arrogant', 'polite')),
    voice TEXT NOT NULL CHECK (voice IN ('gruff', 'deep', 'loud', 'goofy', 'neutral', 'chipper', 'sophisticated', 'charming')),
    main_interest TEXT NOT NULL CHECK (main_interest IN ('fighting', 'complaining', 'sports', 'bugs', 'daydreaming', 'fame', 'gossip', 'cleaning')),
    sleep TEXT NOT NULL,
    wake TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS villagers (
    villager_id INTEGER PRIMARY KEY,
    species_id INTEGER NOT NULL,
    personality_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    gender TEXT NOT NULL CHECK (gender IN ("Male", "Female")),
    birthday TEXT NOT NULL,
    subtype TEXT NOT NULL CHECK (subtype IN ('A', 'B')),
    photo_url TEXT,
    FOREIGN KEY (species_id) REFERENCES species(species_id),
    FOREIGN KEY (personality_id) REFERENCES personalities(personality_id)
);

CREATE TABLE IF NOT EXISTS traits (
    villager_id INTEGER PRIMARY KEY,
    hobby TEXT NOT NULL CHECK (hobby IN ('Nature', 'Fitness', 'Play', 'Education', 'Fashion', 'Music')),
    fav_song TEXT NOT NULL,
    fav_saying TEXT NOT NULL,
    catchphrase TEXT NOT NULL,
    style1 TEXT NOT NULL CHECK (style1 IN ('Active', 'Cool', 'Simple', 'Cute', 'Gorgeous', 'Elegant')),
    style2 TEXT NOT NULL CHECK (style2 IN ('Active', 'Cool', 'Simple', 'Cute', 'Gorgeous', 'Elegant')),
    color1 TEXT NOT NULL CHECK (color1 IN ('Aqua', 'Black', 'Blue', 'Pink', 'Red', 'Yellow', 'Green', 'Colorful', 'Orange', 'Purple', 'Brown', 'Beige', 'White', 'Gray')),
    color2 TEXT NOT NULL CHECK (color2 IN ('Aqua', 'Black', 'Blue', 'Pink', 'Red', 'Yellow', 'Green', 'Colorful', 'Orange', 'Purple', 'Brown', 'Beige', 'White', 'Gray')),
    FOREIGN KEY (villager_id) REFERENCES villagers(villager_id)
);

CREATE TABLE IF NOT EXISTS seasons_events_types (
    type_id INTEGER PRIMARY KEY,
    type TEXT NOT NULL CHECK (type IN ('Basegame Event', 'Special Event', 'Nook Shopping Event', 'Calendar Season', 'Zodiac Season'))
);

CREATE TABLE IF NOT EXISTS seasons_events (
    event_id INTEGER PRIMARY KEY,
    type_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    start_date TEXT NOT NULL,
    end_date TEXT NOT NULL,
    date_vary_year TEXT NOT NULL CHECK (date_vary_year IN ('Yes', 'No')),
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    next_day_overlap TEXT NOT NULL CHECK (next_day_overlap IN ('Yes', 'No')),
    version_added TEXT NOT NULL,
    version_last_updated TEXT NOT NULL,
    FOREIGN KEY (type_id) REFERENCES seasons_events_types(type_id)
);



