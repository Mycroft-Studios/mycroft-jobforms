function DoApplication(AreaIndex)
    local area = Config.Areas[AreaIndex]
    local Questions = area.Questions
    local input = lib.inputDialog(area.label, Questions)
    if not input then return end
    lib.notify({
        title = 'Job Application',
        description = 'Successfully Sent your Application.',
        type = 'success'
    })
    TriggerServerEvent("jobforms:apply", AreaIndex, input)
end

CreateThread(function()
    for i = 1, #(Config.Areas) do
        if Config.UseTarget then
            local area = Config.Areas[i]
            exports.ox_target:addSphereZone({
                coords = area.Coords,
                radius = area.TargetSettings.radius,
                debug = area.TargetSettings.debug,
                options = {
                    {
                        name = area.label,
                        icon = area.TargetSettings.icon,
                        label = area.TargetSettings.label,
                        onSelect = function()
                            DoApplication(i)
                        end,
                        canInteract = function()
                            if not Config.ApplicationSettings.Cooldown.enabled then
                                return true
                            end
                            if not LocalPlayer.state.ApplicationCooldown then
                                return true
                            end
                            return false
                        end
                    }
                }
            })
        elseif Config.QBTarget then
            local area = Config.Areas[i]
            exports['qb-target']:AddCircleZone(Config.Areas[i], area.Coords, area.TargetSettings.radius,
                {
                    -- The name has to be unique, the coords a vector3 as shown and the 1.5 is the radius which has to be a float value
                    name = area.label,                     -- This is the name of the zone recognized by PolyZone, this has to be unique so it doesn't mess up with other zones
                    debugPoly = area.TargetSettings.debug, -- This is for enabling/disabling the drawing of the box, it accepts only a boolean value (true or false), when true it will draw the polyzone in green
                }, {
                    options = {                            -- This is your options table, in this table all the options will be specified for the target to accept
                        {
                            -- This is the first table with options, you can make as many options inside the options table as you want
                            num = 1,                               -- This is the position number of your option in the list of options in the qb-target context menu (OPTIONAL)
                            icon = 'fas fa-example',               -- This is the icon that will display next to this trigger option
                            label = area.TargetSettings.label,     -- This is the label of this option which you would be able to click on to trigger everything, this has to be a string
                            targeticon = area.TargetSettings.icon, -- This is the icon of the target itself, the icon changes to this when it turns blue on this specific option, this is OPTIONAL
                            action = function()
                                DoApplication(i)
                            end,
                            canInteract = function()
                                if not Config.ApplicationSettings.Cooldown.enabled then
                                    return true
                                end
                                if not LocalPlayer.state.ApplicationCooldown then
                                    return true
                                end
                                return false
                            end,
                        }
                    },
                    distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
                })
        else
            local point = lib.points.new(Config.Areas[i].Coords, Config.Areas[i].MarkerSettings.Distance, {
                area = Config.Areas[i], DrawingTextUI = false, areaIndex = i
            })
            function point:nearby()
                if self.area.MarkerSettings.DrawMarker then
                    local m_set = self.area.MarkerSettings
                    DrawMarker(m_set.type, self.coords.x, self.coords.y, self.coords.z, 0, 0, 0, m_set.rotation.x,
                    m_set.rotation.y, m_set.rotation.z, m_set.size.x, m_set.size.y, m_set.size.z, m_set.colour.r,
                    m_set.colour.g, m_set.colour.b, m_set.colour.a, false, true, 2, nil, nil, false)
                end

                if self.currentDistance < 1 then
                    if not self.DrawingTextUI then
                        self.DrawingTextUI = true
                        lib.showTextUI(self.area.MarkerSettings.TextUI)
                    end
                    if IsControlJustPressed(0, 38) then
                        if Config.ApplicationSettings.Cooldown.enabled then
                            if LocalPlayer.state.ApplicationCooldown then
                                return lib.notify({
                                    title = 'Job Application',
                                    description = 'Please Wait for your Cooldown to finish.',
                                    icon = 'ban',
                                    iconColor = '#C53030'
                                })
                            end
                        end
                        DoApplication(self.areaIndex)
                    end
                else
                    if self.DrawingTextUI then
                        self.DrawingTextUI = false
                        lib.hideTextUI()
                    end
                end
            end
        end
        if Config.Areas[i].Blip.enabled then
            local blip_set = Config.Areas[i].Blip
            local blip = AddBlipForCoord(Config.Areas[i].Coords)
            SetBlipSprite(blip, blip_set.sprite)
            SetBlipAsShortRange(blip, true)
            SetBlipColour(blip, blip_set.colour)
            SetBlipScale(blip, blip_set.size)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Config.Areas[i].label)
            EndTextCommandSetBlipName(blip)
        end
    end
end)
