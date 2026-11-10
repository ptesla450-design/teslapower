# Aura Farm of Tesla website

A static website: one file (`index.html`), no build step, no dependencies, no environment variables, no API keys.

## Before you publish: fill in the placeholders
Search `index.html` for `[` to find every placeholder. You need to replace:
- Phone / WhatsApp, email, farm address, district, visiting hours
- Breeds, age and weight ranges for cows, bulls and Qurbani cattle; booking dates
- Price ranges in BDT (3 pricing cards)
- Delivery, pickup, payment and farm visit details (FAQ and steps)
- Customer reviews (3 slots). Add real ones only, or delete the section
- Social links in the footer
Each English text has a Bangla version in its `data-bn="..."` attribute. Edit both.

## Easiest way to publish: Netlify Drop (no account tools, no code)
1. Go to https://app.netlify.com/drop and sign up or log in.
2. Drag the whole `aura-farm-site` folder onto the page.
3. Netlify gives you a `something.netlify.app` address. Open it on your phone and computer and test everything.
Build command: none. Publish directory: the folder itself.

## Alternative: Vercel
1. Install Node.js, then run `npm i -g vercel`.
2. In a terminal, go into the `aura-farm-site` folder and run `vercel`.
3. Answer the questions: framework "Other", build command empty, output directory `.`.
4. Run `vercel --prod` to publish to the production address.
(You can also push the folder to GitHub and import it in Vercel with the same settings.)

## After publishing
1. Add your own domain in the host's "Domains" settings and follow its DNS steps.
2. Add to `<head>`: `<link rel="canonical" href="https://YOUR-DOMAIN/">` and `<meta property="og:url" content="https://YOUR-DOMAIN/">`.
3. Add a real photo as `og:image` (1200x630) so links look good when shared.
4. Create `sitemap.xml`, un-comment the Sitemap line in `robots.txt`, and submit it in Google Search Console.
5. Run Lighthouse (Chrome DevTools) or https://pagespeed.web.dev on the live address.

## The enquiry form does NOT send anything yet
It validates input and shows the enquiry text with a Copy button. To receive enquiries you must connect one of: a WhatsApp link (`https://wa.me/<number>?text=...`), an email form service (for example Formspree), or Netlify Forms. Ask for help wiring the one you choose.
