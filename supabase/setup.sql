-- Run once in your Supabase project's SQL Editor.
create table if not exists public.portfolio_admins (
  user_id uuid primary key references auth.users(id) on delete cascade
);
create table if not exists public.portfolio_items (
  id uuid primary key default gen_random_uuid(),
  kind text not null check (kind in ('artwork','certificate')),
  title text not null check (char_length(title) between 1 and 120),
  category text not null default '',
  issuer text not null default '' check (char_length(issuer) <= 150),
  year text not null default '' check (year = '' or year ~ '^(19|20)[0-9]{2}$' or year = '2100'),
  description text not null default '' check (char_length(description) <= 2000),
  image_path text not null check (image_path ~ '^[0-9a-f-]{36}\.(jpg|png|webp)$'),
  created_at timestamptz not null default now(),
  check ((kind = 'artwork' and category in ('Sketches','Portraits','Mandalas','Canvas','Crafts')) or (kind = 'certificate' and category = ''))
);
alter table public.portfolio_admins enable row level security;
alter table public.portfolio_items enable row level security;
revoke all on public.portfolio_admins from anon, authenticated;
grant select on public.portfolio_admins to authenticated;
grant select on public.portfolio_items to anon, authenticated;
grant insert, update, delete on public.portfolio_items to authenticated;

create policy "Admin may read own membership" on public.portfolio_admins
for select to authenticated using (user_id = (select auth.uid()));
create policy "Anyone may view portfolio" on public.portfolio_items
for select to anon, authenticated using (true);
create policy "Admin may add portfolio entries" on public.portfolio_items
for insert to authenticated with check (exists (select 1 from public.portfolio_admins where user_id = (select auth.uid())));
create policy "Admin may edit portfolio entries" on public.portfolio_items
for update to authenticated using (exists (select 1 from public.portfolio_admins where user_id = (select auth.uid())))
with check (exists (select 1 from public.portfolio_admins where user_id = (select auth.uid())));
create policy "Admin may delete portfolio entries" on public.portfolio_items
for delete to authenticated using (exists (select 1 from public.portfolio_admins where user_id = (select auth.uid())));

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('portfolio', 'portfolio', true, 8388608, array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public = true, file_size_limit = 8388608, allowed_mime_types = array['image/jpeg','image/png','image/webp'];
create policy "Admin may view stored portfolio objects" on storage.objects
for select to authenticated using (bucket_id = 'portfolio' and exists (select 1 from public.portfolio_admins where user_id = (select auth.uid())));
create policy "Admin may upload portfolio images" on storage.objects
for insert to authenticated with check (bucket_id = 'portfolio' and exists (select 1 from public.portfolio_admins where user_id = (select auth.uid())));
create policy "Admin may remove portfolio images" on storage.objects
for delete to authenticated using (bucket_id = 'portfolio' and exists (select 1 from public.portfolio_admins where user_id = (select auth.uid())));
