import { readFileSync, writeFileSync } from 'fs';
let c = readFileSync('ZippApp.jsx', 'utf-8');

// Fix rgba backgrounds that weren't caught
c = c.replaceAll('rgba(8,8,16,', 'rgba(203,221,233,');
c = c.replaceAll('rgba(255,255,255,.025)', 'rgba(40,114,161,.06)');

// Fix button text that should be white on ocean blue buttons
c = c.replaceAll('color:"#EAF2F8",border:"none",borderRadius:12,padding:"13px",fontFamily:"Syne,sans-serif"', 
                  'color:"#fff",border:"none",borderRadius:12,padding:"13px",fontFamily:"Syne,sans-serif"');
c = c.replaceAll('color:"#EAF2F8",border:"none",borderRadius:12,padding:"14px",fontFamily:"Syne,sans-serif"',
                  'color:"#fff",border:"none",borderRadius:12,padding:"14px",fontFamily:"Syne,sans-serif"');

writeFileSync('ZippApp.jsx', c, 'utf-8');
console.log('Rgba fixes applied!');
