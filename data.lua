require "__rubia__.lib.lib"
local asteroid_util = require("__secretas__.prototypes.planet.asteroid-spawn-definitions")
if mods["wood-logistics"] then

    if settings.startup["wood-logistics-cargo-wagon"].value then
        local rubiaCargoWagonRecipe = data.raw["recipe"]["rubia-armored-cargo-wagon"]
        for _, ingredient in pairs(rubiaCargoWagonRecipe.ingredients) do
           if ingredient.name == "cargo-wagon" then
              ingredient.name = "wood-cargo-wagon"
              break
           end
        end
    end

    data:extend({
        {
            type = "technology",
            name = "crappy-logs",
            icon = "__goof512-planetary-tweaks__/graphics/technology/crappy-logs.png",
            icon_size = 256,
            effects = {
                {
                    type="unlock-recipe", recipe="wood-craptonite",
                },
            },
            prerequisites = {"craptonite-processing"},
            research_trigger = {type = "craft-item", item="yeet-craptonite-frame", count=50},
        },{
            type ="recipe",
            name ="wood-craptonite",
            icons = {
                    {icon=data.raw.item["craptonite-frame"].icon, shift={-12, -12}, scale=0.4},
                    {icon=data.raw.item["rubia-cupric-scrap"].icon, shift={12, -12}, scale=0.4},
                    {icon="__base__/graphics/icons/wood.png", scale=0.7},
            },
            category = "biorecycling",
            subgroup = "rubia-biorecycling", order = "e[rubia stage3]-l",
            enabled = false,
            ingredients = {
              {type ="item", name ="rubia-cupric-scrap", amount = 2},
              {type ="item", name ="rubia-bacteria-B", amount = 4},
              {type ="item", name ="craptonite-frame", amount = 1},
            },
            surface_conditions = {
                {
                    property="rubia-wind-speed",
                    min=250,
                },
            },
            energy_required = 6,
            results = {
              {type ="item", name ="wood", amount = 1},
              {type ="item", name ="craptonite-chunk", amount = 1},
            },
            main_product = "wood",
            allow_productivity = true,
            crafting_machine_tint = crafting_machine_tint_brown,
        },
    })

    -- local AsteroidTech = data.raw["technology"]["space-discovery-asteroid-belt"]
    -- AsteroidTech.prerequisites = {"interstellar-science-pack", "rocket-turret"}
    -- local AsteroidTechIngredients = AsteroidTech.unit.ingredients
    -- AsteroidTechIngredients[AsteroidTechIngredients# + 1] = {"interstellar-science-pack", 1}
end

function ReplaceAllIngredientItemWithItem(Item1 , Item2)
	for i, recipe in pairs(data.raw["recipe"]) do
	    local ingredients = data.raw["recipe"][recipe.name].ingredients
	    if ingredients then
            for v, ingredient in pairs(ingredients) do
                if ingredient.type == "item" then
                    if ingredient.name == Item1 then
                        ingredient.name = Item2
                    elseif ingredient[1] == Item1 then
                        ingredient[1] = Item2
                    end
                end
            end
        end
        if main_product == Item1 then
            main_product = Item2
        elseif main_product == Item1.name then
            main_product = Item2.name
        end
        if recipe.results then
            for v, result in pairs(recipe.results) do
                if result.type == "item" then
                    if result.name == Item1 then
                        result.name = Item2
                    elseif result[1] == Item1 then
                        result[1] = Item2
                    end
                end
            end
        end
	end
end

-- removes the duplicated PU239 and PU238's from the isotopes tab.
data.raw["item"]["ske_plutonium_239"] = nil
data.raw["item"]["ske_plutonium_238"] = nil
ReplaceAllIngredientItemWithItem("ske_plutonium_239", "plutonium-239")
ReplaceAllIngredientItemWithItem("ske_plutonium_238", "plutonium-238")

-- make biolab need plutonium-238
local biolabRecipe = data.raw["recipe"]["biolab"]
for _, ingredient in pairs(biolabRecipe.ingredients) do
   if ingredient.name == "uranium-235" then
      ingredient.name = "plutonium-238"
      break
   end
end

--remove fungi-cultural tower, and change the ag tower to compensate
local agriculturalTower = data.raw["agricultural-tower"]["agricultural-tower"]
for _, surfaceCondition in pairs(agriculturalTower.surface_conditions) do
    if surfaceCondition.property == "pressure" then
        surfaceCondition.max = 2500
        break
    end
end

local techs = {"lichen-cultivation", "eschatotaxite-farming"}

for _, techName in pairs(techs) do
    local lichenTech = data.raw["technology"][techName]
    local fungicultureIndex = 0
    for index, unlock in pairs(lichenTech.effects) do
        if unlock.type == "unlock-recipe" and unlock.recipe == "fungicultural-tower" then
           fungicultureIndex = index
           break
        end
    end
    if fungicultureIndex ~= 0 then
        table.remove(lichenTech.effects, fungicultureIndex)
    end
end

data.raw["item"]["fungicultural-tower"] = nil
data.raw["recipe"]["fungicultural-tower"] = nil
data.raw["agricultural-tower"]["fungicultural-tower"] = nil


--move problem planets
local muria = data.raw["planet"]["muria"]
muria.distance = 38

local vesta = data.raw["planet"]["vesta"]
vesta.distance = 44
vesta.solar_power_in_space = 60
vesta.surface_properties["solar-power"] = 10
vesta.orientation = 0.05

--setup new space connections

data.raw["space-connection"]["fulgora-vesta"] = nil
data.raw["space-connection"]["gleba-muria"] = nil
data.raw["space-connection"]["nauvis-corrundum"] = nil

local muriaOuterConn = table.deepcopy(data.raw["space-connection"]["asteroid-belt-outer-edge-aquilo"])
muriaOuterConn.name = "asteroid-belt-outer-edge-muria"
muriaOuterConn.from = "asteroid-belt-outer-edge"
muriaOuterConn.to = "muria"
muriaOuterConn.distance = 40000

data:extend({
    {
		type = "space-connection",
		name = "muria-vesta",
		subgroup = "planet-connections",
		from = "muria",
		to = "vesta",
		order = "h",
		length = 60000,
		asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.fulgora_aquilo)
	},{
      		type = "space-connection",
      		name = "secretas-vesta",
      		subgroup = "planet-connections",
      		from = "secretas",
      		to = "vesta",
      		order = "h",
      		length = 120000,
      		asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.aquilo_secretas)
    }, muriaOuterConn,
})

--lock muria cargo drops
local muriaCargoLock = PlanetsLib.cargo_drops_technology_base("muria",
    "__Muria-Graphics__/graphics/icons/starmap-planet-muria.png", 512)
muriaCargoLock.prerequisites = { "muriatic-science-pack"}
muriaCargoLock.unit = {
   count = 100,
   ingredients = {
       { "muriatic-science-pack", 1 },
   },
   time = 30,
}
data:extend({
    {},
    muriaCargoLock
})

local techs = { "planet-discovery-muria", "planet-discovery-paracelsin"}

for _, techName in pairs(techs) do
    -- modify muria location behind asteroid-belt
    local tech = data.raw["technology"][techName]
    for index, prerequisite in pairs(tech.prerequisites) do
        if prerequisite == "rocket-turret" then
            tech.prerequisites[index] = "space-discovery-asteroid-belt"
        end
    end
end

local prometheumTech = data.raw["technology"]["promethium-science-pack"]
prometheumTech.prerequisites[#prometheumTech.prerequisites] = "gas-manipulation-science-pack"
prometheumTech.prerequisites[#prometheumTech.prerequisites] = "golden-science-pack"

