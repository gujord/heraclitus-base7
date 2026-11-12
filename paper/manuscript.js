/* Continuous original PDF. Audience DOM contains document/search only.
 * Reviewed text-line coordinates provide subtle, non-interactive highlighting. */
'use strict';
(() => {
const $=id=>document.getElementById(id),A=window.HERACLITUS_MANUSCRIPT_NOTES,D=window.HERACLITUS_MANUSCRIPT_DATA;
const embedded=parent!==window&&new URLSearchParams(location.search).get('embedded')==='1';
const origin=location.protocol==='file:'?'null':location.origin,target=location.protocol==='file:'?'*':location.origin;
let active=true,pdf=null,pageNumber=1,verified=false,selected=null,worker=null,workerURL=null,ready=false,generation=0,observer=null,layoutWidth=0,resizeTimer=null,scrollFrame=null;
let pages=[],searchQuery='',matches=[],matchIndex=-1,searchId=0,jumpId=0;
const cache=new Map(),key='heraclitus.manuscript.position.v2',markingsKey='heraclitus.manuscript.markings.v1';
let markings=true;try{markings=sessionStorage.getItem(markingsKey)!=='off';}catch{}
function updateMarkings(){document.body.classList.toggle('pdf-markings',verified&&markings);}
function toggleMarkings(){markings=!markings;try{sessionStorage.setItem(markingsKey,markings?'on':'off');}catch{}updateMarkings();publish();}
const snapshot=()=>({manuscript:{page:pageNumber,pages:pdf?.numPages||0,selected:selected?.id||null,verified,active,markings,sha256:verified?A.sha256:null}});
function publish(){if(embedded)parent.postMessage({type:'heraclitus-manuscript-state',state:snapshot().manuscript},target);}
function setPage(n){if(pageNumber===n)return;pageNumber=n;if(selected?.page!==n)selected=null;publish();}
function position(){const p=pages[pageNumber-1];return {page:pageNumber,offset:p?Math.max(0,Math.min(1,(window.scrollY-p.element.offsetTop)/p.height)):0};}
function save(){if(!ready)return;try{sessionStorage.setItem(key,JSON.stringify(position()));}catch{}}
function trackPage(){
 scrollFrame=null;if(!ready||!active)return;
 const y=window.scrollY+Math.min(100,innerHeight/4);let n=1;
 for(const p of pages){if(p.element.offsetTop<=y)n=p.number;else break;}
 setPage(n);save();
}
function scheduleScroll(){if(!scrollFrame)scrollFrame=requestAnimationFrame(trackPage);}
async function textFor(n){if(!cache.has(n))cache.set(n,pdf.getPage(n).then(p=>p.getTextContent()));return cache.get(n);}
function highlight(p){
 const q=searchQuery.toLocaleLowerCase();let item=0;
 for(const s of p.text.querySelectorAll('span')){
  if(s.children.length)continue;
  const hit=!!q&&s.textContent.toLocaleLowerCase().includes(q),current=matches[matchIndex];
  s.classList.toggle('pdf-match',hit);s.classList.toggle('pdf-match-current',hit&&current?.page===p.number&&current.item===item);
  if(hit)item++;
 }
}
function fail(error){window.HERACLITUS_MANUSCRIPT_ERROR=String(error.stack||error);$('pdf-status').hidden=false;$('pdf-status').textContent='Could not display the document. ';const a=document.createElement('a');a.href='reference/paper/base-seven-heraclitus.pdf';a.textContent='Open PDF';$('pdf-status').append(a);}
async function renderPage(n){
 const p=pages[n-1];if(!p)return;
 if(p.promise)return p.promise;
 const epoch=generation;
 p.promise=(async()=>{
  const page=await pdf.getPage(n);if(epoch!==generation)return;
  const base=page.getViewport({scale:1}),scale=p.width/base.width,viewport=page.getViewport({scale});
  if(Math.abs(base.width-A.width)>.01||Math.abs(base.height-A.height)>.01||page.rotate!==0){verified=false;selected=null;updateMarkings();publish();}
  // Bound raster memory while retaining selectable text and normal browser zoom.
  const ratio=Math.min(devicePixelRatio||1,2,Math.sqrt(1800000/(viewport.width*viewport.height)));
  p.canvas.width=Math.ceil(viewport.width*ratio);p.canvas.height=Math.ceil(viewport.height*ratio);
  p.element.style.setProperty('--total-scale-factor',String(scale));
  p.task=page.render({canvasContext:p.canvas.getContext('2d'),viewport,transform:[ratio,0,0,ratio,0,0]});await p.task.promise;
  if(epoch!==generation)return;
  const text=await textFor(n);if(epoch!==generation)return;
  p.textTask=new pdfjsLib.TextLayer({textContentSource:text,container:p.text,viewport});await p.textTask.render();
  if(epoch!==generation)return;
  p.rendered=true;p.element.setAttribute('aria-busy','false');highlight(p);
 })().catch(error=>{if(error.name!=='RenderingCancelledException'&&error.name!=='AbortException'){p.promise=null;p.error=error;fail(error);}});
 return p.promise;
}
async function showPage(n){
 if(!pdf)return;
 const id=++jumpId,epoch=generation;const number=Math.max(1,Math.min(pdf.numPages,Math.trunc(Number(n))||1));
 setPage(number);const p=pages[number-1];if(!p)return;
 window.scrollTo({top:Math.max(0,p.element.offsetTop-16),behavior:'instant'});
 await renderPage(number);if(id!==jumpId||epoch!==generation)return;
 save();publish();
}
async function selectRegion(r,scroll=true){
 if(!verified||!active||!A.regions.includes(r))return;
 if(scroll){await showPage(r.page);const p=pages[r.page-1];window.scrollTo({top:p.element.offsetTop+r.rect[1]/A.height*p.height-100,behavior:'instant'});}
 pageNumber=r.page;selected=r;publish();
}
function regionAt(p,event){
 if(!verified||!active)return null;
 const rect=p.element.getBoundingClientRect(),x=(event.clientX-rect.left)/rect.width*A.width,y=(event.clientY-rect.top)/rect.height*A.height;
 return A.regions.find(r=>r.page===p.number&&(r.rects||[r.rect]).some(b=>x>=b[0]&&x<=b[0]+b[2]&&y>=b[1]&&y<=b[1]+b[3]));
}
function hoverRegion(p,r){
 if(p.hover===r?.id)return;p.hover=r?.id;
 for(const [id,nodes] of p.marks)for(const node of nodes)node.classList.toggle('pdf-cue-hover',id===p.hover);
}
function clickPage(p,event,start){
 // Selection, dragging and double-click selection remain native. Overlays never intercept input.
 if(!verified||!active||event.button!==0||event.detail>1||!start||Math.hypot(event.clientX-start.x,event.clientY-start.y)>5||!window.getSelection()?.isCollapsed)return;
 const region=regionAt(p,event);
 if(region)selectRegion(region,false);
 else{pageNumber=p.number;selected=null;publish();}
}
function addMarkings(p){
 const layer=document.createElement('div');layer.className='pdf-cue-layer';layer.setAttribute('aria-hidden','true');p.marks=new Map();
 for(const r of A.regions.filter(r=>r.page===p.number)){
  const nodes=[];
  for(const [index,b] of (r.rects||[r.rect]).entries()){
   const node=document.createElement('span');node.className='pdf-cue-mark'+(r.emphasis?.includes(index)?' pdf-cue-update':'');
   Object.assign(node.style,{left:b[0]/A.width*100+'%',top:b[1]/A.height*100+'%',width:b[2]/A.width*100+'%',height:b[3]/A.height*100+'%'});
   layer.append(node);nodes.push(node);
  }
  p.marks.set(r.id,nodes);
 }
 p.element.insertBefore(layer,p.text);
 p.element.addEventListener('pointermove',e=>hoverRegion(p,regionAt(p,e)));
 p.element.addEventListener('pointerleave',()=>hoverRegion(p,null));
}
async function layout(saved=position()){
 const width=Math.min(960,Math.max(160,document.documentElement.clientWidth-(innerWidth<600?12:40)));
 if(!pdf||!active||document.documentElement.clientWidth===0||width===layoutWidth)return;
 layoutWidth=width;ready=false;const epoch=++generation;observer?.disconnect();
 for(const p of pages){p.task?.cancel();p.textTask?.cancel();}
 pages=[];$('pdf-pages').replaceChildren();
 for(let n=1;n<=pdf.numPages;n++){
  const element=document.createElement('section');element.className='pdf-page';element.dataset.page=String(n);element.setAttribute('aria-label','Page '+n);element.setAttribute('aria-busy','true');
  const canvas=document.createElement('canvas');canvas.setAttribute('aria-hidden','true');canvas.width=0;canvas.height=0;
  const text=document.createElement('div');text.className='textLayer';element.append(canvas,text);
  const p={number:n,width,height:width*A.height/A.width,element,canvas,text,promise:null,rendered:false};
  addMarkings(p);element.style.width=width+'px';element.style.height=p.height+'px';$('pdf-pages').append(element);pages.push(p);
  let start=null;element.addEventListener('pointerdown',e=>{start={x:e.clientX,y:e.clientY};});element.addEventListener('click',e=>clickPage(p,e,start));
 }
 observer=new IntersectionObserver(entries=>{for(const entry of entries)if(entry.isIntersecting)renderPage(Number(entry.target.dataset.page));},{rootMargin:'1000px 0px'});pages.forEach(p=>observer.observe(p.element));
 pageNumber=Math.max(1,Math.min(pdf.numPages,saved.page||1));
 const p=pages[pageNumber-1];window.scrollTo({top:p.element.offsetTop+Math.max(0,Math.min(1,saved.offset||0))*p.height,behavior:'instant'});
 await renderPage(pageNumber);if(epoch!==generation)return;
 ready=p.rendered;if(ready)$('pdf-status').hidden=true;publish();
}
function toggleSearch(open){
 $('pdf-search-panel').hidden=!open;$('pdf-search-toggle').setAttribute('aria-expanded',String(open));
 if(open){$('pdf-search').focus();$('pdf-search').select();}
 else{searchId++;searchQuery='';matches=[];matchIndex=-1;pages.forEach(highlight);$('pdf-search-status').textContent='';$('pdf-search-toggle').focus({preventScroll:true});}
}
async function findNext(){
 const query=$('pdf-search').value.trim(),id=++searchId;
 if(!pdf||!query){searchQuery='';matches=[];matchIndex=-1;pages.forEach(highlight);$('pdf-search-status').textContent='';return;}
 if(query!==searchQuery||!matches.length){
  const found=[];$('pdf-search-status').textContent='Searching…';
  for(let n=1;n<=pdf.numPages;n++){
   const text=await textFor(n);if(id!==searchId)return;
   const count=text.items.filter(x=>x.str?.toLocaleLowerCase().includes(query.toLocaleLowerCase())).length;
   for(let item=0;item<count;item++)found.push({page:n,item});
  }
  searchQuery=query;matches=found;matchIndex=-1;
 }
 if(id!==searchId)return;
 if(!matches.length){pages.forEach(highlight);$('pdf-search-status').textContent='No matches';return;}
 matchIndex=(matchIndex+1)%matches.length;const match=matches[matchIndex];await showPage(match.page);if(id!==searchId)return;
 pages.forEach(highlight);const hit=pages[match.page-1].text.querySelector('.pdf-match-current');hit?.scrollIntoView({block:'center',behavior:'instant'});
 $('pdf-search-status').textContent=`${matchIndex+1} of ${matches.length}`;
}
function command(action,value){
 if(!active)return;
 if(action==='jump'&&typeof value==='string'&&value.startsWith('manuscript:')){const r=A.regions.find(r=>r.id===value.slice(11));if(r)selectRegion(r);}
 else if(action==='manuscript-markings'&&verified)toggleMarkings();
 else if(action==='previous')showPage(pageNumber-1);
 else if(action==='next')showPage(pageNumber+1);
}
$('pdf-search-toggle').onclick=()=>toggleSearch($('pdf-search-panel').hidden);
$('pdf-search-close').onclick=()=>toggleSearch(false);
$('pdf-search-panel').onsubmit=e=>{e.preventDefault();findNext();};
$('pdf-search').oninput=()=>{searchId++;searchQuery='';matches=[];matchIndex=-1;pages.forEach(highlight);$('pdf-search-status').textContent='';};
window.addEventListener('scroll',scheduleScroll,{passive:true});
window.addEventListener('resize',()=>{clearTimeout(resizeTimer);resizeTimer=setTimeout(()=>layout(),150);});
window.addEventListener('message',event=>{
 if(!embedded||event.source!==parent||event.origin!==origin)return;
 if(event.data?.type==='heraclitus-manuscript-command')command(event.data.action,event.data.value);
 if(event.data?.type==='heraclitus-edition-active'){active=event.data.active===true;if(active)layout();publish();}
});
window.addEventListener('pagehide',()=>{save();observer?.disconnect();worker?.terminate();if(workerURL)URL.revokeObjectURL(workerURL);});
document.addEventListener('keydown',e=>{
 if((e.ctrlKey||e.metaKey)&&e.key.toLowerCase()==='f'){e.preventDefault();toggleSearch(true);}
 else if(e.key==='Escape'){e.preventDefault();if(!$('pdf-search-panel').hidden)toggleSearch(false);else window.HERACLITUS_EDITIONS?.choose('read');}
});
window.HERACLITUS_MANUSCRIPT={showPage,selectRegion,findNext,snapshot,renderPage,get ready(){return ready;}};
(async()=>{try{
 const bytes=Uint8Array.from(atob(D.base64),c=>c.charCodeAt(0));
 const hash=crypto.subtle?Array.from(new Uint8Array(await crypto.subtle.digest('SHA-256',bytes)),b=>b.toString(16).padStart(2,'0')).join(''):null;
 verified=hash===A.sha256&&hash===D.sha256;updateMarkings();
 if(location.protocol==='file:'){
  await new Promise((resolve,reject)=>{const script=document.createElement('script');script.src='vendor/pdfjs/worker.js';script.onload=resolve;script.onerror=()=>reject(new Error('Offline PDF worker could not load'));document.head.append(script);});
 }else{
  workerURL=URL.createObjectURL(new Blob([window.HERACLITUS_PDF_WORKER],{type:'text/javascript'}));worker=new Worker(workerURL,{type:'module'});pdfjsLib.GlobalWorkerOptions.workerPort=worker;worker.addEventListener('error',fail);
 }
 pdf=await pdfjsLib.getDocument({data:bytes,isEvalSupported:false,useWasm:false}).promise;
 let saved={page:1,offset:0};try{saved=JSON.parse(sessionStorage.getItem(key)||'null')||saved;}catch{}
 const requested=new URLSearchParams(location.search).get('page');if(requested)saved={page:Number(requested),offset:0};
 await layout(saved);
}catch(error){fail(error);}})();
})();
