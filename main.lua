-----------------------------------------------------------------------------------------
--
-- main.lua
-- Created by: Daniel Lopez-Carreon
-- Date: Nov. 22nd, 2014
-- Description: This calls the splash screen of the app to load itself.
-----------------------------------------------------------------------------------------

-- Hiding Status Bar
display.setStatusBar( display.HiddenStatusBar )

--setting lives for all scenes
userLives = 2

-----------------------------------------------------------------------------------------

-- Use composer library
local composer = require( "composer" )
-----------------------------------------------------------------------------------------
-- Go to the intro screen
composer.gotoScene( "level1_screen" )