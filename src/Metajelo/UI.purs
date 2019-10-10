module Metajelo.UI where

import Prelude (Unit, bind, discard, show, pure, unit, ($), (<$>), (<>))

import Concur.Core (Widget)
import Concur.Core.FRP (Signal, display, dyn, loopS, step)
import Concur.React (HTML)
import Concur.React.DOM as D
import Concur.React.Props as P
import Concur.React.Run (runWidgetInDom)
import Data.Maybe (Maybe(..))
import Data.Newtype (unwrap)
import Data.Semigroup.First (First(..))
import Effect (Effect)

main :: Effect Unit
main = pure unit

testWidget :: forall a. Widget HTML a
testWidget = dyn $ loopS Nothing \oldNameMay -> D.div_ [] do
  instNameMay <- textInput Nothing
  -- If I remove the line below, then New Name is always Nothing
  instNameMay <- pure $ unwrap (First instNameMay <> First oldNameMay)
  display $ D.div' [D.text $ "Old Name: " <> (show oldNameMay)]
  display $ D.div' [D.text $ "New Name: " <> (show instNameMay)]
  pure instNameMay
  where
  textInput :: Maybe String -> Signal HTML (Maybe String)
  textInput ms = step ms do
    newTxt <- D.input [P.unsafeTargetValue <$> P.onChange]
    pure $ textInput (Just newTxt)

runFormSPA :: String -> Effect Unit
runFormSPA divId = runWidgetInDom divId testWidget
