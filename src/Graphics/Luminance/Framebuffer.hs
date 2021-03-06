-----------------------------------------------------------------------------
-- |
-- Copyright   : (C) 2015, 2016 Dimitri Sabadie
-- License     : BSD3
--
-- Maintainer  : Dimitri Sabadie <dimitri.sabadie@gmail.com>
-- Stability   : experimental
-- Portability : portable
-----------------------------------------------------------------------------

module Graphics.Luminance.Framebuffer (
    -- * Framebuffer creation
    Framebuffer
  , ColorFramebuffer
  , DepthFramebuffer
  , framebufferID
  , framebufferOutput
  , createFramebuffer
    -- * Framebuffer attachments
  , FramebufferColorAttachment
  , FramebufferDepthAttachment
    -- * Framebuffer access
  , FramebufferColorRW
  , FramebufferTarget
    -- * Framebuffer outputs
  , TexturizeFormat
  , Output(..)
    -- * Blitting
  , FramebufferBlitMask(..)
    -- * Special framebuffers
  , defaultFramebuffer
    -- * Special operations on framebuffers
  , framebufferBlit
    -- * Framebuffer errors
  , FramebufferError(..)
  , HasFramebufferError(..)
  ) where

import Graphics.Luminance.Core.Framebuffer
