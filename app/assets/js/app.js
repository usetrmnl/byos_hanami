import "../css/settings.css";
import "../css/colors.css";
import "../css/keyframes.css";
import "../css/view_transitions.css";
import "../css/defaults.css";
import "../css/layout.css";
import "../css/bits/breadcrumbs.css";
import "../css/bits/buttons.css";
import "../css/bits/cards.css";
import "../css/bits/containers.css";
import "../css/bits/definition_lists.css";
import "../css/bits/editor.css";
import "../css/bits/empty.css";
import "../css/bits/forms.css";
import "../css/bits/headers.css";
import "../css/bits/links.css";
import "../css/bits/loaders.css";
import "../css/bits/pages.css";
import "../css/bits/pills.css";
import "../css/bits/popovers.css";
import "../css/bits/secrets.css";
import "../css/bits/text.css";
import "../css/pages/dashboard.css";
import "../css/pages/designer.css";
import "../css/pages/devices.css";
import "../css/pages/playlists.css";
import "../css/pages/problem_details.css";

import Alpine from "alpinejs";
import htmx from "htmx.org";

window.Alpine = Alpine;
window.htmx = htmx;

Alpine.start();

import "htmx-ext-sse";
import "htmx-remove";

import { basicSetup } from "codemirror";
import { EditorView, keymap } from "@codemirror/view";
import { indentWithTab } from "@codemirror/commands";
import { linter, lintGutter } from "@codemirror/lint";
import { json } from "@codemirror/lang-json";
import { html } from "@codemirror/lang-html";

function initializeCodeMirror() {
  const languages = {
    json: json(),
    liquid: html()
  };

  document.querySelectorAll(".bit-editor").forEach((element) => {
    if (element.dataset.initialized) return;

    let code = element.value;
    let language = element.dataset.language;
    let editor = document.createElement("div");
    let extensions = [
      basicSetup,
      keymap.of([indentWithTab]),
      EditorView.updateListener.of((update) => {
        if (update.docChanged) {
          element.value = update.state.doc.toString();
        }
      })
    ];

    if (languages[language]) {
      extensions.push(languages[language]);
    }

    element.style.display = "none";
    element.parentNode.insertBefore(editor, element.nextSibling);

    new EditorView({
      doc: code,
      extensions: extensions,
      parent: editor
    });

    element.dataset.initialized = "true";
  });
}

document.body.addEventListener("htmx:load", function(event) {
  initializeCodeMirror();
});
