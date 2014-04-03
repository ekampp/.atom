{-# LANGUAGE JavaScriptFFI, CPP #-}

module Main where

import Data.Text.Lazy
import Text.Markdown
import Text.Blaze.Html.Renderer.Text
import System.IO

import Control.Concurrent
import Control.Concurrent.MVar

import GHCJS.Foreign
import GHCJS.Types

foreign import javascript unsafe "var e = process.exit; process.exit = function(){ return; }; module.exports = function(it, cb) { var w = process.stdout.write; var rv = ''; process.stdout.write = function(chunk) { rv += chunk; if (chunk.length && chunk[chunk.length-1] == '\\u0000') { process.stdout.write = w; cb(rv.slice(0, -1)); } }; $1(it); return };" exports
  :: JSFun (JSString -> IO ()) -> IO ()

main = do
  s1 <- syncCallback1 False True $ \x -> do
      putStr (unpack $ renderHtml $ markdown def $ fromChunks [fromJSString x])
      putChar '\0'
      hFlush stdout
  exports s1
