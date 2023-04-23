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

   text = fs.readFileSync \./syntaxes/livescript.tmLanguage.yaml \utf8
   json = jsYaml.load text

   pattern = json.repository.references.patterns.0
   matches = pattern.match.match /^(.*?)([a-zA-Z0-9_|]+)(.*?)$/
   const refs = matches.2.split \|
   index = refs.indexOf \ID_INTERPOLATE
   refs.splice index, 1 if index >= 0
   matchers = <[
      SVGFE,Element
      HTML,Element
      SVG,Element
      BackgroundFetch,
      ReadableStream,
      XMLHttpRequest,
      Presentation,
      Performance,
      SVGAnimated,
      AppHistory,
      Bluetooth,
      ,Observer
      Gamepad,
      ,Manager
      Canvas,
      webkit,
      ,Stream
      Audio,
      Media,
      Video,
      WebGL,
      XPath,
      ,Error
      ,Event
      Text,
      ,List
      ,Node
      ,Map
      CSS,
      DOM,
      IDB,
      RTC,
      USB,
      XML,
      XR,
   ]>
      .map (.split \,)
   refsGroups = []
   refOthers = []
   for ref in refs
      isMatched = no
      for matcher, i in matchers
         if ref.startsWith matcher.0 and ref.endsWith matcher.1
            refsGroups[i] ?= [matcher, []]
            name = ref.substring matcher.0.length, ref.lastIndexOf matcher.1
            refsGroups[i]1.push name
            isMatched = yes
            break
      unless isMatched
         refOthers.push ref
   patternMatch = []
   for refsGroup in refsGroups
      if refsGroup.1.length
         patternMatch.push "#{refsGroup.0.0}(?:#{refsGroup.1.join \|})#{refsGroup.0.1}"
   patternMatch.push refOthers.join \|
   patternMatch = "#{matches.1}#{patternMatch.join \|}#{matches.3}"
   pattern.match = patternMatch

   fs.outputJsonSync "#vscodeExtsLiveScriptPath/syntaxes/livescript.tmLanguage.json" json

   json = fs.readJsonSync \./package.json
   fs.outputJsonSync "#vscodeExtsLiveScriptPath/package.json" json

   json = fs.readJsonSync \./language-configuration.json
   fs.outputJsonSync "#vscodeExtsLiveScriptPath/language-configuration.json" json

   descriptions = fs.readFileSync \./snippets/descriptions.yaml \utf8
   descriptions = descriptions and jsYaml.load descriptions or {}

   snippets = fs.readJsonSync \./snippets/livescript.code-snippets
   for ref in refs
      unless snippets[ref]
         snippet = snippets[ref] =
            scope: \livescript
            prefix: ref
            body: ref
         if description = descriptions[ref]
            snippet.description? = "#description\n\n"
   fs.outputJsonSync "#vscodeExtsLiveScriptPath/snippets/livescript.code-snippets" snippets
else
   throw Error "Không tìm thấy path: #vscodeExtsPath"
