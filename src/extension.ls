# require! {
#    vscode
#    \./libs/livescript.min.js
# }

# !function activate context
#    context.subscriptions.push do
#       vscode.languages.registerDocumentSymbolProvider do
#          language: \livescript
#          new DocumentSymbolProvider

# function addSymbol symbols, range, name, kindName, detail
#    symbol = new vscode.DocumentSymbol name,
#       detail
#       vscode.SymbolKind[kindName]
#       range
#       range
#    symbols.push symbol
#    symbol

# !function walker symbols, lines
#    for line in lines
#       symbol = void

#       firstLine = line.first_line - 1 >? 0
#       firstColumn = line.first_column
#       range = new vscode.Range firstLine, firstColumn, firstLine, firstColumn

#       switch
#       | line.params and line.name
#          symbol = addSymbol symbols, range, line.name, \Function

#       | line.key?name and line.val?params
#          symbol = addSymbol symbols, range, line.key.name, \Method

#       | line.title and line.fun
#          symbol = addSymbol symbols, range, line.title.value, \Class

#       | line.left?value and line.op
#          switch
#          | line.right?items
#             symbol = addSymbol symbols, range, line.left.value, \Object

#          | line.right and line.right.params and line.right.body
#             symbol = addSymbol symbols, range, line.left.value, \Function

#          | line.right and \title of line.right and line.right.fun
#             symbol = addSymbol symbols, range, line.left.value, \Class

#       newSymbols = symbol?children or symbols

#       switch
#       | line.fun?body?lines
#          walker newSymbols, line.fun.body.lines

#       | line.body?lines
#          walker newSymbols, line.body.lines

#       | line.right?items
#          walker newSymbols, line.right.items

#       | line.right?tails
#          walker newSymbols, line.right.tails

#       | line.right?body
#          walker newSymbols, line.right.body

#       | line.right?fun?body?lines
#          walker newSymbols, line.right.fun.body.lines

#       | line.tails
#          walker newSymbols, line.tails

#       | line.args
#          walker newSymbols, line.args

#       | line.items
#          walker newSymbols, line.items

# class DocumentSymbolProvider implements vscode.DocumentSymbolProvider
#    provideDocumentSymbols: (doc, cancelToken) ->
#       symbols = []
#       code = doc.getText!
#       try
#          ast = livescript.ast code
#          walker symbols, ast.lines
#       catch
#          throw e
#       symbols

# module.exports = {activate}
