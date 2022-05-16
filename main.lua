-- TODO(alec): Add voice lines from our favourite Brisbane Vice heroes
local dramaticMusicPath = "Interface\\Addons\\BrisbaneViceWarnings\\dramatic.mp3"

-- Register the main frame
local frame = CreateFrame("Frame", "BrisbaneViceWarningsFrame", UIParent);
frame:SetFrameStrata("BACKGROUND")
frame:SetAllPoints(true)

-- Register where text appears
local frameText = frame:CreateFontString(nil, "ARTWORK")
frameText:SetFont("Fonts\\MORPHEUS.ttf", 72, "OUTLINE")
frameText:SetPoint("CENTER", 0, 0)
frame.text = frameText

local function ShowText(message)
    frameText:SetText(message)
end

--
-- State
--

local isInInstance = false
local isPlayingMusic = false

--
-- Utils
--

local function GetClassicTalentTree()
    -- Go through all talent trees for your class and see which one
    -- you've spent the most points in
    -- https://wowpedia.fandom.com/wiki/API_GetTalentInfo/Classic
    --
    -- Returns the spec name and how many points you've put into it

    -- NOTE(alec): First column is unused
    local choiceCounts = { nil, 0, 0, 0 }

    local highestTalentName = nil
    local highestTalentCount = 0

    for i = 1, GetNumTalentTabs() do
        -- NOTE(alec): It appears this API differes a bit from retail
        local name, description, pointsSpent = GetTalentTabInfo(i)

        if not highestTalentName then
            highestTalentName = name
        end

        if pointsSpent > highestTalentCount then
            highestTalentCount = pointsSpent
            highestTalentName = name
        end
    end

    return highestTalentName, highestTalentCount
end

local tankSpecs = { "Protection", "Feral Combat" }
local healerSpecs = { "Holy", "Discipline", "Restoration" }

local function IsTank()
    local spec, points = GetClassicTalentTree()

    for i = 1, 2 do
        if tankSpecs[i] == spec then
            return true
        end
    end

    return false
end

local function IsHealer()
    local spec, points = GetClassicTalentTree()

    for i = 1, 3 do
        if healerSpecs[i] == spec then
            return true
        end
    end

    return false
end

local soundHandler = -1
local function HandleSoundStarted(_, newSoundHandler)
    soundHandler = newSoundHandler
    isPlayingMusic = true
end

local function HandleStopSound()
    StopSound(soundHandler, 800)
    isPlayingMusic = false
end

--
-- Event handlers
-- https://wowwiki-archive.fandom.com/wiki/Events_A-Z_(full_list)
--

local function HandleUpdateShapeShiftForm()
    -- TODO(alec): Check buffs for druid form and make an Oscar meow if in cat form
    print("mreow")
end

local function HandleAchievementEarned()
    print("Greats!!")
end

local function HandleScreenshotSucceeded()
    HandleSoundStarted(PlaySoundFile(dramaticMusicPath))
end

local function HandlePlayerDead()
    if IsHealer() then
        print("Man, this healer is dogshit")
    elseif IsTank() then
        print("this tank meng")
    else
        print("this dps meng")
    end
end

local function HandleRessurectRequest(playerName)
    print(string.format("Incoming res from %s?!?!!?!?"), playerName)
end

local function HandlePartyInviteRequest(leaderName)
    print(string.format("%s HATH INVITED THEE", leaderName))
end

local function HandlePartyConvertedToRaid()
    print("raid time breeheehee")
end

local function HandlePartyInviteCancel()
    print("Rejected breeheehee")
end

local function HandleRaidInstanceWelcome(instanceName, secondsUntilReset)
    isInInstance = true
    print(string.format("Zoned into %s", instanceName))
end

local function HandleReadyCheck(requestPlayerName, num)
    print("Ready check triggered")
end

local function HandleEvent(self, event, unit, spellName)
    if event == "SCREENSHOT_SUCCEEDED" then
        HandleScreenshotSucceeded()
    end
end

-- local shouldWarn = false
-- local function HandleEvent (self, event, unit, spellName)
--     if event == "PLAYER_REGEN_DISABLED" then
--         shouldWarn = true
--     elseif event == "PLAYER_REGEN_ENABLED" then
--         shouldWarn = false
--         ShowText("")
--     end
-- end

frame:RegisterEvent("SCREENSHOT_SUCCEEDED")
-- frame:RegisterEvent("UNIT_AURA")
-- frame:RegisterEvent("PLAYER_REGEN_DISABLED")
-- frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:SetScript("OnEvent", HandleEvent)
frame:Show()


print(string.format("Welcome %s hehehehehhehe", UnitName("player")))

if IsTank() then
    print("man this tank is dogshit")
end

if IsHealer() then
    print("man this healer is dogshit")
end
