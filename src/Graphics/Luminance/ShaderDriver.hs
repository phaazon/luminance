{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE Rank2Types #-}
{-# LANGUAGE TypeFamilies #-}

-----------------------------------------------------------------------------
-- |
-- Copyright   : (C) 2015, 2016 Dimitri Sabadie
-- License     : BSD3
--
-- Maintainer  : Dimitri Sabadie <dimitri.sabadie@gmail.com>
-- Stability   : experimental
-- Portability : portable
-----------------------------------------------------------------------------

module Graphics.Luminance.ShaderDriver where

import Control.Monad.Except ( MonadError )
import Data.Int ( Int32 )
import Data.Semigroup ( Semigroup )
import Data.Word ( Word32 )
import GHC.Exts ( Constraint )
import Graphics.Luminance.Shader.Stage ( HasStageError, StageType )
import Graphics.Luminance.Shader.Program ( HasProgramError, UniformName )
import Graphics.Luminance.TextureDriver
import Linear ( M44, V2, V3, V4 )

-- |A driver to implement to provide shader features.
class (Monad m) => ShaderDriver m where
  -- |A shader stage.
  type Stage m :: *
  -- |Create a shader stage from a 'String' representation of its source code and its type.
  --
  -- Note: on some hardware and backends, /tessellation shaders/ aren’t available. That function
  -- throws 'UnsupportedStage' error in such cases.
  createStage :: (HasStageError e,MonadError e m)
              => StageType
              -> String
              -> m (Stage m)
  -- |Shader program.
  type Program m :: * -> *
  -- |A special closed, monadic type in which one can create new uniforms.
  type UniformInterface m :: * -> *
  -- |A shader uniform. @'U' a@ doesn’t hold any value. It’s more like a mapping between the host
  -- code and the shader the uniform was retrieved from.
  type U m :: * -> *
  -- |Type-erased 'U'. Used to update uniforms with the 'updateUniforms' function.
  type U' m :: *
  -- |Create a new shader 'Program'.
  --
  -- That function takes a list of 'Stage's and a uniform interface builder function and yields a
  -- 'Program' and the interface.
  --
  -- The builder function takes a function you can use to retrieve uniforms. You can pass
  -- values of type 'UniformName' to identify the uniform you want to retrieve. If the uniform can’t
  -- be retrieved, throws 'InactiveUniform'.
  --
  -- In the end, you get the new 'Program' and a polymorphic value you can choose the type of in
  -- the function you pass as argument. You can use that value to gather uniforms for instance.
  createProgram :: (HasProgramError e,MonadError e m)
                => [Stage m]
                -> ((forall a. UniformName a -> UniformInterface m (U m a)) -> UniformInterface m i)
                -> m (Program m i)
  -- |Update uniforms in a 'Program'. That function enables you to update only the uniforms you want
  -- and not necessarily the whole.
  --
  -- If you want to update several uniforms (not only one), you can use the 'Semigroup' instance
  -- (use '(<>)' or 'sconcat' for instance).
  updateUniforms :: (Semigroup (U' m)) => Program m a -> (a -> U' m) -> m ()
  -- |All possible values that can be sent to shaders.
  type Uniform m :: * -> Constraint
  -- |That function ensures you implement all the required instances to be able to use uniforms in
  -- your code. That function is a no-op, you shouldn’t try to use it nor implement it (its default
  -- definition is @pure ()@).
  uniformInstances :: ( Uniform m Int32
                      , Uniform m (Int32,Int32)
                      , Uniform m (Int32,Int32,Int32)
                      , Uniform m (Int32,Int32,Int32,Int32)
                      , Uniform m (V2 Int32)
                      , Uniform m (V3 Int32)
                      , Uniform m (V4 Int32)
                      , Uniform m [Int32]
                      , Uniform m [(Int32,Int32)]
                      , Uniform m [(Int32,Int32,Int32)]
                      , Uniform m [(Int32,Int32,Int32,Int32)]
                      , Uniform m [(V2 Int32)]
                      , Uniform m [(V3 Int32)]
                      , Uniform m [(V4 Int32)]
                      , Uniform m Word32
                      , Uniform m (Word32,Word32)
                      , Uniform m (Word32,Word32,Word32)
                      , Uniform m (Word32,Word32,Word32,Word32)
                      , Uniform m (V2 Word32)
                      , Uniform m (V3 Word32)
                      , Uniform m (V4 Word32)
                      , Uniform m [Word32]
                      , Uniform m [(Word32,Word32)]
                      , Uniform m [(Word32,Word32,Word32)]
                      , Uniform m [(Word32,Word32,Word32,Word32)]
                      , Uniform m [(V2 Word32)]
                      , Uniform m [(V3 Word32)]
                      , Uniform m [(V4 Word32)]
                      , Uniform m Float
                      , Uniform m (Float,Float)
                      , Uniform m (Float,Float,Float)
                      , Uniform m (Float,Float,Float,Float)
                      , Uniform m (V2 Float)
                      , Uniform m (V3 Float)
                      , Uniform m (V4 Float)
                      , Uniform m [Float]
                      , Uniform m [(Float,Float)]
                      , Uniform m [(Float,Float,Float)]
                      , Uniform m [(Float,Float,Float,Float)]
                      , Uniform m [(V2 Float)]
                      , Uniform m [(V3 Float)]
                      , Uniform m [(V4 Float)]
                      , Uniform m (M44 Float)
                      , Uniform m [M44 Float]
                      )
                   => m ()
  uniformInstances = pure ()