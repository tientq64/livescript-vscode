items = <[
   window
   String
   Number
   Array
   Object
   Symbol
   Math
   Date
   Node
   JSON
   Promise
   Reflect
   Intl
   URL
   Window
   DOMException
   location
   console
   Document::|document
   Navigator::|navigator
   Screen::|screen
   History::|history
   Storage::|localStorage
   Storage::|sessionStorage
   Event::|event
   Clipboard::|navigator.clipboard
   String::
   Number::
   Array::
   RegExp::
   Date::
   Node::
   Element::
   HTMLElement::
   Function::
   Promise::
   EventTarget::
   Crypto::|crypto
   Selection::
   CanvasRenderingContext2D::
   FormData::
   Response::
   FileReader::
   File::
   Blob::
   HTMLMediaElement::
   HTMLCanvasElement::
   BatteryManager::
]>

for item, i in items
   [proto, instance] = item.split \|
   if !instance and !proto.includes \::
      instance = proto
   items[i] =
      key: item
      proto: proto
      instance: instance
      props: []
      methods: []

delete window.livescript

for item in items
   obj = window.eval item.proto.replace \:: \.prototype
   descs = Object.getOwnPropertyDescriptors obj

   for name, desc of descs
      if typeof desc.value == \function
         unless name in <[constructor]>
            item.methods.push name
      else
         unless name in <[name arguments length caller prototype]>
            item.props.push name

json = JSON.stringify items,, "  "
preEl.textContent = json

preEl.addEventListener \click (event) !~>
   jsonMin = JSON.stringify items
   navigator.clipboard.writeText jsonMin
