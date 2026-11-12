/* Between the player and the manuscript view. Loaded before manuscript.js, which is the view of
   presentation/ unchanged and offers window.HERACLITUS_MANUSCRIPT (showPage, selectRegion, snapshot,
   ready).

   From the player:  {type: "proof-paper", region: "<id of a reviewed passage>" or null}
                     null is the whole manuscript: nothing is marked, and it is turned to its first page
   To the player:    {type: "proof-paper-state", ready, verified, region, page, pages, missing?}
                     {type: "proof-paper-close"}   Escape, when the search field is not open

   A passage is one of the reviewed list (manuscript-notes.js) or a reviewed addition (extra-regions.js).
   Both belong to one PDF, by its SHA-256. The view compares the embedded PDF with the list; if they
   differ it is not "verified", and then nothing is marked here and the player is told so. */
(function () {
  "use strict";
  var target = location.protocol === "file:" ? "*" : location.origin;
  var want = null, shown = null, busy = false, asked = false, told = null;      // told: the "ready" the player was last told
  function notes() { return window.HERACLITUS_MANUSCRIPT_NOTES; }
  function view() { return window.HERACLITUS_MANUSCRIPT; }
  function verified() { var v = view(); return !!(v && v.snapshot().manuscript.verified); }
  function region(id) {
    var A = notes(), X = window.PROOF_PAPER_EXTRA, hit = null;
    if (!A || !id) return null;
    A.regions.some(function (r) { if (r.id === id) hit = r; return hit; });
    if (!hit && X && X.sha256 === A.sha256) X.regions.some(function (r) { if (r.id === id) hit = r; return hit; });
    return hit;
  }
  function pageOf(r) { return document.querySelector('.pdf-page[data-page="' + r.page + '"]'); }
  function tell(o) { if (parent !== window) parent.postMessage(o, target); }
  function state(extra) {
    var v = view(), s = v ? v.snapshot().manuscript : {};
    var o = { type: "proof-paper-state", ready: !!(v && v.ready), verified: !!s.verified, region: shown, page: s.page || 0, pages: s.pages || 0 };
    if (extra) for (var k in extra) o[k] = extra[k];
    told = o.ready;
    tell(o);
  }
  // Draw the focus on the pages as they are laid out now. The view lays its pages out again when the
  // width changes, so this is called again then.
  function mark() {
    var old = document.querySelectorAll(".proof-layer"), i;
    for (i = 0; i < old.length; i++) old[i].remove();
    var r = verified() ? region(shown) : null, A = notes(), page = r && pageOf(r);
    document.body.classList.toggle("proof-has-focus", !!(r && page));
    if (!r || !page) return;
    var layer = document.createElement("div"); layer.className = "proof-layer"; layer.dataset.region = r.id;
    function box(cls, b, px, py) {
      var el = document.createElement("span"); el.className = cls;
      el.style.left = (b[0] - px) / A.width * 100 + "%"; el.style.top = (b[1] - py) / A.height * 100 + "%";
      el.style.width = (b[2] + 2 * px) / A.width * 100 + "%"; el.style.height = (b[3] + 2 * py) / A.height * 100 + "%";
      layer.appendChild(el);
    }
    (r.rects || [r.rect]).forEach(function (b) { box("proof-mark", b, 0, 0); });
    box("proof-frame", r.rect, 6, 4);
    page.appendChild(layer);
  }
  function turnTo(r) {             // to the page, then so that the passage begins a little below the top
    var v = view();
    if (notes().regions.indexOf(r) >= 0) return v.selectRegion(r);
    return v.showPage(r.page).then(function () {
      var page = pageOf(r);
      if (page) window.scrollTo({ top: page.offsetTop + r.rect[1] / notes().height * page.offsetHeight - 100, behavior: "instant" });
    });
  }
  function attempt() {
    var v = view();
    if (!asked || busy || !v || !v.ready) return;
    asked = false;
    var id = want, r = region(id);
    var done = function () { busy = false; mark(); state(); attempt(); };
    if (!id) { shown = null; busy = true; v.showPage(1).then(done, done); return; }   // the whole manuscript: from its first page
    if (!r) { shown = null; mark(); state({ missing: id }); return; }
    busy = true;
    if (verified()) turnTo(r).then(function () { shown = id; done(); }, done);
    else { shown = null; v.showPage(r.page).then(done, done); }
  }
  window.addEventListener("message", function (ev) {
    if (ev.source !== parent || !ev.data || ev.data.type !== "proof-paper") return;
    want = ev.data.region || null; asked = true; attempt();
  });
  document.addEventListener("keydown", function (e) {
    var panel = document.getElementById("pdf-search-panel");
    if (e.key === "Escape" && panel && panel.hidden) tell({ type: "proof-paper-close" });
  });
  document.addEventListener("DOMContentLoaded", function () {
    new MutationObserver(function () { setTimeout(mark, 0); }).observe(document.getElementById("pdf-pages"), { childList: true });
    // The view lays its pages out again when its width changes, and is not ready while it does. That can begin
    // and end between two looks here, and a turn of the page that it cuts short reports "not ready" on its way out.
    // So what is compared is what the player was last told, not what was last seen here: otherwise the player
    // is left at "Loading the manuscript…" over a manuscript that is drawn (seen in the player's checks).
    setInterval(function () {
      var v = view(), now = !!(v && v.ready);
      if (now !== told) state();
      attempt();
    }, 120);
    tell({ type: "proof-paper-state", ready: false, verified: false, region: null, page: 0, pages: 0 });
  });
})();
