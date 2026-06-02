# June 2026 Newsletter — Major Key Group

Inland Northwest Real Estate monthly report (Spokane & Coeur d'Alene), June 2026.

Single self-contained `index.html` (HTML/CSS + Chart.js via CDN). Fully responsive
for mobile, tablet, and desktop, with an auto-height `postMessage` script for iframe embeds.

## Deploy
Static site — deploys to Netlify. Connect this repo in Netlify (no build command,
publish directory = repo root) for automatic deploys on push.

Live: https://june-newsletter-majorkeygroup.netlify.app/

## Skills (use on any computer)

This repo ships a reusable Claude skill in `skills/newsletter-builder/` for
regenerating the monthly newsletter.

To use it on any computer:

```bash
# 1. Clone this repo (replace with your repo URL)
git clone https://github.com/YOUR-USERNAME/june-newsletter.git
cd june-newsletter

# 2. Install the skill(s) into ~/.claude/skills
./install-skills.sh

# 3. Restart Claude Code — the "newsletter-builder" skill is now available.
```

`install-skills.sh` copies every `skills/*/` folder into `~/.claude/skills/`
(override the target with `CLAUDE_SKILLS_DIR`). Re-run it after pulling updates.
