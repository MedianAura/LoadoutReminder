LoadoutReminderAddonName, LoadoutReminder = ...

LoadoutReminder.NEWS = {}

function LoadoutReminder.NEWS:Init()
    -- create news frame
    local sizeX = 400
    local sizeY = 100

    local newsFrame = LoadoutReminder.GGUI.Frame({
        parent=UIParent, anchorParent=UIParent,
        anchorA="TOP", anchorB="TOP", sizeX=sizeX, sizeY=sizeY,
        backdropOptions=LoadoutReminder.CONST.DEFAULT_BACKDROP_OPTIONS,
        frameConfigTable=LoadoutReminderGGUIConfig,
        frameTable=LoadoutReminder.MAIN.FRAMES, 
        frameID=LoadoutReminder.CONST.FRAMES.NEWS,
        title=LoadoutReminder.GUTIL:ColorizeText("LoadoutReminder " .. C_AddOns.GetAddOnMetadata(LoadoutReminderAddonName, "Version"), 
            LoadoutReminder.GUTIL.COLORS.BRIGHT_BLUE),
        collapseable=true,
        closeable=true,
        moveable=true,
    })

    newsFrame:Hide()

    newsFrame.content.info = LoadoutReminder.GGUI.Text({
        parent=newsFrame.content, anchorParent=newsFrame.content, offsetY=-10,
        text="", justifyOptions={type="H", align="LEFT"}
    })
end

function LoadoutReminder.NEWS:GET_NEWS()
    local d = LoadoutReminder.GUTIL:ColorizeText("-", LoadoutReminder.GUTIL.COLORS.GREEN)
    return string.format(
    [[
        %1$s Fixed an error when difficulty is not yet loaded
    ]], d)
end

function LoadoutReminder.NEWS:GetChecksum()
    local checksum = 0
    local newsString = LoadoutReminder.NEWS:GET_NEWS()
    local checkSumBitSize = 256

    -- Iterate through each character in the string
    for i = 1, #newsString do
        checksum = (checksum + string.byte(newsString, i)) % checkSumBitSize
    end

    return checksum
end

---@return string | nil newChecksum newChecksum when news should be shown, otherwise nil
function LoadoutReminder.NEWS:IsNewsUpdate()
    local newChecksum = LoadoutReminder.NEWS:GetChecksum()
    local oldChecksum = LoadoutReminderOptionsV2.newsChecksum
    if newChecksum ~= oldChecksum then
        return newChecksum
    end
    return nil
end

function LoadoutReminder.NEWS:ShowNews(force)
    local infoText = LoadoutReminder.NEWS:GET_NEWS()
    local newChecksum = LoadoutReminder.NEWS:IsNewsUpdate()
    if newChecksum == nil and (not force) then
       return 
    end

    LoadoutReminderOptionsV2.newsChecksum = newChecksum

    local newsFrame = LoadoutReminder.GGUI:GetFrame(LoadoutReminder.MAIN.FRAMES, LoadoutReminder.CONST.FRAMES.NEWS)
    -- resize
    newsFrame.content.info:SetText(infoText)
    newsFrame:Show()
end