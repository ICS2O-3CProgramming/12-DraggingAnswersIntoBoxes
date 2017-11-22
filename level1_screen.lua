-----------------------------------------------------------------------------------------
--
-- level1_screen.lua
-- Created by: Daniel
-- Date: Nov. 22nd, 2014
-- Description: This is the level 1 screen of the game.
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- INITIALIZATIONS
-----------------------------------------------------------------------------------------

-- Use Composer Library
local composer = require( "composer" )

-----------------------------------------------------------------------------------------

-- Use Widget Library
local widget = require( "widget" )

-----------------------------------------------------------------------------------------

-- Naming Scene
sceneName = "level1_screen"

-- Creating Scene Object
local scene = composer.newScene( sceneName )

-----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------

-- The background image and soccer ball for this scene
local bkg_image
local soccerball

--the text that displays the question
local questionText 

--the alternate numbers randomly generated
local alternateNumber1
local alternateNumber2  

-- boolean variables telling me which answer box was touched
local answerboxAlreadyTouched
local alternateAnswerBox1AlreadyTouched
local alternateAnswerBox2AlreadyTouched

--create answerbox alternate answers and the boxes to show them
local answerbox
local alternateAnswerBox1
local alternateAnswerBox2

-- the black box where the user will drag the answer
local userAnswerBoxPlaceholder

-- Variables containing the user answer and the actual answer
local answer = 0
local userAnswer = 0

local numberOfLevelQuestions = 0

-- displays the answer and whether or not the answer was correct
local answerText

-----------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
-----------------------------------------------------------------------------------------

        -- Creating Transitioning Function back to main menu
local function YouLoseTransition( )
    audio.stop()
    composer.removeScene( "you_lose")
    composer.gotoScene( "you_lose", {effect = "fade", time = 500 })
end

local function YouWinTransitionLevel1( )
    audio.stop()
    composer.removeScene( "you_win" )
    composer.gotoScene("you_win", {effect = "fade", time = 500})
end

local function Level2Transition( )
    composer.removeScene( "level2_screen" ) 
    composer.gotoScene("level2_screen", {effect = "fade", time = 500})
end


local function ResetSoccerBall()
    soccerball.isVisible = false
    soccerball.x = display.contentWidth*0.385
    soccerball.y = display.contentHeight * 12/20
end

local function ResetSoccerBallDelay()
    timer.performWithDelay(200,ResetSoccerBall )
end
------------------------------------------------------------------------------


local function DisplayQuestion()
    local randomNumber1
    local randomNumber2

    --set random numbers
    randomNumber1 = math.random(1, 10)
    randomNumber2 = math.random(1, 10)

    --calculate answer
    answer = randomNumber1 + randomNumber2

    --changing the answerText
    answerText.text = "Answer: " .. answer

    --change question text in relation to answer
    questionText.text = randomNumber1 .. " + " .. randomNumber2 .. " = " 

    end

local function DisplayAnswers()
        local alternateNumber1
        local alternateNumber2     
        
        --make sure boxes are not clicked at the beginning
        answerboxAlreadyTouched = false
        alternateAnswerBox1AlreadyTouched = false
        alternateAnswerBox2AlreadyTouched = false

        --set response text to nothing
        responseText.text = ""         

        --make a different answer to the correct answer.
        alternateNumber1 = answer + math.random(3, 5)
        alternateAnswerBox1.text = alternateNumber1

        alternateNumber2 = answer - math.random(1, 2)
        --set random number to alternate option
        alternateAnswerBox2.text = alternateNumber2

        
        answerbox.text = answer
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
--ROMDOMLY SELECT ANSWER BOX POSITIONS
-----------------------------------------------------------------------------------------
    alternateAnswerBox1.x = display.contentWidth * 0.9
    alternateAnswerBox2.x = display.contentWidth * 0.9
    answerbox.x = display.contentWidth * 0.9

    answerbox.y = math.random(1,3)

    -------------------------
    --situation 1
    if (answerbox.y == 1) then
        answerbox.y = display.contentHeight * 0.4

        --alternateAnswerBox2
        alternateAnswerBox2.y = display.contentHeight * 0.70

        --alternateAnswerBox1
        alternateAnswerBox1.y = display.contentHeight * 0.55

        ---------------------------------------------------------
        --remembering their positions
        alternateAnswerBox1PreviousY = alternateAnswerBox1.y
        alternateAnswerBox2PreviousY = alternateAnswerBox2.y
        answerboxPreviousY = answerbox.y 

    --situation 2
    elseif (answerbox.y == 2) then

        answerbox.y = display.contentHeight * 0.55
        
        --alternateAnswerBox2
        alternateAnswerBox2.y = display.contentHeight * 0.7

        --alternateAnswerBox1
        alternateAnswerBox1.y = display.contentHeight * 0.40


        alternateAnswerBox1PreviousY = alternateAnswerBox1.y
        alternateAnswerBox2PreviousY = alternateAnswerBox2.y
        answerboxPreviousY = answerbox.y 

    --situation 3
     elseif (answerbox.y == 3) then
        answerbox.y = display.contentHeight * 0.70

        --alternateAnswerBox2
        alternateAnswerBox2.y = display.contentHeight * 0.55

        --alternateAnswerBox1
        alternateAnswerBox1.y = display.contentHeight * 0.4

        alternateAnswerBox1PreviousY = alternateAnswerBox1.y
        alternateAnswerBox2PreviousY = alternateAnswerBox2.y
        answerboxPreviousY = answerbox.y 

    end
    
end


local function TouchListenerAnswerbox(touch)
    --only work if none of the other boxes have been touched
        if (alternateAnswerBox1AlreadyTouched == false and alternateAnswerBox2AlreadyTouched == false) then

            if touch.phase == "began" then
                --let other boxes know it has been clicked
                answerboxAlreadyTouched = true

            elseif touch.phase == "moved" then
                --dragging function
                answerbox.x = touch.x
                answerbox.y = touch.y
            elseif touch.phase == "ended" then
                answerboxAlreadyTouched = false

                -- if the box is in the userAnswerBox Placeholder  go to center of placeholder
                if (((userAnswerBoxPlaceholder.x - userAnswerBoxPlaceholder.width/2) < answerbox.x ) and
                    ((userAnswerBoxPlaceholder.x + userAnswerBoxPlaceholder.width/2) > answerbox.x ) and 
                    ((userAnswerBoxPlaceholder.y - userAnswerBoxPlaceholder.height/2) < answerbox.y ) and 
                    ((userAnswerBoxPlaceholder.y + userAnswerBoxPlaceholder.height/2) > answerbox.y ) ) then

                    answerbox.x = display.contentWidth * 0.6
                    answerbox.y = display.contentHeight * 0.9
                    userAnswer = answer

                     UserAnswerInput()

                --else make box go back to where it was
                else
                    answerbox.x = display.contentWidth * 0.9
                    answerbox.y = answerboxPreviousY
                end
            end
        end                
end -- end of TouchListenerAnswerbox(touch)

local function TouchListenerAnswerBox1(touch)
    --only work if none of the other boxes have been touched
        if (alternateAnswerBox2AlreadyTouched == false and answerboxAlreadyTouched == false) then

            if touch.phase == "began" then
                --let other boxes know it has been clicked
               alternateAnswerBox1AlreadyTouched = true
            
             elseif touch.phase == "moved" then
                --dragging function
               alternateAnswerBox1.x = touch.x
               alternateAnswerBox1.y = touch.y

             elseif touch.phase == "ended" then
                alternateAnswerBox1AlreadyTouched = false
                -- if the box is in the userAnswerBox Placeholder  go to center of placeholder
                if (((userAnswerBoxPlaceholder.x - userAnswerBoxPlaceholder.width/2) < alternateAnswerBox1.x ) and 
                    ((userAnswerBoxPlaceholder.x + userAnswerBoxPlaceholder.width/2) > alternateAnswerBox1.x ) and 
                    ((userAnswerBoxPlaceholder.y - userAnswerBoxPlaceholder.height/2) < alternateAnswerBox1.y ) and 
                    ((userAnswerBoxPlaceholder.y + userAnswerBoxPlaceholder.height/2) > alternateAnswerBox1.y ) ) then

                    alternateAnswerBox1.x = display.contentWidth * 0.6
                    alternateAnswerBox1.y = display.contentHeight * 0.9
                    userAnswer = alternateNumber1

                    UserAnswerInput()

                --else make box go back to where it was
                else
                alternateAnswerBox1.x = display.contentWidth * 0.9
                alternateAnswerBox1.y = alternateAnswerBox1PreviousY
                end
            end
        end

end -- end of TouchListenerAnswerBox1(touch)

local function TouchListenerAnswerBox2(touch)
    --only work if none of the other boxes have been touched
        if (alternateAnswerBox1AlreadyTouched == false and answerboxAlreadyTouched == false) then

            if touch.phase == "began" then
                --let other boxes know it has been clicked
               alternateAnswerBox2AlreadyTouched = true
            
             elseif touch.phase == "moved" then
                --dragging function
               alternateAnswerBox2.x = touch.x
               alternateAnswerBox2.y = touch.y

             elseif touch.phase == "ended" then
                alternateAnswerBox2AlreadyTouched = false

                -- if the box is in the userAnswerBox Placeholder  go to center of placeholder
                if (((userAnswerBoxPlaceholder.x - userAnswerBoxPlaceholder.width/2) < alternateAnswerBox2.x ) and 
                    ((userAnswerBoxPlaceholder.x + userAnswerBoxPlaceholder.width/2) > alternateAnswerBox2.x ) and 
                    ((userAnswerBoxPlaceholder.y - userAnswerBoxPlaceholder.height/2) < alternateAnswerBox2.y ) and 
                    ((userAnswerBoxPlaceholder.y + userAnswerBoxPlaceholder.height/2) > alternateAnswerBox2.y ) ) then

                    alternateAnswerBox2.x = display.contentWidth * 0.6
                    alternateAnswerBox2.y = display.contentHeight * 0.9
                    userAnswer = alternateNumber2

                    UserAnswerInput()

                --else make box go back to where it was
                else
                alternateAnswerBox2.x = display.contentWidth * 0.9
                alternateAnswerBox2.y = alternateAnswerBox2PreviousY
                end
            end
        end

end -- end of TouchListenerAnswerBox2(touch)
    
  

local function AddAnswerBoxEventListeners()
    answerbox:addEventListener("touch", TouchListenerAnswerbox)
    alternateAnswerBox1:addEventListener("touch", TouchListenerAnswerBox1)
    alternateAnswerBox2:addEventListener("touch", TouchListenerAnswerBox2)

end -- end of AddAnswerBoxEventListeners()

local function RemoveAnswerBoxEventListeners()
    answerbox:removeEventListener("touch", TouchListenerAnswerbox)
    alternateAnswerBox1:removeEventListener("touch", TouchListenerAnswerBox1)
    alternateAnswerBox2:removeEventListener("touch", TouchListenerAnswerBox2)

end -- end of AddAnswerBoxEventListeners()


local function LevelStart()
    DisplayQuestion()
    DisplayAnswers()             
    AddAnswerBoxEventListeners()   
                
end


local function LevelStartDelay()
    timer.performWithDelay(1600, LevelStart)
end 

local function RestartLevel1()
    LevelStart()
end

-----------------------------------------------------------------------------------------
-- GLOBAL FUNCTIONS
-----------------------------------------------------------------------------------------


function UserAnswerInput()
    local animationNumber
    animationNumber = math.random(1,3)
    RemoveAnswerBoxEventListeners()

    numberOfLevelQuestions = numberOfLevelQuestions + 1
        
    ----------------------------------------------------------------------------------
    --disable buttons
    ----------------------------------------------------------------------------------

    answerboxAlreadyTouched = true
    alternateAnswerBox1AlreadyTouched = true
    alternateAnswerBox2AlreadyTouched = true

    --Change the response text
    responseText.text = ""
        
        -- if the user gets the right answer, tell them so
        if (userAnswer == answer) then
                        
            local correctSound = audio.loadSound( "Sounds/Correct.wav" )

            audio.play(correctSound)

            -- otherwise, tell them they got the wrong answer and decrease a life
        else            
                   
            userLives = userLives - 1  
                                 
        end

        --if player loses all lives then go to the you lose screen
        if (userLives == 0) then

            YouLoseTransition()

            --if the player completes 2 questions then go to the you win screen
        elseif (numberOfLevelQuestions == 2) then

            YouWinTransitionLevel1()
        else
            -- restart the level with a time delay
            LevelStartDelay()
        end 
end

-----------------------------------------------------------------------------------------
-- GLOBAL SCENE FUNCTIONS
-----------------------------------------------------------------------------------------

-- The function called when the screen doesn't exist
function scene:create( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    ----------------------------------------------------------------------------------
    --Inserting backgroud image and lives
    ----------------------------------------------------------------------------------

    -- Insert the background image
    bkg_image = display.newImageRect("Images/Game Screen.png", 2048, 1536)
    bkg_image.anchorX = 0
    bkg_image.anchorY = 0
    bkg_image.width = display.contentWidth
    bkg_image.height = display.contentHeight

    --the text that displays the question
    questionText = display.newText( "" , 0, 0, nil, 100)

    --initiate variables and the question text
    questionText.x = display.contentWidth * 0.3
    questionText.y = display.contentHeight * 0.9

    -- create the soccer ball and place it on the scene
    soccerball = display.newImageRect("Images/soccerball.png", 60, 60, 0, 0)
    soccerball.x = display.contentWidth*0.385
    soccerball.y = display.contentHeight * 12/20

    answerText = display.newText("", 0, 0, nil, 60)
    answerText.x = display.contentWidth * 0.2
    answerText.y = display.contentHeight * 0.2
    answerText.alpha = 0

    --Gives feedback to the user on thedir answer
    responseText = display.newText ("", 0, 0, nil, 100)
    responseText.x = display.contentWidth * 0.2
    responseText.y = display.contentHeight * 0.4
    responseText.rotation = -20
    responseText:setFillColor(176/256, 23/256, 15/256)

    -- boolean variables stating whether or not the answer was touched
    answerboxAlreadyTouched = false
    alternateAnswerBox1AlreadyTouched = false
    alternateAnswerBox2AlreadyTouched = false

    --create answerbox alternate answers and the boxes to show them
    answerbox = display.newText("", display.contentWidth * 0.9, 0, nil, 100)
    alternateAnswerBox1 = display.newText("", 0, 0, nil, 100)
    alternateAnswerBox2 = display.newText("", 0, 0, nil, 100)

    -- the black box where the user will drag the answer
    userAnswerBoxPlaceholder = display.newImageRect("Images/userAnswerBoxPlaceholder.png",  130, 130, 0, 0)
    userAnswerBoxPlaceholder.x = display.contentWidth * 0.6
    userAnswerBoxPlaceholder.y = display.contentHeight * 0.9

    ----------------------------------------------------------------------------------
    --adding objects to the scene group
    ----------------------------------------------------------------------------------

    sceneGroup:insert( bkg_image ) 
    sceneGroup:insert( questionText ) 
    sceneGroup:insert( userAnswerBoxPlaceholder )
    sceneGroup:insert( answerbox )
    sceneGroup:insert( alternateAnswerBox1 )
    sceneGroup:insert( alternateAnswerBox2 )
    sceneGroup:insert( answerText )
    sceneGroup:insert( soccerball )

end --function scene:create( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to appear on screen
function scene:show( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view
    local phase = event.phase

    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then

        -- Called when the scene is still off screen (but is about to come on screen).    

    elseif ( phase == "did" ) then

        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        RestartLevel1()

    end

end --function scene:show( event )

-----------------------------------------------------------------------------------------

-- Custom function for resuming the game (from pause state)
function scene:resumeGame()
   composer.hideOverlay( "fade", 400)
end

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to leave the screen
function scene:hide( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view
    local phase = event.phase

    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
        

    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end

end --function scene:hide( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to be destroyed
function scene:destroy( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------


    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end

-----------------------------------------------------------------------------------------
-- EVENT LISTENERS
-----------------------------------------------------------------------------------------

-- Adding Event Listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene