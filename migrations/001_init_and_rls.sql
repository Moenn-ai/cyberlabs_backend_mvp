-- 1) Enable uuid extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2) Core tables
CREATE TABLE IF NOT EXISTS public.clusters (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code TEXT NOT NULL, public_name TEXT NOT NULL,
  status TEXT, license TEXT, category TEXT,
  mission TEXT, vision TEXT,
  technical_owner TEXT, strategic_owner TEXT,
  version TEXT, created_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE IF NOT EXISTS public.agents (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  cluster_id UUID NOT NULL REFERENCES public.clusters(id) ON DELETE CASCADE,
  name TEXT NOT NULL, role TEXT, status TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE IF NOT EXISTS public.execution_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  cluster_id UUID REFERENCES public.clusters(id),
  operation TEXT, changed_at TIMESTAMPTZ DEFAULT now()
);

-- 3) RLS
ALTER TABLE public.clusters  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.agents    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.execution_logs ENABLE ROW LEVEL SECURITY;

-- 4) Public policies
DROP POLICY IF EXISTS clusters_public_select ON public.clusters;
CREATE POLICY clusters_public_select ON public.clusters FOR SELECT USING (true);
DROP POLICY IF EXISTS agents_public_select ON public.agents;
CREATE POLICY agents_public_select ON public.agents FOR SELECT USING (true);
DROP POLICY IF EXISTS logs_public_select ON public.execution_logs;
CREATE POLICY logs_public_select ON public.execution_logs FOR SELECT USING (true);

-- 5) Trigger de auditoria de objetos
CREATE OR REPLACE FUNCTION public.log_storage_change()
  RETURNS trigger LANGUAGE plpgsql
  SECURITY INVOKER
  SET search_path = public
AS $$
BEGIN
  INSERT INTO public.execution_logs(id, cluster_id, operation, changed_at)
  VALUES (uuid_generate_v4(), NEW.metadata->>'cluster_id', TG_OP, now());
  RETURN NEW;
END; $$;

DROP TRIGGER IF EXISTS trg_log_storage_change ON storage.objects;
CREATE TRIGGER trg_log_storage_change
  AFTER INSERT OR UPDATE OR DELETE ON storage.objects
  FOR EACH ROW EXECUTE FUNCTION public.log_storage_change();

-- 6) RLS em storage
ALTER TABLE storage.objects  ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS storage_full_access_admins ON storage.objects;
CREATE POLICY storage_full_access_admins
  ON storage.objects FOR ALL TO authenticated USING (true);

ALTER TABLE storage.buckets  ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS buckets_manage_service_role ON storage.buckets;
CREATE POLICY buckets_manage_service_role
  ON storage.buckets FOR ALL TO service_role USING (true);
