-- Aura Farm of Tesla: initial Supabase schema
-- Run in Supabase Dashboard > SQL Editor.
-- Create the first admin in Authentication > Users, then add that user's UUID below.

create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create or replace function public.is_aura_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.admin_users
    where user_id = auth.uid()
  );
$$;

create table if not exists public.cattle (
  id uuid primary key default gen_random_uuid(),
  tag_number text unique,
  name text not null,
  category text not null default 'Cow',
  breed text,
  age_months integer check (age_months is null or age_months >= 0),
  weight_kg numeric(8,2) check (weight_kg is null or weight_kg >= 0),
  purchase_price numeric(12,2) not null default 0 check (purchase_price >= 0),
  sale_price numeric(12,2) not null default 0 check (sale_price >= 0),
  description text,
  image_url text,
  status text not null default 'available' check (status in ('available','reserved','sold')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.enquiries (
  id uuid primary key default gen_random_uuid(),
  customer_name text not null,
  phone text not null,
  interest text,
  message text not null,
  status text not null default 'new' check (status in ('new','contacted','converted','closed')),
  created_at timestamptz not null default now()
);

create table if not exists public.expenses (
  id uuid primary key default gen_random_uuid(),
  expense_date date not null default current_date,
  category text not null,
  description text,
  amount numeric(12,2) not null check (amount >= 0),
  created_at timestamptz not null default now()
);

create table if not exists public.health_records (
  id uuid primary key default gen_random_uuid(),
  cattle_id uuid not null references public.cattle(id) on delete cascade,
  record_date date not null default current_date,
  record_type text not null,
  notes text,
  cost numeric(12,2) not null default 0 check (cost >= 0),
  next_due_date date,
  created_at timestamptz not null default now()
);

alter table public.admin_users enable row level security;
alter table public.cattle enable row level security;
alter table public.enquiries enable row level security;
alter table public.expenses enable row level security;
alter table public.health_records enable row level security;

-- Public visitors can see available cattle only.
drop policy if exists "Public can view available cattle" on public.cattle;
create policy "Public can view available cattle"
on public.cattle for select to anon, authenticated
using (status = 'available' or public.is_aura_admin());

-- Public website can submit enquiries; only admins can read/manage them.
drop policy if exists "Anyone can submit an enquiry" on public.enquiries;
create policy "Anyone can submit an enquiry"
on public.enquiries for insert to anon, authenticated
with check (
  length(trim(customer_name)) >= 2
  and length(trim(phone)) between 10 and 20
  and length(trim(message)) >= 10
);
drop policy if exists "Admins manage enquiries" on public.enquiries;
create policy "Admins manage enquiries"
on public.enquiries for all to authenticated
using (public.is_aura_admin())
with check (public.is_aura_admin());

drop policy if exists "Admins manage cattle" on public.cattle;
create policy "Admins manage cattle"
on public.cattle for all to authenticated
using (public.is_aura_admin())
with check (public.is_aura_admin());

drop policy if exists "Admins manage expenses" on public.expenses;
create policy "Admins manage expenses"
on public.expenses for all to authenticated
using (public.is_aura_admin())
with check (public.is_aura_admin());

drop policy if exists "Admins manage health records" on public.health_records;
create policy "Admins manage health records"
on public.health_records for all to authenticated
using (public.is_aura_admin())
with check (public.is_aura_admin());

-- Create a public bucket for cattle photos. Only admins may upload/update/delete.
insert into storage.buckets (id, name, public)
values ('cattle-photos', 'cattle-photos', true)
on conflict (id) do nothing;

drop policy if exists "Public can view cattle photos" on storage.objects;
create policy "Public can view cattle photos"
on storage.objects for select to anon, authenticated
using (bucket_id = 'cattle-photos');

drop policy if exists "Admins upload cattle photos" on storage.objects;
create policy "Admins upload cattle photos"
on storage.objects for insert to authenticated
with check (bucket_id = 'cattle-photos' and public.is_aura_admin());

drop policy if exists "Admins update cattle photos" on storage.objects;
create policy "Admins update cattle photos"
on storage.objects for update to authenticated
using (bucket_id = 'cattle-photos' and public.is_aura_admin())
with check (bucket_id = 'cattle-photos' and public.is_aura_admin());

drop policy if exists "Admins delete cattle photos" on storage.objects;
create policy "Admins delete cattle photos"
on storage.objects for delete to authenticated
using (bucket_id = 'cattle-photos' and public.is_aura_admin());

-- IMPORTANT: after creating the admin user in Supabase Auth, run:
-- insert into public.admin_users (user_id) values ('PASTE-AUTH-USER-UUID-HERE');
