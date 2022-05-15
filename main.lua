-- TODO(alec): Add voice lines from our favourite Brisbane Vice heroes
local dramaticMusicPath = "Interface\\Addons\\PI-Power\\dramatic.mp3"

-- Register the main frame
local frame = CreateFrame("Frame", "PIPowerFrame", UIParent);
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

-- 
-- Event handlers
-- https://wowwiki-archive.fandom.com/wiki/Events_A-Z_(full_list)
-- 

local function HandleUpdateShapeShiftForm()
-- TODO(alec): Check if druid form and make an Oscar meow if in cat form
    print("mreow")
end

local function HandleAchievementEarned()
    print("Greats!!")
end

local function HandleScreenshotSucceeded()
    print("Screenshot - breeheehee")
end

local function GetClassicTalentTree()
    -- Go through all talent trees for your class and see which one
    -- you've spent the most points in
    -- https://wowpedia.fandom.com/wiki/API_GetTalentInfo/Classic
    for i = 1, GetNumTalentTabs() do
	    for j = 1, GetNumTalents(i) do
		    local name, iconTexture, tier, column, rank, maxRank, isExceptional = GetTalentInfo(i, j)
            print(rank, "/", maxRank)
	    end
    end
end

end

local function HandlePlayerDead()
    -- Tom's idea, having different voice lines dependent on your spec
    -- tank dies: ???
    -- DPS dies: ???
    -- healer dies: man, this healer is dogshit

    -- RETAIL
    local currentSpecIndex = GetSpecialization()
    local role = GetSpecializationRole(currentSpecIndex)
    if isInInstance and role == "HEALER" then
        print("Man, this healer is dogshit")
    elseif isInInstance and role == "TANK" then
        print("this tank meng")
    elseif isInInstance and role == "DAMAGER" them
        print("this dps meng") 
    end

    -- CLASSIC
    local talentTabCount = GetNumTalentTabs()
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


local shouldWarn = false
local function HandleEvent (self, event, unit, spellName)
    if event == "PLAYER_REGEN_DISABLED" then
        shouldWarn = true
    elseif event == "PLAYER_REGEN_ENABLED" then
        shouldWarn = false
        ShowText("")
    end
end

frame:RegisterEvent("UNIT_AURA")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:SetScript("OnEvent", HandleEvent)
frame:Show()


print(string.format("Welcome %s hehehehehhehe", UnitName("player")))
GetClassicTalentTree()