--Made by Jijamik, feel free to modify


local cityid = "5368361" -- Los Angeles
local apikey = "Ici votre clé openweathermap"
local GetWeather = "http://api.openweathermap.org/data/2.5/weather?id="..cityid.."&lang=fr&units=metric&APPID="..apikey

function sendToDiscordMeteo (type, name,message,color)
    local DiscordWebHook = "Webhook Discord"

    local avatar = "Url de l'image"


    local embeds = {
        {

            ["title"]=message,
            ["type"]="rich",
            ["color"] =color,
            ["footer"]=  {
                ["text"]= "-------------------------------------------------------------------------------------------------------------------",
            },
        }
    }

    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds,avatar_url = avatar}), { ['Content-Type'] = 'application/json' })
end

function checkMeteo(err,response)
    local data = json.decode(response)
    local type = data.weather[1].main
    local id = data.weather[1].id
    local description = data.weather[1].description
    local wind = math.floor(data.wind.speed)
    local windrot = data.wind.deg
    local meteo = "EXTRASUNNY"
    local ville = data.name
    local temp = math.floor(data.main.temp)
    local tempmini = math.floor(data.main.temp_min)
    local tempmaxi = math.floor(data.main.temp_max)
    local emoji = ":white_sun_small_cloud:"
    if type == "Thunderstorm" then
        meteo = "THUNDER"
        emoji = ":cloud_lightning:"
    end
    if type == "Rain" then
        meteo = "RAIN"
        emoji = ":cloud_snow:"
    end
    if type == "Drizzle" then
        meteo = "CLEARING"
        emoji = ":clouds:"
        if id == 608  then
            meteo = "OVERCAST"
        end
    end
    if type == "Clear" then
        meteo = "CLEAR"
        emoji = ":sun_with_face:"
    end
    if type == "Clouds" then
        meteo = "CLOUDS"
        emoji = ":clouds:"
        if id == 804  then
            meteo = "OVERCAST"
        end
    end
    if type == "Snow" then
        meteo = "SNOW"
        emoji = ":cloud_snow:"
        if id == 600 or id == 602 or id == 620 or id == 621 or id == 622 then
            meteo = "XMAS"
        end
    end

    Data = {
        ["Meteo"] = meteo,
        ["VitesseVent"] = wind,
        ["DirVent"] = windrot
    }
    TriggerClientEvent("meteo:actu", -1, Data)
    sendToDiscordMeteo(1,('Météo'), emoji.." La météo à "..ville.." est "..description..". \n:thermometer: Il fait actuellement "..temp.."°C avec des minimales à "..tempmini.."°C et des maximales à "..tempmaxi.."°C. \n:wind_blowing_face: Des vents de "..wind.."m/s sont à prévoir.",16711680)
    SetTimeout(60*60*1000, checkMeteoHTTPRequest)
end

function checkMeteoHTTPRequest()
    PerformHttpRequest(GetWeather, checkMeteo, "GET")
end

checkMeteoHTTPRequest()

RegisterServerEvent("meteo:sync")
AddEventHandler("meteo:sync",function()
    TriggerClientEvent("meteo:actu", source, Data)
end)

--[[
"EXTRASUNNY"
"SMOG"
"CLEAR"
"CLOUDS"
"FOGGY"
"OVERCAST"
"RAIN"
"THUNDER"
"CLEARING"
"NEUTRAL"
"SNOW"
"BLIZZARD"
"SNOWLIGHT"
"XMAS"
]]