CREATE OR REPLACE FUNCTION notify_trigger() RETURNS trigger AS $$
 DECLARE
  channel_name varchar DEFAULT ('uniqueNameAsID');
 BEGIN
  IF TG_OP = 'INSERT' THEN
   RAISE NOTICE '% triggered on INSERT', channel_name; 
   PERFORM pg_notify(channel_name, '{"table: "' || TG_TABLE_NAME ||'"data:"'|| NEW || '"}');
   RETURN NEW;
  END IF;
  IF TG_OP = 'DELETE' THEN
   RAISE NOTICE '% triggered on DELETE', channel_name; 
   PERFORM pg_notify(channel_name, '{"table: "' || TG_TABLE_NAME ||'"data:"'|| OLD || '"}');
   RETURN OLD;
  END IF;
  IF TG_OP = 'UPDATE' THEN
   RAISE NOTICE '% triggered on UPDATE', channel_name; 
   PERFORM pg_notify(channel_name, '{"table: "' || TG_TABLE_NAME ||'"data:"'|| NEW || '"}');
   RETURN NEW;
  END IF;
 END;
 $$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS core_changes_trigger on users;
CREATE TRIGGER core_changes_trigger AFTER INSERT OR UPDATE OR DELETE ON users FOR EACH ROW EXECUTE PROCEDURE notify_trigger();