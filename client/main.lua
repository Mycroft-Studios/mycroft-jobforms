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
                    name = area.label,
                    debugPoly = area.TargetSettings.debug,
                }, {
                    options = {
                        {
                            num = 1,
                            label = area.TargetSettings.label,
                            targeticon = area.TargetSettings.icon,
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
                    distance = 2.5,
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
