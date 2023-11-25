-- Define the dimensions and position of the CapsuleHP
local CapsuleHP = {
    x = 0.02 * ScrW(),
    y = 0.76 * ScrH(),
    width = 0.016 * ScrW(),
    height = 0.196 * ScrH(),
    color = Color(0, 0, 0, 128),
    cornerRadius = 100
}

-- Define the dimensions and position of the CapsuleArmor
local CapsuleArmor = {
    x = 0.05 * ScrW(),
    y = 0.76 * ScrH(),
    width = 0.015 * ScrW(),
    height = 0.196 * ScrH(),
    color = Color(0, 0, 0, 128),
    cornerRadius = 100
}

hook.Add("HUDPaint", "DrawCapsules", function()
    draw.RoundedBox(CapsuleHP.cornerRadius, CapsuleHP.x, CapsuleHP.y, CapsuleHP.width, CapsuleHP.height, CapsuleHP.color)
    draw.RoundedBox(CapsuleArmor.cornerRadius, CapsuleArmor.x, CapsuleArmor.y, CapsuleArmor.width, CapsuleArmor.height, CapsuleArmor.color)
end)

-- Define the dimensions and position of the HP bar
local width = 0.004 * ScrW()
local height = 0.168 * ScrH()
local xPos = 0.03 * ScrW()
local yPos = 0.944 * ScrH()

local rotation = 0
local cornerRadius = 90

local color = Color(255, 0, 0)

local maxHP = 100

hook.Add("HUDPaint", "DrawHPBar", function()
    local currentHP = LocalPlayer():Health()
    local hpPercentage = math.Clamp(currentHP / maxHP, 0, 1)
    local adjustedHeight = height * hpPercentage

    -- Draw the black background for the health bar
    surface.SetDrawColor(Color(0, 0, 0, 255))
    surface.SetMaterial(Material("vgui/white"))

    cam.Start2D()
    local rotatedX = xPos - (width / 2)
    local rotatedY = yPos - (height / 2)
    surface.DrawTexturedRectRotated(rotatedX, rotatedY, width, height, rotation)
    cam.End2D()

    -- Draw the red health bar on top of the black background
    surface.SetDrawColor(color)
    cam.Start2D()
    surface.DrawTexturedRectRotated(rotatedX, rotatedY + (height - adjustedHeight) / 2, width, adjustedHeight, rotation)
    cam.End2D()
end)

-- Define the dimensions and position of the Armor bar
local armorWidth = 0.004 * ScrW()
local armorHeight = 0.168 * ScrH()
local armorXPos = 0.060 * ScrW()
local armorYPos = 0.944 * ScrH()

local armorRotation = 0
local armorCornerRadius = 90

local maxArmor = 100

hook.Add("HUDPaint", "DrawArmorBar", function()
    local currentArmor = LocalPlayer():Armor()
    local armorPercentage = math.Clamp(currentArmor / maxArmor, 0, 1)
    local adjustedArmorHeight = armorHeight * armorPercentage

    surface.SetDrawColor(Color(0, 0, 0))
    surface.SetMaterial(Material("vgui/white"))

    cam.Start2D()
    local armorRotatedX = armorXPos - (armorWidth / 2)
    local armorRotatedY = armorYPos - (armorHeight / 2)
    surface.DrawTexturedRectRotated(armorRotatedX, armorRotatedY, armorWidth, armorHeight, armorRotation)
    cam.End2D()

    if currentArmor > 0 then
        surface.SetDrawColor(Color(0, 0, 255))
        cam.Start2D()
        surface.DrawTexturedRectRotated(armorRotatedX, armorRotatedY + (armorHeight - adjustedArmorHeight) / 2, armorWidth, adjustedArmorHeight, armorRotation)
        cam.End2D()
    end
end)

local width = 0.23 * ScrW()
local height = 0.123 * ScrH()

local AmmoBarX = 0.77 * ScrW()
local AmmoBarY = 0.869 * ScrH()

local function GreenAmmoRectangle()
    local ply = LocalPlayer()

    if IsValid(ply) and ply:Alive() then
        local weapon = ply:GetActiveWeapon()

        local allowedWeapons = {
            "weapon_physgun",
            "gmod_tool",
            "weapon_physcannon",
            "weapon_crowbar"
        }

        if not IsValid(weapon) or not table.HasValue(allowedWeapons, weapon:GetClass()) then
            draw.RoundedBox(0, AmmoBarX, AmmoBarY, width, height, Color(0, 255, 0, 100))
        end
    end
end

hook.Add("HUDPaint", "GreenAmmoRectangle", GreenAmmoRectangle)

surface.CreateFont("WeaponName", {
    font = "CloseCaption_Normal",
    size = 0.023 * ScrH(),
    weight = 800,
    italic = true,
})

hook.Add("HUDPaint", "WeaponName", function()
    local ply = LocalPlayer()

    if IsValid(ply) and ply:Alive() then
        local weapon = ply:GetActiveWeapon()

        local allowedWeapons = {
            "weapon_physgun",
            "gmod_tool",
            "weapon_physcannon",
            "weapon_crowbar"
        }

        if IsValid(weapon) and not table.HasValue(allowedWeapons, weapon:GetClass()) then
            local weaponName = weapon:GetPrintName()
            weaponName = string.gsub(weaponName, "^.-_", "")

            surface.SetFont("CloseCaption_Normal")
            surface.SetTextColor(255, 255, 255, 255)
            surface.SetTextPos(0.775 * ScrW(), 0.879 * ScrH())
            surface.DrawText("Weapon: " .. weaponName)
        end
    end
end)

surface.CreateFont("AmmoText", {
    font = "CloseCaption_Normal",
    size = 0.023 * ScrH(),
    weight = 800,
    italic = true,
})

hook.Add("HUDPaint", "DrawAndUpdateHUD", function()
    local ply = LocalPlayer()

    if IsValid(ply) and ply:Alive() then
        local weapon = ply:GetActiveWeapon()

        local allowedWeapons = {
            "weapon_physgun",
            "gmod_tool",
            "weapon_physcannon",
            "weapon_crowbar"
        }

        if not IsValid(weapon) or not table.HasValue(allowedWeapons, weapon:GetClass()) then
            surface.SetFont("CloseCaption_Normal")
            surface.SetTextColor(255, 255, 255, 255)
            surface.SetTextPos(0.777 * ScrW(), 0.907 * ScrH())
            surface.DrawText("Ammo:")

            if IsValid(weapon) then
                local ammoType = weapon:GetPrimaryAmmoType()
                local ammoCount = ply:GetAmmoCount(ammoType)

                if weapon:GetClass() == "weapon_rpg" or weapon:GetClass() == "weapon_frag" then
                    surface.SetTextPos((0.775 + 0.047) * ScrW(), 0.907 * ScrH())
                    surface.DrawText(ammoCount)
                elseif weapon:GetClass() == "weapon_slam" then
                    -- Customize display for SLAM or other deployable items
                    surface.SetTextPos((0.775 + 0.047) * ScrW(), 0.907 * ScrH())
                    surface.DrawText("SLAMS")
                else
                    local currentClip = weapon:Clip1()
                    surface.SetTextPos((0.775 + 0.047) * ScrW(), 0.907 * ScrH())
                    surface.DrawText(currentClip .. "/" .. ammoCount)
                end
            end
        end
    end
end)

hook.Add("HUDShouldDraw", "HideDefaultHUD", function(name)
    local hudToHide = {"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}
    for i = 1, #hudToHide do
        if name == hudToHide[i] then
            return false
        end
    end
end)
