export const fullscreen = {
  toggleFullscreen: function() {
    const viewport = document.querySelector(".viewport");

    if (!document.fullscreenElement) {
      if (viewport.requestFullscreen) {
        viewport.requestFullscreen();
      }
    } else {
      if (document.exitFullscreen) {
        document.exitFullscreen();
      }
    }
  }
};

if (document.querySelector(".reeler")) {
  document.addEventListener("keydown", function(event) {
    if (event.key === "f") {
      fullscreen.toggleFullscreen();
    }
  });
}
