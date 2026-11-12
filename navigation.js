/* The transcript and chapter overview share the catalogue. No network requests,
   scene SVG loading or separate animation clock are needed for text search. */
(function () {
  "use strict";
  var P = window.PROOF;
  var N = P.navigation = {};
  N.chapters = function (cat) {
    var groups = {}, order = [];
    cat.order.forEach(function (id) {
      var s = cat.scenes[id], p = String(s.part);
      if (!groups[p]) { groups[p] = { number: p, title: cat.parts[p], scenes: [], duration: 0 }; order.push(p); }
      groups[p].scenes.push(id); groups[p].duration += s.duration || 0;
    });
    return order.map(function (p) {
      var c = groups[p]; c.first = c.scenes[0];
      var example = c.scenes.filter(function (id) { return !/^D\d+$/.test(id); })[0] || c.first;
      c.still = cat.scenes[example].still;
      return c;
    });
  };
  function normalize(s) { return s.toLocaleLowerCase().replace(/[’‘]/g, "'").replace(/\s+/g, " ").trim(); }
  // Where a word of the query is found in a text (both in lower case). A word of one or two characters
  // is a symbol or a number here (m, k, C, 7m): it has to stand as a word of its own, so that "m" does not
  // find the m in "jump". A longer word is found anywhere, so that "mark" finds "marker".
  var LETTER = /[\p{L}\p{N}]/u;
  N.places = function (text, word) {
    var out = [], at = 0, i;
    while (word && (i = text.indexOf(word, at)) >= 0) {
      if (word.length > 2 || (!LETTER.test(text.charAt(i - 1)) && !LETTER.test(text.charAt(i + word.length)))) out.push(i);
      at = i + 1;
    }
    return out;
  };
  N.find = function (cat, query) {
    var terms = normalize(query).split(" ").filter(Boolean), found = [];
    if (!terms.length) return found;
    cat.order.forEach(function (id) {
      var c = cat.scenes[id], heading = id + " " + c.title + " " + cat.parts[String(c.part)];
      (cat.transcript[id] || []).forEach(function (row, k) {
        var hay = normalize(heading + " " + row.text);
        if (terms.every(function (word) { return N.places(hay, word).length; })) {
          found.push({ scene: id, shot: k, start: row.start, text: row.text, part: c.part });
        }
      });
    });
    return found;
  };
  // The drawing clock includes the previous shot's endpoint. A timestamp seeks
  // just inside the next shot so its transcript row is selected from the start.
  N.cueTime = function (start, index) { return start + (index > 0 ? 0.000001 : 0); };
  N.init = function (ui, chapters) {
    var cat = P.cat, $ = function (id) { return document.getElementById(id); };
    var list = $("shots"), cards = $("chapter-cards"), results = $("transcript-results");
    var input = $("transcript-search"), following = true, autoTop = null, searching = false;
    var chapterCards = {}, active = { scene: null, shot: -1 };
    function fmt(t) { t = Math.floor(t + 1e-6); return Math.floor(t / 60) + ":" + String(t % 60).padStart(2, "0"); }
    function node(tag, cls, text) { var e = document.createElement(tag); if (cls) e.className = cls; if (text !== undefined) e.textContent = text; return e; }
    function follow(on) {
      autoTop = null;
      following = on;
      $("transcript-follow").setAttribute("aria-pressed", String(on));
      $("transcript-follow-status").textContent = on ? "Following playback" : "Reading freely";
      if (on) scrollCurrent();
    }
    function scrollCurrent() {
      if (!following || searching || $("panel-transcript").hidden) return;
      var el = list.children[active.shot]; if (!el) return;
      var row = el.getBoundingClientRect(), box = list.getBoundingClientRect();
      if (row.top < box.top + 8 || row.bottom > box.bottom - 8) {
        list.scrollTop = Math.max(0, list.scrollTop + row.top - box.top - list.clientHeight / 3);
        autoTop = list.scrollTop;
      }
    }
    function stopFollowing() { if (following) follow(false); }
    list.addEventListener("wheel", stopFollowing, { passive: true });
    list.addEventListener("touchmove", stopFollowing, { passive: true });
    list.addEventListener("scroll", function () {
      if (autoTop !== null && Math.abs(list.scrollTop - autoTop) < 1) { autoTop = null; return; }
      autoTop = null; stopFollowing();
    }, { passive: true });
    list.addEventListener("keydown", function (e) {
      if (["ArrowUp", "ArrowDown", "PageUp", "PageDown", "Home", "End"].indexOf(e.key) >= 0) { stopFollowing(); e.stopPropagation(); }
    });
    $("transcript-follow").onclick = function () { follow(!following); };
    function go(id, time) {
      var playing = ui.state.playing || ui.state.loading;
      if (ui.state.scene && ui.state.scene.id === id) ui.seek(time);
      else ui.open(id, "@" + time, playing);
    }
    N.highlight = function (el, text, query) { highlighted(el, text, query); };   // the start page's search marks its words the same way
    function markHits() {
      Array.prototype.forEach.call(results.querySelectorAll(".search-hit"), function (b) {
        var on = b.dataset.scene === active.scene && Number(b.dataset.shot) === active.shot;
        b.classList.toggle("now", on);
        if (on) b.setAttribute("aria-current", "true"); else b.removeAttribute("aria-current");
      });
    }
    function highlighted(el, text, query) {
      var words = query.trim().split(/\s+/).filter(Boolean).sort(function (a, b) { return b.length - a.length; });
      var at = 0, lower = text.toLocaleLowerCase();
      while (at < text.length) {
        var next = -1, length = 0;
        words.forEach(function (word) {
          var i = N.places(lower, word.toLocaleLowerCase()).filter(function (j) { return j >= at; })[0];
          if (i !== undefined && (next < 0 || i < next)) { next = i; length = word.length; }
        });
        if (next < 0) { el.appendChild(document.createTextNode(text.slice(at))); break; }
        el.appendChild(document.createTextNode(text.slice(at, next)));
        el.appendChild(node("mark", "", text.slice(next, next + length))); at = next + length;
      }
    }
    function search() {
      var query = input.value.trim(); searching = !!query;
      $("transcript-clear").hidden = !searching;
      $("transcript-heading").hidden = searching;
      $("transcript-follow-row").hidden = searching;
      $("transcript-search-status").hidden = !searching;
      results.hidden = !searching; list.hidden = searching; results.replaceChildren();
      if (!searching) { scrollCurrent(); return; }
      var hits = N.find(cat, query), scenes = new Set(hits.map(function (h) { return h.scene; }));
      $("transcript-search-status").textContent = hits.length ? hits.length + " passages in " + scenes.size + " scenes · times within each scene" : "No matches. Try a different word or scene number.";
      var lastPart = null, lastScene = null;
      hits.forEach(function (h) {
        if (lastPart !== h.part) { results.appendChild(node("h3", "search-chapter", "Part " + h.part + " · " + cat.parts[String(h.part)])); lastPart = h.part; }
        if (lastScene !== h.scene) { results.appendChild(node("h4", "search-scene", h.scene + " · " + cat.scenes[h.scene].title)); lastScene = h.scene; }
        var b = node("button", "search-hit"); b.type = "button"; b.dataset.scene = h.scene; b.dataset.shot = String(h.shot);
        b.setAttribute("aria-label", "Scene " + h.scene + ", " + fmt(h.start) + ": " + h.text);
        b.appendChild(node("time", "", fmt(h.start)));
        var text = node("span"); highlighted(text, h.text, query); b.appendChild(text);
        b.onclick = function () { go(h.scene, N.cueTime(h.start, h.shot)); };
        results.appendChild(b);
      });
      results.scrollTop = 0; markHits();
    }
    input.addEventListener("input", search);
    input.addEventListener("keydown", function (e) { if (e.key === "Escape" && input.value) { e.preventDefault(); e.stopPropagation(); input.value = ""; search(); } });
    $("transcript-clear").onclick = function () { input.value = ""; search(); input.focus(); };
    $("transcript-search-form").onsubmit = function (e) { e.preventDefault(); var first = results.querySelector(".search-hit"); if (first) first.click(); };
    chapters.forEach(function (c) {
      var b = node("button", "chapter-card"); b.type = "button"; b.dataset.chapter = c.number;
      var img = node("img"); img.src = c.still; img.alt = ""; img.loading = "lazy"; b.appendChild(img);
      b.appendChild(node("small", "", "Part " + c.number + " · " + fmt(c.duration)));
      b.appendChild(node("b", "", c.title));
      b.setAttribute("aria-label", "Part " + c.number + ": " + c.title + ", " + fmt(c.duration));
      b.onclick = function () { ui.open(c.first, 0, ui.state.playing || ui.state.loading); };
      cards.appendChild(b); chapterCards[c.number] = b;
    });
    function arrows() {
      $("chapters-prev").disabled = cards.scrollLeft <= 1;
      $("chapters-next").disabled = cards.scrollLeft + cards.clientWidth >= cards.scrollWidth - 1;
    }
    function shift(sign) { cards.scrollBy({ left: sign * Math.max(180, cards.clientWidth * .8), behavior: "auto" }); arrows(); }
    $("chapters-prev").onclick = function () { shift(-1); };
    $("chapters-next").onclick = function () { shift(1); };
    cards.addEventListener("scroll", arrows, { passive: true });
    cards.addEventListener("keydown", function (e) {
      var all = Array.prototype.slice.call(cards.children), at = all.indexOf(document.activeElement), next;
      if (at < 0) return;
      if (e.key === "ArrowRight") next = Math.min(all.length - 1, at + 1);
      else if (e.key === "ArrowLeft") next = Math.max(0, at - 1);
      else if (e.key === "Home") next = 0;
      else if (e.key === "End") next = all.length - 1;
      else return;
      e.preventDefault(); e.stopPropagation(); all[next].focus();
    });
    [$("chapters-prev"), $("chapters-next")].forEach(function (b) {
      b.addEventListener("keydown", function (e) {
        if (e.key === "ArrowLeft" || e.key === "ArrowRight") { e.preventDefault(); e.stopPropagation(); shift(e.key === "ArrowLeft" ? -1 : 1); }
      });
    });
    window.addEventListener("resize", arrows);
    $("desc-more").addEventListener("click", function () { arrows(); });
    function reveal(which) {
      ui.tab(which);
      var target = $("tab-" + which); target.focus({ preventScroll: true });
      var box = $("navigation-panel").getBoundingClientRect();
      if (box.top < 56 || box.top > window.innerHeight - 120) $("navigation-panel").scrollIntoView({ block: "start", behavior: "auto" });
    }
    $("chapters-all").onclick = function () { reveal("scenes"); };
    $("show-transcript").onclick = function () { input.value = ""; search(); follow(true); reveal("transcript"); };
    $("more-manuscript").onclick = function () { ui.paper.open(null); };
    var tabs = [$("tab-scenes"), $("tab-transcript")];
    tabs.forEach(function (b, i) {
      b.addEventListener("keydown", function (e) {
        var j = e.key === "ArrowRight" ? (i + 1) % 2 : e.key === "ArrowLeft" ? (i + 1) % 2 : e.key === "Home" ? 0 : e.key === "End" ? 1 : -1;
        if (j < 0) return;
        e.preventDefault(); e.stopPropagation(); ui.tab(j ? "transcript" : "scenes"); tabs[j].focus();
      });
    });
    return {
      fill: function (s) {
        $("transcript-title").textContent = s.id + " · " + s.title;
        $("transcript-sub").textContent = "Part " + s.part.number + " · " + fmt(s.duration) + " · times within this scene";
        Object.keys(chapterCards).forEach(function (p) {
          var on = p === String(s.part.number), b = chapterCards[p]; b.classList.toggle("now", on);
          if (on) b.setAttribute("aria-current", "true"); else b.removeAttribute("aria-current");
        });
        // Clearing/replacing scene rows resets their scroll position; that reset
        // is not a reader gesture and must not disable following.
        autoTop = list.scrollTop;
      },
      sync: function (s, k) {
        active = { scene: s.id, shot: k };
        Array.prototype.forEach.call(list.children, function (li, j) {
          var b = li.querySelector(".ts");
          if (j === k) b.setAttribute("aria-current", "true"); else b.removeAttribute("aria-current");
        });
        scrollCurrent(); if (searching) markHits();
      },
      tab: function () { scrollCurrent(); },
      follow: follow,
      search: search
    };
  };
})();
