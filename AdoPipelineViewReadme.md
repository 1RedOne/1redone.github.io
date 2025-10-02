# 🔧 Deployment Notes: AdoPipelineView SPA and Blog Integration

## 🧠 Context

This repository is part of a two-repo setup used to host:

- 📰 A **Jekyll-based blog** at **https://www.foxdeploy.com/**
- ⚙️ A **standalone Single Page App (SPA)** at **https://www.foxdeploy.com/AdoPipelineView/**

The SPA and blog are hosted via **GitHub Pages**, but they live in **separate repositories** for clarity and cleaner dev workflows.

---

## 🌐 Domain + URL Structure

| URL | Purpose | Hosted From |
|-----|---------|-------------|
| `https://www.foxdeploy.com/` | Main Jekyll blog | [`1redone.github.io`](https://github.com/1RedOne/1redone.github.io) |
| `https://www.foxdeploy.com/AdoPipelineView/` | Deployed SPA | [`AdoPipelineView`](https://github.com/1RedOne/AdoPipelineView) |

---

## 📦 Where is the SPA code?

The SPA source code is **NOT inside the blog repo** (`1redone.github.io`) — instead, it is located in its own repository:

> [`1RedOne/AdoPipelineView`](https://github.com/1RedOne/AdoPipelineView)

This repo builds a single-page app (`index.html`, etc.) and publishes it to GitHub Pages using either:

- The `gh-pages` branch (recommended), OR
- The `/docs` folder, OR
- GitHub Actions with Pages deployment (e.g., `pages-build-deployment`)

You can confirm it is published successfully at:

>https://github.com/1RedOne/AdoPipelineView/settings/pages


---

## 🔍 Why is this split across two repos?

Keeping the SPA separate helps with:
- Clean dev workflows (the SPA can use its own toolchain, like React, Vue, or Vite)
- Independent deployments (no interference with Jekyll builds)
- Smaller repos, faster CI
- Easier separation of concerns

The blog can safely link to the SPA without needing to embed or bundle it.



## 🧪 How to test changes to the SPA

If you need to make changes to the SPA:

1. Go to [`1RedOne/AdoPipelineView`](https://github.com/1RedOne/AdoPipelineView)
2. Edit the SPA source files (`index.html`, JS/CSS/etc.)
3. Push to the branch configured for GitHub Pages (e.g., `main`, `gh-pages`, or `/docs`)
4. GitHub Pages will auto-deploy to:

### 🧭 How to Add Additional Single-Page Apps (SPAs) to FoxDeploy

Want to host another standalone tool or SPA at `https://www.foxdeploy.com/YourNewTool/`? Here's the full process:

---

#### ✅ Step-by-Step Instructions

**Step 1: Create a New Repo**  
Make a new GitHub repository for your SPA.  
Give it a name like `CoolNewViewer`, `MyStaticTool`, etc.  
This keeps the app self-contained and versionable.

---

**Step 2: Configure GitHub Pages for the SPA Repo**  
In the **new repo**:

- Go to **Settings → Pages**
- Set the **Source** to:
  - `gh-pages` branch (recommended), **or**
  - `/docs` folder (if using `main`)
- Set the **custom path** to match your desired sub-URL  
  → For example, `/CoolNewViewer/` will publish at:  https://www.foxdeploy.com/CoolNewViewer/


---

**Step 3: Upload the `index.html` File**  
Make sure your repo contains at least: `index.html`

Test your deployment by visiting the live link. You should see your SPA appear at the custom subfolder.

---

**Step 4: Update Blog Navigation**  
In the **main blog repo** (`1redone.github.io`):

- Open: `_data/navigation.yml` or wherever your nav is configured
- Add a new entry pointing to your SPA subpath:
  ```yaml
  - title: Cool New Viewer
    url: /CoolNewViewer/

#### Step 5: Brag with a Blog Post
Write a new post in your blog's _posts folder to:

Announce the new tool 🎉

Explain what it does

Link to https://www.foxdeploy.com/CoolNewViewer/

Boom — you're done. Your new app is live, linked, and documented.