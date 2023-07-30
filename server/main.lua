function Discord(name, title, color, fields)
    local webHook = DiscordLogs.Webhooks[name] or DiscordLogs.Webhooks.default
    local embedData = {{
        ['title'] = title,
        ['color'] = DiscordLogs.Colors[color] or DiscordLogs.Colors.default,
        ['footer'] = {
            ['text'] = Config.ShowTime and Config.FooterText .. " " .. os.date() or Config.FooterText,
            ['icon_url'] = Config.FooterIconURL
        },
        ['fields'] = fields, 
        ['description'] = "",
        ['author'] = {
            ['name'] = Config.ServerName,
            ['icon_url'] = Config.AuthorAvatar
        }
    }}
    PerformHttpRequest(webHook, nil, 'POST', json.encode({
        username = Config.BotUsername,
        avatar_url = Config.BotAvatar,
        embeds = embedData
    }), {['Content-Type'] = 'application/json'})
end

function Sanitize(str)
	local replacements = {
		['&' ] = '&amp;',
		['<' ] = '&lt;',
		['>' ] = '&gt;',
		['\n'] = '<br/>'
	}

	return str
		:gsub('[&<>\n]', replacements)
		:gsub(' +', function(s)
			return ' '..('&nbsp;'):rep(#s-1)
		end)
end

function TableToString(table)
    local string = ""
    for k,v in pairs(table) do
        local answer = Sanitize(tostring(v))
        if not answer or answer == "" then answer = "N/A" end
        if Config.ChangeBoolsToStrings and answer == "true" then answer = "Yes" end
        if Config.ChangeBoolsToStrings and answer == "false" then answer = "No" end
        string = string .. (Config.MakeAnswersBold and ("**%s**: **%s** \n"):format(k, answer) or ("%s: %s"):format(k, answer))
    end
    return string
end

function ConvertAnswers(Questions, Answers)
    for i=1, #(Answers) do
        if type(Answers[i]) == "table" then
            Questions[i].Answer = TableToString(Answers[i])
        else
            local answer = Sanitize(tostring(Answers[i]))
            if not answer or answer == "" then answer = "N/A" end
            if Config.ChangeBoolsToStrings and answer == "true" then answer = "Yes" end
            if Config.ChangeBoolsToStrings and answer == "false" then answer = "No" end
            Questions[i].Answer = Config.MakeAnswersBold and ("**%s**"):format(answer) or answer
        end
    end
    return Questions
end

RegisterNetEvent("jobforms:apply", function(AreaIndex, Answers)
    local source = source
    if Player(source).state.ApplicationCooldown then 
        return 
    end
    local Ped = GetPlayerPed(source)
    local ped_pos = GetEntityCoords(Ped)
    local dist = #(Config.Areas[AreaIndex].Coords - ped_pos)
    if dist > 10.0 then
        return
    end
    local Questions = ConvertAnswers(Config.Areas[AreaIndex].Questions, Answers)
    local Fields = {}
    for i=1, #(Questions) do
        Fields[#Fields + 1] = {name = Questions[i].label, value = Questions[i].Answer, inline = false}
    end
    Discord(Config.Areas[AreaIndex].webhook, Config.Areas[AreaIndex].label, "green", Fields)
    Player(source).state:set("ApplicationCooldown", true, true)
    SetTimeout(Config.ApplicationSettings.Cooldown.time, function()
        Player(source).state:set("ApplicationCooldown", false, true)
    end)
end)