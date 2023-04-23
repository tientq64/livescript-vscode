require! {vscode}

types = new Map
modifiers = new Map

legendTypes =
   \method
   \variable
for legendType, i in legendTypes
   types.set legendType, i

legendModifiers =
   \declaration
   \readonly
for legendModifier, i in legendModifiers
   modifiers.set legendModifier, i

legend = new vscode.SemanticTokensLegend legendTypes, legendModifiers

function activate context
   context.subscriptions.push do
      vscode.languages.registerDocumentSemanticTokensProvider do
         language: \livescript
         new DocumentSemanticTokensProvider
         legend

class DocumentSemanticTokensProvider extends vscode.DocumentSemanticTokensProvider
   provideDocumentSemanticTokens: (doc, cancelToken) ->
      builder = new vscode.SemanticTokensBuilder
      builder.push 2 1 11 1 1
      builder.build!

module.exports = {activate}
