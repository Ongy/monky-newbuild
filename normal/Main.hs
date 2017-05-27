import Monky
import Monky.Modules

import Monky.Examples.Sound.Pulse
import Monky.Examples.CPU
import Monky.Examples.Memory
import Monky.Examples.Network
import Monky.Examples.Time
import Monky.Examples.MPD
import Monky.Examples.IBus
import Monky.Examples.Modify

import Monky.Outputs.Guess
import Monky.Outputs.Utf8
import Monky.Outputs.Modify

-- import Data.Text (Text)
import qualified Data.Text as T

ibusMap :: [(String, MonkyOut)]
ibusMap =
  [ ("xkb:us::eng", MonkyImage "e" 'E')
  , ("xkb:de::ger", MonkyImage "d" 'D')
  , ("anthy", MonkyImage "か" 'か')
  ]

modifyMPD :: [MonkyOut] -> [MonkyOut]
modifyMPD orig@(MonkyPlain xs:ys) =
  if T.length xs > len
     then MonkyPlain (T.take (len - 3) xs `T.append` "..."):ys
     else orig
  where len = 26

main :: IO()
main =
  startLoop ({-getModifyOutput removeColour $-} guessOutput 18 "/home/ongy/.local/share/monky/xbm/")
    [ evtPack    $ getModifyHandle modifyMPD $ getMPDHandle "127.0.0.1" "6600"
    , evtPack    $ getPulseHandle Nothing
    , pollPack 1 $ getCPUHandle' ScalingCur
    , pollPack 1 $ getStaticHandle "None" "enp4s0"
    , pollPack 1 $ getMemoryBarHandle 2
    , pollPack 1 $ getFancyTimeHandle "%a %d.%m %H:%M:%S"
    , evtPack    $ getIBusH ibusMap
    ]
