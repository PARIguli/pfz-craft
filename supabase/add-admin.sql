-- First create your admin user in Supabase Authentication > Users.
-- Replace YOUR_ADMIN_EMAIL with exactly that user's email. Run in SQL Editor.
insert into public.portfolio_admins (user_id)
select id from auth.users where lower(email) = lower('YOUR_ADMIN_EMAIL')
on conflict (user_id) do nothing;
-- This must return one row. Zero rows means the email/user was not found.
select a.user_id, u.email from public.portfolio_admins a
join auth.users u on u.id = a.user_id;
