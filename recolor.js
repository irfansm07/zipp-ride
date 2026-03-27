const fs = require('fs');
let c = fs.readFileSync('ZippApp.jsx', 'utf8');

// Dark → Light theme
const replacements = [
  // Backgrounds
  [/#080810/g, '#EAF2F8'],
  [/#12121a/g, '#FFFFFF'],
  [/#1c1c28/g, '#CBDDE9'],
  [/#2a2a3a/g, '#9BBCD0'],
  [/#1a1a28/g, '#C0D8E8'],
  // Accent green → Ocean Blue
  [/#00e5a0/g, '#2872A1'],
  [/#00b87a/g, '#1A5C8A'],
  // Purple → Darker blue
  [/#7b5ef8/g, '#1D6FA4'],
  [/#5b3fd8/g, '#155F8E'],
  [/rgba\(123,94,248,/g, 'rgba(29,111,164,'],
  [/rgba\(0,229,160,/g, 'rgba(40,114,161,'],
  // Text colors
  [/#f0f0f8/g, '#0D2137'],
  [/#8888aa/g, '#4A6B80'],
  [/#666688/g, '#5A7A8F'],
  [/#555577/g, '#6A90A0'],
  [/#444466/g, '#7A9FAF'],
  // Splash stays dark
];

replacements.forEach(([from, to]) => {
  c = c.replace(from, to);
});

// Fix: button text that was dark-on-dark — make it white on Ocean Blue buttons
// When bg is ocean blue gradient, text should be white not dark
c = c.replace(/color:"#0D2137"([^}]*?)background:"linear-gradient\(135deg,#2872A1/g, 
  'color:"#fff"$1background:"linear-gradient(135deg,#2872A1');

// Splash screen keep dark
c = c.replace(
  `background:"#EAF2F8",\r\n      display:"flex", flexDirection:"column", alignItems:"center", justifyContent:"center",`,
  `background:"#0D2137",\r\ndisplay:"flex", flexDirection:"column", alignItems:"center", justifyContent:"center",`
);

fs.writeFileSync('ZippApp.jsx', c, 'utf8');
console.log('Color theme applied successfully!');
