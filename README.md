# PFZ craft — public art portfolio with an admin panel

A responsive HTML, CSS, and JavaScript website, ready to open in VS Code and deploy to Vercel through GitHub. Supabase stores your artwork, certificates, and account securely. Images are saved in Supabase, not in GitHub or your browser.

## What you can do

- Public visitors can browse artwork, filter categories, and enlarge images.
- You can sign in at `/admin.html` and add artwork or certificate images.
- Add a title, description, artwork category, certificate issuer, and year.
- Edit details, replace an image, or delete an entry whenever you want.
- Images support JPG, PNG, and WebP, up to 8 MB each. For PDF certificates, export a page as an image first.
- Uploading new work does not require editing code, GitHub commits, or Vercel redeployment.
- The request form creates a brief to copy; it does not send messages or collect paid orders.

The website includes your supplied PFZ logo. Initial gallery illustrations are visibly labeled placeholders; after your first upload, real artwork replaces the sample gallery. Certificates replace their placeholder cards after the first certificate upload.

## 1. Open the source in VS Code

Extract this ZIP. Open the `pfz-craft-vercel` folder with File > Open Folder in VS Code. You do not need to copy each file manually.

Files you may edit:

- `public/index.html`: website text and sections.
- `public/style.css`: colours, spacing, fonts, mobile layout.
- `public/config.js`: Supabase public configuration.
- `public/admin.html` and `public/admin.js`: upload panel.
- `public/backend.js`: authentication and data connections.
- `supabase/setup.sql`: database and permissions.
- `supabase/add-admin.sql`: grant access to your account.
- `vercel.json`: Vercel configuration.

## 2. Create the Supabase project

1. Go to https://supabase.com and create a project. Keep its database password private.
2. Open SQL Editor. Copy `supabase/setup.sql` into a new query and run it ONCE.
3. The script creates the public `portfolio` image bucket and the two database tables, with access rules.
4. Go to Authentication > Users and use Add user/Create user to create your own admin email and password. Confirm the user when the dashboard offers that option. This is the password you will use on the website, not your database password.
5. Open `supabase/add-admin.sql`, replace `YOUR_ADMIN_EMAIL` with that same email, and run it in SQL Editor. Its final query must show your account.
6. For this owner-only admin panel, disable new user sign-ups in Supabase Auth settings. There is no public registration page.

## 3. Connect the website

Find your project's URL and publishable key in Supabase's Connect/API settings. A legacy `anon` public key also works. Open `public/config.js`:

```js
export const SUPABASE_URL = 'https://YOUR_PROJECT.supabase.co';
export const SUPABASE_PUBLIC_KEY = 'YOUR_PUBLISHABLE_OR_ANON_KEY';
```

The public key is meant to be in browser code. Database and Storage policies restrict changes to your admin account. NEVER use a Supabase secret key, service_role key, database password, or your login password in config.js or GitHub.

## 4. Preview on your laptop

Do not double-click index.html: ES modules need an HTTP server.

If Node.js is installed, open the terminal in the project folder:

```cmd
npx serve public
```

Open the local URL it prints. Or, with Python installed:

```cmd
cd public
python -m http.server 5500
```

Open http://localhost:5500 and http://localhost:5500/admin.html. You can also open the `public` folder directly in VS Code and use Live Server.

Sign in using the account from step 2. Upload one artwork and one certificate, then open the public home page to check both. Use a private/incognito browser window to check that visitors can view them without signing in, and cannot upload/edit without your admin account.

## 5. Upload to GitHub

Create an empty GitHub repository named `pfz-craft` (do not initialize with a README). In the terminal, inside this project folder:

```cmd
git init
git add .
git commit -m "Add PFZ craft portfolio"
git branch -M main
git remote add origin https://github.com/PARIguli/pfz-craft.git
git push -u origin main
```

If using another repository name, change the URL accordingly.

## 6. Deploy on Vercel

1. Sign in at https://vercel.com and import your GitHub `pfz-craft` repository.
2. Framework preset: Other.
3. Project root: the folder containing vercel.json. If you upload the whole extracted parent folder, set Root Directory to `pfz-craft-vercel`.
4. Output Directory: `public`. No build command is needed. The included vercel.json declares the output directory.
5. Deploy. Your normal Vercel production URL should be accessible to the public. Ensure production deployment protection is not restricting visitors.
6. In Supabase Auth URL configuration, set Site URL to your Vercel website URL.
7. Open `https://YOUR_SITE.vercel.app/admin.html`, sign in, and upload your work.

For code/design changes, commit and push again. Vercel deploys the updated source. Supabase uploads remain in the database and bucket between deployments.

## Before sharing with customers

Add your WhatsApp/Instagram links in `public/index.html` and replace the current contact placeholder text. Review the About Me wording. The site is not a checkout/payment system. Upload only artwork and certificates you intend to show publicly; images in the portfolio bucket are publicly accessible.

## Common issues

- "Setup needed": fill in config.js, then refresh/redeploy.
- "Invalid login credentials": use the Supabase Auth user's email/password and confirm the user.
- "Not a portfolio administrator": run add-admin.sql with the correct email.
- "Violates row-level security": check admin membership and confirm setup.sql completed.
- Duplicate policy name while running SQL: setup.sql is a one-time setup script; do not rerun it after successful creation.
- Image doesn't upload: use JPG/PNG/WebP under 8 MB. Check the portfolio bucket and permissions.
- Vercel 404: confirm Root Directory contains vercel.json and Output Directory is public.
- Can't load Supabase SDK: this version loads the pinned browser SDK from jsDelivr, so an internet connection and access to that CDN are required.

## Verification and limits

Source JavaScript syntax and local file references were checked. Live Supabase login, Storage permissions, and Vercel deployment must be verified after you create the project and enter your configuration. No live Supabase account or Vercel deployment was created for this package.

Official references:
- https://supabase.com/docs/guides/storage/security/access-control
- https://supabase.com/docs/guides/storage/buckets/fundamentals
- https://vercel.com/docs/project-configuration/vercel-json
