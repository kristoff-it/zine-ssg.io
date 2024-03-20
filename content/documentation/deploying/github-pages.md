---
{
    .title = "Deploying on GitHub Pages",
    .date = @date("2020-07-06T00:00:00"),
    .author = "Sample Author",
    .draft = false,
    .layout = "documentation.html",
    .tags = [],
} 
--- 
## About
This guide assumes that you're already familiar with GitHub Pages. Please refer [the official GitHub Pages documentation](https://pages.github.com/) for more info.


## 1. Build locally
The first one, which is more efficient, is to build the website locally and commit it to the correct branch/subdir. 

Currently Zine doesn't offer any help automating this process, but in the future it might.

**NOTE: currently Zine doesn't clean `zig-out/` across rebuilds so you will have to it manually.**


## 2. Use GitHub Actions

This is a more popular, but slower option.

GitHub Actions runner have an inherent overhead and, since Zine is a collection of tools that gets compiled on-demand, your runner will need to do some work that wounldn't be necessary with a single-executable tool.

Luckly, the build can be cached by adding a few lines to your GitHub Actions workflow.

[This site currently builds in 25-35 seconds](https://github.com/kristoff-it/zine/actions), of which 9 are spent setting up Zig, 2 restoring the Zine tools cache, and 1 for the actual site build.

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
          path: |
            ~/.cache/zig
            zig-cache
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
          path: |
            ~/.cache/zig
            zig-cache
          key: zine-${{hashFiles('build.zig.zon')}}          
```
