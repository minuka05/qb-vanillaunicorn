QBCore = exports['qb-core']:GetCoreObject() -- Core

n = RegisterNetEvent -- I'm lazy
t = Translation[Config.Translation] -- For translations (even lazier)
ped = PlayerPedId() -- Player ped

barSettings = Config.Settings['barSettings']
bossSettings = Config.Settings['bossSettings']

CreateThread(function() -- Thread to handle original context menu setup
    setupContext()
end)

if Config.debug then 
    RegisterCommand('hayden:test', function() -- debug command
        TriggerServerEvent('hayden:test')
    end, false)
end

n('qb-vanillaunicorn:accessBarMenu', function(data) -- Access bar menu, exploit checks
    canUse = data.args.canUse
    plyCoords = GetEntityCoords(ped)

    for index = 1, #barSettings do
        local barCoords = vector3(barSettings[index].coords.x, barSettings[index].coords.y, barSettings[index].coords.z)  
        if canUse and #(plyCoords - barCoords) < 5 then 
            exports["zf_context"]:openMenu(barMenu)
        else
            print("User is attempting to access menu whilst not near - exploit")
        end
    end
end)

n('qb-vanillaunicorn:purchaseDrink', function(data) -- purchase drinks, exploit check
    name = data.type.name
    price = data.type.price

    if name and price then 
        barConfirmation = {
            {
                id = 1,
                header = t['confirmDrink'] .. name .. "?",
                txt = ' '
            },
            {
                id = 2,
                header = t['yes'],
                txt = 'This will cost $' .. price .. '',
                params = {
                    isServer = true,
                    event = "qb-vanillaunicorn:handleItem",
                    args = {
                        type = data.type.item,
                        amount = data.type.amount, 
                        price = data.type.price, 
                    }
                }
            },
            {
                id = 3,
                header = t['no'],
                txt = ' ',
                params = {
                    event = "",
                }
            },
        }

        exports["zf_context"]:openMenu(barConfirmation)  
    else
        print("How did you get here?")
    end
end)

n('qb-vanillaunicorn:barMenu', function() -- Open bar menu
    exports["zf_context"]:openMenu(drinks)
end)

n('qb-vanillaunicorn:employeeManagement', function() -- Open boss menu
    exports["zf_context"]:openMenu(bossMenu)
end)