-- Layout
local BUTTON_SIZE = 24
local BUTTON_PADDING = 2
local FRAME_PADDING = 4
local TEXT_SIZE = 15

-- Variables
SelectedChannel = "Party"
IsWindowShown = true

local summaryData = {
    -- Dusts
    { key = "Strange Dust", tooltip = "Strange Dust", value = 0, icon = "Interface\\Icons\\inv_enchant_duststrange" },
    { key = "Soul Dust", tooltip = "Soul Dust", value = 0, icon = "Interface\\Icons\\inv_enchant_dustsoul" },
    { key = "Vision Dust", tooltip = "Vision Dust", value = 0, icon = "Interface\\Icons\\inv_enchant_dustvision" },
    { key = "Dream Dust", tooltip = "Dream Dust", value = 0, icon = "Interface\\Icons\\inv_enchant_dustdream" },
    { key = "Illusion Dust", tooltip = "Illusion Dust", value = 0, icon = "Interface\\Icons\\inv_enchant_dustillusion" },

    -- Essences
    { key = "Lesser Magic Essence", tooltip = "Lesser Magic Essence", value = 0, icon = "Interface\\Icons\\inv_enchant_essencemagicsmall" },
    { key = "Greater Magic Essence", tooltip = "Greater Magic Essence", value = 0, icon = "Interface\\Icons\\inv_enchant_essencemagiclarge" },
    { key = "Lesser Astral Essence", tooltip = "Lesser Astral Essence", value = 0, icon = "Interface\\Icons\\inv_enchant_essenceastralsmall" },
    { key = "Greater Astral Essence", tooltip = "Greater Astral Essence", value = 0, icon = "Interface\\Icons\\inv_enchant_essenceastrallarge" },
    { key = "Lesser Mystic Essence", tooltip = "Lesser Mystic Essence", value = 0, icon = "Interface\\Icons\\inv_enchant_essencemysticalsmall" },
    { key = "Greater Mystic Essence", tooltip = "Greater Mystic Essence", value = 0, icon = "Interface\\Icons\\inv_enchant_essencemysticallarge" },
    { key = "Lesser Nether Essence", tooltip = "Lesser Nether Essence", value = 0, icon = "Interface\\Icons\\inv_enchant_essencenethersmall" },
    { key = "Greater Nether Essence", tooltip = "Greater Nether Essence", value = 0, icon = "Interface\\Icons\\inv_enchant_essencenetherlarge" },
    { key = "Lesser Eternal Essence", tooltip = "Lesser Eternal Essence", value = 0, icon = "Interface\\Icons\\inv_enchant_essenceeternalsmall" },
    { key = "Greater Eternal Essence", tooltip = "Greater Eternal Essence", value = 0, icon = "Interface\\Icons\\inv_enchant_essenceeternallarge" },

    -- Shards
    { key = "Small Glimmering Shard", tooltip = "Small Glimmering Shard", value = 0, icon = "Interface\\Icons\\inv_enchant_shardglimmeringsmall" },
    { key = "Large Glimmering Shard", tooltip = "Large Glimmering Shard", value = 0, icon = "Interface\\Icons\\inv_enchant_shardglimmeringlarge" },
    { key = "Small Glowing Shard", tooltip = "Small Glowing Shard", value = 0, icon = "Interface\\Icons\\inv_enchant_shardglowingsmall" },
    { key = "Large Glowing Shard", tooltip = "Large Glowing Shard", value = 0, icon = "Interface\\Icons\\inv_enchant_shardglowinglarge" },
    { key = "Small Radiant Shard", tooltip = "Small Radiant Shard", value = 0, icon = "Interface\\Icons\\inv_enchant_shardradientsmall" },
    { key = "Large Radiant Shard", tooltip = "Large Radiant Shard", value = 0, icon = "Interface\\Icons\\inv_enchant_shardradientlarge" },
    { key = "Small Brilliant Shard", tooltip = "Small Brilliant Shard", value = 0, icon = "Interface\\Icons\\inv_enchant_shardbrilliantsmall" },
    { key = "Large Brilliant Shard", tooltip = "Large Brilliant Shard", value = 0, icon = "Interface\\Icons\\inv_enchant_shardbrilliantlarge" },

    -- Crystals
    { key = "Nexus Crystal", tooltip = "Nexus Crystal", value = 0, icon = "Interface\\Icons\\inv_enchant_shardnexuslarge" },
}

local summaryLookup = {}
    for _, entry in ipairs(summaryData) do
        summaryLookup[entry.key] = entry
    end

-- Functions
local function InitializeSavedData()
    if not DisenchantingCounterDB then
        DisenchantingCounterDB = {}
    end

    if not DisenchantingCounterDB.selectedChannel then
        DisenchantingCounterDB.selectedChannel = "Party"
    else
        SelectedChannel = DisenchantingCounterDB.selectedChannel
    end

    if DisenchantingCounterDB.isWindowShown == nil then
        DisenchantingCounterDB.isWindowShown = true
    end
    IsWindowShown = DisenchantingCounterDB.isWindowShown

    if not DisenchantingCounterDB.data then
        DisenchantingCounterDB.data = {
            ["Strange Dust"] = 0,
            ["Soul Dust"] = 0,
            ["Vision Dust"] = 0,
            ["Dream Dust"] = 0,
            ["Illusion Dust"] = 0,
        
            ["Lesser Magic Essence"] = 0,
            ["Greater Magic Essence"] = 0,
            ["Lesser Astral Essence"] = 0,
            ["Greater Astral Essence"] = 0,
            ["Lesser Mystic Essence"] = 0,
            ["Greater Mystic Essence"] = 0,
            ["Lesser Nether Essence"] = 0,
            ["Greater Nether Essence"] = 0,
            ["Lesser Eternal Essence"] = 0,
            ["Greater Eternal Essence"] = 0,
        
            ["Small Glimmering Shard"] = 0,
            ["Large Glimmering Shard"] = 0,
            ["Small Glowing Shard"] = 0,
            ["Large Glowing Shard"] = 0,
            ["Small Radiant Shard"] = 0,
            ["Large Radiant Shard"] = 0,
            ["Small Brilliant Shard"] = 0,
            ["Large Brilliant Shard"] = 0,
        
            ["Nexus Crystal"] = 0,
        }
    end

    for _, entry in ipairs(summaryData) do
        entry.value = DisenchantingCounterDB.data[entry.key]

        if entry.row and entry.row.valueText then
            local newValue = DisenchantingCounterDB.data[entry.key] or 0
            entry.row.valueText:SetText(tostring(newValue))
        end
    end
end

local function AddTooltip(frame, text)
    frame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(text, 1, 1, 1)
    end)
    frame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

function IncrementSummary(key, amount)
    local data = summaryLookup[key]
    local current = DisenchantingCounterDB.data[key] or 0
    local newValue = current + amount

    data.row.valueText:SetText(tostring(newValue))
    data.value = newValue
    DisenchantingCounterDB.data[key] = newValue
end

local function ResetSummary()
    for _, entry in ipairs(summaryData) do
        entry.value = 0
        entry.row.valueText:SetText("0")
        summaryLookup[entry.key].value = 0
        DisenchantingCounterDB.data[entry.key] = 0
    end
    print("DisenchantingCounter: Counter has been reset")
end

function SendSummaryMessage()
    local totalCount = 0
    local lines = {}

    for _, entry in pairs(summaryData) do
        local count = tonumber(entry.value) or 0
        if count > 0 then
            totalCount = totalCount + count
            table.insert(lines, string.format("%s: %d", entry.key, count))
        end
    end

    if totalCount == 0 then
        print("DisenchantingCounter: Nothing to send")
        return
    end

    local channel
    if SelectedChannel == "Party" then
        channel = "PARTY"
    elseif SelectedChannel == "Raid" then
        channel = "RAID"
    elseif SelectedChannel == "Say" then
        channel = "SAY"
    end

    SendChatMessage("DisenchantingCounter Summary:", channel)

    for _, line in ipairs(lines) do
        SendChatMessage(line, channel)
    end
end

-- Frames
-- Main frame
local mainFrame = CreateFrame("Frame", "MyReloadMainFrame", UIParent, "InsetFrameTemplate3")
mainFrame:SetMovable(true)
mainFrame:EnableMouse(true)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)
mainFrame:SetPoint("CENTER")

local titleText = mainFrame:CreateFontString(nil, "OVERLAY")
titleText:SetFontObject("GameFontNormalSmall")
titleText:SetText("Disenchanting")
titleText:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 4, -5)

mainFrame:EnableMouse(true)
mainFrame:SetMovable(true)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:SetScript("OnDragStart", function(self)
	self:StartMoving()
end)
mainFrame:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
end)

-- Settings frame
local settingsFrame = CreateFrame("Frame", "DisenchantCounterSettingsFrame", UIParent, "BackdropTemplate")
settingsFrame:SetPoint("CENTER")
settingsFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
settingsFrame:SetBackdropColor(0, 0, 0, 0.9)
settingsFrame:SetFrameStrata("DIALOG")
settingsFrame:Hide()

local closeButton = CreateFrame("Button", nil, settingsFrame, "UIPanelCloseButton")

local infoText = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
infoText:SetPoint("TOPLEFT", 15, -40)
infoText:SetJustifyH("LEFT")
infoText:SetText("To open or hide the DisenchantingCounter window, use:")

local infoCommandsText = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
infoCommandsText:SetPoint("TOPLEFT", infoText, "BOTTOMLEFT", 0, -5)
infoCommandsText:SetJustifyH("LEFT")
infoCommandsText:SetText("/disenchantingcounter or /dec")

-- -- Settings Frame - dropdown
local chatChannelLabel = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
chatChannelLabel:SetPoint("TOPLEFT", infoCommandsText, "BOTTOMLEFT", 0, -20)
chatChannelLabel:SetJustifyH("LEFT")
chatChannelLabel:SetText("Chat channel for summary:")

local chatChannels = { "Party", "Raid", "Say" }

local dropdown = CreateFrame("Frame", "MyAddonDropdown", settingsFrame, "UIDropDownMenuTemplate")
dropdown:SetPoint("TOPLEFT", chatChannelLabel, "BOTTOMLEFT", -15, -5)
UIDropDownMenu_SetWidth(dropdown, 100)
UIDropDownMenu_SetText(dropdown, SelectedChannel or "Party")

UIDropDownMenu_Initialize(dropdown, function(self, level)
    for _, channel in ipairs(chatChannels) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = channel
        info.checked = (channel == SelectedChannel)
        info.func = function()
            SelectedChannel = channel
            DisenchantingCounterDB.selectedChannel = channel
            UIDropDownMenu_SetText(dropdown, channel)
        end
        UIDropDownMenu_AddButton(info)
    end
end)

-- -- Settings Frame - dynamic window size
settingsFrame:Show()
local texts = { infoText, infoCommandsText, chatChannelLabel }

local maxWidth = 0
for _, fontString in ipairs(texts) do
    local w = fontString:GetStringWidth()
    if w > maxWidth then
        maxWidth = w
    end
end

local dropdownWidth = 180
if dropdown:GetWidth() and dropdown:GetWidth() > 0 then
    dropdownWidth = dropdown:GetWidth()
end

if dropdownWidth > maxWidth then
    maxWidth = dropdownWidth
end

local paddingX = 40
local totalWidth = maxWidth + paddingX

local spacing = {
    40, -- top padding
    infoText:GetStringHeight(),
    5,
    infoCommandsText:GetStringHeight(),
    20,
    chatChannelLabel:GetStringHeight(),
    5,
    26, -- dropdown approx height
    15 -- bottom padding
}
local totalHeight = 0
for _, v in ipairs(spacing) do
    totalHeight = totalHeight + v
end

settingsFrame:SetSize(totalWidth, totalHeight)
closeButton:SetPoint("TOPRIGHT", -5, -5)
settingsFrame:Hide()


-- Confirm reset frame
local confirmResetFrame = CreateFrame("Frame", "MyAddonConfirmResetFrame", UIParent, "BasicFrameTemplateWithInset")
confirmResetFrame:SetPoint("CENTER")
confirmResetFrame:SetFrameStrata("DIALOG")
confirmResetFrame:Hide()

local confirmText = confirmResetFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
confirmText:SetPoint("TOP", 0, -30)
confirmText:SetText("Are you sure you want to reset counter?")

local yesBtn = CreateFrame("Button", nil, confirmResetFrame, "UIPanelButtonTemplate")
yesBtn:SetSize(80, 22)
yesBtn:SetText("Yes")

local cancelBtn = CreateFrame("Button", nil, confirmResetFrame, "UIPanelButtonTemplate")
cancelBtn:SetSize(80, 22)
cancelBtn:SetText("Cancel")

yesBtn:SetScript("OnClick", function()
    ResetSummary()
    confirmResetFrame:Hide()
end)

cancelBtn:SetScript("OnClick", function()
    confirmResetFrame:Hide()
end)

-- Confirm reset frame - dynamic window size
confirmResetFrame:Show()
local textWidth = confirmText:GetStringWidth()
local buttonsWidth = yesBtn:GetWidth() + cancelBtn:GetWidth() + 40 -- 40 = przerwa między przyciskami i marginesy

local paddingX = 40
local totalWidth = math.max(textWidth, buttonsWidth) + paddingX

yesBtn:SetPoint("BOTTOMLEFT", 20, 15)
cancelBtn:SetPoint("BOTTOMRIGHT", -20, 15)

local totalHeight = 30 + confirmText:GetStringHeight() + 15 + yesBtn:GetHeight() + 20
confirmResetFrame:SetSize(totalWidth, totalHeight)
confirmResetFrame:Hide()


-- Reload button
local reloadBtn = CreateFrame("Button", nil, mainFrame)
reloadBtn:SetSize(BUTTON_SIZE, BUTTON_SIZE)
reloadBtn.icon = reloadBtn:CreateTexture(nil, "ARTWORK")
reloadBtn.icon:SetAllPoints()
reloadBtn.icon:SetTexture("Interface\\Icons\\Spell_holy_borrowedtime")
reloadBtn:SetScript("OnClick", function()
    confirmResetFrame:Show()
end)
reloadBtn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")

-- Summary button
local summaryBtn = CreateFrame("Button", nil, mainFrame)
summaryBtn:SetSize(BUTTON_SIZE, BUTTON_SIZE)
summaryBtn.icon = summaryBtn:CreateTexture(nil, "ARTWORK")
summaryBtn.icon:SetAllPoints()
summaryBtn.icon:SetTexture("Interface\\Icons\\Inv_enchant_formulasuperior_01")
summaryBtn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")

-- Settings button
local settingsBtn = CreateFrame("Button", nil, mainFrame)
settingsBtn:SetSize(BUTTON_SIZE, BUTTON_SIZE)
settingsBtn.icon = settingsBtn:CreateTexture(nil, "ARTWORK")
settingsBtn.icon:SetAllPoints()
settingsBtn.icon:SetTexture("Interface\\Icons\\Trade_engineering")
settingsBtn:SetScript("OnClick", function()
    settingsFrame:Show()
end)
settingsBtn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")

reloadBtn:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", FRAME_PADDING, -FRAME_PADDING - TEXT_SIZE)
summaryBtn:SetPoint("LEFT", reloadBtn, "RIGHT", BUTTON_PADDING, 0)
settingsBtn:SetPoint("LEFT", summaryBtn, "RIGHT", BUTTON_PADDING, 0)

local mainFrameWidth = (BUTTON_SIZE * 3) + (BUTTON_PADDING * 2) + (FRAME_PADDING * 2)
local mainFrameHeight = BUTTON_SIZE + (FRAME_PADDING * 2) + TEXT_SIZE
mainFrame:SetSize(mainFrameWidth, mainFrameHeight)

AddTooltip(reloadBtn, "Reset disenchanting counter")
AddTooltip(summaryBtn, "Summary")
AddTooltip(settingsBtn, "Open Settings")

-- Summary frame
local summaryFrame = CreateFrame("Frame", nil, mainFrame, "InsetFrameTemplate")
summaryFrame:SetPoint("TOPLEFT", mainFrame, "BOTTOMLEFT", 0, 0)
summaryFrame:Hide()

local numColumns = 4
local cellWidth = 30
local cellHeight = 20
local spacingX = 10
local spacingY = 6

for i, entry in ipairs(summaryData) do
    local col = (i - 1) % numColumns
    local rowNum = math.floor((i - 1) / numColumns)

    local row = CreateFrame("Frame", nil, summaryFrame)
    row:SetSize(cellWidth, cellHeight)
    row:SetPoint(
        "TOPLEFT",
        summaryFrame,
        "TOPLEFT",
        10 + col * (cellWidth + spacingX),
        -10 - rowNum * (cellHeight + spacingY)
    )

    local iconFrame = CreateFrame("Button", nil, row)
    iconFrame:SetSize(16, 16)
    iconFrame:SetPoint("LEFT")

    local icon = iconFrame:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints()
    icon:SetTexture(entry.icon)
    AddTooltip(icon, entry.tooltip)

    local valueText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    valueText:SetText(tostring(entry.value))
    valueText:SetPoint("LEFT", icon, "RIGHT", 6, 0)

    row.valueText = valueText
    entry.row = row
end

local totalItems = #summaryData
local numRows = math.ceil(totalItems / numColumns)
local paddingX = 10 * 2
local paddingY = 10 * 2

local summaryFrameWidth = numColumns * cellWidth + (numColumns - 1) * spacingX + paddingX
local summaryFrameHeight = numRows * cellHeight + (numRows - 1) * spacingY + paddingY
summaryFrame:SetSize(summaryFrameWidth, summaryFrameHeight + 20)

-- Collapse summary button
local sendSummaryBtn = CreateFrame("Button", nil, summaryFrame, "UIPanelButtonTemplate")
sendSummaryBtn:SetSize(120, 20)
sendSummaryBtn:SetText("Send summary")
sendSummaryBtn:SetPoint("BOTTOM", summaryFrame, "BOTTOM", 0, 5)
sendSummaryBtn:SetScript("OnClick", function()
    SendSummaryMessage()
end)

summaryBtn:SetScript("OnClick", function()
    if summaryFrame:IsShown() then
		summaryFrame:Hide()
	else
		summaryFrame:Show()
	end
end)

-- Listeners
-- Disenchanting Listener
local disenchanting = false
local disenchantSpellId = 13262

local summaryLookupIfExiists = {}
for _, entry in ipairs(summaryData) do
    summaryLookupIfExiists[entry.key] = true
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
eventFrame:RegisterEvent("CHAT_MSG_LOOT")


eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unit, _, spellId = ...
        if unit == "player" and spellId == disenchantSpellId then
            disenchanting = true
        end

    elseif event == "CHAT_MSG_LOOT" and disenchanting then
        local msg = ...
        local itemLink, count = msg:match("You receive loot: (|c%x+|Hitem:.-|h%[.-%]|h|r)x(%d+)%.")

        if not itemLink then
            itemLink = msg:match("You receive loot: (|c%x+|Hitem:.-|h%[.-%]|h|r)%.")
            count = 1
        end
        count = tonumber(count) or 1

        if itemLink then
            local name = C_Item.GetItemInfo(itemLink)
            if name and summaryLookupIfExiists[name] then
                IncrementSummary(name, tonumber(count))
            end
        end

        disenchanting = false
    end
end)

-- Database Listener
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "DisenchantingCounter" then
        InitializeSavedData()
        UIDropDownMenu_SetText(dropdown, SelectedChannel)
        if IsWindowShown then
            mainFrame:Show()
        else
            mainFrame:Hide()
        end
    end
end)

-- Slash functions
SLASH_MYADDON1 = "/disenchantingcoutner"
SLASH_MYADDON2 = "/dec"
SlashCmdList["MYADDON"] = function()
    if mainFrame:IsShown() then
        IsWindowShown = false
        DisenchantingCounterDB.isWindowShown = false
		mainFrame:Hide()
	else
		mainFrame:Show()
        DisenchantingCounterDB.isWindowShown = true
        IsWindowShown = true
	end
end