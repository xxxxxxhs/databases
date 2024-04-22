CREATE OR REPLACE FUNCTION verify_character_location()
RETURNS TRIGGER AS $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM area_object WHERE id = NEW.location_area_id) THEN
    RAISE EXCEPTION 'Персонаж перемещен в несуществующую область';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_character_location
BEFORE UPDATE OF location_area_id ON characterr
FOR EACH ROW EXECUTE FUNCTION verify_character_location();

-- Если местоположение персонажа меняется, то производится проверка,
-- определена ли, локация, в которую переходит герой