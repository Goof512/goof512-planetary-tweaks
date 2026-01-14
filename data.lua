require "__rubia__.lib.lib"

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
            {type="unlock-recipe", recipe="wood-craptonite"},
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


end