import re

def import_species(filepath):
    with open(filepath, 'r') as f:
        for line in f:

            if 'INSERT INTO `species`' in line:
                entries = re.findall(r"\((\d+),'([^']+)'\)", line)

                for entry in entries:
                    species_id, name = entry
                    print(f"INSERT INTO species (species_id, name) VALUES ({species_id}, '{name}');")


def import_personalities(filepath):
    with open(filepath, 'r') as f:
        for line in f:

            if 'INSERT INTO `personalities`' in line:
                entries = re.findall(r"\((\d+),'([^']+)','([^']+)','([^']+)','([^']+)','([^']+)','([^']+)'\)", line)

                for entry in entries:
                    personality_id, personality, attitude, voice, main_interest, sleep, wake = entry
                    print(f"INSERT INTO personalities (personality_id, personality, attitude, voice, main_interest, sleep, wake) VALUES ({personality_id}, '{personality}', '{attitude}', '{voice}', '{main_interest}', '{sleep}', '{wake}');")


def import_seasons_events_types(filepath):
    with open(filepath, 'r') as f:
        for line in f:

            if 'INSERT INTO `seasons_events_types`' in line:
                entries = re.findall(r"\((\d+),'([^']+)'\)", line)

                for entry in entries:
                    type_id, type_ = entry
                    print(f"INSERT INTO seasons_events_types (type_id, type) VALUES ({type_id}, '{type_}');")


def import_villagers(filepath):
    with open(filepath, 'r') as f:
        for line in f:
            line = line.replace("\\'", "APOSTROPHE")

            if 'INSERT INTO `villagers`' in line:
                entries = re.findall(r"\((\d+),(\d+),(\d+),'([^']+)','([^']+)','([^']+)','([^']+)'\)", line)

                for entry in entries:
                    villager_id, species_id, personality_id, name, gender, birthday, subtype = entry
                    name = name.replace("APOSTROPHE", "''")
                    print(f"INSERT INTO villagers (villager_id, species_id, personality_id, name, gender, birthday, subtype) VALUES ({villager_id}, {species_id}, {personality_id}, '{name}', '{gender}', '{birthday}', '{subtype}');")


def import_traits(filepath):
    with open(filepath, 'r') as f:
        for line in f:
            line = line.replace("\\'", "APOSTROPHE")

            if 'INSERT INTO `traits`' in line:
                entries = re.findall(r"\((\d+),'([^']+)','([^']+)','([^']+)','([^']+)','([^']+)','([^']+)','([^']+)','([^']+)'\)", line)

                for entry in entries:
                    villager_id, hobby, fav_song, fav_saying, catchphrase, style1, style2, color1, color2 = entry
                    fav_saying = fav_saying.replace("APOSTROPHE", "''")
                    fav_song = fav_song.replace("APOSTROPHE", "''")
                    catchphrase = catchphrase.replace("APOSTROPHE", "''")
                    hobby = hobby.replace("APOSTROPHE", "''")
                    print(f"INSERT INTO traits (villager_id, hobby, fav_song, fav_saying, catchphrase, style1, style2, color1, color2) VALUES ({villager_id}, '{hobby}', '{fav_song}', '{fav_saying}', '{catchphrase}', '{style1}', '{style2}', '{color1}', '{color2}');")


def import_seasons_events(filepath):
    with open(filepath, 'r') as f:
        for line in f:
            line = line.replace("\\'", "APOSTROPHE")

            if 'INSERT INTO `seasons_events`' in line:
                entries = re.findall(r"\((\d+),(\d+),'([^']+)','([^']+)','([^']+)','([^']+)','([^']+)','([^']+)','([^']+)','([^']+)','([^']+)'\)", line)

                for entry in entries:
                    event_id, type_id, name, start_date, end_date, date_vary_year, start_time, end_time, next_day_overlap, version_added, version_last_updated = entry
                    name = name.replace("APOSTROPHE", "''")
                    print(f"INSERT INTO seasons_events (event_id, type_id, name, start_date, end_date, date_vary_year, start_time, end_time, next_day_overlap, version_added, version_last_updated) VALUES ({event_id}, {type_id}, '{name}', '{start_date}', '{end_date}', '{date_vary_year}', '{start_time}', '{end_time}', '{next_day_overlap}', '{version_added}', '{version_last_updated}');")

if __name__ == "__main__":
    import_species('data/ACNH.sql')
    import_personalities('data/ACNH.sql')
    import_seasons_events_types('data/ACNH.sql')
    import_villagers('data/ACNH.sql')
    import_traits('data/ACNH.sql')
    import_seasons_events('data/ACNH.sql')