{-#LANGUAGE JavaScriptFFI #-}
{-#LANGUAGE OverloadedStrings #-}
{-#LANGUAGE LambdaCase #-}

module JavaScript.XHR
( Method (..)
, xhr
, getStatus
, getBody
, ajax
, get
)
where

import Data.JSString
import Data.JSString.Text (textToJSString, textFromJSString)
import GHCJS.Types
import GHCJS.Marshal (ToJSVal(..), FromJSVal(..))
import Data.Text (Text)
import Data.Maybe (fromMaybe)

newtype XHR = XHR { unXHR :: JSVal }

data Method = GET
            | POST
            deriving (Show, Eq, Enum, Ord)

methodJSString :: Method -> JSString
methodJSString GET = "GET"
methodJSString POST = "POST"

foreign import javascript interruptible
    "ghcjs_xhr$ajax($1, $2, $3, $4, $c);"
    js_ajax :: JSString -> JSString -> JSString -> JSString -> IO JSVal

foreign import javascript
    "ghcjs_xhr$xhrGetStatus($1)"
    js_xhrGetStatus :: JSVal -> IO JSVal

foreign import javascript
    "ghcjs_xhr$xhrGetBody($1) || ''"
    js_xhrGetBody :: JSVal -> IO JSString

xhr :: Method -> Text -> Text -> Text -> IO XHR
xhr method url contentType body = do
    let js_method = methodJSString method
        js_url = textToJSString url
        js_contentType = textToJSString contentType
        js_body = textToJSString body
    XHR <$> js_ajax js_method js_url js_contentType js_body

getStatus :: XHR -> IO Int
getStatus xhr = fmap (fromMaybe 500) $ fromJSVal =<< js_xhrGetStatus (unXHR xhr)

getBody :: XHR -> IO Text
getBody xhr = fmap textFromJSString $ js_xhrGetBody (unXHR xhr)

ajax :: Method -> Text -> Text -> Text -> IO (Int, Text)
ajax method url contentType body = do
    req <- xhr method url contentType body
    (,) <$> getStatus req <*> getBody req

get :: Text -> IO (Int, Text)
get url = ajax GET url "application/x-www-form-encoded" ""
