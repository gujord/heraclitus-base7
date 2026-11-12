/* Local provider marks identify existing destinations; labels and handlers stay intact. */
(function (root, factory) {
  "use strict";
  var api = factory();
  if (typeof module === "object" && module.exports) module.exports = api;
  else { root.PROOF = root.PROOF || {}; root.PROOF.linkIcons = api; }
})(typeof window === "object" ? window : globalThis, function () {
  "use strict";
  var files = { github: "link-icons/github.svg", zenodo: "link-icons/zenodo.svg", oeis: "link-icons/oeis.png", pdf: "link-icons/pdf.svg" };
  function provider(href) {
    var url;
    try { url = new URL(href); } catch (e) { return null; }
    if (url.protocol !== "https:" || url.username || url.password || url.port || url.search || url.hash) return null;
    if (url.hostname === "github.com" && (url.pathname === "/gujord/heraclitus-base7" || url.pathname === "/gujord/heraclitus-base7/releases/tag/v1.1.0")) return "github";
    if (url.hostname === "doi.org" && url.pathname === "/10.5281/zenodo.24086002") return "zenodo";
    if (url.hostname === "oeis.org" && url.pathname === "/A398761") return "oeis";
    return null;
  }
  function decorate(doc, node, kind) {
    if (!node || !files[kind] || node.querySelector(".resource-icon, svg, .guide-ic")) return;
    var image = doc.createElement("img");
    image.className = "resource-icon resource-icon-" + kind;
    image.src = files[kind]; image.alt = "";
    image.setAttribute("aria-hidden", "true");
    image.setAttribute("width", "20"); image.setAttribute("height", "20");
    image.setAttribute("draggable", "false");
    image.decoding = "async";
    node.classList.add("has-resource-icon");
    node.insertBefore(image, node.firstChild);
  }
  function init(doc) {
    doc = doc || document;
    Array.prototype.forEach.call(doc.querySelectorAll("a[href]"), function (anchor) {
      var kind = provider(anchor.href);
      if (kind) decorate(doc, anchor, kind);
    });
    ["channel-manuscript", "more-manuscript", "about-manuscript", "guide-manuscript", "paper-original"].forEach(function (id) {
      decorate(doc, doc.getElementById(id), "pdf");
    });
  }
  return { init: init, provider: provider };
});
