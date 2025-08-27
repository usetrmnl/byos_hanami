import "../css/settings.css";
import "../css/colors.css";
import "../css/keyframes.css";
import "../css/view_transitions.css";
import "../css/defaults.css";
import "../css/layout.css";
import "../css/bits/actions.css";
import "../css/bits/breadcrumbs.css";
import "../css/bits/buttons.css";
import "../css/bits/containers.css";
import "../css/bits/definition_lists.css";
import "../css/bits/empty.css";
import "../css/bits/forms.css";
import "../css/bits/headers.css";
import "../css/bits/links.css";
import "../css/bits/loaders.css";
import "../css/bits/pills.css";
import "../css/bits/popovers.css";
import "../css/bits/search.css";
import "../css/bits/secrets.css";
import "../css/bits/text.css";
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
  import("htmx-remove");
});
