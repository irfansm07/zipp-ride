import { readFileSync, writeFileSync } from 'fs';

// Read with proper encoding
let c = readFileSync('ZippApp.jsx', { encoding: 'utf-8' });
console.log('Read', c.length, 'chars');

const map = [
  ['#080810', '#EAF2F8'],
  ['#12121a', '#FFFFFF'],
  ['#1c1c28', '#CBDDE9'],
  ['#2a2a3a', '#9BBCD0'],
  ['#1a1a28', '#C0D8E8'],
  ['#00e5a0', '#2872A1'],
  ['#00b87a', '#1A5C8A'],
  ['#7b5ef8', '#1D6FA4'],
  ['#5b3fd8', '#155F8E'],
  ['#f0f0f8', '#0D2137'],
  ['#8888aa', '#4A6B80'],
  ['#666688', '#5A7A8F'],
  ['#555577', '#6A90A0'],
  ['#444466', '#7A9FAF'],
];

for (const [from, to] of map) {
  const re = new RegExp(from.replace('#', '#'), 'gi');
  const count = (c.match(re) || []).length;
  c = c.replace(re, to);
  if (count > 0) console.log(`  ${from} -> ${to} (${count} replacements)`);
}

// Also fix rgba variants
c = c.replaceAll('rgba(123,94,248,', 'rgba(29,111,164,');
c = c.replaceAll('rgba(0,229,160,', 'rgba(40,114,161,');

writeFileSync('ZippApp.jsx', c, 'utf-8');
console.log('Written', c.length, 'chars. Done!');
