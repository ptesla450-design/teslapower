# Aura Farm of Tesla — Backend starter

This package preserves the existing single-page frontend design and adds a Supabase-backed enquiry form plus an admin dashboard.

## Included
- `index.html` — original frontend with only backend scripts added at the bottom.
- `admin.html` — admin login, dashboard, cattle inventory, enquiries, expenses and health records.
- `site-backend.js` — submits public enquiries to Supabase.
- `supabase-config.js.example` — configuration template; rename to `supabase-config.js`.
- `supabase-schema.sql` — database tables, Row Level Security (RLS), and cattle photo storage policies.
- `robots.txt` — original file.

## Setup (required before it works live)
1. Create a Supabase project at https://supabase.com.
2. In Project Settings → API, copy the Project URL and anon/public key.
3. Rename `supabase-config.js.example` to `supabase-config.js` and enter those two values.
   - The anon/public key is intended for browser use with RLS enabled.
   - NEVER paste a `service_role` or secret key into website files or chat.
4. In Supabase → SQL Editor, run all of `supabase-schema.sql`.
5. In Supabase → Authentication → Users, create the admin user with email and password.
6. Copy that user's UUID, then run this SQL in the SQL Editor:
   `insert into public.admin_users (user_id) values ('YOUR-AUTH-USER-UUID');`
7. Upload the complete folder to your hosting provider. Keep `index.html`, `admin.html`, `site-backend.js`, `supabase-config.js` and `robots.txt` in the same root folder.
8. Open `https://YOUR-SITE/admin.html` and sign in.

## Security notes
- Never publish the Supabase service role key.
- The database uses Row Level Security. Public users can submit enquiries and view available cattle; admin CRUD access requires an authenticated user whose UUID is in `admin_users`.
- Do not add admin users by creating a public sign-up page. Add approved admin UUIDs through the Supabase SQL Editor.
- Configure Supabase Auth allowed redirect URLs for your exact website domain.

## Important current scope
- The admin panel can create cattle records, upload cattle photos, change cattle availability/sold status, delete cattle, review/update enquiry status, add expenses and add health/vaccination records.
- Sales and profit reports are not yet a full accounting ledger: a sold-status toggle is inventory status, not proof of payment. Add a proper orders/payments workflow before treating dashboard figures as audited revenue.
- The public cattle cards on the existing homepage remain their original static content in this starter. Dynamic catalogue rendering is a separate integration step once the real cattle data and display layout are confirmed.
- No live backend is connected until you create/configure the Supabase project and deploy the files.
