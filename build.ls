process.chdir __dirname

require! {
   "fs-extra": fs
   "livescript2": livescript
   terser
   \js-yaml
   \@vscode/vsce
}

const dist = \./dist

fs.emptyDirSync dist

# code = fs.readFileSync \./src/extension.ls \utf8
# code = livescript.compile code,
#   bare: yes
# code = await terser.minify code
# code .= code
# fs.outputFileSync "#dist/dist/extension.js" code

# fs.copySync \./src/libs/livescript.min.js "#dist/dist/libs/livescript.min.js"

autocompletes = fs.readJsonSync \./syntaxes/autocompletes.json

snippets = fs.readJsonSync \./snippets/livescript.code-snippets

syntaxes = fs.readFileSync \./syntaxes/livescript.tmLanguage.yaml \utf8
windowMethods = []
staticMethods = {}
protoMethods = new Set

for item in autocompletes
   if item.instance
      methods = []
      staticMethods[item.instance] = methods
   for name in item.props ++ item.methods
      isMethod = item.methods.includes name and name.0 == name.0.toLowerCase!
      if item.proto == \window
         key = name
         snippet =
            scope: \livescript
            prefix: name
            body: name
         if isMethod
            windowMethods.push name
      else if item.instance
         key = "#{item.instance}.#name"
         snippet =
            scope: \livescript
            prefix: key
            body: key
         if isMethod
            methods.push name
      else
         key = "#{item.proto}#name"
         snippet =
            scope: \livescript
            prefix: name
            body: name
         if isMethod
            protoMethods.add name
      snippets[key] ?= snippet

windowMethods .= join \|
protoMethods = Array.from protoMethods .join \|

yamls = []
for instance, methods of staticMethods
   if methods.length
      instance .= split \.
      methods .= join \|
      switch instance.length
      case 1
         yaml = """
            -  match: (?<![."')\\]}?!])(#{instance.0})(\\.~?)(#methods)(?![\\w$])
               captures:
                  1:
                     name: storage.type.livescript
                  2:
                     name: punctuation.accessor.livescript
                  3:
                     name: entity.name.function.livescript
         """
      case 2
         yaml = """
            -  match: (?<![."')\\]}?!])(#{instance.0})(\\.~?)(#{instance.1})(\\.~?)(#methods)(?![\\w$])
               captures:
                  1:
                     name: storage.type.livescript
                  2:
                     name: punctuation.accessor.livescript
                  3:
                     patterns:
                     - include: '\#variable'
                  4:
                     name: punctuation.accessor.livescript
                  5:
                     name: entity.name.function.livescript
         """
      yaml .= replace /^/gm "      " .trimLeft!
      yamls.push yaml
staticMethods = yamls.join "\n      "

syntaxes .= replace /{{(\w+)}}/g (, name) ~>
   eval name

json = jsYaml.load syntaxes
while /<<(\w+)>>/.test syntaxes
   syntaxes .= replace /<<(\w+)>>/g (, name) ~>
      json.variables[name].replace /'/g \''

json = jsYaml.load syntaxes
delete json.variables
fs.outputJsonSync "#dist/syntaxes/livescript.tmLanguage.json" json
fs.outputJsonSync "#dist/snippets/livescript.code-snippets" snippets

json = fs.readJsonSync \./package.json
fs.outputJsonSync "#dist/package.json" json

json = fs.readJsonSync \./language-configuration.json
fs.outputJsonSync "#dist/language-configuration.json" json

fs.copySync \./icon.png "#dist/icon.png"
fs.copySync \./sample.png "#dist/sample.png"
fs.copySync \./LICENSE "#dist/LICENSE"
fs.copySync \./README.md "#dist/README.md"
fs.copySync \./CHANGELOG.md "#dist/CHANGELOG.md"

pack = require \./package.json
extsDir = "C:/Users/QUANGTIEN/.vscode/extensions"
extDir = "#extsDir/tientq64.livescript-vscode-#{pack.version}"
fs.emptyDirSync extDir
fs.copySync dist, extDir

process.chdir dist
await vsce.createVSIX!
