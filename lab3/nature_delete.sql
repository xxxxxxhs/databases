CREATE OR REPLACE FUNCTION remove_nature_objects()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM nature_object WHERE situated_at_area_id = OLD.id;
    DELETE FROM enchantment WHERE source_area_obj_id = OLD.id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_remove_nature_objects
BEFORE DELETE ON area_object
FOR EACH ROW
EXECUTE FUNCTION remove_nature_objects();


-- Если удалется объект местности, то удаляются так же все объекты природы,
-- которые с ним связаны