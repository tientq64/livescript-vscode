process.chdir(__dirname)

const fs = require('fs-extra')
const jsYaml = require('js-yaml')

const vscodeExtsPath = 'F:/apps/Microsoft VS Code/resources/app/extensions'

if (fs.existsSync(vscodeExtsPath)) {
   const vscodeExtsLiveScriptPath = vscodeExtsPath + '/livescript'

   fs.emptyDirSync(vscodeExtsLiveScriptPath)

   let yamlText = fs.readFileSync('./syntaxes/livescript.tmLanguage.yaml', 'utf8')
   let json = jsYaml.load(yamlText)
   fs.outputJsonSync(`${vscodeExtsLiveScriptPath}/syntaxes/livescript.tmLanguage.json`, json)

   json = fs.readJsonSync('./package.json')
   fs.outputJsonSync(`${vscodeExtsLiveScriptPath}/package.json`, json)

   json = fs.readJsonSync('./language-configuration.json')
   fs.outputJsonSync(`${vscodeExtsLiveScriptPath}/language-configuration.json`, json)

   json = fs.readJsonSync('./snippets/livescript.code-snippets')
   fs.outputJsonSync(`${vscodeExtsLiveScriptPath}/snippets/livescript.code-snippets`, json)
} else {
   throw Error(`Không tìm thấy path: ${vscodeExtsPath}`)
}
