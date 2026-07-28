# LinkMe

A lightweight, tree-style personal links page for [ianwardell.com](https://ianwardell.com).

## Links

LinkedIn

```text
https://www.linkedin.com/in/ian-wardell/
```

Research

```text
https://www.research.ianwardell.com/
```

Git

```text
https://www.git.ianwardell.com/
```

Résumé

```text
https://www.resume.ianwardell.com/
```

## Project structure

```text
site/       Static website and assets
scripts/    Validation and deployment helpers
```

The contents of `site/` can be served by any static web server or hosting provider.

## Local development

Preview the site locally:

```bash
cd site
python3 -m http.server 8080
```

Then visit [http://localhost:8080](http://localhost:8080).

Validate the site before publishing:

```bash
bash scripts/validate-site.sh
```

## Deployment

Publish the contents of `site/` with any static hosting provider.

## License

The source code is publicly available for viewing and reference. Reuse, modification, redistribution, and deployment are not permitted without prior written permission. See [LICENSE](LICENSE) for the complete terms.
