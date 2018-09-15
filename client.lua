--Made by Jijamik, feel free to modify

RegisterNetEvent('meteo:actu')
AddEventHandler('meteo:actu', function(data)
	ClearWeatherTypePersist()
	SetWeatherTypeOverTime(data["Meteo"], 80.00)
	SetWind(1.0)
	SetWindSpeed(data["VitesseVent"]);
	SetWindDirection(data["DirVent"])
end)

AddEventHandler('onClientMapStart', function()
	TriggerServerEvent('meteo:sync')
end)

TriggerServerEvent('meteo:sync')