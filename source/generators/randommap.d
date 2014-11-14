import std.random;
import map;
import tile;

class RandomMapGenerator : MapGenerator {
    void generate(ref Map map) {
        foreach (i; 0 .. map.bounds.width + 1) {
            Tile[] row;
            foreach (j; 0 .. map.bounds.height + 1) {
                Tile[] tile_choices = [new FloorTile, new WallTile];
                auto tile_chances = [30, 3];
                row ~= tile_choices[dice(tile_chances)];
            }
            map.tiles ~= row;
        }
    }
}
