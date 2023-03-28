process.chdir(__dirname)

const fs = require('fs-extra')
const jsYaml = require('js-yaml')

const dist = 'F:/apps/Microsoft VS Code/resources/app/extensions/livescript'
const filename = 'livescript.tmLanguage'

let json = jsYaml.load(fs.readFileSync(`./syntaxes/${filename}.yaml`, 'utf8'))

fs.emptyDirSync(dist)
fs.outputJsonSync(`${dist}/syntaxes/${filename}.json`, json)

fs.copySync('./package.json', `${dist}/package.json`)
fs.copySync('./language-configuration.json', `${dist}/language-configuration.json`)
