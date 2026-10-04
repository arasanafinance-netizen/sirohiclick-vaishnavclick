-- VAISHNAV CLICK × SIROHI CLICK
-- Run this once in Supabase Dashboard -> SQL Editor.
-- IMPORTANT: Keep your Supabase secret/service key private. Never put it in index.html.

create extension if not exists pgcrypto;

create table if not exists public.media (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  path text not null unique,
  type text not null,
  url text not null,
  created_at timestamptz not null default now()
);

alter table public.media enable row level security;

drop policy if exists "Public can view media" on public.media;
create policy "Public can view media"
on public.media for select
to anon, authenticated
using (true);

drop policy if exists "Authenticated can add media" on public.media;
create policy "Authenticated can add media"
on public.media for insert
to authenticated
with check (true);

drop policy if exists "Authenticated can delete media" on public.media;
create policy "Authenticated can delete media"
on public.media for delete
to authenticated
using (true);

insert into storage.buckets (id, name, public)
values ('media','media',true)
on conflict (id) do update set public = true;

drop policy if exists "Public can view media files" on storage.objects;
create policy "Public can view media files"
on storage.objects for select
to public
using (bucket_id = 'media');

drop policy if exists "Authenticated can upload media files" on storage.objects;
create policy "Authenticated can upload media files"
on storage.objects for insert
to authenticated
with check (bucket_id = 'media');

drop policy if exists "Authenticated can delete media files" on storage.objects;
create policy "Authenticated can delete media files"
on storage.objects for delete
to authenticated
using (bucket_id = 'media');
