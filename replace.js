const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'lib', 'views', 'auth', 'register_screen.dart');
let content = fs.readFileSync(filePath, 'utf8');

content = content.replace(/^\s*hintColor:\s*Colors\.white(?:70)?,\r?\n?/gm, '');
content = content.replace(/color:\s*Colors\.white54/g, 'color: AppColors.textLight');
content = content.replace(/import\s+'package:liquid_glass_renderer\/liquid_glass_renderer\.dart';\r?\n?/g, '');

fs.writeFileSync(filePath, content, 'utf8');
console.log('Replacement complete.');
