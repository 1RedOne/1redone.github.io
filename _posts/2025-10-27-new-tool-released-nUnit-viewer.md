---
title: "New Tool – nUnit Test Results Viewer"
date: "2025-10-27"
redirect_from: /new-tools-nunit-test-viewer
coverImage: \assets\images\2025\pipelineViewHeader.png
categories:
  - "programming"
  - "tools"
  - "testing"
tags:
  - "nUnit"
  - "Testing"
  - "XML"
  - "SPA"
  - "DevOps"
excerpt: "Tired of trying to parse nUnit XML test results by hand? This new single-page application renders your test results in a clean, pipeline-style view that makes it easy to understand your test outcomes at a glance."
fileName: '2025-10-27-new-tool-released-nUnit-viewer.md'
---

![](../assets/images/2025/pipelineViewHeader.png)
Ever find yourself staring at a massive nUnit XML test results file, trying to figure out which tests passed, failed, or were skipped? Ever wish you could see your test results in the same clean, organized view you get when running tests in an Azure DevOps pipeline?

If you're like me, you've probably opened those XML files in a text editor more times than you'd care to admit, scrolling through endless `<test-case>` elements, trying to make sense of the results. There has to be a better way!

Well, now there is.

## Introducing: **nUnit Test Results Viewer** 🎉

This single-page application takes your nUnit XML test results and renders them in a beautiful, pipeline-style view that makes it easy to understand your test outcomes at a glance.

![nUnit Test Results in a clean, organized view](<../assets/images/2025/pipelineView.png>)

No more squinting at raw XML trying to count passed vs failed tests, or hunting through massive files to find that one test that's been causing issues.

Think of it as "Azure DevOps Test Results tab," except it works with any nUnit XML file and runs entirely in your browser.

### Features
- **Pipeline-style test visualization** - See your test results organized just like in Azure DevOps
- **Test summary dashboard** - Get an instant overview of passed, failed, and skipped tests
- **Expandable test details** - Click into individual tests to see failure messages and stack traces
- **Search and filter** - Quickly find specific tests or filter by status
- **Runs entirely in your browser** - No installs, no servers, no hassle
- **Complete privacy** - Your test results never leave your browser


### How to Use It
Simply upload your nUnit XML results file or paste the XML content directly into the viewer. The app will parse your test results and display them in an organized, easy-to-read format that mimics the test results view you're familiar with from Azure DevOps pipelines.

### It's Completely Private!
There's no telemetry, monitoring, or data collection of any kind. Your test results stay completely within your browser tab - nothing is ever sent to a server or stored anywhere.

### Perfect for:
- **Local development** - Quickly review test results from your local test runs
- **CI/CD troubleshooting** - Download XML results from failed builds and analyze them locally
- **Test result archiving** - Keep historical test results viewable in a user-friendly format
- **Team collaboration** - Share test results in a format that's actually readable

If you've ever spent way too long trying to parse XML test results by hand, this tool will save your sanity (and probably some time too).

Give it a try here: **[nUnit Test Results Viewer](https://www.foxdeploy.com/NUnitTestViewer/)**  
And if you find any bugs, well... at least now you'll have a nice way to view the test results when you fix them! 😉
