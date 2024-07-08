import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Prelude "mo:base/Prelude";

actor AchievementTracker {
    // Definición de un logro
    type Achievement = {
        id: Nat;
        name: Text;
        description: Text;
    };
    
    // Definición de un jugador
    type Player = {
        id: Nat;
        name: Text;
        achievements: [Achievement];
    };
    
    // Estado del actor
    var players: [Player] = [];
    var nextPlayerId: Nat = 0;
    var nextAchievementId: Nat = 0;

    // Agregar un jugador
    public func addPlayer(name: Text): async Player {
        let newPlayer: Player = {
            id = nextPlayerId;
            name = name;
            achievements = [];
        };
        players := Array.append(players, [newPlayer]);
        nextPlayerId += 1;
        return newPlayer;
    };

    // Eliminar un jugador
    public func removePlayer(playerId: Nat): async Bool {
        let initialLength = Array.size(players);
        players := Array.filter<Player>(players, func (player) { player.id != playerId });
        return Array.size(players) < initialLength;
    };
    // Agregar un logro a un jugador
    public func addAchievementToPlayer(playerId: Nat, name: Text, description: Text): async ?Achievement {
        let achievement: Achievement = {
            id = nextAchievementId;
            name = name;
            description = description;
        };
        nextAchievementId += 1;
        
        var found: Bool = false;
        var updatedPlayers: [Player] = Array.map<Player, Player>(players, func (player) {
            if (player.id == playerId) {
                found := true;
                { player with achievements = Array.append(player.achievements, [achievement]) }
            } else {
                player
            }
        });
        players := updatedPlayers;
        
        if (found) {
            Debug.print("New achievement added: " # name);
            return ?achievement;
        } else {
            return null;
        }
    };

        // Obtener logros de un jugador
    public func getPlayerAchievements(playerId: Nat): async ?[Achievement] {
        for (player in players.vals()) {
            if (player.id == playerId) {
                return ?player.achievements;
            }
        };
        return null;
    };

        // Notificar a un jugador
    public func notifyPlayer(playerId: Nat, message: Text): async Bool {
        for (player in players.vals()) {
            if (player.id == playerId) {
                Debug.print("Notification to " # player.name # ": " # message);
                return true;
            }
        };
        return false;
    };


        // Obtener estadísticas de logros
    public func getAchievementStats(): async (totalAchievements: Nat, mostCommonAchievement: ?Achievement) {
        var achievementCount: Nat = 0;
        
        for (player in players.vals()) {
            achievementCount += Array.size(player.achievements);
        };
        
        return (achievementCount, null);
    };
};