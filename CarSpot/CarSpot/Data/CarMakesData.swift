import Foundation

let allCarMakes: [CarMake] = [
    CarMake(name: "Acura", models: [
        "CL", "ILX", "Integra", "Legend", "MDX", "NSX", "RDX", "RL", "RLX", "RSX", "TL", "TLX", "TSX", "ZDX"
    ]),
    CarMake(name: "Alfa Romeo", models: [
        "147", "156", "159", "166", "4C", "Giulia", "Giulietta", "GTV", "Junior", "MiTo", "Spider", "Stelvio", "Tonale"
    ]),
    CarMake(name: "Aston Martin", models: [
        "DB7", "DB9", "DB11", "DB12", "DBS", "DBX", "Rapide", "V8 Vantage", "V12 Vantage", "Vantage", "Vanquish", "Virage"
    ]),
    CarMake(name: "Audi", models: [
        "A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "e-tron", "e-tron GT", "Q2", "Q3", "Q4 e-tron", "Q5", "Q6 e-tron",
        "Q7", "Q8", "R8", "RS3", "RS4", "RS5", "RS6", "RS7", "RS Q3", "RS Q8", "S3", "S4", "S5", "S6", "S7", "S8",
        "SQ5", "SQ7", "SQ8", "TT", "TTS", "TT RS"
    ]),
    CarMake(name: "Bentley", models: [
        "Arnage", "Azure", "Bentayga", "Continental Flying Spur", "Continental GT", "Continental GTC",
        "Flying Spur", "Mulsanne", "Turbo R"
    ]),
    CarMake(name: "BMW", models: [
        "1 Series", "2 Series", "3 Series", "4 Series", "5 Series", "6 Series", "7 Series", "8 Series",
        "i3", "i4", "i5", "i7", "iX", "iX1", "iX3", "M2", "M3", "M4", "M5", "M6", "M8", "X1", "X2",
        "X3", "X4", "X5", "X6", "X7", "XM", "Z3", "Z4", "Z8"
    ]),
    CarMake(name: "Bugatti", models: [
        "Bolide", "Chiron", "Divo", "Mistral", "Tourbillon", "Veyron", "W16 Mistral"
    ]),
    CarMake(name: "Buick", models: [
        "Century", "Enclave", "Encore", "Encore GX", "Envision", "Envista", "LaCrosse", "LeSabre",
        "Lucerne", "Park Avenue", "Rainier", "Regal", "Rendez-vous", "Riviera", "Verano"
    ]),
    CarMake(name: "Cadillac", models: [
        "ATS", "CT4", "CT5", "CT6", "CTS", "DeVille", "DTS", "Eldorado", "Escalade", "Escalade ESV",
        "Lyriq", "SRX", "STS", "Seville", "XLR", "XT4", "XT5", "XT6"
    ]),
    CarMake(name: "Chevrolet", models: [
        "Blazer", "Blazer EV", "Bolt EUV", "Bolt EV", "Camaro", "Colorado", "Corvette", "Equinox",
        "Equinox EV", "Express", "Impala", "Malibu", "Monte Carlo", "Silverado", "Silverado EV",
        "Sonic", "Spark", "Suburban", "Tahoe", "Trailblazer", "Traverse", "Trax"
    ]),
    CarMake(name: "Chrysler", models: [
        "200", "300", "300C", "Aspen", "Crossfire", "Grand Voyager", "Pacifica", "PT Cruiser",
        "Sebring", "Town & Country", "Voyager"
    ]),
    CarMake(name: "Citroën", models: [
        "Berlingo", "C1", "C2", "C3", "C3 Aircross", "C4", "C4 Cactus", "C4 Picasso", "C5", "C5 Aircross",
        "C5 X", "C6", "DS3", "DS4", "DS5", "Dispatch", "Grand C4 Picasso", "Jumpy", "Xsara"
    ]),
    CarMake(name: "Dodge", models: [
        "Challenger", "Charger", "Dart", "Durango", "Grand Caravan", "Hornet", "Journey",
        "Neon", "Ram 1500", "Viper"
    ]),
    CarMake(name: "Ferrari", models: [
        "296 GTB", "296 GTS", "360 Modena", "430 Scuderia", "458 Italia", "458 Spider", "488 GTB",
        "488 Spider", "California", "F40", "F50", "F8 Tributo", "Ferrari Roma", "GTC4Lusso",
        "LaFerrari", "Portofino", "Purosangue", "SF90 Stradale", "Testarossa"
    ]),
    CarMake(name: "Fiat", models: [
        "124 Spider", "500", "500C", "500e", "500L", "500X", "Bravo", "Doblo", "Grande Punto",
        "Panda", "Punto", "Stilo", "Tipo"
    ]),
    CarMake(name: "Ford", models: [
        "Bronco", "Bronco Sport", "Edge", "Escape", "Expedition", "Explorer", "F-150", "F-150 Lightning",
        "F-250", "F-350", "Fiesta", "Flex", "Focus", "Fusion", "Galaxy", "Maverick", "Mondeo",
        "Mustang", "Mustang Mach-E", "Puma", "Ranger", "S-Max", "Territory", "Transit"
    ]),
    CarMake(name: "Genesis", models: [
        "G70", "G80", "G90", "GV60", "GV70", "GV80"
    ]),
    CarMake(name: "GMC", models: [
        "Acadia", "Canyon", "Envoy", "Hummer EV", "Jimmy", "Safari", "Sierra", "Sierra EV",
        "Terrain", "Yukon", "Yukon XL"
    ]),
    CarMake(name: "Honda", models: [
        "Accord", "BR-V", "City", "Civic", "CR-V", "CR-Z", "Element", "Fit", "HR-V", "Insight",
        "Jazz", "Legend", "Odyssey", "Passport", "Pilot", "Prelude", "Prologue", "Ridgeline",
        "S2000", "ZR-V"
    ]),
    CarMake(name: "Hyundai", models: [
        "Accent", "Azera", "Bayon", "Elantra", "Equus", "Genesis Coupe", "i10", "i20", "i30",
        "i40", "IONIQ", "IONIQ 5", "IONIQ 6", "IONIQ 9", "Kona", "Kona Electric", "Nexo",
        "Palisade", "Santa Cruz", "Santa Fe", "Sonata", "Staria", "Tucson", "Venue", "Veloster"
    ]),
    CarMake(name: "Infiniti", models: [
        "EX35", "EX37", "FX35", "FX45", "FX50", "G25", "G35", "G37", "M35", "M45", "M56",
        "Q30", "Q40", "Q45", "Q50", "Q60", "Q70", "QX30", "QX50", "QX55", "QX60", "QX70", "QX80"
    ]),
    CarMake(name: "Jaguar", models: [
        "E-Pace", "E-Type", "F-Pace", "F-Type", "I-Pace", "S-Type", "X-Type", "XE", "XF", "XJ",
        "XJR", "XJS", "XK", "XKR"
    ]),
    CarMake(name: "Jeep", models: [
        "Cherokee", "Commander", "Compass", "Gladiator", "Grand Cherokee", "Grand Cherokee L",
        "Grand Wagoneer", "Liberty", "Patriot", "Renegade", "Wagoneer", "Wrangler"
    ]),
    CarMake(name: "Kia", models: [
        "Carnival", "Ceed", "EV3", "EV6", "EV9", "K5", "K8", "Niro", "Optima", "Picanto",
        "ProCeed", "Rio", "Seltos", "Soul", "Sorento", "Sportage", "Stinger", "Stonic", "Telluride", "XCeed"
    ]),
    CarMake(name: "Lamborghini", models: [
        "Aventador", "Countach", "Diablo", "Gallardo", "Huracán", "Murciélago", "Revuelto",
        "Sián", "Urus", "Urus SE"
    ]),
    CarMake(name: "Land Rover", models: [
        "Defender", "Discovery", "Discovery Sport", "Freelander", "Range Rover", "Range Rover Evoque",
        "Range Rover Sport", "Range Rover Velar"
    ]),
    CarMake(name: "Lexus", models: [
        "CT 200h", "ES", "GS", "GX", "IS", "LC", "LFA", "LM", "LS", "LX", "NX", "RC",
        "RC F", "RX", "RZ", "SC", "TX", "UX"
    ]),
    CarMake(name: "Lincoln", models: [
        "Aviator", "Continental", "Corsair", "MKC", "MKT", "MKX", "MKZ", "Nautilus",
        "Navigator", "Star", "Town Car"
    ]),
    CarMake(name: "Lotus", models: [
        "Eletre", "Elise", "Emira", "Evija", "Evora", "Exige", "Emeya"
    ]),
    CarMake(name: "Maserati", models: [
        "GranCabrio", "GranTurismo", "Ghibli", "GranSport", "GranTurismo Folgore", "Grecale",
        "Levante", "MC20", "Quattroporte"
    ]),
    CarMake(name: "Mazda", models: [
        "2", "3", "6", "CX-3", "CX-30", "CX-5", "CX-50", "CX-60", "CX-70", "CX-80", "CX-90",
        "MX-5 Miata", "MX-30", "RX-7", "RX-8"
    ]),
    CarMake(name: "McLaren", models: [
        "540C", "570S", "600LT", "620R", "650S", "675LT", "720S", "750S", "765LT", "Artura",
        "Elva", "GT", "P1", "Senna", "Speedtail"
    ]),
    CarMake(name: "Mercedes-Benz", models: [
        "A-Class", "AMG GT", "B-Class", "C-Class", "CLA", "CLS", "E-Class", "EQA", "EQB",
        "EQC", "EQE", "EQE SUV", "EQS", "EQS SUV", "G-Class", "GLA", "GLB", "GLC", "GLE",
        "GLS", "S-Class", "SL", "SLC", "V-Class"
    ]),
    CarMake(name: "MINI", models: [
        "Aceman", "Clubman", "Convertible", "Countryman", "Coupe", "Hatch", "John Cooper Works",
        "Paceman", "Roadster"
    ]),
    CarMake(name: "Mitsubishi", models: [
        "ASX", "Colt", "Eclipse Cross", "Galant", "i-MiEV", "L200", "Lancer", "Lancer Evolution",
        "Outlander", "Outlander PHEV", "Pajero", "Space Star"
    ]),
    CarMake(name: "Nissan", models: [
        "350Z", "370Z", "Armada", "Ariya", "Cube", "Frontier", "GT-R", "Juke", "Kicks",
        "Leaf", "Maxima", "Murano", "Navara", "Note", "Pathfinder", "Patrol", "Qashqai",
        "Rogue", "Sentra", "Skyline", "Titan", "Versa", "X-Trail"
    ]),
    CarMake(name: "Pagani", models: [
        "Huayra", "Huayra BC", "Huayra Roadster", "Utopia", "Zonda", "Zonda Cinque", "Zonda R"
    ]),
    CarMake(name: "Peugeot", models: [
        "106", "107", "108", "206", "207", "208", "307", "308", "3008", "407", "408", "508",
        "5008", "e-208", "e-2008", "Partner", "Rifter"
    ]),
    CarMake(name: "Porsche", models: [
        "718 Boxster", "718 Cayman", "911", "918 Spyder", "944", "Cayenne", "Cayenne Coupe",
        "Cayenne E-Hybrid", "Macan", "Macan Electric", "Panamera", "Taycan", "Taycan Cross Turismo"
    ]),
    CarMake(name: "RAM", models: [
        "1500", "1500 Classic", "2500", "3500", "ProMaster", "ProMaster City", "TRX"
    ]),
    CarMake(name: "Renault", models: [
        "Arkana", "Austral", "Captur", "Clio", "Espace", "Kadjar", "Kangoo", "Megane",
        "Megane E-Tech", "Scenic", "Symbioz", "Trafic", "Twingo", "Zoe"
    ]),
    CarMake(name: "Rivian", models: [
        "R1S", "R1T", "R2", "R3"
    ]),
    CarMake(name: "Rolls-Royce", models: [
        "Black Badge Ghost", "Black Badge Wraith", "Cullinan", "Dawn", "Ghost", "Phantom",
        "Silver Shadow", "Silver Spur", "Spectre", "Wraith"
    ]),
    CarMake(name: "Subaru", models: [
        "Ascent", "BRZ", "Crosstrek", "Forester", "Impreza", "Legacy", "Levorg", "Outback",
        "Solterra", "WRX", "WRX STI", "XV"
    ]),
    CarMake(name: "Tesla", models: [
        "Cybertruck", "Model 3", "Model S", "Model X", "Model Y", "Roadster"
    ]),
    CarMake(name: "Toyota", models: [
        "4Runner", "86", "Alphard", "Avalon", "bZ4X", "Camry", "C-HR", "Corolla", "Corolla Cross",
        "Crown", "FJ Cruiser", "GR86", "GR Corolla", "GR Supra", "Highlander", "Land Cruiser",
        "Mirai", "Prado", "Prius", "Prius Prime", "RAV4", "RAV4 Prime", "Sequoia", "Sienna",
        "Supra", "Tacoma", "Tundra", "Venza", "Yaris"
    ]),
    CarMake(name: "Volkswagen", models: [
        "Amarok", "Arteon", "Atlas", "Caddy", "Golf", "Golf GTI", "Golf R", "ID.3", "ID.4",
        "ID.5", "ID.6", "ID.7", "Jetta", "Passat", "Polo", "Sharan", "T-Cross", "T-Roc",
        "Taigo", "Tiguan", "Touareg", "Touran", "Transporter", "Up!"
    ]),
    CarMake(name: "Volvo", models: [
        "C30", "C40 Recharge", "EX30", "EX40", "EX90", "S40", "S60", "S90", "V40", "V60",
        "V70", "V90", "XC40", "XC40 Recharge", "XC60", "XC70", "XC90"
    ])
].sorted { $0.name < $1.name }

func make(named name: String) -> CarMake? {
    allCarMakes.first { $0.name.lowercased() == name.lowercased() }
}

var makeNames: [String] {
    allCarMakes.map { $0.name }
}
