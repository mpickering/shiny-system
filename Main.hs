module Main where

import qualified GHC as G
import qualified Outputable as G
import qualified MonadUtils as G
import System.Process
import Control.Monad

main :: IO ()
main = do
  withGHC' $ test
  putStrLn "done"



withGHC' :: G.Ghc a -> IO a
withGHC' body = do
    mlibdir <- getSystemLibDir
    G.runGhc mlibdir body

-- | Obtaining the directory for system libraries.
getSystemLibDir :: IO (Maybe FilePath)
getSystemLibDir = do
    res <- readProcess "ghc" ["--print-libdir"] []
    return $ case res of
        ""   -> Nothing
        dirn -> Just (init dirn)

initSession ::
            [String]
            -> G.Ghc ()
initSession opts = do
    df <- G.getSessionDynFlags
    (df', _, _) <- G.parseDynamicFlags df (map G.noLoc opts)
    void $ G.setSessionDynFlags df'

opts = words "-v2 -fno-code -package-db /home/matt/jsaddle-dom/dist-newstyle/build/x86_64-linux/ghc-8.6.4/jsaddle-dom-0.9.3.1/package.conf.inplace -package jsaddle-dom -XHaskell2010"

test :: G.Ghc ()
test = do
  initSession ["-v2", "-package", "big-package", "-fno-code"]
  t <- G.guessTarget "Target.hs" Nothing
  G.setTargets [t]
  G.liftIO $ print "Before load"
  void $ G.load G.LoadAllTargets
  G.liftIO $ print "After load"
