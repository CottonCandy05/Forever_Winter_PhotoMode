local UEHelpers = require("UEHelpers")

local IsActive = false
local pawn  -- to keep track of the original
local photomode = nil
local isBusy = false

-- Helper to clean up the zombie process from memory
local function GetPhotoModeComponent()
    local pms = FindAllOf("BPC_PhotoMode_C")
    if pms then
        for i = #pms, 1, -1 do
            local pm = pms[i]
            if pm and pm:IsValid() then
                return pm
            end
        end
    end
    return nil
end

local function RestoreGameInput()
    local gameplayStatics = UEHelpers.GetGameplayStatics()
    local engine = UEHelpers:GetEngine()
    local pc = gameplayStatics:GetPlayerController(engine.GameViewport.World, 0)
    if not pc or not pc:IsValid() then return end

    --Locking mouse back to game world
    if engine and engine.GameViewport then
        engine.GameViewport.MouseCaptureMode = 1
    end

    local lib = FindFirstOf("WidgetBlueprintLibrary")
    if lib and lib:IsValid() then
        lib:SetInputMode_GameOnly(pc, false)
        lib:SetFocusToGameViewport() -- Releases Slate mouse capture directly into 3D world!
    end

    pc.bShowMouseCursor = false
    pc.bEnableClickEvents = false
    pc.bEnableMouseOverEvents = false

    pc:ResetIgnoreLookInput()
    pc:SetIgnoreLookInput(false)
end

local function RestoreColor()
    local cams = FindAllOf("CineCameraComponent")
    if cams then
        for _, cam in ipairs(cams) do
            if cam and cam:IsValid() then
                local pp = cam.PostProcessSettings
                pp.bOverride_ColorSaturation = false
                pp.bOverride_ColorGradingIntensity = false
                pp.bOverride_ColorGradingLUT = false
                pp.bOverride_FilmSaturation = false
                pp.bOverride_WhiteTemp = false
                pp.bOverride_WhiteTint = false
                pp.bOverride_AutoExposureBias = false
                pp.bOverride_ColorGain = false
                pp.bOverride_ColorContrast = false
                pp.bOverride_ColorGamma = false
                pp.bOverride_VignetteIntensity = false
                pp.bOverride_FilmGrainIntensity = false
            end
        end
    end
end

local function ToggleSpectator()
	local gameplayStatics = UEHelpers.GetGameplayStatics()
	local engine = UEHelpers:GetEngine()
	local playerController = gameplayStatics:GetPlayerController(engine.GameViewport.World, 0)

    if not IsActive then
        --print(string.format("[SpectatorMode] PlayerController: %s",playerController, playerController:GetFullName()))
        if playerController and playerController:IsValid() then
            ---@class ABP_PlayerBase_C
            pawn = playerController:K2_GetPawn()
            if pawn and pawn:IsValid() then
                --print(string.format("[SpectatorMode] Pawn: %s",  pawn, pawn:GetFullName()))
                pawn:SpawnSpectator()
                IsActive = true
                --print("[SpectatorMode] Enabled SpectatorMode")
            end
        end
    else
		local spectatorPawn = playerController:K2_GetPawn()
		playerController:Possess(pawn)  -- playerController posesses the original pawn
		pawn.PossesBack()
		spectatorPawn:K2_DestroyActor() -- get rid of spectator
		IsActive = false
        --Restoring controls and reset color filter
        RestoreGameInput()
        RestoreColor()
		--print("[SpectatorMode] Disabled SpectatorMode")
    end
end

RegisterKeyBind(Key.F8, {}, function()
    ExecuteInGameThread(function()
        print("Pressed F8\n")
        ToggleSpectator()
    end)
end)


RegisterKeyBind(Key.N, {}, function()
    ExecuteInGameThread(function()
        print("Pressed N\n")
        if isBusy then
            print("Busy, skipping process\n")
            return -- Exit, Don't run
        end

        isBusy = true

        local pm = GetPhotoModeComponent()

        if not pm or not pm:IsValid() then
            print("No BPC_PhotoMode_C components found, skipping process\n")
            isBusy = false
            return -- Exit, Don't run
        end

        --[[print("List of BPC_PhotoMode_C functions\n")
        pm:GetClass():ForEachFunction(function(fn)
        print("  Function: " .. fn:GetFName():ToString() .. "\n")
        end)]]

        --[[print("List of BPC_PhotoMode_C properties\n")
        pm:GetClass():ForEachProperty(function(prop)
        print("  Property: " .. prop:GetFName():ToString() .. "\n")
        end)]]

		photomode = pm

        if pm.bIsUsingPhotoMode then
            print("Closing Photo Mode\n")

            --[[local pmWidget = pm.PhotoModeWidgetRef
            if pmWidget and pmWidget:IsValid() then
                local bSlider = pmWidget.Brightness
                if bSlider and bSlider:IsValid() then
                    print("=== BRIGHTNESS SLIDER DUMP ===\n")
                    print("  bMapMinMax: " .. tostring(bSlider.bMapMinMax) .. "\n")
                    print("  MinimumValue: " .. tostring(bSlider.MinimumValue) .. "\n")
                    print("  MaximumValue: " .. tostring(bSlider.MaximumValue) .. "\n")
                    print("  DefaultValue: " .. tostring(bSlider.DefaultValue) .. "\n")

                    local inner = bSlider.Slider
                    if inner and inner:IsValid() then
                        print("  Inner Slider MinValue: " .. tostring(inner.MinValue) .. "\n")
                        print("  Inner Slider MaxValue: " .. tostring(inner.MaxValue) .. "\n")
                        print("  Inner Slider Current Value: " .. tostring(inner.Value) .. "\n")
                    end
                end
            end]]

            -- 1.Removing UI
            local widget = pm.PhotoModeWidgetRef
            if widget and widget:IsValid() then
                widget:SetVisibility(2) -- Hidden
                widget:RemoveFromParent() -- Removed from screen
            end

            -- 2.Cleaning up cam references and updating component state
            pm.ResetPhotoMode()
            pm.UpdateReferences(false)
            pm.bIsUsingPhotoMode = false

            -- 3.Restoring controls and reset color filter
            RestoreGameInput()
            RestoreColor()

        else
            print("Opening Photo Mode\n")
            pm.UpdateReferences(true)
            pm.InitWidgets()
            pm.ResetPhotoMode()
            pm.bIsUsingPhotoMode = true
        end
        isBusy = false
    end)
end)