process.chdir __dirname

require! {
   "fs-extra": fs
   "livescript2": livescript
   \terser
   \js-yaml
}

const vscodeExtsPath = "F:/apps/Microsoft VS Code/resources/app/extensions"

if fs.existsSync vscodeExtsPath
   const vscodeExtsLiveScriptPath = "#vscodeExtsPath/livescript"

   fs.emptyDirSync vscodeExtsLiveScriptPath

   code = fs.readFileSync \./src/extension.ls \utf8
   code = livescript.compile code,
      bare: yes
   code = await terser.minify code
   code .= code
   fs.outputFileSync "#vscodeExtsLiveScriptPath/dist/extension.js" code

   fs.copySync \./src/libs/livescript.min.js "#vscodeExtsLiveScriptPath/dist/libs/livescript.min.js"

   syntaxes = fs.readFileSync \./syntaxes/livescript.tmLanguage.yaml \utf8
   snippets = fs.readJsonSync \./snippets/livescript.code-snippets

   generator = fs.readJsonSync \./syntaxes/generator.json
   map =
      windowProps: []
      windowMethods: []
      builtInStaticProps: []
      builtInStaticMethods: []
      builtInProtoProps: []
      builtInProtoMethods: []
   for k, {props, methods, prefix} of generator
      prefix ?= k
      if prefix is \window
         map.windowProps = props
         map.windowMethods = methods
         for name in props ++ methods
            snippets[name] =
               scope: \livescript
               prefix: name
               body: name
               description: k
      else if prefix.includes \.prototype
         if props.length
            map.builtInProtoProps.push ...props
         if methods.length
            map.builtInProtoMethods.push ...methods
         for name in props ++ methods
            snippets".#name" =
               scope: \livescript
               prefix: name
               body: name
               description: k
      else
         if props.length
            yaml = """
               - match: (?<![."')\\]}?!])(#prefix)(\\.)(#{props.join \|})(?![\\w$])
                 captures:
                   1:
                     name: storage.type.livescript
                   2:
                     name: punctuation.accessor
                   3:
                     name: storage.type.livescript
            """
            yaml .= replace /^/gm "    " .trimLeft!
            map.builtInStaticProps.push yaml
         if methods.length
            yaml = """
               - match: (?<![."')\\]}?!])(#prefix)(\\.)(#{methods.join \|})(?![\\w$])
                 captures:
                   1:
                     name: storage.type.livescript
                   2:
                     name: punctuation.accessor
                   3:
                     name: entity.name.function
            """
            yaml .= replace /^/gm "    " .trimLeft!
            map.builtInStaticMethods.push yaml
         for name in props ++ methods
            snippets"#prefix.#name" =
               scope: \livescript
               prefix: "#prefix.#name"
               body: "#prefix.#name"
               description: k
   map.windowProps = [...new Set map.windowProps]join \|
   map.windowMethods = [...new Set map.windowMethods]join \|
   map.builtInStaticProps .= join "\n    "
   map.builtInStaticMethods .= join "\n    "
   map.builtInProtoProps = [...new Set map.builtInProtoProps]join \|
   map.builtInProtoMethods = [...new Set map.builtInProtoMethods]join \|
   syntaxes .= replace /\{\{ (\w+) \}\}/gm (, name) ~>
      map[name]

   json = jsYaml.load syntaxes
   fs.outputJsonSync "#vscodeExtsLiveScriptPath/syntaxes/livescript.tmLanguage.json" json
   fs.outputJsonSync "#vscodeExtsLiveScriptPath/snippets/livescript.code-snippets" snippets

   json = fs.readJsonSync \./package.json
   fs.outputJsonSync "#vscodeExtsLiveScriptPath/package.json" json

   json = fs.readJsonSync \./language-configuration.json
   fs.outputJsonSync "#vscodeExtsLiveScriptPath/language-configuration.json" json
else
   throw Error "Không tìm thấy path: #vscodeExtsPath"
