import "../css/settings.css";
import "../css/colors.css";
import "../css/keyframes.css";
import "../css/view_transitions.css";
import "../css/defaults.css";
import "../css/layout.css";
import "../css/bits.css";
import "../css/components.css";
import "../css/pages/dashboard.css";
import "../css/pages/designer.css";
import "../css/pages/devices.css";
import "../css/pages/models.css";
import "../css/pages/playlists.css";
import "../css/pages/problem_details.css";
import "../css/pages/screens.css";

import htmx from "htmx.org";
window.htmx = htmx;

import "htmx-ext-sse";

htmx.onLoad(() => {
  import("htmx-remove/build/htmx-remove.js");
});
