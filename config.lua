Config = {}

Config.NPC = {
    model = 'a_m_m_business_01',
    position = vector4(-783.57, -390.68, 36.33, 160.07),
    scenario = 'WORLD_HUMAN_STAND_IMPATIENT'
}

Config.TargetVectors = {
    vector3(-2194.1, 286.06, 169.61),
    vector3(-2245.38, 199.36, 174.6),
    vector3(-2222.16, 304.31, 174.6),
    vector3(-2253.59, 233.62, 174.61)
}
Config.PrinterNPC = {
    model = 's_m_m_highsec_01',
    position = vector4(-3099.71, 211.62, 13.07, 47.43), -- vector4!
    scenario = 'WORLD_HUMAN_CLIPBOARD'
}

Config.MaterialRange = {
    paper = {min = 5, max = 10},
    ink = {min = 2, max = 5}
}

Config.Items = {
    paper = 'money_paper',
    ink = 'money_ink',
    black_money = 'black_money'
}

Config.MoneyPrinterOptions = {
    {
        header = "100 Karapara Bas",
        requiredPaper = 1,
        requiredInk = 1,
        moneyAmount = 100
    },
    {
        header = "200 Karapara Bas",
        requiredPaper = 2,
        requiredInk = 2,
        moneyAmount = 200
    }
}

Config.Timers = {
    stealTime = 5000 -- Malzeme çalma süresi (ms)
}

Config.BlipSettings = {
    stealBlip = {
        sprite = 1,
        color = 1,
        scale = 0.7,
        label = 'Malzeme Çalma Bölgesi'
    },
    printerBlip = {
        sprite = 500,
        color = 4,
        scale = 0.8,
        label = 'Karapara Basma Noktası'
    }
}

Config.Notification = {
    missionStart = "Malzemeleri çalmak için işaretli bölgeye git!",
    steal = {
        success = "Malzemeler çalındı! Karapara basma noktasına git.",
        cancel = "İşlem iptal edildi."
    },
    printing = {
        success = "Başarıyla karapara basıldı!",
        noItems = "Yeterli malzemen yok!",
        cancel = "İşlem iptal edildi."
    }
}