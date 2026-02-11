local addonName, SDT = ...
local L = SDT.L
SDT.BarManager = {}

----------------------------------------------------
-- Create Data Bar
----------------------------------------------------
function SDT.BarManager:CreateDataBar(id, numSlots)
    local name = "SDT_Bar" .. id
    if not SDT.db.profile.bars[name] then
        SDT.db.profile.bars[name] = {
            numSlots = numSlots or 3,
            slots = {},
            bgOpacity = 50,
            borderName = "None",
            border = "None",
            width = 300,
            height = 22,
            name = name
        }
    end
    
    local saved = SDT.db.profile.bars[name]
    local bar = SDT.BarManager:CreateMovableFrame(name)
    SDT.bars[name] = bar

    bar:SetSize(300, 22)
    if saved.point then
        bar:SetPoint(saved.point.point, UIParent, saved.point.relativePoint, saved.point.x, saved.point.y)
    else
        bar:SetPoint("CENTER")
    end

    local scale = saved.scale or 100
    bar:SetScale(scale / 100)

    function bar:ApplyBackground()
        local hasBackground = saved.bgOpacity and saved.bgOpacity > 0
        local hasBorder = saved.borderName and saved.borderName ~= "None"

        if hasBackground or hasBorder then
            bar:SetBackdrop({
                bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                edgeFile = hasBorder and saved.border or nil,
                edgeSize = hasBorder and saved.borderSize or 0
            })
            local alpha = (saved.bgOpacity or 50) / 100
            bar:SetBackdropColor(0, 0, 0, alpha)
            if saved.borderColor then
                local color = saved.borderColor:gsub("#", "")
                local r = tonumber(color:sub(1, 2), 16) / 255
                local g = tonumber(color:sub(3, 4), 16) / 255
                local b = tonumber(color:sub(5, 6), 16) / 255
                bar:SetBackdropBorderColor(r, g, b, alpha)
            end
        else
            bar:SetBackdrop(nil)
        end
    end

    bar:ApplyBackground()
    self:RebuildSlots(bar)
    return bar
end

----------------------------------------------------
-- Create Bars from Profile
----------------------------------------------------
function SDT.BarManager:CreateFromProfile()
    for barName, barData in pairs(SDT.db.profile.bars) do
        local id = tonumber(barName:match("SDT_Bar(%d+)"))
        if id and id > 0 then
            self:CreateDataBar(id, barData.numSlots)
        end
    end
end

----------------------------------------------------
-- Create Movable Frame
----------------------------------------------------
function SDT.BarManager:CreateMovableFrame(name)
    local f = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetClampedToScreen(true)

    f:SetScript("OnDragStart", function(self)
        if not SDT.db.profile.locked then
            self:StartMoving()
        end
    end)

    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        self:SaveBarPosition(self)
    end)

    return f
end

----------------------------------------------------
-- Bar ID Helper
----------------------------------------------------
function SDT.BarManager:GetNextBarID()
    local n = 1
    while SDT.db.profile.bars["SDT_Bar" .. n] and SDT.db.profile.bars["SDT_Bar" .. n].name do
        n = n + 1
    end
    return n
end

----------------------------------------------------
-- Rebuild Slots
----------------------------------------------------
function SDT.BarManager:RebuildSlots(bar)
    if not bar then return end

    local barName = bar:GetName()
    local saved = SDT.db.profile.bars[barName]
    if not saved then return end

    local numSlots = saved.numSlots or 3
    local totalW = saved.width or 300
    local totalH = saved.height or 22
    local slotW = totalW / numSlots
    local slotH = totalH
    
    bar:SetSize(totalW, totalH)

    bar.slots = bar.slots or {}

    -- Hide/cleanup extra slots if we have more than needed
    for i = numSlots + 1, #bar.slots do
        local slot = bar.slots[i]
        if slot then
            if slot.moduleFrame then
                slot.moduleFrame:UnregisterAllEvents()
                slot.moduleFrame:SetScript("OnUpdate", nil)
                slot.moduleFrame:SetScript("OnEvent", nil)
                slot.moduleFrame:Hide()
                
                if SDT.UpdateTicker then
                    SDT.UpdateTicker:UnregisterPrefix(slot.module .. "_")
                end
            end
            slot:Hide()
        end
    end

    for i = 1, numSlots do
        local slot = bar.slots[i]
        
        -- Reuse existing slot frame if possible
        if not slot then
            local slotName = barName .. "_Slot" .. i
            slot = CreateFrame("Button", slotName, bar)
            slot.text = slot:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            slot.text:SetPoint("CENTER")
            
            -- Set up mouse events once
            slot:EnableMouse(true)
            slot:RegisterForClicks("AnyUp")
            slot:RegisterForDrag("LeftButton")
            
            bar.slots[i] = slot
        end
        
        -- Update slot properties
        slot.index = i
        slot:SetSize(slotW, slotH)
        slot:ClearAllPoints()
        slot:SetPoint("LEFT", bar, "LEFT", (i - 1) * slotW, 0)
        slot:Show()
        
        -- Read slot data
        local slotData = saved.slots[i]
        local assignedName, offsetX, offsetY
        
        if type(slotData) == "string" then
            assignedName = slotData
            offsetX, offsetY = 0, 0
        elseif type(slotData) == "table" then
            assignedName = slotData.module
            offsetX = slotData.offsetX or 0
            offsetY = slotData.offsetY or 0
        else
            assignedName = nil
            offsetX, offsetY = 0, 0
        end
        
        -- Only recreate module frame if the module changed
        if slot.module ~= assignedName then
            if slot.moduleFrame then
                slot.moduleFrame:UnregisterAllEvents()
                slot.moduleFrame:SetScript("OnUpdate", nil)
                slot.moduleFrame:SetScript("OnEvent", nil)
                slot.moduleFrame:Hide()
                
                if SDT.UpdateTicker then
                    SDT.UpdateTicker:UnregisterPrefix(slot.module .. "_")
                end
                slot.moduleFrame = nil
            end
            
            if assignedName == "(spacer)" then
                slot.module = "(spacer)"
                slot.text:SetText("")
            elseif assignedName and SDT.modules[assignedName] then
                slot.module = assignedName
                slot.moduleFrame = SDT.modules[assignedName].Create(slot)
            else
                slot.module = nil
                slot.text:SetText(assignedName or L["(empty)"])
            end
        end

        -- Apply frame strata
        if assignedName and assignedName ~= "(spacer)" and SDT.modules[assignedName] then
            local strata = SDT.ModuleRegistry:GetModuleFrameStrata(assignedName)
            
            -- Set strata on the slot itself (parent frame)
            slot:SetFrameStrata(strata)
            
            -- Set strata on the module frame if it exists
            if slot.moduleFrame then
                slot.moduleFrame:SetFrameStrata(strata)
            end
            
            -- Set strata on secure button if it exists
            if slot.secureButton then
                slot.secureButton:SetFrameStrata(strata)
            end
        end
        
        -- Apply offset
        if slot.text then
            local anchorPoint = SDT:GetModuleSetting(assignedName, "anchorPoint", "CENTER")
            slot.text:ClearAllPoints()
            slot.text:SetPoint(anchorPoint, slot, anchorPoint, offsetX, offsetY)
        end
        
        -- Set up event handlers (these need to capture current values)
        slot:SetScript("OnMouseUp", function(self, btn)
            if btn == "RightButton" and IsControlKeyDown() then
                SDT.BarManager:ShowSlotDropdown(self, bar)
            end
        end)
        
        slot:SetScript("OnDragStart", function(self)
            if not SDT.db.profile.locked then
                bar:StartMoving()
            end
        end)
        
        slot:SetScript("OnDragStop", function(self)
            bar:StopMovingOrSizing()
            SDT.BarManager:SaveBarPosition(bar)
        end)
    end

    SDT.FontManager:ApplyFont()
end

----------------------------------------------------
-- Rebuild All Slots
----------------------------------------------------
function SDT.BarManager:RebuildAllSlots()
    for _, bar in pairs(SDT.bars) do
        self:RebuildSlots(bar)
    end
end

----------------------------------------------------
-- Save Bar Position
----------------------------------------------------
function SDT.BarManager:SaveBarPosition(bar)
    local point, _, relativePoint, x, y = bar:GetPoint()
    local barName = bar:GetName()
    SDT.db.profile.bars[barName].point = {
        point = point,
        relativePoint = relativePoint,
        x = x,
        y = y
    }
end

----------------------------------------------------
-- Slot Selection Dropdown
----------------------------------------------------
function SDT.BarManager:ShowSlotDropdown(slot, bar)
    local maxVisibleItems = 20 -- Maximum items to show before scrolling
    local totalItems = 2 + #SDT.cache.moduleNames -- (empty) + (spacer) + modules
    
    if totalItems <= maxVisibleItems then
        -- Use normal context menu for small lists
        MenuUtil.CreateContextMenu(slot, function(owner, root)
            -- Empty option
            root:CreateButton(L["(empty)"], function()
                SDT.db.profile.bars[bar:GetName()].slots[slot.index] = nil
                self:RebuildSlots(bar)
            end)

            -- Spacer option
            root:CreateButton(L["(spacer)"], function()
                SDT.db.profile.bars[bar:GetName()].slots[slot.index] = "(spacer)"
                self:RebuildSlots(bar)
            end)

            -- Module options
            for _, moduleName in ipairs(SDT.cache.moduleNames) do
                root:CreateButton(moduleName, function()
                    SDT.db.profile.bars[bar:GetName()].slots[slot.index] = moduleName
                    self:RebuildSlots(bar)
                end)
            end
        end)
    else
        -- Close any existing custom dropdown
        if self.customDropdown then
            self.customDropdown:Hide()
            self.customDropdown = nil
        end
        
        -- Create custom scrollable dropdown
        local dropdown = CreateFrame("Frame", "SDT_CustomSlotDropdown", UIParent, "BackdropTemplate")
        self.customDropdown = dropdown
        
        local itemHeight = 18
        local visibleHeight = maxVisibleItems * itemHeight
        local dropdownWidth = 200
        local backdropInsets = 4 -- top (2) + bottom (2) insets from backdrop
        
        dropdown:SetSize(dropdownWidth, visibleHeight + backdropInsets)
        dropdown:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Buttons\\WHITE8X8",
            tile = false,
            edgeSize = 1,
            insets = { left = 1, right = 1, top = 1, bottom = 1 }
        })
        dropdown:SetBackdropColor(0.1, 0.1, 0.1, 0.95)
        dropdown:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
        dropdown:SetFrameStrata("FULLSCREEN_DIALOG")
        dropdown:SetClampedToScreen(true)
        
        -- Position at cursor
        local x, y = GetCursorPosition()
        local scale = UIParent:GetEffectiveScale()
        dropdown:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / scale, y / scale)
        
        -- Close on escape
        dropdown:SetScript("OnKeyDown", function(self, key)
            if key == "ESCAPE" then
                self:Hide()
            end
        end)
        dropdown:SetPropagateKeyboardInput(false)
        
        -- Create scroll frame
        local scrollFrame = CreateFrame("ScrollFrame", nil, dropdown)
        scrollFrame:SetPoint("TOPLEFT", 2, -2)
        scrollFrame:SetPoint("BOTTOMRIGHT", -20, 2)
        
        -- Create scroll child (content container)
        local scrollChild = CreateFrame("Frame", nil, scrollFrame)
        scrollChild:SetSize(dropdownWidth - 22, totalItems * itemHeight)
        scrollFrame:SetScrollChild(scrollChild)
        
        -- Create scrollbar
        local scrollbar = CreateFrame("Slider", nil, dropdown, "UIPanelScrollBarTemplate")
        scrollbar:SetPoint("TOPRIGHT", dropdown, "TOPRIGHT", -3, -18)
        scrollbar:SetPoint("BOTTOMRIGHT", dropdown, "BOTTOMRIGHT", -3, 18)
        scrollbar:SetMinMaxValues(0, math.max(0, (totalItems * itemHeight) - visibleHeight))
        scrollbar:SetValueStep(itemHeight)
        scrollbar:SetObeyStepOnDrag(true)
        scrollbar:SetWidth(18)
        
        scrollbar:SetScript("OnValueChanged", function(self, value)
            scrollFrame:SetVerticalScroll(value)
        end)
        
        -- Mouse wheel scrolling
        scrollFrame:EnableMouseWheel(true)
        scrollFrame:SetScript("OnMouseWheel", function(self, delta)
            local current = scrollbar:GetValue()
            local minVal, maxVal = scrollbar:GetMinMaxValues()
            local newValue = current - (delta * itemHeight * 3) -- Scroll 3 items at a time
            newValue = math.max(minVal, math.min(maxVal, newValue))
            scrollbar:SetValue(newValue)
        end)
        
        -- Create buttons
        local buttons = {}
        local itemIndex = 0
        
        local function CreateButton(text, onClick)
            local btn = CreateFrame("Button", nil, scrollChild)
            btn:SetSize(dropdownWidth - 22, itemHeight)
            btn:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, -(itemIndex * itemHeight))
            
            btn:SetNormalFontObject("GameFontHighlightSmall")
            btn:SetHighlightFontObject("GameFontHighlightSmall")
            
            local btnText = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            btnText:SetPoint("LEFT", btn, "LEFT", 5, 0)
            btnText:SetText(text)
            btn:SetFontString(btnText)
            
            -- Highlight texture
            local highlight = btn:CreateTexture(nil, "BACKGROUND")
            highlight:SetAllPoints(btn)
            highlight:SetColorTexture(0.3, 0.3, 0.8, 0.5)
            btn:SetHighlightTexture(highlight)
            
            btn:SetScript("OnClick", function()
                onClick()
                dropdown:Hide()
            end)
            
            itemIndex = itemIndex + 1
            return btn
        end
        
        -- Add (empty) option
        CreateButton(L["(empty)"], function()
            SDT.db.profile.bars[bar:GetName()].slots[slot.index] = nil
            self:RebuildSlots(bar)
        end)
        
        -- Add (spacer) option
        CreateButton(L["(spacer)"], function()
            SDT.db.profile.bars[bar:GetName()].slots[slot.index] = "(spacer)"
            self:RebuildSlots(bar)
        end)
        
        -- Add module options
        for _, moduleName in ipairs(SDT.cache.moduleNames) do
            CreateButton(moduleName, function()
                SDT.db.profile.bars[bar:GetName()].slots[slot.index] = moduleName
                self:RebuildSlots(bar)
            end)
        end
        
        -- Close on click outside
        dropdown:SetScript("OnHide", function()
            self.customDropdown = nil
        end)
        
        -- Close on right click anywhere
        dropdown:SetScript("OnMouseDown", function(self, button)
            if button == "RightButton" then
                self:Hide()
            end
        end)
        
        -- Create invisible close button that covers entire screen
        local closeButton = CreateFrame("Button", nil, UIParent)
        closeButton:SetFrameStrata("FULLSCREEN")
        closeButton:SetAllPoints(UIParent)
        closeButton:SetScript("OnClick", function()
            dropdown:Hide()
            closeButton:Hide()
        end)
        closeButton:Show()
        
        dropdown:SetScript("OnHide", function()
            closeButton:Hide()
            self.customDropdown = nil
        end)
        
        -- Show the dropdown after close button so it's on top
        closeButton:SetFrameLevel(dropdown:GetFrameLevel() - 1)
        dropdown:Show()
        
        -- Set initial scroll position
        scrollbar:SetValue(0)
    end
end