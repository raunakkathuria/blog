---
layout: page
title: LexiLint Privacy
permalink: /lexilint/privacy
exclude: true
---

# Privacy Policy for LexiLint

**Last Updated:** October 24, 2025

## Overview

LexiLint is a browser extension that helps you proofread webpages by checking spelling and grammar. Your privacy is our top priority. This policy explains exactly what data we collect (spoiler: almost nothing) and how we handle it.

## Data Collection

**LexiLint collects NO personal data. Zero. None.**

We do not:
- Track your browsing history
- Collect analytics or usage statistics
- Store any text you check
- Send data to our servers (we don't even have servers)
- Use cookies or tracking pixels
- Share data with third parties

## What Happens to Your Text

### Spell Checking (100% Offline)
- **Where it happens:** Entirely on your device
- **Internet required:** No
- **Data sent anywhere:** No
- **How it works:** LexiLint uses local dictionary files bundled with the extension. Your text never leaves your browser.

### Grammar Checking (Optional, AI-Powered)
- **Where it happens:** Sent to your chosen AI provider (currently Google Gemini, more providers coming soon)
- **Internet required:** Yes
- **Who sees your text:** Only the AI provider you choose
- **Your control:** You provide your own API key. We never see it or your text.
- **Data storage:** LexiLint does NOT store the text you check. Refer to your AI provider's privacy policy for their data handling.

**Important:** When you use grammar checking, you are directly communicating with the AI provider using YOUR API key. LexiLint acts only as a messenger. We never intercept, store, or transmit your text to our servers.

## What We Store Locally

LexiLint stores the following data **only on your device** using Chrome's local storage:

1. **Custom Dictionary Words** - Words you've added to your personal dictionary via the "+ Ignore" button
2. **API Keys** - Your AI provider API keys (encrypted by Chrome's storage API)
3. **Settings** - Your preferences (language variant, auto-check toggle)
4. **Session Cache** - Temporary storage of check results to avoid re-checking the same page (cleared on navigation/refresh)

**This data:**
- Never leaves your device
- Is NOT accessible to us
- Can be deleted anytime via Chrome settings or the extension's settings page

## Permissions Explanation

LexiLint requests these Chrome permissions:

### `activeTab`
**Why we need it:** To read the webpage text when you click "Check Spelling" or "Check Grammar"

**What we do NOT do:**
- We do NOT track which pages you visit
- We do NOT access tabs you haven't explicitly checked
- We only read text when you click the check button

### `storage`
**Why we need it:** To save your custom dictionary words and API keys locally on your device

**What we do NOT do:**
- We do NOT sync data to cloud servers
- We do NOT share storage data with other extensions or websites

## Third-Party Services

### AI Grammar Checking (Optional Feature)
If you choose to use AI grammar checking, LexiLint facilitates communication between your browser and your chosen AI provider. You must:

1. Create your own account with the AI provider
2. Generate your own API key
3. Provide the API key to LexiLint

**Current supported provider:**
- Google Gemini - [Privacy Policy](https://policies.google.com/privacy) | [API Terms](https://ai.google.dev/gemini-api/terms)

**Coming soon:**
- OpenAI ChatGPT
- Anthropic Claude
- Ollama (fully local, no internet required)

When you use grammar checking, you are subject to the privacy policy and terms of service of the AI provider you choose. We recommend reviewing their policies before enabling this feature.

## Data Deletion

To delete all LexiLint data:

1. **Delete custom dictionary and settings:**
   - Open LexiLint settings
   - Click "Clear Custom Dictionary"
   - Or manually delete via Chrome: `chrome://extensions` → LexiLint → "Remove extension"

2. **Delete session cache:**
   - Automatically cleared on page navigation/refresh
   - Or manually: Close the browser tab

3. **Delete API keys:**
   - Open LexiLint settings
   - Delete the API key field
   - Or remove the extension entirely

Uninstalling the extension removes ALL locally stored data immediately.

## Children's Privacy

LexiLint does not knowingly collect data from anyone, including children under 13. Since we collect no personal data, there is no age-specific data to protect or delete.

## Changes to This Policy

We may update this privacy policy as we add new features (like additional AI providers). Changes will be posted here with an updated "Last Updated" date. Significant changes will be announced via the Chrome Web Store listing.

## Contact Us

Questions about privacy? We're here to help:

**Email:** lexilintapp@gmail.com
**Subject Line:** "Privacy Question"

We respond within 48 hours (usually much faster).

---

**TL;DR:**
- Spell checking: 100% offline, no data sent anywhere
- Grammar checking: Optional, uses YOUR API key with YOUR chosen provider
- We collect zero analytics, zero tracking, zero personal data
- Everything stays on your device unless you use AI grammar (then only your AI provider sees it)
- You control all data and can delete it anytime
