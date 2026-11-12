/* Installation and explicit offline saving. Only the hosted edition registers a worker. */
(function () {
  "use strict";
  var P = window.PROOF;
  P.pwa = { init: init };
  var installPrompt = null, initialized = false, refresh = null;
  function supported() {
    return /^https?:$/.test(location.protocol) && window.isSecureContext && ("serviceWorker" in navigator);
  }
  window.addEventListener("beforeinstallprompt", function (event) {
    if (!supported()) return;
    event.preventDefault(); installPrompt = event;
    if (refresh) refresh();
  });
  function init() {
    var $ = function (id) { return document.getElementById(id); };
    // The check window is built into the player: its files are among those the worker's list is made from.
    if (initialized || !supported()) return;
    initialized = true;
    var ui = P.ui, box = $("pwa-box"), from = null, registration = null, saving = false, reloading = false;
    var controlledAtStart = !!navigator.serviceWorker.controller, serial = 0, revision = 0, didInstall = false;
    $("guide-pwa").hidden = false;
    function say(text) { $("pwa-status").textContent = text; }
    function standalone() { return (window.matchMedia && window.matchMedia("(display-mode: standalone)").matches) || navigator.standalone === true; }
    function installed() { return didInstall || standalone(); }
    function lay() {
      $("pwa-install").hidden = installed() || !installPrompt;
      $("pwa-install-help").hidden = installed() || !!installPrompt;
      $("pwa-installed").hidden = !installed();
      $("pwa-installed").textContent = standalone() ? "This presentation is running as an installed app." : "The presentation has been installed on this device.";
      $("pwa-update").hidden = !(registration && registration.waiting);
      $("pwa-update").disabled = reloading;
      $("pwa-save").disabled = saving || !(registration && registration.active);
      $("guide-pwa-status").textContent = registration && registration.waiting ? "Update available" : "Install and use offline";
    }
    refresh = lay;
    function request(type, progress, targetWorker) {
      return new Promise(function (resolve, reject) {
        var worker = targetWorker || (registration && registration.active);
        if (!worker) { reject(new Error("The app is still preparing. Please try again.")); return; }
        var channel = new MessageChannel(), id = ++serial, finished = false, timer;
        function finish(error, value) {
          if (finished) return; finished = true; clearTimeout(timer); channel.port1.close();
          if (error) reject(error); else resolve(value);
        }
        function resetTimeout() {
          clearTimeout(timer);
          timer = setTimeout(function () { finish(new Error("The connection stopped responding. Check your connection and try again.")); }, 90000);
        }
        channel.port1.onmessage = function (event) {
          var value = event.data || {}; if (value.requestId !== id) return;
          resetTimeout();
          try {
            if (value.type === "offline-progress" && type === "offline-save") { if (progress) progress(value); }
            else if ((type === "offline-save" && value.type === "offline-complete") ||
                     (type === "offline-status" && value.type === "offline-status") ||
                     (type === "activate_update" && value.type === "update-activating")) finish(null, value);
          } catch (error) { finish(error); }
        };
        channel.port1.onmessageerror = function () { finish(new Error("The offline service returned an unreadable response. Please try again.")); };
        resetTimeout();
        try { worker.postMessage({ type: type, requestId: id }, [channel.port2]); }
        catch (error) { finish(new Error("The offline service is not responding. Reload the page and try again.")); }
      });
    }
    function counts(value) { return Number.isSafeInteger(value.total) && value.total > 0 && Number.isSafeInteger(value.saved) && value.saved >= 0 && value.saved <= value.total; }
    function progress(value) {
      if (value.ok === false || !counts(value)) {
        $("pwa-progress").hidden = true;
        say("The offline copy could not be checked. Browser storage may be unavailable. Please try again.");
        return;
      }
      var total = value.total, saved = value.saved;
      $("pwa-progress").hidden = false; $("pwa-progress").max = total; $("pwa-progress").value = saved;
      if (value.totalBytes) $("pwa-size").textContent = "The complete presentation uses about " + Math.ceil(value.totalBytes / 1000000) + " MB, including narration and the manuscript.";
      if (value.type !== "offline-progress" && value.complete === true && saved === total) say("All presentation files are saved on this device for offline use.");
      else say((saving ? "Saving: " : "Saved on this device: ") + saved + " of " + total + " files.");
    }
    function status() {
      if (saving) return;
      var at = revision;
      request("offline-status").then(function (value) { if (!saving && at === revision) progress(value); })
        .catch(function (error) { if (!saving && at === revision) say(error.message); });
    }
    function close() {
      box.hidden = true; ui.behind();
      var to = from && document.contains(from) && !from.closest("[hidden], [inert]") && from.getClientRects().length ? from : $("guide-button");
      if (to) to.focus(); from = null;
    }
    function open() {
      if (!box.hidden) return;
      from = document.activeElement; ui.pause(); ui.clear(); box.hidden = false; ui.behind(); lay();
      $("pwa-close").focus(); if (registration && registration.active) status();
    }
    ui.over({ box: box, open: open, close: close });
    $("guide-pwa").onclick = open; $("pwa-close").onclick = close;
    box.addEventListener("pointerdown", function (event) { if (event.target === box) close(); });
    $("pwa-install").onclick = function () {
      if (!installPrompt) return;
      var prompt = installPrompt; installPrompt = null; lay();
      Promise.resolve().then(function () { return prompt.prompt(); }).then(function () { return prompt.userChoice; })
        .then(function () { lay(); }).catch(function () { say("Your browser could not open the installation prompt. Use its Install app or Add to Home Screen action."); lay(); });
    };
    window.addEventListener("appinstalled", function () { installPrompt = null; didInstall = true; lay(); });
    $("pwa-save").onclick = function () {
      if (saving) return; saving = true; revision++; lay(); say("Preparing the offline copy…");
      if (navigator.storage && navigator.storage.persist) Promise.resolve().then(function () { return navigator.storage.persist(); })
        .catch(function () { /* saving still works without persistent storage */ });
      request("offline-save", progress).then(function (value) {
        progress(value);
        if (!(value.ok === true && value.complete === true && counts(value) && value.saved === value.total) && counts(value)) {
          say("The offline copy is incomplete (" + value.saved + " of " + value.total + " files). Check your connection and available storage, then try again to save the remaining files.");
        }
      }).catch(function (error) { say(error.message); }).finally(function () { saving = false; lay(); });
    };
    function rememberPosition() {
      ui.pause();
      var state = ui.state;
      if (!ui.home() && state.scene) {
        var fragment = "#" + state.scene.id + "@" + Math.round(state.t * 10) / 10;
        try { history.replaceState(null, "", P.web.address(location.href, P.cat.web, state.scene.id, fragment)); } catch (e) { /* retain the current address */ }
      }
    }
    $("pwa-update").onclick = function () {
      if (!(registration && registration.waiting) || reloading) return;
      rememberPosition(); reloading = true; lay(); say("Updating the app…");
      request("activate_update", null, registration.waiting).catch(function (error) {
        reloading = false; lay(); say(error.message);
      });
    };
    navigator.serviceWorker.addEventListener("controllerchange", function () {
      if (!navigator.serviceWorker.controller) { controlledAtStart = false; return; }
      if (reloading || controlledAtStart) { rememberPosition(); controlledAtStart = false; reloading = false; location.reload(); }
      else { controlledAtStart = true; lay(); }
    });
    Promise.resolve().then(function () { return navigator.serviceWorker.register("sw.js", { scope: "./", updateViaCache: "none" }); }).then(function (reg) {
      registration = reg;
      function changed() { lay(); if (!box.hidden && reg.active) status(); }
      reg.addEventListener("updatefound", function () { if (reg.installing) reg.installing.addEventListener("statechange", changed); });
      if (reg.installing) reg.installing.addEventListener("statechange", changed);
      changed();
      navigator.serviceWorker.ready.then(changed).catch(function () { /* registration's status remains visible */ });
    }).catch(function () { say("Offline support could not start. Check your connection and reload this page."); lay(); });
    lay();
  }
})();
