{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
module Test.Cardano.Api
  ( tests
  ) where

import           Cardano.Prelude

import           Cardano.Api

import           Test.Cardano.Api.Orphans ()

import           Hedgehog (Property, (/==), discover)
import qualified Hedgehog as Hedgehog

import           Test.Cardano.Api.Gen

prop_byronGenSigningKey_unique :: Property
prop_byronGenSigningKey_unique =
  Hedgehog.property $ do
    -- Basic sanity test that two distinct calls to the real 'genByronSigningKey'
    -- produces two distinct SigningKeys.
    kp1 <- liftIO byronGenSigningKey
    kp2 <- liftIO byronGenSigningKey
    kp1 /== kp2

-- | Basic sanity test that two distinct calls to the real 'shelleyGenSigningKey'
-- produces two distinct 'SigningKey's.
prop_shelleyGenSigningKey_unique :: Property
prop_shelleyGenSigningKey_unique =
  Hedgehog.property $ do
    kp1 <- liftIO shelleyGenSigningKey
    kp2 <- liftIO shelleyGenSigningKey
    kp1 /== kp2

prop_roundtrip_AddressByron_hex :: Property
prop_roundtrip_AddressByron_hex = do
  Hedgehog.property $ do
    addr <- Hedgehog.forAll genByronVerificationKeyAddress
    Hedgehog.tripping addr addressToHex addressFromHex

prop_roundtrip_AddressShelley_hex :: Property
prop_roundtrip_AddressShelley_hex = do
  Hedgehog.property $ do
    addr <- Hedgehog.forAll genShelleyVerificationKeyAddress
    Hedgehog.tripping addr addressToHex addressFromHex

-- -----------------------------------------------------------------------------

tests :: IO Bool
tests =
  Hedgehog.checkParallel $$discover
