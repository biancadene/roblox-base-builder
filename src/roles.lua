-- roles.lua
-- Humans vs Zombies role management for Roblox Base Builder
-- All players start as humans, initial zombies are selected, humans convert to zombies on death

local RolesSystem = {}

-- Player roles table
RolesSystem.playerRoles = {} -- key: player.UserId, value: "Human" or "Zombie"

-- Initialize roles at the start of a round
function RolesSystem:startRound(players)
    for _, player in ipairs(players) do
        self.playerRoles[player.UserId] = "Human"
    end
end

-- Select initial zombies when attack phase starts
function RolesSystem:selectInitialZombies(players, numZombies)
    local humans = {}
    for _, player in ipairs(players) do
        if self.playerRoles[player.UserId] == "Human" then
            table.insert(humans, player)
        end
    end

    -- Shuffle humans
    for i = #humans, 2, -1 do
        local j = math.random(i)
        humans[i], humans[j] = humans[j], humans[i]
    end

    -- Assign initial zombies
    for i = 1, math.min(numZombies, #humans) do
        self.playerRoles[humans[i].UserId] = "Zombie"
    end
end

-- Convert a human to zombie (when killed/infected)
function RolesSystem:convertToZombie(player)
    self.playerRoles[player.UserId] = "Zombie"
end

-- Check role of a player
function RolesSystem:getRole(player)
    return self.playerRoles[player.UserId] or "Human"
end

-- Reset roles for a new round
function RolesSystem:resetRound(players)
    self:startRound(players)
end

return RolesSystem
