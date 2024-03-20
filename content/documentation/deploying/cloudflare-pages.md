---
{
    .title = "Deploying on Cloudflare Pages",
    .date = @date("2023-02-12T00:00:00"),
    .author = "Etahn Holz",
    .draft = false,
    .layout = "documentation.html",
    .tags = [],
}
---
## About
This guide assumes that you're already familiar with using Cloudflare Pages and the Wrangler CLI. Please refer [the official Cloudflare Pages documentation](https://developers.cloudflare.com/pages/) for more info.

## Getting Started
To get started you will need to first create a new Cloudflare Pages project.

***`shell`***
```bash
$ wrangler pages project create PROJECT_NAME
```
,
This will create a new Cloudflare Pages project that you can deploy to, which can be done in two different ways.

## 1. Build locally and deploy directly with wrangler
To publish from your computer you will need fist to build your Zine site, and then upload the output to Cloudflare Pages using `wrangler`.

**NOTE: currently Zine doesn't clean `zig-out/` across rebuilds so you will have to it manually.**

***`shell`***
```bash
$ zig build 
$ wrangler pages deploy ./zig-out --project-name PROJECT_NAME
```

## 2. Use GitHub Actions

This method uses GitHub Actions to build the site and then uploads the output to Cloudflare Pages (instead of GitHub Pages).

This section assumes that you're already familiar with GitHub Actions. Please refer [the official GitHub Actions documentation](https://docs.github.com/en/actions) for more info.

Once we have created our Cloudflare Pages project, we will need a few things from Cloudflare:
- [Your Cloudflare Account ID](https://github.com/cloudflare/pages-action#get-account-id)
- [An API Token](https://github.com/cloudflare/pages-action#generate-an-api-token)
- The project name created in the previous command

Replace `ACCOUNT_ID` with your Cloudflare Account ID and add your API key as a GitHub Actions secret. In the example below, this would be set to `CLOUDFLARE_API_TOKEN`.

***`.github/workflows/cf-pages.yml`***
```
name: cloudflare pages

on:
  push:
    branches:
      - main  # Set a branch to deploy
jobs:
  deploy:
    runs-on: ubuntu-20.04
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0  # Change if you need git info

      - name: Setup Zig
        uses: goto-bus-stop/setup-zig@v2
        with:
          version: 0.12.0-dev.2701+d18f52197
          
      - name: Restore cache
        uses: actions/cache/restore@v3
        with:
          path: |
            ~/.cache/zig
            zig-cache
          key: zine-${{hashFiles('build.zig.zon')}}          

      - name: Build
        run: zig build --summary all
          
      - name: Deploy
        uses: cloudflare/pages-action@v1
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ACCOUNT_ID
          projectName: PROJECT_NAME
          directory: ./zig-out
          # Optional: Used for adding GitHub deployments support
          githubToken: ${{ secrets.GITHUB_TOKEN }}
          
      - name: Save Cache
        uses: actions/cache/save@v3
        with:
          path: |
            ~/.cache/zig
            zig-cache
          key: zine-${{hashFiles('build.zig.zon')}}          
```
**NOTE:** If you want to have your deployments populate the GitHub deployments menu, you must also enable your Action to have read and write permissions. This can be by going to Settings -> Actions -> General -> Workflow Permissions.
