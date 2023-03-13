Config = {}

Config.UseTarget = false -- ox target support
Config.QBTarget = true -- qb target support

-- Discord Log Settings
Config.ServerName = "Example Roleplay"
Config.FooterText = "Mycroft | Job Forms | "
Config.FooterIconURL = ""
Config.ShowTime = true -- shows date in the footer
Config.ChangeBoolsToStrings = true -- changes True/False to Yes/No
Config.MakeAnswersBold = true
Config.BotUsername = "Job Form Bot"
Config.BotAvatar = "https://cdn.discordapp.com/emojis/939245183621558362.webp?size=128&quality=lossless"
Config.AuthorAvatar = "https://cdn.discordapp.com/emojis/939245183621558362.webp?size=128&quality=lossless"

 --[[
    Question Types:
    input,
    number,
    checkbox,
    select,
    slider
    color
    multi-select
    date
    date-range 
    time
    textarea

    for more details, visit: https://overextended.github.io/docs/ox_lib/Interface/Client/input
    ]]

-- Main Settings

Config.Areas = {
    {
        label = "Police Application",
        webhook = "police", -- note if not present, it will send to "default"
        Coords = vector3(441.5298, -981.1339, 30.6896),
        Blip = {
            enabled = false,
            sprite = 1,
            size = 0.7,
            colour = 1,
        },
        TargetSettings = { -- For when using OX-target
            radius = 2,
            debug = false,
            icon = "fa-solid fa-list-check",
            label = "Police Applications"
        },
        MarkerSettings = { -- if not using OX-Target
            DrawMarker = true,
            size = vec3(1, 1, 1),
            rotation = vec3(1, 1, 1),
            type = 21,
            Distance = 10.0,
            colour = {r = 50, g = 200, b = 50, a = 200},
            TextUI = "[E] -> Police Applications"
        },
        Questions = {
            {
                type = "input",
                label = "Question 1",
                description = "This is a Required Question",
                placeholder = "Answer",
                required = true
            },
            {   
                type = "input",
                label = "Question 2",
                description = "This is a Non-Required Question",
                placeholder = "Answer",
                required = false
            },
            {   
                type = "checkbox",
                label = "Do you like Chicken?",
                description = "Very Important Yes/No Question.",
                required = false
            },
            {   
                type = "slider",
                label = "How Much Do you like Noodles?",
                default = 5,
                min = 1,
                max = 10,
                step = 1,
                required = true
            },
            {   
                type = "textarea",
                label = "Is the Sky Blue?",
                description = "This is a Very Long Question",
                placeholder = "Who Knows?",
                max = 50, -- Max Lines
                required = true
            },
        }
    }
}

Config.ApplicationSettings = {
    Cooldown = {
        enabled = true,
        time = 5 * 60000 -- time in milliseconds (default: 5 mins)
    },
}
