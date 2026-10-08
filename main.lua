local mod = ...

mod.hooks:wrap("ui.start_menu.items", function(next, game, items)
  local result = next(game, items) or items
  
  -- Etichetta corta per non sbordare dal menu di Gen 2
  mod.ui.insertBefore(result, "SAVE", {
    label = "TIME",
    onSelect = function()
      -- Definiamo le opzioni del sottomenù
      local menuItems = {
        { label = "AUTO", value = "AUTO" },
        { label = "MORN", value = "MORN" },
        { label = "DAY",  value = "DAY" },
        { label = "NITE", value = "NITE" }
      }
      
      -- Creiamo il sottomenù a tendina
      local subMenu
      subMenu = mod.ui.ListMenu.new(game, "SET TIME", menuItems, {
        kind = "time_switcher_menu",
        onChoose = function(item)
          local newState = item.value
          
          if game.world then
            -- Salva la VERA funzione dell'orologio se non è già salvata
            if not game.world._originalTimeOfDay then
              game.world._originalTimeOfDay = game.world.timeOfDay
            end

            if newState == "AUTO" then
              game.world.timeOfDay = game.world._originalTimeOfDay
            else
              -- Sovrascrive con la NUOVA funzione
              game.world.timeOfDay = function(self)
                return newState
              end
            end
          end
          
          -- Chiude il sottomenù
          subMenu:close()
          -- Chiude anche il menu START per farti vedere subito il cambio di luce
          if game.stack then game.stack:pop() end
        end
      })
      
      -- Spinge il sottomenù a schermo
      game.stack:push(subMenu)
    end
  })
  
  return result
end)