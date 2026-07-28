# ianwardell.com

A polished, dependency-free personal links page for Ian Wardell.

## Links

- LinkedIn: https://www.linkedin.com/in/ian-wardell/
- Research: https://www.research.ianwardell.com/
- Git: https://www.git.ianwardell.com/
- Résumé: https://www.resume.ianwardell.com/

## Repository layout

- `site/` contains the complete website and is the only folder copied to the web root.
- `site/assets/css/` contains the site stylesheet.
- `site/assets/images/` contains public images, including the profile headshot.
- `scripts/deploy-hostgator.sh` clones or refreshes the repository and deploys `site/`.
- `scripts/validate-site.sh` verifies the required files and URLs before release.

## 1. GitHub repository

This project is published from the `IanWardell/linkme` repository. A public repository is simplest for unattended HostGator cron deployments because cloning and fetching do not require stored GitHub credentials.

From a computer with Git and GitHub access:

```bash
git add .
git commit -m "Build personal links site"
git push -u origin main
```

## 2. Configure the HostGator domain

In cPanel, confirm the document root for `ianwardell.com`. This project assumes:

```text
/home/CPANEL_USERNAME/public_html
```

If cPanel shows another path, set `WEB_ROOT` to that exact path. The deployment replaces the contents of `WEB_ROOT` except for `.well-known`, so back up any existing site before the first deployment.

## 3. Add the self-bootstrapping cron job

In cPanel, open **Advanced → Cron Jobs**. The following command checks every five minutes. On its first run it clones the repository. On later runs it fetches `release` and deploys the current site:

```cron
*/5 * * * * /bin/bash -lc 'R="$HOME/repositories/linkme"; if [ ! -d "$R/.git" ]; then mkdir -p "$(dirname "$R")" && git clone --depth 1 --branch release https://github.com/IanWardell/linkme.git "$R"; fi; REPO_URL="https://github.com/IanWardell/linkme.git" BRANCH="release" CHECKOUT_DIR="$R" WEB_ROOT="$HOME/public_html" /bin/bash "$R/scripts/deploy-hostgator.sh"' >> "$HOME/ianwardell.deploy.log" 2>&1
```

The same command is saved in `HOSTGATOR_CRON.txt` for easy copying. Replace `public_html` when cPanel lists a different document root.

Pushing to `main` does not deploy the site. To publish a tested version, promote `main` to the `release` branch:

```bash
bash scripts/validate-site.sh
git switch release
git merge --ff-only main
git push origin release
git switch main
```

After every push to `release`, the next cron run fetches the new commit and replaces the files in the subdomain document root. The deployment script preserves `.well-known`, which cPanel or AutoSSL may use.

To deploy immediately instead of waiting for cron, open cPanel Terminal and run the command portion manually, or run:

```bash
BRANCH="release" WEB_ROOT="$HOME/public_html" /bin/bash "$HOME/repositories/linkme/scripts/deploy-hostgator.sh"
```

## Private-repository alternative

A private repository requires unattended authentication. Prefer a read-only SSH deploy key added to the GitHub repository, then change `REPO_URL` to:

```text
git@github.com:IanWardell/linkme.git
```

For this small public website, a public repository avoids credential management.

## Local preview

```bash
cd site
python3 -m http.server 8080
```

Then open `http://localhost:8080`.
