import std.random;

import tile;
import util : Point, Bounds;

class Map {
    Tile[][] tiles;
    Bounds bounds;

    this(int width = 1000, int height = 1000) {
        this.bounds = Bounds(Point(0, 0), Point(width, height));
        foreach (i; 0 .. width) {
            Tile[] row;
            foreach (j; 0 .. height) {
                row ~= Tile( dice(30, 3) == 0 ? TileType.FLOOR_TILE : TileType.WALL_TILE);
            }
            this.tiles ~= row;
        }
    }

    Tile getTile(Point p) {
        if (bounds.contains(p)) {
            return tiles[p.x][p.y];
        } else {
            return Tile(TileType.WALL_TILE);
        }
    }
}
