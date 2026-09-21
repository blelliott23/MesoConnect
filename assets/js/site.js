/*
 * MesoConnect site behavior
 * -------------------------
 * This file contains only small usability enhancements. The scientific content
 * remains readable when JavaScript is unavailable.
 *
 * Edit here when you want to change:
 *   1. the mobile navigation behavior,
 *   2. the copy-code buttons, or
 *   3. the tutorial step progress indicator.
 */

const navToggle = document.querySelector("[data-nav-toggle]");
const siteNav = document.querySelector("[data-site-nav]");

if (navToggle && siteNav) {
  navToggle.addEventListener("click", () => {
    const isOpen = navToggle.getAttribute("aria-expanded") === "true";
    navToggle.setAttribute("aria-expanded", String(!isOpen));
    siteNav.dataset.open = String(!isOpen);
  });

  siteNav.querySelectorAll("a").forEach((link) => {
    link.addEventListener("click", () => {
      navToggle.setAttribute("aria-expanded", "false");
      siteNav.dataset.open = "false";
    });
  });
}

// Add a keyboard-accessible copy button to every code example marked copyable.
document.querySelectorAll("pre[data-copy]").forEach((codeBlock) => {
  const button = document.createElement("button");
  button.className = "copy-button";
  button.type = "button";
  button.textContent = "Copy";
  button.setAttribute("aria-label", "Copy command to clipboard");

  button.addEventListener("click", async () => {
    const code = codeBlock.querySelector("code")?.innerText ?? codeBlock.innerText;

    try {
      await navigator.clipboard.writeText(code);
      button.textContent = "Copied";
      button.dataset.copied = "true";
      window.setTimeout(() => {
        button.textContent = "Copy";
        delete button.dataset.copied;
      }, 1800);
    } catch {
      // Older browsers may block the clipboard API. Selecting the text still
      // gives the reader a clear fallback without hiding any content.
      const selection = window.getSelection();
      const range = document.createRange();
      range.selectNodeContents(codeBlock.querySelector("code") ?? codeBlock);
      selection?.removeAllRanges();
      selection?.addRange(range);
      button.textContent = "Selected";
    }
  });

  codeBlock.append(button);
});

// On the tutorial page, highlight the section closest to the reading position.
const stepLinks = [...document.querySelectorAll("[data-step-link]")];
const tutorialSteps = [...document.querySelectorAll("[data-tutorial-step]")];

if (stepLinks.length && tutorialSteps.length && "IntersectionObserver" in window) {
  const activateStep = (id) => {
    stepLinks.forEach((link) => {
      const active = link.getAttribute("href") === `#${id}`;
      link.toggleAttribute("aria-current", active);
    });
  };

  const observer = new IntersectionObserver(
    (entries) => {
      const visible = entries
        .filter((entry) => entry.isIntersecting)
        .sort((a, b) => b.intersectionRatio - a.intersectionRatio)[0];
      if (visible?.target.id) activateStep(visible.target.id);
    },
    { rootMargin: "-18% 0px -65%", threshold: [0.05, 0.25, 0.5] }
  );

  tutorialSteps.forEach((step) => observer.observe(step));
}

// Insert the current year anywhere the footer uses data-current-year.
document.querySelectorAll("[data-current-year]").forEach((element) => {
  element.textContent = String(new Date().getFullYear());
});

