---
{
  "title": "Deploying on GitHub Pages",
  "date": "2020-07-06T00:00:00",
  "author": "Sample Author",
  "draft": false,
  "layout": "documentation.html",
  "tags": []
}  
--- 
## About
This guide assumes that you're already familiar with GitHub Pages. Please refer [the official GitHub Pages documentation](https://pages.github.com/) for more info.

If you're a developer looking to deploy a static website to GitHub Pages, you have two main options.


## 1. Build locally
The first one, which is more efficient, is to build the website locally and commit it to the correct branch/subdir. 

Currently Zine doesn't offer any help automating this process, but in the future it might.


## 2. Use GitHub Actions
This one is a more hands-off, but slower option. 

It is inherently slower because of all the overhead introduced by GitHub Actions. Additionally, Zine is a collection of tools compiled on demand by your build script, which is a bad match for GitHub Actions given its ephemeral nature.

One day we might maintain a set of Zine actions that pre-builds Zine once for everybody but, in the meantime, the following workflow definition will use the GitHub's caching system to cache builds of Zine for you.

***`.github/workflows/gh-pages.yml`***
```
name: github pages

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
          path: zig-cache
          key: zine-${{hashFiles('build.zig.zon')}}          

      - name: Build
        run: zig build --summary all
          
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        if: github.ref == 'refs/heads/main'
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./zig-out
          
      - name: Save Cache
        uses: actions/cache/save@v3
        with:
          path: zig-cache
          key: zine-${{hashFiles('build.zig.zon')}}          
```

This is how we deploy this website: [https://github.com/kristoff-it/zine-ssg.io](https://github.com/kristoff-it/zine-ssg.io).
