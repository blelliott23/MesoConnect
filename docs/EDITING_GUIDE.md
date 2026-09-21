# Editing the MesoConnect website

This guide is for routine edits by someone who does not want to learn a web framework. The site deliberately uses plain files so every visible section can be changed directly.

## Find the right file

| If you want to change | Edit this file |
|---|---|
| Home-page title, summary, pathway groups, or main cautions | `index.html` |
| Map types, thresholds, filename examples, or interpolation guidance | `atlas-files/index.html` |
| Step-by-step commands and tutorial prose | `tutorial/index.html` |
| Manuscript settings, method distinctions, or interpretation language | `methods/index.html` |
| Software, ROI sources, folders, troubleshooting, QA, or citation | `resources/index.html` |
| Colors, spacing, typography, cards, code blocks, or mobile layout | `assets/css/styles.css` |
| Navigation toggle, copy buttons, or tutorial reading progress | `assets/js/site.js` |
| Runnable Inferior VTA–NAc example | `examples/mesoconnect_inferior_vta_nac_template.sh` |

## Edit text safely

Text normally sits between an opening and closing tag:

```html
<p>This is the text a reader sees.</p>
```

Change only the sentence unless you intend to change the structure. Keep the angle-bracketed tags themselves.

Headings use `h1`, `h2`, and `h3`:

```html
<h2>Choose the file by its meaning</h2>
```

Every page should have one `h1`. Section headings should follow in order; do not jump from `h2` directly to `h4`.

## Add a new tutorial section

Copy one complete `<section class="tutorial-step">` block in `tutorial/index.html`. Give it a unique ID such as `step-9`, update the visible number, and add a matching item in the sidebar navigation.

The important attributes are:

```html
<section id="step-9" class="tutorial-step" data-tutorial-step>
```

The sidebar link must match that ID:

```html
<a href="#step-9" data-step-link>...</a>
```

## Add a code example

Use a `pre` block with `data-copy` so the JavaScript adds a copy button:

```html
<pre data-copy><code>command --option value</code></pre>
```

HTML treats `<` and `>` as markup. Write literal placeholders as `&lt;VALUE&gt;` inside HTML code blocks.

## Add or replace a figure

Use a `figure` with an image, meaningful alternative text, and a caption:

```html
<figure class="figure-placeholder">
  <img
    src="/assets/images/figures/my-final-figure.png"
    alt="Concise description of the scientific information shown in the figure."
    width="1600"
    height="900"
  />
  <figcaption><strong>Figure 3.</strong> Final caption text.</figcaption>
</figure>
```

When the final image replaces a placeholder, you may keep the `figure-placeholder` class; it controls the border, spacing, and caption style, not the image content.

Do not place participant identifiers in screenshots. Crop away local paths, usernames, terminal prompts, and unrelated interface elements.

## Change colors

At the top of `assets/css/styles.css`, edit the values inside `:root`. Changing one token updates the entire site. For example:

```css
:root {
  --navy: #152b4f;
  --teal: #147d75;
  --orange: #d9651a;
}
```

Check text contrast after any color change, especially white text on navy buttons and dark text on tinted notes.

## Add a new page

1. Copy an existing page folder such as `methods`.
2. Rename the folder and update the page `<title>`, meta description, breadcrumb, `h1`, and main content.
3. Add the new link to the header and footer on all five existing pages plus the new page.
4. Use root-relative paths that start with `/`, such as `/assets/css/styles.css`.
5. Run `npm run check`.

## Check changes locally

Start the local server:

```bash
python3 -m http.server 4173
```

Open `http://localhost:4173`, then test:

- All header and footer links.
- Mobile navigation at a narrow browser width.
- Copy buttons on tutorial commands.
- Horizontal scrolling for wide tables and code.
- Keyboard focus using the Tab key.
- Figure alternative text and captions.
- Print preview for the tutorial page.

Finally, run:

```bash
npm run check
```

## Keep scientific content synchronized

Some information appears in more than one place because readers need it in context. When changing tracking parameters, update:

- The warning at the top of `tutorial/index.html`.
- The commands in `tutorial/index.html`.
- The comparison and reference tables in `methods/index.html`.
- The variables and comments in `examples/mesoconnect_inferior_vta_nac_template.sh`.
- The scientific guardrails in `README.md` if the distinction itself changes.
