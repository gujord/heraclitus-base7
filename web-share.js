/* Relative page routes keep scene previews readable by crawlers on a static host.
   The file edition retains its original fragment links. No network requests. */
(function (root, factory) {
  "use strict";
  var api = factory();
  if (typeof module === "object" && module.exports) module.exports = api;
  else { root.PROOF = root.PROOF || {}; root.PROOF.web = api; }
})(typeof window === "object" ? window : globalThis, function () {
  "use strict";
  function record(web, id) {
    return web && (id ? web.scenes && Object.prototype.hasOwnProperty.call(web.scenes, id) && web.scenes[id] : web.home);
  }
  function hosted(href) { return /^https?:$/.test(new URL(href).protocol); }
  function pageURL(href, web, id) {
    var r = record(web, id);
    if (!r) return null;
    return new URL(r.file, href).href;
  }
  function address(href, web, id, fragment) {
    return hosted(href) && record(web, id) ? pageURL(href, web, id) + fragment : fragment;
  }
  function shareURL(href, web, id, time) {
    var base = hosted(href) && record(web, id) ? pageURL(href, web, id) : href.split("#")[0];
    var timed = typeof time === "number" && Number.isFinite(time) && time >= 0;
    if (!hosted(href) || !record(web, id) || timed) base += "#" + id;
    return base + (timed ? "@" + Math.round(time * 10) / 10 : "");
  }
  function entry(href, web) {
    if (!web || !web.scenes) return null;
    var name;
    try { name = decodeURIComponent(new URL(href).pathname.split("/").pop()); }
    catch (e) { return null; }       // a malformed escape must not stop the player opening
    return Object.keys(web.scenes).find(function (id) { return web.scenes[id].file === name; }) || null;
  }
  function syncMetadata(doc, web, id) {
    var r = record(web, id), canonical = doc.querySelector('link[rel="canonical"]');
    if (!r || !canonical) return;
    // Use the configured public origin already in static metadata, never the local preview origin.
    var base = new URL("./", canonical.href), url = new URL(id ? r.file : "./", base).href;
    canonical.href = url;
    var values = {
      'meta[name="description"]': r.description,
      'meta[property="og:title"]': r.title,
      'meta[property="og:description"]': r.description,
      'meta[property="og:url"]': url,
      'meta[property="og:image"]': new URL(r.image_path, base).href,
      'meta[property="og:image:secure_url"]': new URL(r.image_path, base).href,
      'meta[property="og:image:alt"]': r.image_alt,
      'meta[name="twitter:title"]': r.title,
      'meta[name="twitter:description"]': r.description,
      'meta[name="twitter:image"]': new URL(r.image_path, base).href,
      'meta[name="twitter:image:alt"]': r.image_alt
    };
    Object.keys(values).forEach(function (selector) {
      var node = doc.querySelector(selector);
      if (node) node.setAttribute("content", values[selector]);
    });
  }
  return { address: address, shareURL: shareURL, entry: entry, syncMetadata: syncMetadata };
});
