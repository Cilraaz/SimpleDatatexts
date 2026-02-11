-- UpdateTicker.lua - Centralized update management for modules
local addonName, SDT = ...

----------------------------------------------------
-- Update Ticker System
----------------------------------------------------
SDT.UpdateTicker = SDT.UpdateTicker or {}
local UpdateTicker = SDT.UpdateTicker

-- Storage for registered callbacks
local updateCallbacks = {}
local timers = {}

-- Main update frame
local tickerFrame = CreateFrame("Frame")

----------------------------------------------------
-- Register a callback to be called at specified interval
-- @param key string Unique identifier for this callback (e.g., "Speed_Slot1")
-- @param callback function Function to call
-- @param interval number Update interval in seconds
----------------------------------------------------
function UpdateTicker:Register(key, callback, interval)
    if not updateCallbacks[interval] then
        updateCallbacks[interval] = {}
        timers[interval] = 0
    end
    
    updateCallbacks[interval][key] = callback
end

----------------------------------------------------
-- Unregister a callback
-- @param key string Unique identifier for the callback
-- @param interval number The interval it was registered at
----------------------------------------------------
function UpdateTicker:Unregister(key, interval)
    if updateCallbacks[interval] then
        updateCallbacks[interval][key] = nil
        
        -- Clean up empty interval tables
        if not next(updateCallbacks[interval]) then
            updateCallbacks[interval] = nil
            timers[interval] = nil
        end
    end
end

----------------------------------------------------
-- Unregister all callbacks with a given prefix
-- @param prefix string Prefix to match (e.g., "Speed_" to remove all Speed callbacks)
----------------------------------------------------
function UpdateTicker:UnregisterPrefix(prefix)
    for interval, callbacks in pairs(updateCallbacks) do
        for key in pairs(callbacks) do
            if key:find("^" .. prefix) then
                callbacks[key] = nil
            end
        end
        
        -- Clean up empty interval tables
        if not next(callbacks) then
            updateCallbacks[interval] = nil
            timers[interval] = nil
        end
    end
end

----------------------------------------------------
-- Main OnUpdate handler
----------------------------------------------------
tickerFrame:SetScript("OnUpdate", function(self, elapsed)
    for interval, callbacks in pairs(updateCallbacks) do
        timers[interval] = timers[interval] + elapsed
        
        if timers[interval] >= interval then
            for key, callback in pairs(callbacks) do
                local success, err = pcall(callback)
                if not success then
                    -- Log error but don't break other callbacks
                    print("|cFFFF6600[SDT]|r Error in update callback '" .. key .. "': " .. tostring(err))
                end
            end
            timers[interval] = 0
        end
    end
end)

----------------------------------------------------
-- Debug function to see what's registered
----------------------------------------------------
function UpdateTicker:GetRegistered()
    local count = 0
    local details = {}
    for interval, callbacks in pairs(updateCallbacks) do
        local callbackCount = 0
        for _ in pairs(callbacks) do
            callbackCount = callbackCount + 1
        end
        count = count + callbackCount
        details[interval] = callbackCount
    end
    return count, details
end

return UpdateTicker