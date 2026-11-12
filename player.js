/* The proof player. Plain JavaScript, no framework, no network.

   One clock: the picture is a function of the time within the scene alone,
   draw(view, scene, t). When the sound plays, t is the time of the sound; when
   it is paused, sought, played at another speed or stepped without sound, the
   same function is called with the new time. Nothing animates on a clock of
   its own, so the same time always gives the same picture.

   A scene is a list of shots. Shot k runs over the times start < t <= end
   (the first shot also holds t = 0). In the first part of a shot the still
   before it changes into the shot's own still; from then on, and at the end of
   the shot, the figure is exactly the shot's still, a checked still copied
   byte for byte from the generators.

   Three kinds of change: a fade of the whole figure; a movement, where objects
   with the same data-id in both stills move from the old place to the new one
   while the rest fades; and a jump, an object with data-kind="jump", which
   travels along an arc above the line and touches only where it lands. */
(function () {
  "use strict";
  var P = window.PROOF = window.PROOF || {};
  P.scenes = P.scenes || {};
  P.add = function (s) { P.scenes[s.id] = s; if (P.onadd) P.onadd(s); };
  P.catalogue = function (c) { P.cat = c; };

  // ------------------------------------------------------------ time to state
  P.at = function (scene, t) {
    var sh = scene.shots, n = sh.length, k = 0;
    t = Math.max(0, Math.min(t, scene.duration));
    while (k < n - 1 && t > sh[k].end) k++;
    var s = sh[k], f = Math.min(s.fade, s.end - s.start);
    var p = f > 0 ? Math.max(0, Math.min(1, (t - s.start) / f)) : 1;
    return { k: k, p: p, t: t };
  };
  function ease(p) { return p * p * (3 - 2 * p); }

  // ------------------------------------------------------------ drawing
  var NS = "http://www.w3.org/2000/svg";
  function setLayer(layer, scene, k) {
    var key = k < 0 ? "" : scene.id + "/" + k;
    if (layer.key !== key || layer.dirty) {
      layer.innerHTML = k < 0 ? "" : scene.shots[k].still;
      layer.key = key; layer.dirty = false;
    }
  }
  function show(el, on, opacity) {
    el.style.visibility = on ? "visible" : "hidden";
    el.style.opacity = on ? String(opacity) : "0";
  }
  function empty(layer) {
    if (layer.firstChild) layer.innerHTML = "";
    layer.key = ""; layer.dirty = false; show(layer, false, 0);
  }
  P.view = function (stage) {
    return { stage: stage, A: stage.querySelector(".layer.a"), B: stage.querySelector(".layer.b"),
             C: stage.querySelector(".layer.c") };
  };
  P.draw = function (view, scene, t) {
    var st = P.at(scene, t), sh = scene.shots[st.k];
    setLayer(view.B, scene, st.k);
    if (st.p >= 1) {
      // The still alone. The other layers are emptied, not only hidden: an arrowhead is found by its name
      // in the whole page, the first of that name wins, and it takes its visibility from where it is
      // defined. A hidden copy of the last still, lying first, would take the arrowheads off this one.
      show(view.B, true, 1); empty(view.A);
      if (view.C) empty(view.C);
      return st;
    }
    setLayer(view.A, scene, st.k - 1);
    var e = ease(st.p);
    show(view.A, st.k > 0, 1); show(view.B, true, e);
    if (view.C) {
      if (sh.change.kind === "move" && st.k > 0) move(view, e, st.p);
      else empty(view.C);
    }
    return st;
  };

  // ------------------------------------------------------------ movement
  var NUM = ["x", "y", "width", "height", "cx", "cy", "r", "rx", "x1", "y1", "x2", "y2", "font-size", "opacity",
             "stroke-width", "fill-opacity", "stroke-opacity"];
  var COLOR = ["fill", "stroke"];
  function lerp(a, b, e) { return a + (b - a) * e; }
  function hex(c) {
    var m = /^#([0-9a-f]{6})$/i.exec(c || "");
    return m ? [0, 2, 4].map(function (i) { return parseInt(m[1].substr(i, 2), 16); }) : null;
  }
  function mix(a, b, e) {
    var x = hex(a), y = hex(b);
    if (!x || !y) return e < 0.5 ? a : b;
    return "#" + x.map(function (v, i) { return ("0" + Math.round(lerp(v, y[i], e)).toString(16)).slice(-2); }).join("");
  }
  function translate(el) {
    var m = /translate\(\s*([-\d.e]+)[ ,]+([-\d.e]+)\s*\)/.exec(el.getAttribute("transform") || "");
    return m ? [parseFloat(m[1]), parseFloat(m[2])] : [0, 0];
  }
  function numbers(d) { return (d || "").match(/-?[\d.]+(?:e-?\d+)?/g) || []; }
  function tween(a, b, e, jump) {
    // b is a copy of the new object; give it attributes between those of a and its own.
    NUM.forEach(function (n) {
      if (a.hasAttribute(n) && b.hasAttribute(n)) {
        var x = parseFloat(a.getAttribute(n)), y = parseFloat(b.getAttribute(n));
        if (!isNaN(x) && !isNaN(y)) b.setAttribute(n, String(lerp(x, y, e)));
      }
    });
    COLOR.forEach(function (n) {
      if (a.hasAttribute(n) && b.hasAttribute(n)) b.setAttribute(n, mix(a.getAttribute(n), b.getAttribute(n), e));
    });
    if (a.hasAttribute("d") && b.hasAttribute("d")) {
      var da = a.getAttribute("d"), db = b.getAttribute("d"), na = numbers(da), nb = numbers(db);
      if (na.length === nb.length && da.replace(/-?[\d.]+(?:e-?\d+)?/g, "#") === db.replace(/-?[\d.]+(?:e-?\d+)?/g, "#")) {
        var i = 0;
        b.setAttribute("d", db.replace(/-?[\d.]+(?:e-?\d+)?/g, function () {
          var v = lerp(parseFloat(na[i]), parseFloat(nb[i]), e); i++; return String(v);
        }));
      }
    }
    var ta = translate(a), tb = translate(b);
    if (ta[0] !== tb[0] || ta[1] !== tb[1] || jump) {
      var x = lerp(ta[0], tb[0], e), y = lerp(ta[1], tb[1], e);
      if (jump) y -= Math.max(24, Math.min(100, 0.4 * Math.abs(tb[0] - ta[0]))) * Math.sin(Math.PI * e);
      b.setAttribute("transform", "translate(" + x + "," + y + ")");
    }
    return [ta, tb];
  }
  function move(view, e, p) {
    var A = view.A.firstElementChild, B = view.B.firstElementChild;
    view.C.innerHTML = "";
    if (!A || !B) { show(view.C, false, 0); return; }
    var svg = B.cloneNode(false);
    var old = {};
    A.querySelectorAll("[data-id]").forEach(function (el) { old[el.getAttribute("data-id")] = el; });
    var defs = B.querySelector("defs");
    if (defs) svg.appendChild(defs.cloneNode(true));
    B.querySelectorAll("[data-id]").forEach(function (el) {
      var id = el.getAttribute("data-id"), a = old[id];
      if (!a) return;
      var jump = el.getAttribute("data-kind") === "jump";
      var same = a.innerHTML === el.innerHTML;
      var before = a.cloneNode(true), after = el.cloneNode(true);
      var ends = tween(a, after, e, jump);
      if (!same) {              // the object changed its inside: the old inside fades out at the same place
        before.setAttribute("transform", after.getAttribute("transform") || "");
        before.setAttribute("opacity", String(1 - e));
        after.setAttribute("opacity", String(e));
        svg.appendChild(before);
      }
      if (jump) {               // the arc it travels, drawn as far as it has come
        var x0 = ends[0][0], y0 = ends[0][1], x1 = ends[1][0], y1 = ends[1][1];
        var h = Math.max(24, Math.min(100, 0.4 * Math.abs(x1 - x0)));
        var d = "M" + x0 + " " + y0;
        for (var i = 1; i <= 24; i++) {
          var q = e * i / 24;
          d += "L" + lerp(x0, x1, q) + " " + (lerp(y0, y1, q) - h * Math.sin(Math.PI * q));
        }
        var arc = document.createElementNS(NS, "path");
        arc.setAttribute("d", d); arc.setAttribute("fill", "none");
        arc.setAttribute("stroke", el.getAttribute("data-arc") || "#1d2733");
        arc.setAttribute("stroke-width", "3"); arc.setAttribute("stroke-dasharray", "6 5");
        arc.setAttribute("transform", "translate(" + (el.getAttribute("data-ax") || 0) + "," + (el.getAttribute("data-ay") || 0) + ")");
        svg.appendChild(arc);
      }
      svg.appendChild(after);
      a.setAttribute("visibility", "hidden"); el.setAttribute("visibility", "hidden");
      view.A.dirty = true; view.B.dirty = true;
    });
    view.C.appendChild(svg);
    show(view.C, true, 1);
  }

  // ------------------------------------------------------------ the player page
  var ICON = {
    play: '<path d="M8 5v14l11-7z"/>',
    pause: '<path d="M6 5h4v14H6zM14 5h4v14h-4z"/>',
    next: '<path d="M5 6l9 6-9 6zM16 6h2.5v12H16z"/>',
    prev: '<path d="M5.5 6H8v12H5.5zM19 6v12l-9-6z"/>',
    vol: '<path d="M3 9v6h4l5 5V4L7 9z"/><path d="M14 7.2a5.5 5.5 0 0 1 0 9.6v-2.3a3.3 3.3 0 0 0 0-5z"/><path d="M14 3.2a9.2 9.2 0 0 1 0 17.6v-2.2a7 7 0 0 0 0-13.2z"/>',
    mute: '<path d="M3 9v6h4l5 5V4L7 9z"/><path d="M14.6 9l1.4-1.4 2.3 2.3 2.3-2.3L22 9l-2.3 2.3 2.3 2.3-1.4 1.4-2.3-2.3-2.3 2.3-1.4-1.4 2.3-2.3z"/>',
    back: '<path d="M15.4 7.4L14 6l-6 6 6 6 1.4-1.4-4.6-4.6z"/>',
    fwd: '<path d="M8.6 7.4L10 6l6 6-6 6-1.4-1.4 4.6-4.6z"/>',
    cc: '<rect x="2.5" y="5" width="19" height="14" rx="2.5" fill="none" stroke="#fff" stroke-width="1.8"/>' +
        '<text x="12" y="15.4" text-anchor="middle" font-size="8.2" font-weight="800" fill="#fff" font-family="Arial, sans-serif">CC</text>',
    theater: '<rect x="2.5" y="6.5" width="19" height="11" rx="1.5" fill="none" stroke="#fff" stroke-width="2"/>',
    full: '<path d="M4 9.5V4h5.5v2.2H6.2v3.3zM14.5 4H20v5.5h-2.2V6.2h-3.3zM20 14.5V20h-5.5v-2.2h3.3v-3.3zM9.5 20H4v-5.5h2.2v3.3h3.3z"/>',
    replay: '<path d="M12 5V1L7 6l5 5V7c3.31 0 6 2.69 6 6s-2.69 6-6 6-6-2.69-6-6H4c0 4.42 3.58 8 8 8s8-3.58 8-8-3.58-8-8-8z"/>',
    small: '<path d="M7.3 4h2.2v5.5H4V7.3h3.3zM14.5 4h2.2v3.3H20v2.2h-5.5zM14.5 14.5H20v2.2h-3.3V20h-2.2zM4 14.5h5.5V20H7.3v-3.3H4z"/>'
  };
  ICON.gear = (function () {
    var d = "", n = 8, R = 9.6, r = 7.3;
    for (var i = 0; i < n * 4; i++) {
      var a = (i / (n * 4)) * 2 * Math.PI - Math.PI / 2 + Math.PI / (n * 4), q = i % 4, rad = q === 1 || q === 2 ? R : r;
      d += (i ? "L" : "M") + (12 + rad * Math.cos(a)).toFixed(2) + " " + (12 + rad * Math.sin(a)).toFixed(2);
    }
    return '<path fill-rule="evenodd" d="' + d + 'ZM12 8.6a3.4 3.4 0 1 0 0 6.8a3.4 3.4 0 1 0 0-6.8z"/>';
  })();
  function svg(name) { return '<svg viewBox="0 0 24 24" aria-hidden="true">' + ICON[name] + "</svg>"; }

  P.start = function () {
    var cat = P.cat, $ = function (id) { return document.getElementById(id); };
    var stage = $("stage"), view = P.view(stage), audio = $("audio"), player = $("player");
    var state = { scene: null, t: 0, playing: false, sound: true, speed: 1, w0: 0, t0: 0, raf: 0, auto: true,
                  captions: false, drag: false, volume: 1, muted: false, next: null, loading: false, load: 0, icon: "", want: false };
    // After a scene, autoplay waits GAP seconds before the next scene's sound begins: the last figure stays
    // with the card for the next scene, and for the last LOAD seconds the new scene is open, not yet playing.
    var GAP = 2.0, LOAD = 0.4, SPEEDS = [0.5, 0.75, 1, 1.25, 1.5, 1.75, 2];
    var store = {};
    try { store = JSON.parse(localStorage.getItem("proof-player") || "{}") || {}; } catch (e) { store = {}; }
    function keep(k, v) { store[k] = v; try { localStorage.setItem("proof-player", JSON.stringify(store)); } catch (e) { /* none */ } }
    ["auto", "captions", "speed", "volume", "muted"].forEach(function (k) { if (k in store) state[k] = store[k]; });

    ["play", "prev-scene", "next-scene", "prev", "next", "cc", "gear", "theater"].forEach(function (id) {
      $(id).innerHTML = svg({ "prev-scene": "prev", "next-scene": "next", prev: "back", next: "fwd" }[id] || id);
    });
    $("bigplay").innerHTML = svg("play");

    function scene() { return state.scene; }
    function clock() {
      if (!state.playing) return state.t;
      if (useAudio()) return audio.currentTime;
      return state.t0 + (performance.now() - state.w0) / 1000 * state.speed;
    }
    function useAudio() { return state.sound && scene() && scene().audio; }
    function fmt(t) { t = Math.floor(t + 1e-6); var m = Math.floor(t / 60), s = t - 60 * m; return m + ":" + (s < 10 ? "0" : "") + s; }

    // ---------------------------------------------------------- the scene list
    var chapters = P.navigation.chapters(cat), rows = {}, navigation = null;
    var pl = $("playlist");
    chapters.forEach(function (chapter) {
      var p = chapter.number;
      var h = document.createElement("h4"); h.className = "chapter-heading";
      h.textContent = "Part " + p + " · " + chapter.title;
      var detail = document.createElement("small"); detail.textContent = chapter.scenes.length + " scenes · " + fmt(chapter.duration);
      h.appendChild(detail); pl.appendChild(h);
      chapter.scenes.forEach(function (id) {
        var c = cat.scenes[id], b = document.createElement("button");
        b.type = "button"; b.className = "item";
        b.innerHTML = '<span class="num"></span><span class="th"><img loading="lazy" alt=""><em></em><u></u></span><span class="tx"><b></b><small></small></span>';
        b.querySelector(".num").textContent = String(cat.order.indexOf(id) + 1);
        if (c.still) b.querySelector("img").src = c.still;
        b.querySelector("em").textContent = c.duration ? fmt(c.duration) : "";
        b.querySelector("b").textContent = id + " · " + c.title;
        b.querySelector("small").textContent = "Part " + p + (c.shots ? " · " + c.shots + " shots" : "") + ((cat.notes || {})[id] ? " · with the argument to read" : "");
        b.querySelector("u").style.width = (100 * ((store.seen || {})[id] || 0)) + "%";
        b.onclick = function () { open(id, 0, state.playing || state.loading); };
        pl.appendChild(b); rows[id] = b;
      });
    });

    // ---------------------------------------------------------- drawing the page at a time
    var posterOf = null, posterUrl = null;
    function render() {
      var s = scene(); if (!s) return;
      var st = P.draw(view, s, state.t), segs = $("segments").children;
      for (var i = 0; i < segs.length; i++) {
        var sh = s.shots[i], f = state.t >= sh.end ? 1 : state.t <= sh.start ? 0 : (state.t - sh.start) / (sh.end - sh.start);
        segs[i].firstChild.style.transform = "scaleX(" + f + ")";
      }
      $("knob").style.left = (100 * st.t / s.duration) + "%";
      $("time").textContent = fmt(st.t) + " / " + fmt(s.duration);
      $("chapter").textContent = "Shot " + (st.k + 1) + " of " + s.shots.length;
      var fresh = !state.playing && !state.loading && st.t === 0;
      player.classList.toggle("fresh", fresh);
      if (fresh && posterOf !== s.id) {     // the first shot's still, as a picture of its own: not a second figure in the page
        if (posterUrl) URL.revokeObjectURL(posterUrl);
        posterUrl = URL.createObjectURL(new Blob([s.shots[0].still], { type: "image/svg+xml" }));
        $("poster").src = posterUrl; posterOf = s.id;
      }
      $("poster").classList.toggle("fade", posterOf === s.id && st.t === 0 && (state.playing || state.loading));
      button();
      if (state.shown !== s.id + "/" + st.k) {
        state.shown = s.id + "/" + st.k;
        var items = $("shots").children;
        for (var j = 0; j < items.length; j++) items[j].classList.toggle("now", j === st.k);
        if (navigation) navigation.sync(s, st.k);
        var cap = $("caption");
        cap.firstChild.textContent = s.shots[st.k].text;
        cap.classList.toggle("question", s.shots[st.k].speaker.indexOf("question") >= 0);
        paperLinks(s, st.k); address();
      }
    }
    function address() {           // the scene and shot, and the passage of the manuscript if its window is open
      var s = scene(); if (!s || homeOn) return;   // the start page keeps its own address, also with the manuscript over it
      var o = overOpen();          // a window another file brought, if it has a name for the address
      var h = "#" + s.id + "/" + (P.at(s, state.t).k + 1) + (paper.open ? ";paper=" + (paper.want || "") : o && o.name ? ";" + o.name : "");
      try { history.replaceState(null, "", P.web ? P.web.address(location.href, cat.web, s.id, h) : h); } catch (e) { /* a page from a folder may refuse */ }
    }
    function into(box, el) {          // scroll a list, not the page
      var top = el.offsetTop - box.offsetTop, h = box.clientHeight;
      if (top < box.scrollTop + 8 || top + el.offsetHeight > box.scrollTop + h - 8) box.scrollTop = Math.max(0, top - h / 3);
    }
    function button() {            // play, pause, or play again when the scene has ended
      var s = scene(), want = state.playing || state.loading ? "pause" : s && state.t >= s.duration ? "replay" : "play";
      if (state.icon !== want) { state.icon = want; $("play").innerHTML = svg(want); $("play").title = (want === "replay" ? "play again" : want) + " (k)"; }
    }
    function spin(on) { $("spinner").hidden = !on; }
    function flash(name) {         // the round sign in the middle, as feedback for a key or a click
      var b = $("bezel"); b.innerHTML = svg(name); b.classList.remove("go"); void b.offsetWidth; b.classList.add("go");
    }
    function loadbar() { var b = $("loadbar"); b.classList.remove("run"); void b.offsetWidth; b.classList.add("run"); }
    function seen() {              // how far each scene has been played, shown under its small picture
      var s = scene(); if (!s || !rows[s.id]) return;
      var all = store.seen || {}, f = Math.round(100 * Math.min(1, state.t / s.duration)) / 100;
      keep("last", { scene: s.id, t: Math.round(state.t * 10) / 10 });
      if (f > (all[s.id] || 0)) { all[s.id] = f; keep("seen", all); }
      rows[s.id].querySelector("u").style.width = (100 * (all[s.id] || 0)) + "%";
    }
    function finish() {            // the scene has ended: its last still stays; autoplay announces the next scene
      var s = scene(); state.playing = false; state.t = s.duration; pause();
      var i = cat.order.indexOf(s.id);
      if (state.auto && i + 1 < cat.order.length) upnext(cat.order[i + 1]);
    }
    function upnext(id) {
      var c = cat.scenes[id], n = state.next = { id: id, w0: performance.now(), raf: 0, timer: 0 }, wait = GAP - LOAD;
      $("upnext-title").textContent = id + " · " + c.title;
      $("upnext-sub").textContent = "Part " + c.part + (c.duration ? " · " + fmt(c.duration) : "");
      if (c.still) $("upnext").querySelector("img").src = c.still;
      $("ring").style.strokeDashoffset = "125.66";
      $("upnext").hidden = false; wake();
      n.timer = setTimeout(function () { if (state.next === n) open(id, 0, true); }, wait * 1000);
      (function ring() {
        if (state.next !== n) return;
        var f = Math.min(1, (performance.now() - n.w0) / 1000 / wait);
        $("ring").style.strokeDashoffset = String(125.66 * (1 - f));
        if (f < 1) n.raf = requestAnimationFrame(ring);
      })();
    }
    function cancelNext() {
      if (state.next) { clearTimeout(state.next.timer); cancelAnimationFrame(state.next.raf); state.next = null; }
      $("upnext").hidden = true;
    }
    function tick() {
      state.t = clock();
      if (state.t >= scene().duration) { finish(); return; }
      render();
      state.raf = requestAnimationFrame(tick);
    }
    function play() {
      var s = scene(); if (!s) return;
      cancelNext(); clearTimeout(state.load); state.loading = false; spin(false);
      if (state.t >= s.duration) state.t = 0;
      state.playing = true; button();
      state.sound = true;          // every start tries the sound; a refusal holds for that start only
      if (useAudio()) {
        audio.playbackRate = state.speed; audio.currentTime = state.t;
        // A start that a pause or the next scene interrupts is reported like a refusal (AbortError). It is none:
        // the sound stays on. A real refusal lets this start go by the clock, if it is still going.
        var go = audio.play(); if (go && go.catch) go.catch(function (e) {
          if ((e && e.name === "AbortError") || !state.playing) return;
          state.sound = false; restart();
        });
      }
      restart(); wake();
    }
    function restart() { state.t0 = state.t; state.w0 = performance.now(); cancelAnimationFrame(state.raf); state.raf = requestAnimationFrame(tick); }
    function pause() {
      if (state.playing) state.t = clock();
      state.playing = false; state.want = false; cancelNext(); clearTimeout(state.load); state.loading = false; spin(false);
      audio.pause(); cancelAnimationFrame(state.raf); seen(); render(); wake();
    }
    function toggle() {
      if (state.next) { cancelNext(); wake(); return; }
      if (state.playing || state.loading) pause(); else play();
    }
    function user() {              // play or pause by a key or a click on the figure, with the sign in the middle
      var was = state.playing || state.loading || !!state.next;
      toggle(); flash(was ? "pause" : "play");
    }
    function seek(t) {
      var s = scene(); cancelNext(); state.t = Math.max(0, Math.min(t, s.duration));
      if (state.playing) { if (useAudio()) audio.currentTime = state.t; restart(); }
      render();
    }
    function endOf(k) { return scene().shots[k].end; }
    function step(d) {
      var s = scene(), st = P.at(s, state.t), k = st.k;
      var atEnd = Math.abs(state.t - endOf(k)) < 1e-6;
      var target = d > 0 ? (atEnd ? k + 1 : k) : (atEnd ? k - 1 : k - 1);
      if (target >= s.shots.length) { var i = cat.order.indexOf(s.id); if (i + 1 < cat.order.length) open(cat.order[i + 1], 1, false); return; }
      if (target < 0) { var j = cat.order.indexOf(s.id); if (j > 0) open(cat.order[j - 1], -1, false); else seek(0); return; }
      pause(); seek(endOf(target));
    }
    function sceneBy(d) { var i = cat.order.indexOf(scene().id) + d; if (i >= 0 && i < cat.order.length) open(cat.order[i], 0, true); }

    // ---------------------------------------------------------- the controls hide while it plays
    // While it plays the controls go away after a moment, and at once when the mouse leaves the player.
    // Paused, they stay, as a reader expects from a video player: they are the visible way to the next
    // scene. They lie over the lowest 64 px of the figure; two of the 695 stills have ink there
    // (7.3 shot 17 and 7.11 shot 4, by 6 and 10 px at a figure 577 px high).
    var idle = 0;
    function running() { return state.playing || state.loading; }
    function wake() {
      player.classList.remove("idle"); clearTimeout(idle);
      if (!state.drag && running()) idle = setTimeout(function () { if ($("menu").hidden && running()) player.classList.add("idle"); }, 2600);
    }
    // The row of controls keeps what fits the player's own width (the page's width does not say it: beside
    // the list the player is narrower than under it). What leaves the row is still in the settings menu
    // (captions, autoplay) or has no use at that width (theater mode, the volume slider, the shot's number).
    function fit() {
      var wide = player.clientWidth;
      player.classList.toggle("compact", wide < 660); player.classList.toggle("small", wide < 580); player.classList.toggle("tiny", wide < 340);
    }
    if (window.ResizeObserver) new ResizeObserver(fit).observe(player);
    fit();
    player.addEventListener("pointerenter", wake);
    player.addEventListener("pointermove", wake);
    player.addEventListener("pointerleave", function () { if (running() && !state.drag && $("menu").hidden) { clearTimeout(idle); player.classList.add("idle"); } });

    // ---------------------------------------------------------- the time bar
    var bar = $("bar"), tip = $("tip");
    function tAt(ev) { var r = bar.getBoundingClientRect(); return Math.max(0, Math.min(1, (ev.clientX - r.left) / r.width)) * scene().duration; }
    function hover(ev) {
      var s = scene(), t = tAt(ev), k = P.at(s, t).k, segs = $("segments").children;
      for (var i = 0; i < segs.length; i++) segs[i].classList.toggle("hover", i === k);
      if (tip.k !== s.id + "/" + k) { tip.k = s.id + "/" + k; $("tip-thumb").innerHTML = s.shots[k].still; $("tip-text").textContent = s.shots[k].text; }
      $("tip-label").textContent = "Shot " + (k + 1) + " · " + fmt(t);
      var pr = player.getBoundingClientRect(), x = ev.clientX - pr.left - tip.offsetWidth / 2;
      tip.style.left = Math.max(8, Math.min(pr.width - tip.offsetWidth - 8, x)) + "px";
      tip.classList.add("on");
    }
    function unhover() { tip.classList.remove("on"); var segs = $("segments").children; for (var i = 0; i < segs.length; i++) segs[i].classList.remove("hover"); }
    bar.addEventListener("pointerdown", function (ev) {
      state.drag = true; bar.setPointerCapture(ev.pointerId); player.classList.add("dragging"); seek(tAt(ev)); hover(ev);
    });
    bar.addEventListener("pointermove", function (ev) { hover(ev); if (state.drag) seek(tAt(ev)); });
    bar.addEventListener("pointerup", function () { state.drag = false; player.classList.remove("dragging"); wake(); });
    bar.addEventListener("pointerleave", function () { if (!state.drag) unhover(); });
    bar.addEventListener("lostpointercapture", function () { state.drag = false; player.classList.remove("dragging"); unhover(); });

    // ---------------------------------------------------------- the manuscript
    // The paper itself, in a window over the player: paper/index.html in a frame, which is the manuscript
    // view with the reviewed passages. Opening pauses; closing returns to the same scene and time, paused.
    // A passage is named by its id in the reviewed list; the frame turns to it and marks it (paper.js).
    var paper = { open: false, frame: null, loaded: false, want: null, sent: null, back: null, link: null };
    function paperSay() {
      if (paper.loaded && paper.sent !== paper.want) {
        paper.sent = paper.want;
        paper.frame.contentWindow.postMessage({ type: "proof-paper", region: paper.want }, location.protocol === "file:" ? "*" : location.origin);
      }
    }
    function paperHead(d) {
      var r = paper.want && cat.paper.regions[paper.want], l = paper.link, box = $("paper"), sub = $("paper-sub"), warn = false, text;
      $("paper-title").textContent = r ? (l ? l.label + " · " + l.ref : r.title) : "The manuscript";
      $("paper-context").textContent = r && l ? l.context : "";
      if (!d || !d.ready) text = "Loading the manuscript…";
      else if (!d.verified) { warn = true; text = "This PDF is not the one the passages were marked in: nothing is marked" + (r ? ". The passage is on page " + r.page + "." : "."); }
      else if (d.missing) { warn = true; text = "The passage " + d.missing + " is not in this manuscript view."; }
      else if (r && d.region === paper.want) text = "Page " + r.page + " of " + d.pages + " · the passage is marked · paper " + cat.paper.version + ", PDF fingerprint verified";
      else if (r) text = "Turning to page " + r.page + "…";
      else text = d.pages + " pages · paper " + cat.paper.version + ", PDF fingerprint verified";
      sub.textContent = text; sub.classList.toggle("warn", warn);
      box.dataset.ready = String(!!(d && d.ready)); box.dataset.verified = String(!!(d && d.verified));
      box.dataset.region = d && d.region || ""; box.dataset.page = String(d && d.page || 0);
    }
    function openPaper(region, link) {
      if (region && !cat.paper.regions[region]) region = null;
      if (!paper.open) { paper.back = document.activeElement; if (scene()) pause(); }
      paper.open = true; paper.want = region || null; paper.link = region && link || null; paper.sent = undefined;
      state.want = false;          // a scene whose file is still on its way opens behind the window, and does not start
      $("paper").hidden = false; document.body.classList.add("paper-open");
      termClose(false); menu(false); shareClose(); helpClose(); aboutClose(); overClose(); behind();
      if (guideOver) { guideOver = false; guideFrom = null; guideLay(); }
      if (!paper.frame) {
        var f = paper.frame = document.createElement("iframe");
        f.title = "The manuscript"; f.src = "paper/index.html"; $("paper-body").appendChild(f);
      }
      paperHead(null); paperSay(); address(); $("paper-close").focus();
    }
    // A window over the page (the manuscript, Share, Help, About) has the keyboard to itself: Tab stays in it,
    // because everything behind it is out of reach until it is closed.
    // A window that another file of the player brings (P.ui.over) is held in the same way: it gives its box and
    // how to close it.
    var overs = [];
    function overOpen() { return overs.filter(function (o) { return !o.box.hidden; })[0] || null; }
    function overClose() { overs.forEach(function (o) { if (!o.box.hidden) o.close(); }); }
    function behind() {
      var on = paper.open || !$("share-box").hidden || !$("help-box").hidden || !$("about-box").hidden || !!overOpen();
      [document.querySelector("header.top"), $("guide"), $("start-page"), $("watch")].forEach(function (el) { el.inert = on; });
    }
    function closePaper() {
      if (!paper.open) return;
      paper.open = false; $("paper").hidden = true; document.body.classList.remove("paper-open"); behind();
      address();
      if (paper.back && paper.back.focus && document.contains(paper.back)) paper.back.focus();
      paper.back = null;
    }
    window.addEventListener("message", function (ev) {
      var d = ev.data;
      if (!paper.frame || ev.source !== paper.frame.contentWindow || !d) return;
      if (d.type === "proof-paper-close") closePaper();
      if (d.type === "proof-paper-state") { paper.loaded = true; paperSay(); if (paper.open) paperHead(d); }
    });
    $("paper-close").onclick = closePaper;
    $("paper").addEventListener("pointerdown", function (ev) { if (ev.target === this) closePaper(); });
    function paperFromHash(id, region) {     // the address may also name a passage of the manuscript: #4.1/3;paper=marker
      if (region === undefined) { closePaper(); return; }
      openPaper(region, ((cat.links || {})[id] || []).filter(function (l) { return l.region === region; })[0]);
    }
    // The links of the scene: those for the whole scene and those for the shot shown, in the order of the file.
    function paperLinks(s, k) {
      var row = $("paper-links"), links = ((cat.links || {})[s.id] || []).filter(function (l) { return l.shot === null || l.shot === k + 1; });
      var none = (cat.unlinked || {})[s.id], now = s.id + ":" + links.map(function (l) { return l.id; }).join(",");
      if (row.dataset.now === now) return;   // the same buttons stay in place from shot to shot: a click or the focus is never lost
      row.dataset.now = now; row.innerHTML = "";
      $("paper-links-head").textContent = links.length ? "View in manuscript" : "Manuscript";
      var doc = '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 3h8l4 4v14H6z"/><path d="M14 3v4h4M9 12h6M9 16h6"/></svg>';
      links.forEach(function (l) {
        var r = cat.paper.regions[l.region], b = document.createElement("button");
        b.type = "button"; b.className = "paper-link"; b.dataset.link = l.id; b.dataset.region = l.region;
        b.innerHTML = doc + "<span></span><small></small>";
        b.querySelector("span").textContent = l.label;
        b.querySelector("small").textContent = l.ref + " · p. " + r.page;
        b.title = l.context;
        b.onclick = function () { openPaper(l.region, l); };
        row.appendChild(b);
      });
      var all = document.createElement("button");
      all.type = "button"; all.className = "paper-link quiet"; all.id = "paper-whole";
      all.innerHTML = doc + "<span>The whole manuscript</span>";
      all.title = none ? "No single passage of the paper corresponds to this scene: " + none : "Open the manuscript at its first page, with nothing marked";
      all.onclick = function () { openPaper(null); };
      row.appendChild(all);
    }

    // ---------------------------------------------------------- the argument, to read
    // For nine scenes the catalogue holds a short text that can be read without the voice: what is claimed,
    // what is assumed, why it follows, what it is used for. The texts are the content agent's
    // (video/content/reading-notes.json) and are shown as written. The status the file gives them is not shown:
    // the box says instead what the text is, an explanation, and where the claim and the proposed proof are.
    // Under every paragraph: the passages of the paper it rests on, which open the manuscript window.
    var ROLE = { claim: "Claim", assumptions: "Assumptions", argument: "Argument", used_for: "Used for", scope: "Scope" };
    function reading(s) {
      var note = (cat.notes || {})[s.id], box = $("reading");
      box.hidden = !note; if (!note) return;
      $("reading-title").textContent = note.title;
      var body = $("reading-rows"); body.innerHTML = "";
      note.blocks.forEach(function (b, i) {
        var row = document.createElement("div"); row.className = "reading-row"; row.dataset.role = b.role;
        var label = document.createElement("div"); label.className = "reading-role";
        label.textContent = i && note.blocks[i - 1].role === b.role ? "" : ROLE[b.role];   // one label for a run of paragraphs
        var text = document.createElement("div"), p = document.createElement("p"), src = document.createElement("div");
        p.textContent = b.text; src.className = "reading-sources";
        b.sources.forEach(function (x) {
          var r = cat.paper.regions[x.region], a = document.createElement("button");
          a.type = "button"; a.className = "reading-source"; a.dataset.region = x.region;
          a.textContent = x.ref + " · p. " + r.page;
          a.title = "Open the manuscript at this passage";
          a.onclick = function () { openPaper(x.region, { label: ROLE[b.role], ref: x.ref, context: "The argument here: " + note.title }); };
          src.appendChild(a);
        });
        text.appendChild(p); text.appendChild(src); row.appendChild(label); row.appendChild(text); body.appendChild(row);
      });
      readingOpen(store.reading !== false);
    }
    function readingOpen(on) {
      $("reading-body").hidden = !on; $("reading-toggle").textContent = on ? "Hide" : "Show";
      $("reading-toggle").setAttribute("aria-expanded", String(on));
    }
    $("reading-toggle").onclick = function () { var on = $("reading-body").hidden; keep("reading", on); readingOpen(on); };

    // ---------------------------------------------------------- the start page, and the chain of the proof
    // The logo opens the start page: every scene as a card, part by part, in the order of the proof. The row
    // of chips at its top is the chain of five links that scene 1.6 draws; a link shows the scenes that explain
    // it. The catalogue says where each scene belongs (video/player/proof-map.json): the chain places scenes,
    // it does not show dependences. Under a scene's title one line names its link and leads to it here.
    function powers(el, text) {     // "From 7^k to 7^(k+1)" with the exponents raised
      el.textContent = "";
      text.split(/(\^\([^)]*\)|\^\w+)/).forEach(function (part) {
        if (part.charAt(0) === "^") { var sup = document.createElement("sup"); sup.textContent = part.replace(/^\^\(?|\)$/g, ""); el.appendChild(sup); }
        else if (part) el.appendChild(document.createTextNode(part));
      });
    }
    function linkOf(id) { var at = cat.map.of[id]; return at[0] >= 0 ? cat.map.links[at[0]] : null; }
    function placeNow(s, n) {       // under the title: which scene of how many, and its link of the chain
      var where = $("where"), link = linkOf(s.id), a = document.createElement("a");
      where.textContent = "Scene " + n + " of " + cat.order.length + " · ";
      a.id = "where-link";
      if (link) {
        where.appendChild(document.createTextNode("in the chain: "));
        a.href = "#home/" + link.id; powers(a, link.name); a.title = "The scenes of this link of the proof, on the start page";
      } else { a.href = "#home"; a.textContent = cat.map.outside[cat.map.of[s.id][1]].where.toLowerCase(); a.title = "The start page"; }
      where.appendChild(a);
    }
    var homeOn = false, homeLink = "", homeTab = "home", homeWhere = "home", wantPlay = null;
    var TABS = ["home", "scenes", "playlists", "search"];
    function plain(ev) { return !ev.defaultPrevented && ev.button === 0 && !ev.metaKey && !ev.ctrlKey && !ev.shiftKey && !ev.altKey; }
    function el(tag, cls, text) { var e = document.createElement(tag); if (cls) e.className = cls; if (text !== undefined) e.textContent = text; return e; }
    function count(n) { return n + (n === 1 ? " scene" : " scenes"); }
    function length(ids) { return ids.reduce(function (sum, id) { return sum + (cat.scenes[id].duration || 0); }, 0); }
    function scenesOf(l) { return cat.order.filter(function (id) { return linkOf(id) === l; }); }
    function starts(a, id) { a.onclick = function (ev) { if (plain(ev)) wantPlay = id; }; }   // a card starts its scene, as a video's card does
    // Under a mouse pointer a scene's card goes through the scene's shots, as a video's card previews it. Each
    // shot's still is shown as a picture of its own, made from the still's text, and is not put into the page: a
    // second figure in the page could take the arrowheads of the one in the player. Nothing is played, and nothing
    // is counted as watched. Not for a finger, and not where the reader has asked for less movement.
    function previews(a, id) {
      var th = a.querySelector(".card-th"), wait = null, turn = null, urls = [];
      function stop() {
        clearTimeout(wait); clearInterval(turn); wait = turn = null;
        Array.prototype.forEach.call(th.querySelectorAll(".card-live, .card-live-at"), function (e) { e.remove(); });
        th.classList.remove("live");
        urls.forEach(function (u) { URL.revokeObjectURL(u); }); urls = [];
      }
      a.addEventListener("pointerenter", function (ev) {
        if (ev.pointerType !== "mouse" || wait || turn || (window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches)) return;
        wait = setTimeout(function () {
          var k = -1, img = null, at = null;
          wait = null;
          if (!P.scenes[id] && !document.querySelector('script[data-preview="' + id + '"]')) {      // the scene's file, as when the scene is opened
            var tag = document.createElement("script"); tag.src = cat.scenes[id].file; tag.dataset.preview = id; document.body.appendChild(tag);
          }
          function next() {
            var s = P.scenes[id];
            if (!s) return;
            if (!img) { img = el("img", "card-live"); img.alt = ""; at = el("span", "card-live-at"); th.appendChild(img); th.appendChild(at); th.classList.add("live"); }
            k = (k + 1) % s.shots.length;
            if (!urls[k]) urls[k] = URL.createObjectURL(new Blob([s.shots[k].still], { type: "image/svg+xml" }));
            img.src = urls[k]; at.textContent = "Shot " + (k + 1) + " of " + s.shots.length;
          }
          turn = setInterval(next, 1000); next();
        }, 500);
      });
      a.addEventListener("pointerleave", stop);
    }
    function card(id) {
      var x = cat.scenes[id], link = linkOf(id), a = el("a", "card");
      a.href = "#" + id; a.dataset.scene = id; a.dataset.link = link ? link.id : "";
      a.innerHTML = '<span class="card-th"><img loading="lazy" alt=""><em></em><u></u></span><span class="card-tx"><b></b><small></small></span>';
      if (x.still) a.querySelector("img").src = x.still;
      a.querySelector("em").textContent = x.duration ? fmt(x.duration) : "";
      a.querySelector("b").textContent = id + " · " + x.title;
      a.querySelector("small").textContent = (x.shots ? x.shots + " shots" : "") + ((cat.notes || {})[id] ? " · with the argument to read" : "");
      starts(a, id); previews(a, id);
      return a;
    }
    function listCard(href, still, n, title, sub) {     // a card for a list of scenes: a link of the chain, or a part
      var a = el("a", "card playlist"); a.href = href;
      a.innerHTML = '<span class="card-th"><img loading="lazy" alt=""><em></em></span><span class="card-tx"><b></b><small></small></span>';
      if (still) a.querySelector("img").src = still;
      a.querySelector("em").textContent = count(n);
      powers(a.querySelector("b"), title); a.querySelector("small").textContent = sub;
      return a;
    }
    (function () {
      var chain = $("home-chain"), banner = $("banner-chain"), m = cat.map;
      function chip(id, name) {
        var c = el("button", "chip"); c.type = "button"; c.dataset.link = id; powers(c, name);
        c.onclick = function () { homeShow(id || "scenes"); }; chain.appendChild(c);
      }
      function mark(box, cls, text) { var e = el("span", cls, text); e.setAttribute("aria-hidden", "true"); box.appendChild(e); }
      // the top of the page: the chain as the banner, and the facts under the name
      // Each link is a stop: its number in a ring that fills with what has been played, its name, its scenes and
      // length. A link made of whole parts (the second: Parts 3 to 8) also has a way straight into each of them.
      // Under the stops a bar shares its width between the links as the time is shared.
      var ARROW = '<svg viewBox="0 0 34 14"><path d="M3 7h24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/><path d="M22 2.5 28.5 7 22 11.5" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></svg>';
      m.links.forEach(function (l, i) {
        var ids = scenesOf(l), stop = el("div", "banner-stop"), a = el("a", "banner-link"), ring = el("i", "banner-num"), name = el("b"), sub = el("small", "", count(ids.length) + " · " + fmt(length(ids)));
        if (i) { mark(banner, "banner-arrow", ""); banner.lastChild.innerHTML = ARROW; }
        stop.dataset.n = String(i + 1); stop.dataset.link = l.id;
        a.href = "#home/" + l.id; a.dataset.link = l.id; powers(name, l.name);
        ring.appendChild(el("span", "", String(i + 1))); a.appendChild(ring); a.appendChild(name); a.appendChild(sub); stop.appendChild(a);
        var whole = chapters.filter(function (c) { return c.scenes.every(function (id) { return linkOf(id) === l; }); });
        if (whole.length > 1) {
          var row = el("div", "banner-parts"); stop.classList.add("wide");
          whole.forEach(function (c) { var b = el("a", "", "Part " + c.number); b.href = "#home/part-" + c.number; b.title = "Part " + c.number + " · " + c.title; row.appendChild(b); });
          stop.appendChild(row);
        }
        banner.appendChild(stop);
        var seg = el("i"); seg.dataset.n = String(i + 1); seg.style.flex = length(ids) + " 1 0"; $("banner-bar").appendChild(seg);
      });
      $("banner-time").textContent = "Where the time goes: the five links are " + Math.round(length(cat.order.filter(function (id) { return linkOf(id); })) / 60) + " of the " + Math.round(length(cat.order) / 60) + " minutes.";
      $("channel-facts").textContent = count(cat.order.length) + " · " + Math.round(length(cat.order) / 60) + " min · paper " + cat.paper.version;
      $("channel-play").onclick = function (ev) { if (plain(ev)) wantPlay = this.dataset.scene; };
      TABS.forEach(function (name) { $("home-tab-" + name).onclick = function () { homeShow(name); }; });
      $("home-tabs").addEventListener("keydown", function (ev) {
        var at = TABS.indexOf(homeTab), to = ev.key === "ArrowRight" ? at + 1 : ev.key === "ArrowLeft" ? at - 1 : -1;
        if (to < 0 || to >= TABS.length) return;
        ev.preventDefault(); homeShow(TABS[to]); $("home-tab-" + TABS[to]).focus();
      });
      // Scenes: the chain as a row of choices, and every scene under its part
      chip("", "All"); mark(chain, "chain-gap", "");
      m.links.forEach(function (l, i) { if (i) mark(chain, "chain-arrow", "→"); chip(l.id, l.name); });
      chapters.forEach(function (c) {
        var sec = el("section", "home-section"), head = el("div", "home-head"), grid = el("div", "cards");
        sec.dataset.part = c.number;
        head.appendChild(el("h2", "", "Part " + c.number + " · " + c.title)); head.appendChild(el("small"));
        sec.appendChild(head); sec.appendChild(grid);
        c.scenes.forEach(function (id) { grid.appendChild(card(id)); });
        $("home-parts").appendChild(sec);
      });
      // Home: one row per part, which moves sideways
      chapters.forEach(function (c) {
        var sec = el("section", "shelf"), head = el("div", "shelf-head"), h = el("h2"), name = el("a", "", "Part " + c.number + " · " + c.title);
        var play = el("a", "outline-pill shelf-play", "Play all"), wrap = el("div", "shelf-wrap"), row = el("div", "shelf-row");
        var prev = el("button", "carousel-arrow", "‹"), next = el("button", "carousel-arrow", "›");
        sec.dataset.part = c.number; name.href = "#home/part-" + c.number; h.appendChild(name);
        play.href = "#" + c.first; play.dataset.scene = c.first; starts(play, c.first);
        play.title = "Starts at " + c.first + "; with autoplay on, the scenes follow in the order of the proof";
        head.appendChild(h); head.appendChild(el("small", "", count(c.scenes.length) + " · " + fmt(c.duration))); head.appendChild(play);
        c.scenes.forEach(function (id) { row.appendChild(card(id)); });
        prev.type = next.type = "button"; prev.setAttribute("aria-label", "Earlier scenes of Part " + c.number); next.setAttribute("aria-label", "Later scenes of Part " + c.number);
        function arrows() { prev.disabled = row.scrollLeft <= 1; next.disabled = row.scrollLeft + row.clientWidth >= row.scrollWidth - 1; }
        prev.onclick = function () { row.scrollBy({ left: -Math.max(240, row.clientWidth * .8), behavior: "auto" }); arrows(); };
        next.onclick = function () { row.scrollBy({ left: Math.max(240, row.clientWidth * .8), behavior: "auto" }); arrows(); };
        row.addEventListener("scroll", arrows, { passive: true }); sec.arrows = arrows;
        wrap.appendChild(prev); wrap.appendChild(row); wrap.appendChild(next);
        sec.appendChild(head); sec.appendChild(wrap); $("home-shelves").appendChild(sec);
      });
      // Playlists: the five links of the chain, and the ten parts
      m.links.forEach(function (l) {
        var ids = scenesOf(l), a = listCard("#home/" + l.id, cat.scenes[ids[0]].still, ids.length, l.name, fmt(length(ids)) + " · " + l.groups.map(function (g) { return g.label; }).join("; "));
        a.dataset.link = l.id; $("playlist-chain").appendChild(a);
      });
      chapters.forEach(function (c) {
        var a = listCard("#home/part-" + c.number, c.still, c.scenes.length, "Part " + c.number + " · " + c.title, fmt(c.duration));
        a.dataset.part = c.number; $("playlist-parts").appendChild(a);
      });
      $("playlist-chain-what").textContent = m.what.replace(/^.*?\. /, "");
      $("playlist-parts-what").textContent = count(cat.order.length) + " in " + chapters.length + " parts, in the order of the proof";
      $("home-first-card").onclick = function (ev) { if (plain(ev)) wantPlay = this.dataset.scene; };
      // Search: the words of every scene
      var input = $("home-search"), found = $("home-search-results"), said = $("home-search-status");
      function at(h) { return h.shot > 0 ? "@" + (h.start + .001).toFixed(3) : ""; }
      function search() {
        var q = input.value.trim(), hits = q ? P.navigation.find(cat, q) : [], by = {}, ids = [];
        $("home-search-clear").hidden = !input.value; found.innerHTML = "";
        hits.forEach(function (h) { if (!by[h.scene]) { by[h.scene] = []; ids.push(h.scene); } by[h.scene].push(h); });
        said.textContent = !q ? "Search the words of all " + count(cat.order.length) + "." :
          hits.length ? hits.length + (hits.length === 1 ? " passage in " : " passages in ") + count(ids.length) : "No matches for “" + q + "”";
        ids.forEach(function (id) {
          var x = cat.scenes[id], row = el("div", "result"), th = el("a", "card-th"), tx = el("div", "result-tx"), title = el("a", "result-title", id + " · " + x.title);
          row.dataset.scene = id; th.href = title.href = "#" + id + at(by[id][0]); starts(th, id); starts(title, id);
          th.innerHTML = '<img loading="lazy" alt=""><em></em>'; th.tabIndex = -1; th.setAttribute("aria-hidden", "true");
          if (x.still) th.querySelector("img").src = x.still;
          th.querySelector("em").textContent = x.duration ? fmt(x.duration) : "";
          tx.appendChild(title);
          tx.appendChild(el("small", "", "Part " + x.part + " · " + cat.parts[String(x.part)] + " · " + by[id].length + (by[id].length === 1 ? " passage" : " passages")));
          by[id].slice(0, 3).forEach(function (h) {
            var line = el("a", "result-hit"), text = el("span");
            line.href = "#" + id + at(h); line.dataset.shot = String(h.shot); starts(line, id);
            line.appendChild(el("i", "", fmt(h.start))); P.navigation.highlight(text, h.text, q); line.appendChild(text); tx.appendChild(line);
          });
          if (by[id].length > 3) tx.appendChild(el("small", "result-more", "and " + (by[id].length - 3) + " more in this scene"));
          row.appendChild(th); row.appendChild(tx); found.appendChild(row);
        });
      }
      input.addEventListener("input", search);
      $("home-search-form").addEventListener("submit", function (ev) { ev.preventDefault(); });
      $("home-search-clear").onclick = function () { input.value = ""; search(); input.focus(); };
      search();
    })();
    // where: nothing or "home", "scenes", "playlists", "search", the id of a link of the chain, or "part-4"
    // The ring of a stop: how much of the link's time has been played, from what is kept for each scene.
    function bannerSeen() {
      var all = store.seen || {};
      Array.prototype.forEach.call($("banner-chain").querySelectorAll(".banner-stop"), function (stop, i) {
        var ids = scenesOf(cat.map.links[i]), got = ids.reduce(function (sum, id) { return sum + (all[id] || 0) * (cat.scenes[id].duration || 0); }, 0), pc = Math.round(100 * got / (length(ids) || 1));
        stop.style.setProperty("--seen", String(pc)); stop.dataset.seen = String(pc);
        var ring = stop.querySelector(".banner-num"); if (pc) ring.title = pc + "% played"; else ring.removeAttribute("title");
      });
    }
    // Behind the stops: the walk itself. a(0) = 0, and each step jumps a power of seven to the unused integer
    // closest to zero, the positive one in a tie. Drawn are the first steps that stay within 80 of zero, on a
    // number line along the top of the stops: each jump of 7 or more is an arc from where the walk stood to
    // where it lands (jumps of 1 are too small to draw). An ornament, but a true one: check_player.py
    // computes the walk by its own program and compares.
    var WALK = (function () {
      var used = { 0: true }, p = 0, out = [0], R = 80;
      for (;;) {
        var best = null, s = 1;
        for (;;) {
          [p + s, p - s].forEach(function (c) {
            if (used[c]) return;
            if (best === null || Math.abs(c) < Math.abs(best) || (Math.abs(c) === Math.abs(best) && c > best)) best = c;
          });
          if (best !== null && s - Math.abs(p) > Math.abs(best)) break;   // larger jumps land further out than this
          s *= 7;
        }
        if (Math.abs(best) > R) break;
        p = best; used[p] = true; out.push(p);
      }
      return { terms: out, range: R };
    })();
    function bannerArt() {
      var art = $("banner-art"), box = $("banner").getBoundingClientRect(), W = box.width, H = box.height;
      if (!W || art.dataset.size === W + "x" + H) return;
      art.dataset.size = W + "x" + H;
      var R = WALK.range, w = WALK.terms, y = Math.round($("banner-chain").getBoundingClientRect().top - box.top), unit = W / (2 * R + 8);
      var x = function (n) { return (W / 2 + n * unit).toFixed(1); }, html = '<path class="line" d="M0 ' + y + "H" + W.toFixed(1) + '"/>';
      for (var n = -R; n <= R; n++) html += '<circle class="dot" cx="' + x(n) + '" cy="' + y + '" r="' + (n % 7 === 0 ? 1.7 : 1) + '"/>';
      for (var k = 0; k + 1 < w.length; k++) {
        var d = Math.abs(w[k + 1] - w[k]); if (d < 7) continue;
        var r = d * unit / 2;
        html += '<path class="arc' + (d >= 49 ? " far" : "") + '" data-from="' + w[k] + '" data-to="' + w[k + 1] + '" d="M' + x(w[k]) + " " + y + "A" + r.toFixed(1) + " " + Math.min(r, y - 10).toFixed(1) + " 0 0 " + (w[k + 1] > w[k] ? 1 : 0) + " " + x(w[k + 1]) + " " + y + '"/>';
      }
      art.setAttribute("viewBox", "0 0 " + W.toFixed(1) + " " + H.toFixed(1)); art.innerHTML = html;
      art.dataset.walk = w.join(",");
      $("banner-art-note").textContent = "The arcs: the first " + (w.length - 1) + " steps of the walk, its jumps of 7 and 49";
    }
    window.addEventListener("resize", function () { if (homeOn) bannerArt(); });
    function homeShow(where) {      // the start page as the address and what has been played make it
      var m = cat.map, tab = "home", chosen = null, part = "", total = 0, time = 0;
      if (TABS.indexOf(where) > 0) tab = where;
      else if (/^part-\d+$/.test(where || "") && cat.parts[where.slice(5)]) { tab = "scenes"; part = where.slice(5); }
      else if ((chosen = m.links.filter(function (l) { return l.id === where; })[0] || null)) tab = "scenes";
      homeTab = tab; homeLink = chosen ? chosen.id : ""; homeWhere = chosen ? chosen.id : part ? "part-" + part : tab;
      TABS.forEach(function (name) {
        var on = name === tab, b = $("home-tab-" + name);
        b.classList.toggle("on", on); b.setAttribute("aria-selected", String(on)); b.tabIndex = on ? 0 : -1;
        $("home-panel-" + name).hidden = !on;
      });
      Array.prototype.forEach.call($("home-chain").querySelectorAll(".chip"), function (c) {
        var on = c.dataset.link === homeLink; c.classList.toggle("on", on); c.setAttribute("aria-pressed", String(on));
      });
      Array.prototype.forEach.call($("start-page").querySelectorAll(".card[data-scene] u"), function (u) {
        u.style.width = (100 * ((store.seen || {})[u.closest(".card").dataset.scene] || 0)) + "%";
      });
      bannerSeen(); bannerArt();
      Array.prototype.forEach.call($("home-parts").children, function (sec) {
        var n = 0, dur = 0, all = sec.querySelectorAll(".card");
        Array.prototype.forEach.call(all, function (a) {
          var on = !homeLink || a.dataset.link === homeLink; a.hidden = !on;
          if (on) { n++; dur += cat.scenes[a.dataset.scene].duration || 0; }
        });
        sec.hidden = !n; total += n; time += dur;
        sec.querySelector(".home-head small").textContent = (n < all.length ? n + " of " + all.length + " scenes" : n + " scenes") + " · " + fmt(dur);
      });
      var what = $("home-what"); what.textContent = "";
      if (chosen) {
        var name = document.createElement("b"); powers(name, chosen.name); what.appendChild(name);
        what.appendChild(document.createTextNode(" is explained by " + chosen.groups.map(function (g) { return g.label; }).join("; ") + ". " + total + (total === 1 ? " scene" : " scenes") + " · " + fmt(time) + "."));
      } else what.textContent = cat.order.length + " scenes in " + chapters.length + " parts, in the order of the proof. The row above is the chain of five links the proof is made of: choose a link to see the scenes that explain it. " + m.what.replace(/^.*?\. /, "");
      // the first card: where the reader left off, or the beginning
      var last = store.last, id = last && cat.scenes[last.scene] ? last.scene : null, t = id ? last.t || 0 : 0, again = !!id;
      if (id && t >= cat.scenes[id].duration - .5) { t = 0; id = cat.order[cat.order.indexOf(id) + 1] || id; }
      $("home-first-head").textContent = id ? "Continue watching" : "Start here";
      if (!id) id = cat.order[0];
      var x = cat.scenes[id], first = $("home-first-card"), go = $("channel-play");
      first.href = go.href = "#" + id + (t > 0 ? "@" + t : ""); first.dataset.scene = go.dataset.scene = id;
      if (x.still) $("home-first-img").src = x.still;
      $("home-first-time").textContent = x.duration ? fmt(x.duration) : "";
      $("home-first-bar").style.width = (x.duration ? 100 * Math.min(1, t / x.duration) : 0) + "%";
      $("home-first-title").textContent = id + " · " + x.title;
      $("home-first-sub").textContent = "Part " + x.part + " · " + cat.parts[String(x.part)] + (t > 0 ? " · from " + fmt(t) + " of " + fmt(x.duration) : "");
      $("home-first-go").textContent = t > 0 ? "Continue" : "Play";
      go.textContent = again ? "▶ Continue " + id : "▶ Play from the start";
      Array.prototype.forEach.call($("home-shelves").children, function (sec) { sec.arrows(); });
      guideFill();
      try { history.replaceState(null, "", "#home" + (homeWhere === "home" ? "" : "/" + homeWhere)); } catch (e) { /* a page from a folder may refuse */ }
      // a link or a part named by the address begins under the tabs; so does a tab chosen far down the page
      var top = $("home-tabs").getBoundingClientRect().top + window.scrollY - 56;
      if (part) {
        var sec = $("home-parts").querySelector('[data-part="' + part + '"]');
        window.scrollTo(0, sec.getBoundingClientRect().top + window.scrollY - 56 - $("home-tabs").offsetHeight - $("home-chain").offsetHeight - 6);
      } else if (chosen || window.scrollY > top) window.scrollTo(0, top);
    }
    function home(on, link) {
      homeOn = on;
      if (on) {
        P.onadd = null;            // a scene whose file is still on its way is given up: it would open behind this page
        if (paper.open) closePaper();
        if (scene()) pause();
        termClose(false); menu(false); shareClose(); helpClose(); aboutClose(); overClose();
      }
      $("start-page").hidden = !on; $("watch").hidden = on;   // its id is not "home": the address #home would scroll the page to it
      document.body.classList.toggle("at-home", on);
      guideLay();
      if (on) {
        document.title = "Base-seven Heraclitus: the coverage proof";
        if (P.web) {
          P.web.syncMetadata(document, cat.web, null);
          try { history.replaceState(null, "", P.web.address(location.href, cat.web, null, location.hash || "#home")); } catch (e) { /* file edition */ }
        }
        window.scrollTo(0, 0); homeShow(link || "");
      }
    }

    // ---------------------------------------------------------- light or dark: the frame only
    // As a video site's Appearance: the page follows the device's setting (the browser's) unless the reader
    // chooses light or dark in the menu; the choice is kept. Only the frame changes. The figures, their
    // small pictures and the manuscript are the content and look the same in both. The page's head has
    // already set the theme, before anything was drawn; this keeps it right afterwards.
    var darkPref = window.matchMedia ? window.matchMedia("(prefers-color-scheme: dark)") : null;
    var THEMES = { device: "Device theme", dark: "Dark theme", light: "Light theme" };
    function themeChoice() { return store.theme === "dark" || store.theme === "light" ? store.theme : "device"; }
    function themeLay() {
      var c = themeChoice();
      document.documentElement.setAttribute("data-theme", c !== "device" ? c : darkPref && darkPref.matches ? "dark" : "light");
      $("guide-theme-now").textContent = THEMES[c];
      Array.prototype.forEach.call($("guide-themes").querySelectorAll(".guide-choice"), function (b) { b.setAttribute("aria-checked", String(b.dataset.choice === c)); });
    }
    function theme(c) { if (THEMES[c]) keep("theme", c); themeLay(); }
    (function () {
      $("guide-theme").onclick = function () {
        var open = $("guide-themes").hidden;
        $("guide-themes").hidden = !open; this.setAttribute("aria-expanded", String(open));
        if (open) $("guide-themes").querySelector('[aria-checked="true"]').focus();
      };
      $("guide-themes").addEventListener("click", function (ev) { var b = ev.target.closest && ev.target.closest(".guide-choice"); if (b) theme(b.dataset.choice); });
      $("guide-themes").addEventListener("keydown", function (ev) {     // a radio group: the arrows move and choose
        var d = { ArrowDown: 1, ArrowRight: 1, ArrowUp: -1, ArrowLeft: -1 }[ev.key]; if (!d) return;
        var all = Array.prototype.slice.call(this.querySelectorAll(".guide-choice")), to = all[(all.indexOf(document.activeElement) + d + all.length) % all.length];
        ev.preventDefault(); ev.stopPropagation(); to.focus(); theme(to.dataset.choice);
      });
      if (darkPref) { if (darkPref.addEventListener) darkPref.addEventListener("change", themeLay); else if (darkPref.addListener) darkPref.addListener(themeLay); }
      themeLay();
    })();

    // ---------------------------------------------------------- the menu behind the three lines
    // As a video site's: on a wide start page it stands beside the page, and the three lines put it away or
    // bring it back (the choice is kept); on a narrow page and beside a scene it comes over the page and
    // goes away again with a choice, a click outside it or Escape. It leads to the start page's tabs, to
    // where the reader left off, to each link of the chain and each part, and to the manuscript, Help and About.
    var guideOver = false, guideFrom = null, WIDE = 1200;
    function guideDocked() { return homeOn && store.guide !== false && window.innerWidth >= WIDE; }
    function guideLay() {
      var docked = guideDocked();
      if (docked) guideOver = false;
      document.body.classList.toggle("guide-docked", docked); document.body.classList.toggle("guide-over", guideOver);
      $("guide").hidden = !(docked || guideOver); $("guide-scrim").hidden = !guideOver;
      $("guide-button").setAttribute("aria-expanded", String(docked || guideOver));
    }
    function guide(on) {
      if (homeOn && window.innerWidth >= WIDE) { keep("guide", on); guideOver = false; guideLay(); return; }
      if (on && !guideOver) { guideFrom = document.activeElement; guideFill(); }
      guideOver = on; guideLay();
      if (on) $("guide-close").focus();
      else { if (guideFrom && document.contains(guideFrom)) guideFrom.focus(); guideFrom = null; }
    }
    function guideFill() {         // where the reader is, and where they left off
      var s = scene(), here = homeOn ? homeWhere : s ? "part-" + s.part.number : "", link = !homeOn && s ? linkOf(s.id) : null;
      Array.prototype.forEach.call($("guide").querySelectorAll("[data-where]"), function (a) {
        if (a.dataset.where === here || (link && a.dataset.where === link.id)) a.setAttribute("aria-current", homeOn ? "page" : "true"); else a.removeAttribute("aria-current");
      });
      var last = store.last, id = last && cat.scenes[last.scene] ? last.scene : null, t = id ? last.t || 0 : 0, a = $("guide-last");
      if (!homeOn && s) { id = null; }
      a.parentNode.hidden = !id; if (!id) return;
      a.href = "#" + id + (t > 0 ? "@" + t : ""); a.dataset.scene = id;
      $("guide-last-head").textContent = "Continue watching"; $("guide-last-sub").textContent = id + " · " + cat.scenes[id].title + (t > 0 ? " · " + fmt(t) : "");
    }
    (function () {
      var ICON = { home: '<path d="M4 11 12 4l8 7v9h-5v-6H9v6H4z"/>', scenes: '<rect x="3.5" y="5.5" width="17" height="13" rx="2"/><path d="m10 9 5 3-5 3z"/>',
                   playlists: '<path d="M4 7h11M4 12h11M4 17h7"/><path d="m16 13 5 3-5 3z"/>', search: '<circle cx="10" cy="10" r="6.5"/><path d="m15 15 6 6"/>' };
      function item(box, where, text, lead) {
        var a = el("a", "guide-item"), ic = el("span", "guide-ic"), tx = el("span");
        a.href = "#home" + (where === "home" ? "" : "/" + where); a.dataset.where = where;
        if (ICON[lead]) ic.innerHTML = '<svg viewBox="0 0 24 24" aria-hidden="true">' + ICON[lead] + "</svg>"; else { ic.textContent = lead; ic.classList.add("num"); }
        powers(tx, text); a.appendChild(ic); a.appendChild(tx); box.appendChild(a);
      }
      item($("guide-main"), "home", "Home", "home"); item($("guide-main"), "scenes", "Scenes", "scenes");
      item($("guide-main"), "playlists", "Playlists", "playlists"); item($("guide-main"), "search", "Search", "search");
      cat.map.links.forEach(function (l, i) { item($("guide-chain"), l.id, l.name, String(i + 1)); });
      chapters.forEach(function (c) { item($("guide-parts"), "part-" + c.number, c.title, c.number); });
      $("guide-last").onclick = function (ev) { if (plain(ev)) wantPlay = this.dataset.scene; };
      $("guide-button").onclick = function () { guide($("guide").hidden); };
      $("guide-close").onclick = $("guide-scrim").onclick = function () { guide(false); };
      $("guide").addEventListener("click", function (ev) {   // over the page, a choice puts the menu away
        if (guideOver && ev.target.closest && ev.target.closest(".guide-item") && !ev.target.closest("#guide-theme")) { guideOver = false; guideFrom = null; guideLay(); }
      });
      window.addEventListener("resize", guideLay);
    })();

    // ---------------------------------------------------------- about: what this is, the links out, the numbers
    var aboutFrom = null;
    function aboutOpen() {
      if (!$("about-box").hidden || paper.open) return;
      shareClose(); helpClose(); menu(false);
      aboutFrom = document.activeElement; $("about-box").hidden = false; behind(); $("about-close").focus();
    }
    function aboutClose() {
      if ($("about-box").hidden) return;
      $("about-box").hidden = true; behind();
      if (aboutFrom && document.contains(aboutFrom)) aboutFrom.focus();
      aboutFrom = null;
    }
    (function () {
      var lastPart = chapters[chapters.length - 1], status = $("about-status"), list = $("about-details");
      status.textContent = "Part " + lastPart.number + " · " + lastPart.title; status.href = "#home/part-" + lastPart.number;
      status.onclick = function () { aboutClose(); };
      [["Scenes", String(cat.order.length)], ["Shots", String(cat.order.reduce(function (n, id) { return n + (cat.scenes[id].shots || 0); }, 0))],
       ["Length", fmt(length(cat.order))], ["Paper", "version " + cat.paper.version], ["PDF, SHA-256", cat.paper.sha256]].forEach(function (row) {
        list.appendChild(el("dt", "", row[0])); list.appendChild(el("dd", "", row[1]));
      });
      $("channel-about").onclick = $("guide-about").onclick = aboutOpen;
      $("about-close").onclick = aboutClose;
      $("about-box").addEventListener("pointerdown", function (ev) { if (ev.target === this) aboutClose(); });
      $("about-manuscript").onclick = function () { aboutClose(); openPaper(null); };
      $("channel-manuscript").onclick = $("guide-manuscript").onclick = function () { openPaper(null); };
      $("guide-help").onclick = function () { helpOpen(); };
    })();

    // ---------------------------------------------------------- share: the address of the scene, to copy
    // As in a video player: a small window with the address, a box for "start at" the time shown when it
    // was opened, and Copy. It does not pause, so the next scene can come while it is open: the address stays
    // that of the scene and the time it was opened at. The address is the page's own, so from a folder it is a
    // file address, and the window says so.
    var shareFrom = null, shareT = 0, shareScene = "";
    function shareFill() {
      $("share-url").value = P.web ? P.web.shareURL(location.href, cat.web, shareScene, $("share-start").checked ? shareT : null) : location.href.split("#")[0] + "#" + shareScene + ($("share-start").checked ? "@" + shareT : "");
      $("share-copy").textContent = "Copy";
      $("share-url").scrollLeft = $("share-url").scrollWidth;   // a long address shows its end, which names the scene
    }
    function shareOpen() {
      if (!scene()) return;
      shareFrom = document.activeElement; shareScene = scene().id; shareT = Math.round((state.playing ? clock() : state.t) * 10) / 10;
      var card = cat.web && cat.web.scenes[shareScene];
      $("share-preview").hidden = !card;
      if (card) {
        $("share-image").src = card.image_path; $("share-image").alt = card.image_alt;
        $("share-title").textContent = card.title; $("share-description").textContent = card.description;
      }
      $("share-native").hidden = !navigator.share || location.protocol === "file:";
      $("share-status").textContent = "";
      $("share-start").checked = false; $("share-start-text").textContent = "Start at " + fmt(shareT);
      $("share-note").hidden = location.protocol !== "file:";
      $("share-box").hidden = false; behind(); shareFill(); $("share-url").focus(); $("share-url").select(); $("share-url").scrollLeft = $("share-url").scrollWidth;
    }
    function shareClose() {
      if ($("share-box").hidden) return;
      $("share-box").hidden = true; behind();
      if (shareFrom && document.contains(shareFrom)) shareFrom.focus();
      shareFrom = null;
    }
    $("share").onclick = shareOpen;
    $("share-close").onclick = shareClose;
    $("share-box").addEventListener("pointerdown", function (ev) { if (ev.target === this) shareClose(); });
    $("share-start").onchange = shareFill;
    $("share-native").onclick = function () {
      var card = cat.web && cat.web.scenes[shareScene], button = this;
      if (!card || !navigator.share) return;
      button.disabled = true;
      navigator.share({ title: card.title, text: card.description, url: $("share-url").value }).catch(function (error) {
        if (error.name !== "AbortError") $("share-status").textContent = "Sharing is unavailable here. You can copy the link instead.";
      }).finally(function () { button.disabled = false; });
    };
    $("share-copy").onclick = function () {
      var input = $("share-url"), done = function () { $("share-copy").textContent = "Copied"; };
      function old() { try { input.focus(); input.select(); if (document.execCommand("copy")) done(); } catch (e) { /* the address stays selected, to copy by hand */ } }
      input.focus(); input.select();
      if (navigator.clipboard && navigator.clipboard.writeText) navigator.clipboard.writeText(input.value).then(done, old); else old();
    };

    // ---------------------------------------------------------- help: the keys, and how the player works
    // As a video player's list of keyboard shortcuts: a window over the page, opened by the ? in the top bar
    // or the ? key, on both pages. It does not pause.
    var helpFrom = null;
    function helpOpen() {
      if (!$("help-box").hidden || paper.open) return;
      shareClose(); aboutClose(); menu(false);
      helpFrom = document.activeElement; $("help-box").hidden = false; behind(); $("help-close").focus();
    }
    function helpClose() {
      if ($("help-box").hidden) return;
      $("help-box").hidden = true; behind();
      if (helpFrom && document.contains(helpFrom)) helpFrom.focus();
      helpFrom = null;
    }
    $("help").onclick = helpOpen;
    $("help-close").onclick = helpClose;
    $("help-box").addEventListener("pointerdown", function (ev) { if (ev.target === this) helpClose(); });

    // ---------------------------------------------------------- the words
    // A lookup pauses. If the reader goes on to the scene that defines the word, the place that was left is
    // kept, and Back to explanation returns to it: the first place left, also after several lookups in a row.
    var back = null, termFrom = null;
    function backBar() {
      $("back").hidden = !back; if (!back) return;
      var c = cat.scenes[back.scene];
      $("back-text").textContent = "You left " + back.scene + " · " + c.title + " at " + fmt(back.t) + " to look up “" + back.term + "”.";
      $("back").dataset.scene = back.scene; $("back").dataset.t = String(back.t);
    }
    function termClose(refocus) {
      if ($("term").hidden) return;
      $("term").hidden = true;
      if (refocus && termFrom && document.contains(termFrom)) termFrom.focus();
      termFrom = null;
    }
    function term(name) {
      var t = cat.terms[name]; if (!t) return;
      pause();
      if ($("term").hidden) termFrom = document.activeElement;
      $("term").hidden = false;
      $("term-name").textContent = t.term;
      $("term-text").textContent = t.definition;
      var a = $("term-scene"), here = scene() && scene().id === t.scene;
      a.textContent = (here ? "Defined in this scene: " : "Go to the scene that defines it: ") + t.scene + " · " + cat.scenes[t.scene].title;
      a.href = "#" + t.scene + "/1";
      a.onclick = function (ev) {
        ev.preventDefault();
        if (!back) back = { scene: scene().id, t: state.t };
        back.term = t.term;
        termClose(false); open(t.scene, 1, false); backBar();
      };
      a.focus();
    }
    $("back-go").onclick = function () { var b = back; back = null; backBar(); termClose(false); open(b.scene, "@" + b.t, false); };
    $("back-close").onclick = function () { back = null; backBar(); };
    function words(sh) {
      var p = document.createElement("p");
      sh.segments.forEach(function (seg) {
        if (seg[1]) {
          var b = document.createElement("button"); b.className = "term"; b.type = "button";
          b.textContent = seg[0]; b.title = cat.terms[seg[1]].definition;
          b.onclick = function (ev) { ev.stopPropagation(); term(seg[1]); };
          p.appendChild(b);
        } else p.appendChild(document.createTextNode(seg[0]));
      });
      return p;
    }
    // ---------------------------------------------------------- the description of the scene
    // Under "…more", about the open scene and made from what the catalogue and the scene file hold: the
    // passages of the paper with the sentence that says what each supports; the words the scene defines and
    // the words it uses from earlier scenes; and, for the scenes whose brief in the script states them, what
    // the viewer can do afterwards and the earlier scenes it rests on. Nothing here is written by the player.
    function used(s) {             // the words of earlier scenes that this scene's text uses, in the order they come
      var out = [];
      s.shots.forEach(function (sh) { sh.segments.forEach(function (seg) { if (seg[1] && out.indexOf(seg[1]) < 0 && s.defines.indexOf(seg[1]) < 0) out.push(seg[1]); }); });
      return out;
    }
    function about(s) {
      var links = (cat.links || {})[s.id] || [], lead = $("about"), box = $("about-more"), words = used(s);
      function section(id, head) {
        var sec = document.createElement("section"), h = document.createElement("h3");
        sec.id = id; sec.className = "about-section"; h.textContent = head; sec.appendChild(h); box.appendChild(sec);
        return sec;
      }
      function word(name) {
        var b = document.createElement("button"); b.type = "button"; b.className = "term"; b.dataset.term = name;
        b.textContent = name; b.title = cat.terms[name].definition;
        b.onclick = function () { term(name); };
        return b;
      }
      // the first lines, which also show when the description is folded
      lead.className = "about" + (s.goal ? " goal" : "");
      if (s.goal) powers(lead, "After this scene you can " + s.goal.charAt(0).toLowerCase() + s.goal.slice(1));
      else if (links.length) lead.textContent = (s.defines.length ? "Defines " + s.defines.join(", ") + ". " : "") + "In the paper, " + links[0].ref + ": " + links[0].context;
      else lead.textContent = s.defines.length ? "Defines " + s.defines.join(", ") + "." : "";
      lead.hidden = !lead.textContent;
      box.innerHTML = "";
      if (s.uses && s.uses.length) {
        var rest = section("about-rests", "Rests on"), line = document.createElement("p");
        s.uses.forEach(function (seg) {
          if (!seg[1]) { var plainText = document.createElement("span"); powers(plainText, seg[0]); line.appendChild(plainText); return; }
          var a = document.createElement("a"); a.href = "#" + seg[1]; a.className = "about-scene"; a.dataset.scene = seg[1];
          a.textContent = seg[0]; a.title = seg[1] + " · " + cat.scenes[seg[1]].title;
          line.appendChild(a);
        });
        rest.appendChild(line);
      }
      var inPaper = section("about-paper", "In the paper");
      links.forEach(function (l) {
        var row = document.createElement("div"), b = document.createElement("button"), text = document.createElement("p");
        row.className = "about-passage"; b.type = "button"; b.className = "about-open"; b.dataset.link = l.id; b.dataset.region = l.region;
        b.innerHTML = "<span></span><small></small>";
        b.querySelector("span").textContent = l.label;
        b.querySelector("small").textContent = l.ref + " · p. " + cat.paper.regions[l.region].page;
        b.title = "Open the manuscript at this passage";
        b.onclick = function () { openPaper(l.region, l); };
        text.textContent = l.context;
        row.appendChild(b); row.appendChild(text); inPaper.appendChild(row);
      });
      if (!links.length) {
        var none = document.createElement("p");
        none.textContent = "No single passage of the paper corresponds to this scene" + ((cat.unlinked || {})[s.id] ? ": " + cat.unlinked[s.id] : ".");
        inPaper.appendChild(none);
      }
      if (s.defines.length) {
        var list = document.createElement("dl"); list.className = "about-terms";
        s.defines.forEach(function (name) {
          var dt = document.createElement("dt"), dd = document.createElement("dd");
          dt.textContent = cat.terms[name].term; dd.textContent = cat.terms[name].definition;
          list.appendChild(dt); list.appendChild(dd);
        });
        section("about-defined", "Defined in this scene").appendChild(list);
      }
      if (words.length) {
        var row = document.createElement("p"); row.className = "about-words";
        words.forEach(function (name, i) {
          if (i) row.appendChild(document.createTextNode(" · "));
          row.appendChild(word(name));
          var from = document.createElement("small"); from.textContent = " " + cat.terms[name].scene; row.appendChild(from);
        });
        section("about-used", "Words from earlier scenes").appendChild(row);
      }
    }
    function fill(s) {
      var n = cat.order.indexOf(s.id) + 1;
      $("title").textContent = s.id + " · " + s.title;
      $("avatar").textContent = String(s.part.number);
      $("part").textContent = "Part " + s.part.number + " · " + s.part.title;
      $("meta").textContent = s.kind + (s.paper ? " · paper " + s.paper : "") + " · " + s.shots.length + " shots · " + fmt(s.duration) +
        (s.timing === "voice" ? " · generated voice" : " · no sound yet: the times are made up from the words");
      placeNow(s, n); reading(s); about(s); guideFill();
      $("transcript-sub").textContent = s.id + " · " + s.shots.length + " shots";
      $("playlist-sub").textContent = "Scene " + n + " / " + cat.order.length;
      var list = $("shots"); list.innerHTML = "";
      s.shots.forEach(function (sh, k) {
        var li = document.createElement("li");
        if (sh.speaker.indexOf("question") >= 0) li.classList.add("question");
        var ts = document.createElement("button"); ts.type = "button"; ts.className = "ts"; ts.textContent = fmt(sh.start);
        ts.setAttribute("aria-label", "Go to " + fmt(sh.start) + " in scene " + s.id);
        li.appendChild(ts); li.appendChild(words(sh));
        // A timestamp always means the beginning, including when paused. The
        // separate previous/next figure controls still select checked endpoints.
        ts.onclick = function (ev) { ev.stopPropagation(); seek(P.navigation.cueTime(sh.start, k)); };
        list.appendChild(li);
      });
      var segs = $("segments"); segs.innerHTML = "";
      s.shots.forEach(function (sh, k) {
        var d = document.createElement("div"); d.className = "seg";
        d.style.left = (100 * sh.start / s.duration) + "%";
        d.style.width = "calc(" + (100 * (sh.end - sh.start) / s.duration) + "% - " + (k + 1 < s.shots.length ? 2 : 0) + "px)";
        d.appendChild(document.createElement("i")); segs.appendChild(d);
      });
      tip.k = null;
      Object.keys(rows).forEach(function (id) { rows[id].classList.toggle("now", id === s.id); });
      rows[s.id].querySelector(".num").textContent = "▶";
      cat.order.forEach(function (id, i) { if (id !== s.id) rows[id].querySelector(".num").textContent = String(i + 1); });
      if (!$("panel-scenes").hidden) into(pl, rows[s.id]);
      if (s.audio) { audio.src = s.audio; audio.playbackRate = state.speed; } else audio.removeAttribute("src");
      document.title = s.id + " " + s.title + " · Base-seven Heraclitus";
      if (P.web) P.web.syncMetadata(document, cat.web, s.id);
      if (navigation) navigation.fill(s);
      if (P.checks) P.checks.fill(s);
    }
    // where: shot number counted from 1 (its end is shown), -1 for the last shot, 0 for the very start
    function open(id, where, playing) {
      if (!cat.scenes[id]) id = cat.order[0];
      if (homeOn || $("watch").hidden) home(false);   // both pages are hidden in the markup until the address says which
      if (scene()) pause();
      P.onadd = null; // A newer navigation choice supersedes a still-loading scene.
      // Whether the scene is to start once it is there. Its file may come later, and by then the reader may have
      // paused, looked up a word or opened the manuscript (each takes the wish back), or pressed play (which
      // makes it): what is true when the file comes decides, not what was true when the scene was chosen.
      state.want = !!playing;
      if (!scene() || scene().id !== id) loadbar();
      var go = function () {
        var start = state.want || state.playing;
        if (state.playing) pause();   // the scene that played meanwhile stops, with its sound
        state.want = false;
        var s = P.scenes[id]; state.scene = s; state.shown = null; fill(s);
        if (typeof where === "string" && where.charAt(0) === "@") state.t = parseFloat(where.slice(1)) || 0;
        else if (where === -1) state.t = s.duration;
        else if (where > 0) state.t = s.shots[Math.min(where, s.shots.length) - 1].end;
        else state.t = 0;
        // a scene that is to play waits a moment first, open and still, so that scenes do not run into each other
        if (start) { state.loading = true; spin(true); state.load = setTimeout(play, LOAD * 1000); }
        seen(); render();
      };
      if (P.scenes[id]) go();
      else {
        P.onadd = function (s) { if (s.id === id) { P.onadd = null; go(); } };
        var tag = document.createElement("script"); tag.src = cat.scenes[id].file; document.body.appendChild(tag);
      }
    }
    // No address, or #home, is the start page; #home/step is the start page at a link of the chain.
    // play: the scene a card was clicked for, which then starts.
    function fromHash(play) {
      var h = decodeURIComponent(location.hash.slice(1)), start = /^(?:home(?:\/([\w-]+))?)?$/.exec(h);
      if (start) { home(true, start[1]); return; }
      var m = /^([\w.]+)(?:\/(\d+)|(@[\d.]+))?(?:;paper=([\w-]*)|;([a-z]+))?$/.exec(h);
      if (m && cat.scenes[m[1]]) open(m[1], m[3] || (m[2] ? parseInt(m[2], 10) : 0), play === m[1]);
      else open(cat.order[0], 0, false);
      paperFromHash(m && m[1], m ? m[4] : undefined);
      overFromHash(m && m[5]);
    }
    function overFromHash(name) {           // #10.4/1;checks: the address may name a window another file brought
      overs.forEach(function (o) { if (name && o.name === name) { if (o.box.hidden) o.open(); } else if (!o.box.hidden) o.close(); });
    }

    // ---------------------------------------------------------- settings
    function sound() {
      audio.volume = state.volume; audio.muted = state.muted || state.volume === 0;
      $("mute").innerHTML = svg(audio.muted ? "mute" : "vol"); $("mute").title = audio.muted ? "unmute (m)" : "mute (m)";
      $("volume").value = String(audio.muted ? 0 : state.volume);
    }
    function captions(on) {
      state.captions = on; keep("captions", on); $("cc").classList.toggle("on", on); $("caption").hidden = !on;
      $("menu-cc-v").textContent = on ? "On" : "Off";
    }
    function autoplay(on) { state.auto = on; keep("auto", on); $("autoplay").classList.toggle("on", on); $("autoplay").title = "autoplay the next scene: " + (on ? "on" : "off"); $("menu-auto-v").textContent = on ? "On" : "Off"; }
    function speed(v) {
      var was = state.playing; if (was) state.t = clock();
      state.speed = v; keep("speed", v); audio.playbackRate = v; if (was) restart();
      $("menu-speed-v").textContent = v === 1 ? "Normal" : v + "×";
      Array.prototype.forEach.call($("speeds").children, function (b) { b.classList.toggle("on", parseFloat(b.dataset.v) === v); });
    }
    SPEEDS.forEach(function (v) {
      var b = document.createElement("button"); b.type = "button"; b.dataset.v = String(v); b.textContent = v === 1 ? "Normal" : String(v);
      b.onclick = function () { speed(v); $("menu").hidden = true; wake(); };
      $("speeds").appendChild(b);
    });
    function fullscreen() {
      if (document.fullscreenElement) document.exitFullscreen();
      else if (player.requestFullscreen) player.requestFullscreen();
    }
    document.addEventListener("fullscreenchange", function () { $("enlarge").innerHTML = svg(document.fullscreenElement ? "small" : "full"); });
    function theater() { var on = !$("watch").classList.contains("theater"); $("watch").classList.toggle("theater", on); keep("theater", on); }

    function menu(on) { $("menu").hidden = !on; $("menu-main").hidden = false; $("menu-speeds").hidden = true; $("menu").classList.remove("sub"); }
    $("menu-cc").onclick = function () { captions(!state.captions); };
    $("menu-speed").onclick = function () {
      $("menu-main").hidden = true; $("menu-speeds").hidden = false; $("menu").classList.add("sub");
      // On a small figure the list is taller than its room and scrolls: it opens with the chosen speed in the
      // middle of what shows, under the heading, which stays in place.
      var m = $("menu"), on = $("speeds").querySelector(".on"), head = $("menu-back").offsetHeight;
      if (on) m.scrollTop = on.offsetTop - head - (m.clientHeight - head - on.offsetHeight) / 2;
    };
    $("menu-back").onclick = function () { menu(true); };
    $("upnext-go").onclick = function () { if (state.next) open(state.next.id, 0, true); };
    $("upnext-cancel").onclick = function () { cancelNext(); wake(); };
    audio.addEventListener("ended", function () { if (state.playing && useAudio()) finish(); });
    audio.addEventListener("waiting", function () { if (state.playing) spin(true); });
    ["playing", "canplay", "seeked"].forEach(function (e) { audio.addEventListener(e, function () { if (!state.loading) spin(false); }); });
    $("play").onclick = toggle; $("bigplay").onclick = toggle;
    $("figure").onclick = function () { if (!$("menu").hidden) { menu(false); return; } user(); };
    $("figure").ondblclick = fullscreen;
    $("prev").onclick = function () { step(-1); };
    $("next").onclick = function () { step(1); };
    $("prev-scene").onclick = function () { sceneBy(-1); };
    $("next-scene").onclick = function () { sceneBy(1); };
    $("mute").onclick = function () { state.muted = !audio.muted; if (!state.muted && state.volume === 0) state.volume = 0.5; keep("muted", state.muted); keep("volume", state.volume); sound(); };
    $("volume").oninput = function () { state.volume = parseFloat(this.value); state.muted = state.volume === 0; keep("volume", state.volume); keep("muted", state.muted); sound(); };
    $("cc").onclick = function () { captions(!state.captions); };
    $("autoplay").onclick = $("menu-auto").onclick = function () { autoplay(!state.auto); };
    $("gear").onclick = function (ev) { ev.stopPropagation(); menu($("menu").hidden); wake(); };
    $("theater").onclick = theater;
    $("enlarge").onclick = fullscreen;
    $("chapter").onclick = function () { tab("transcript"); };
    $("desc-more").onclick = function () { var d = $("desc"), on = !d.classList.contains("open"); d.classList.toggle("open", on); this.setAttribute("aria-expanded", String(on)); this.textContent = on ? "Show less" : "…more"; };
    // collapsed, the whole description opens on a click anywhere in it; open, only Show less closes it,
    // so that its text can be selected and its buttons used
    $("desc").addEventListener("click", function (ev) {
      if (!this.classList.contains("open") && !(ev.target.closest && ev.target.closest("button, a"))) $("desc-more").click();
    });
    function tab(which) {
      ["transcript", "scenes"].forEach(function (w) {
        var on = w === which, b = $("tab-" + w); b.classList.toggle("on", on); b.setAttribute("aria-selected", String(on)); b.tabIndex = on ? 0 : -1;
        $("panel-" + w).hidden = !on;
      });
      if (which === "scenes" && scene()) into(pl, rows[scene().id]);
      else if (navigation) navigation.tab();
    }
    $("tab-transcript").onclick = function () { tab("transcript"); };
    $("tab-scenes").onclick = function () { tab("scenes"); };
    $("term-close").onclick = function () { termClose(true); };
    document.addEventListener("keydown", function (ev) {
      var tg = ev.target, over = overOpen();
      if (over) {                    // a window from another file is over the page: only Escape, which closes it
        if (ev.key === "Escape") { ev.preventDefault(); over.close(); }
        return;
      }
      if (!$("share-box").hidden) {  // the share window is over the page: only Escape, which closes it; its own fields keep their keys
        if (ev.key === "Escape") { ev.preventDefault(); shareClose(); }
        return;
      }
      if (!$("about-box").hidden) {  // so is About
        if (ev.key === "Escape") { ev.preventDefault(); aboutClose(); }
        return;
      }
      if (guideOver) {               // and the menu, when it is over the page
        if (ev.key === "Escape") { ev.preventDefault(); guide(false); }
        return;
      }
      if (!$("help-box").hidden) {   // so is the help: Escape or ? closes it, Tab and the arrows are the window's own
        if (ev.key === "Escape" || ev.key === "?") { ev.preventDefault(); helpClose(); }
        return;
      }
      if (ev.defaultPrevented || tg.tagName === "SELECT" || tg.tagName === "TEXTAREA" || (tg.tagName === "INPUT" && tg.type !== "range") || ev.metaKey || ev.ctrlKey || ev.altKey) return;
      if (paper.open) {              // the manuscript window is over the player: only Escape, which closes it
        if (ev.key === "Escape") { ev.preventDefault(); closePaper(); }
        return;
      }
      if (ev.key === "?") { ev.preventDefault(); helpOpen(); return; }
      if (homeOn) return;            // on the start page there is nothing to play: the keys are the page's own
      // Let native buttons and links activate once with Space/Enter. The page's
      // playback shortcut applies when focus is not on an interactive control.
      if ((ev.key === " " || ev.key === "Enter") && tg.closest && tg.closest("button, a, [role=button]")) return;
      var s = scene(), k = ev.key, done = true;
      if (k === " " || k === "k") user();
      else if (k === "ArrowRight") step(1);
      else if (k === "ArrowLeft") step(-1);
      else if (k === "j") seek(state.t - 10);
      else if (k === "l") seek(state.t + 10);
      else if (k === "N") sceneBy(1);
      else if (k === "P") sceneBy(-1);
      else if (k === "m") { $("mute").click(); flash(audio.muted ? "mute" : "vol"); }
      else if (k === ">" || k === "<") {
        var at = SPEEDS.indexOf(state.speed); if (at < 0) at = SPEEDS.indexOf(1);
        at += k === ">" ? 1 : -1; if (at >= 0 && at < SPEEDS.length) speed(SPEEDS[at]);
      }
      else if (k === "c") captions(!state.captions);
      else if (k === "f") fullscreen();
      else if (k === "t") theater();
      else if (k === "Home") seek(0);
      else if (k === "End") seek(s.duration);
      else if (/^[0-9]$/.test(k)) seek(s.duration * parseInt(k, 10) / 10);
      else if (k === "Escape") { if (!$("term").hidden) termClose(true); else { menu(false); cancelNext(); } }
      else done = false;
      if (done) { ev.preventDefault(); wake(); }
    });
    window.addEventListener("pagehide", function () {   // where the reader was, for Continue watching on the start page
      var s = scene(); if (s && !homeOn) keep("last", { scene: s.id, t: Math.round((state.playing ? clock() : state.t) * 10) / 10 });
    });
    window.addEventListener("hashchange", function () {
      var s = scene(), h = decodeURIComponent(location.hash.slice(1)), m = /;paper=([\w-]*)$/.exec(h), play = wantPlay;
      wantPlay = null;
      if (homeOn || !s || /^(?:home(?:\/|$)|$)/.test(h) || h.split(/[\/@;]/)[0] !== s.id) fromHash(play);
      else {                         // the same scene: an address typed or followed may name another shot or time in it
        var to = /^[\w.]+(?:\/(\d+)|@([\d.]+))?/.exec(h);
        if (to && to[2] !== undefined) seek(parseFloat(to[2]) || 0);
        else if (to && to[1] && parseInt(to[1], 10) !== P.at(s, state.t).k + 1) seek(s.shots[Math.min(Math.max(parseInt(to[1], 10), 1), s.shots.length) - 1].end);
        paperFromHash(s.id, m ? m[1] : undefined);
        var over = /;([a-z]+)$/.exec(h); overFromHash(over && over[1]);
      }
    });

    sound(); captions(state.captions); autoplay(state.auto); speed(state.speed);
    $("enlarge").innerHTML = svg("full");
    if (store.theater) $("watch").classList.add("theater");
    P.ui = { open: open, seek: seek, step: step, state: state, render: render, captions: captions, tab: tab, theater: theater,
             paper: { open: openPaper, close: closePaper, state: paper }, back: function () { return back; },
             home: function () { return homeOn; }, where: function () { return homeWhere; }, guide: function () { return guideOver ? "over" : guideDocked() ? "docked" : ""; }, help: function () { return !$("help-box").hidden; },
             theme: function (c) { if (c) theme(c); return { choice: themeChoice(), shown: document.documentElement.getAttribute("data-theme") }; },
             // for a window another file brings: it pauses, closes what else is over the page, and is held like the others
             pause: function () { if (scene()) pause(); }, behind: behind, address: address,
             over: function (o) { overs.push(o); },      // { box, close, and for the address: name, open }
             clear: function () { termClose(false); menu(false); shareClose(); helpClose(); aboutClose(); if (guideOver) { guideOver = false; guideFrom = null; guideLay(); } } };
    navigation = P.navigation.init(P.ui, chapters);
    if (P.checks) P.checks.init(P.ui);
    P.ui.navigation = navigation;
    if (P.pwa) P.pwa.init();
    if (!location.hash && P.web) {
      var entry = P.web.entry(location.href, cat.web);
      if (entry) { try { history.replaceState(null, "", "#" + entry); } catch (e) { /* file edition */ } }
    }
    fromHash();
  };

  // ------------------------------------------------------------ the player's own checks
  P.selfcheck = function () {
    var out = [], bad = [], view = P.view(document.getElementById("stage"));
    var ids = P.cat.order.filter(function (id) { return P.scenes[id]; });
    var tpl = document.createElement("template");
    function node(s) { tpl.innerHTML = s; return tpl.content.firstElementChild; }
    function visible(el) { return el.style.visibility !== "hidden" && el.style.opacity !== "0"; }
    function picture() {
      return [view.A, view.B, view.C].map(function (l) { return l ? (visible(l) ? l.style.opacity + ":" + l.innerHTML : "-") : ""; }).join("|");
    }
    // the first name in a figure that the page resolves to another element (own = true), or to a hidden one
    function foreign(layer, own) {
      var named = layer.querySelectorAll("[id]");
      for (var i = 0; i < named.length; i++) {
        var hit = document.getElementById(named[i].id);
        if (own ? hit !== named[i] : getComputedStyle(hit).visibility === "hidden") return named[i].id;
      }
      return "";
    }
    var shots = 0, moves = 0;
    ids.forEach(function (id) {
      var s = P.scenes[id], sh = s.shots;
      function no(why) { bad.push(id + ": " + why); }
      if (Math.abs(sh[0].start) > 1e-9) no("the first shot does not begin at 0");
      for (var k = 0; k < sh.length; k++) {
        shots++;
        if (!(sh[k].start < sh[k].end)) no("shot " + (k + 1) + " has no length");
        if (k > 0 && Math.abs(sh[k].start - sh[k - 1].end) > 1e-9) no("shot " + (k + 1) + " does not begin where shot " + k + " ends");
        if (sh[k].end > s.duration + 1e-9) no("shot " + (k + 1) + " ends after the sound");
        if (!(sh[k].fade < sh[k].end - sh[k].start)) no("shot " + (k + 1) + ": its change takes the whole shot");
        if (sh[k].change.kind !== "fade") moves++;
        // at the end of the shot the figure is exactly the still, and nothing else shows
        var st = P.draw(view, s, sh[k].end);
        if (st.k !== k || st.p !== 1) no("at the end of shot " + (k + 1) + " the player is in shot " + (st.k + 1) + " at " + st.p);
        if (!view.B.firstElementChild || !view.B.firstElementChild.isEqualNode(node(sh[k].still))) no("shot " + (k + 1) + ": the figure at its end is not its still");
        if (view.B.childNodes.length !== 1) no("shot " + (k + 1) + ": more than the still in the figure");
        if (visible(view.A) || (view.C && visible(view.C))) no("shot " + (k + 1) + ": another layer shows at its end");
        if (view.B.style.opacity !== "1") no("shot " + (k + 1) + ": the still is not fully shown at its end");
        // an arrowhead, a gradient or a clip is found by its name in the whole page, and the first one of
        // that name is used; it must be the still's own, and never one inside something hidden
        if (view.A.firstChild || (view.C && view.C.firstChild)) no("shot " + (k + 1) + ": a hidden layer holds a figure at its end");
        if (foreign(view.B, true)) no("shot " + (k + 1) + ": at its end the still uses a definition outside itself: " + foreign(view.B, true));
        // the same time twice gives the same picture, also after drawing other times in between
        var mid = sh[k].start + Math.min(sh[k].fade, sh[k].end - sh[k].start) / 2;
        P.draw(view, s, mid); var one = picture();
        P.draw(view, s, sh[(k + 1) % sh.length].end); P.draw(view, s, 0);
        P.draw(view, s, mid); if (picture() !== one) no("shot " + (k + 1) + ": two draws at the same time differ");
        if (foreign(view.B, false)) no("shot " + (k + 1) + ": in its change the still uses a hidden definition: " + foreign(view.B, false));
        // the shot's change has begun but not ended in the middle of the change
        st = P.at(s, mid);
        if (st.k !== k || !(st.p > 0 && st.p < 1)) no("shot " + (k + 1) + ": the middle of its change is not inside it");
      }
      var all = "";
      sh.forEach(function (x) { all += x.still; });
      if (/(?:href|src)\s*=\s*["'](?:https?:|\/\/|\/|file:)/i.test(all) || /url\(\s*["']?(?:https?:|\/\/)/i.test(all)) no("a still points outside the folder");
      if (s.audio && !/^audio\/[\w.]+\.mp3$/.test(s.audio)) no("the sound is not a relative path in audio/");
    });
    out.push("scenes " + ids.length + ", shots " + shots + ", movements " + moves + ", faults " + bad.length);
    document.getElementById("out").textContent = (bad.length ? "FAIL\n" : "PASS\n") + out.concat(bad).join("\n");
  };
})();
