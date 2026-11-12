# PDF.js 6.5.438

Mozilla PDF.js, Apache-2.0 (see LICENSE).
Source: https://www.npmjs.com/package/pdfjs-dist/v/6.5.438
Documentation: https://mozilla.github.io/pdf.js/
Retrieved 10 November 2026. npm tarball SHA-1:
`e7f8986ec4ea04057b5d9d2f0e5b63ea94d2303f`.

- `pdf.js`: upstream `build/pdf.mjs`, bundled with esbuild 0.27.0:
  `esbuild pdf.mjs --bundle --format=iife --global-name=pdfjsLib --minify --target=es2022 --outfile=pdf.js`
  The import.meta warning concerns the Node-only branch; this is a browser bundle.
- `worker-data.js`: unchanged `build/pdf.worker.min.mjs` encoded as a JSON
  string assigned to `window.HERACLITUS_PDF_WORKER`. A Blob module worker
  runs locally when served over HTTP(S).
- `worker.js`: upstream `build/pdf.worker.mjs`, bundled with the same esbuild
  flags and global name `pdfjsWorker`. This is the in-process PDF.js fallback
  for `file://` (module workers are restricted on opaque file origins).
  WASM is disabled; the import.meta warnings concern unused WASM loading.
- `text-layer.css`: the upstream `.textLayer` block from `web/pdf_viewer.css`.

No CDN or network access at runtime. The PDF payload is generated separately
by `presentation/build_manuscript.py`. This viewer targets current browsers
with module workers, modern PDF.js APIs and Web Crypto. An original-PDF
link remains available if startup fails. Only this embedded manuscript was
validated; this is not a general PDF upload/viewer service.
