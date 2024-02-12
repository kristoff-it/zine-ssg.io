---
{
  "title": "Deploying on Cloudflare Pages",
  "date": "2023-02-12T00:00:00",
  "author": "Etahn Holz",
  "draft": false,
  "layout": "documentation.html",
  "tags": []
}
---
## About
This guide assumes that you're already familiar with using Cloudflare Pages and the Wrangler CLI. Please refer [the official Cloudflare Pages documentation](https://developers.cloudflare.com/pages/) for more info.

If you're a developer looking to deploy a static website to Cloudflare Pages, you have a two options.


## 1. Build locally and deploy locally with wrangler
The first one, which is more efficient, is to build the website locally and use `wrangler` to publish this to Cloudflare Pages. To get started, run `wrangler pages project create PROJECT_NAME`. This will create a new Cloudflare Pages project that you can deploy to. Once complete, you can push your built Zine files to that project using `wrangler pages deploy ./zig-out --project-name PROJECT_NAME`. 

## 2. Use GitHub Actions
This one is a more hands-off, but slower option. 

It is inherently slower because of all the overhead introduced by GitHub Actions. Additionally, Zine is a collection of tools compiled on demand by your build script, which is a bad match for GitHub Actions given its ephemeral nature.

One day we might maintain a set of Zine actions that pre-builds Zine once for everybody but, in the meantime, the following workflow definition will use the GitHub's caching system to cache builds of Zine for you.

To get started you will need to create a new project in Cloudflare Pages. This can be done by running:

`wrangler pages project create PROJECT_NAME`


Once completed, we will need a few things from Cloudflare to get the GitHub Action to run:
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
