import std.random;
import std.algorithm;

import tile;
import display;
import util : Point, Bounds;
import logger;

class Map {
    Tile[][] tiles;
    Bounds bounds;

    this(int width = 100, int height = 100) {
        this.bounds = Bounds(Point(0, 0), Point(width, height));
        // TODO: Factor this to a seperate, proper generator function
        foreach (i; 0 .. bounds.width + 1) {
            Tile[] row;
            foreach (j; 0 .. bounds.height + 1) {
                Tile[] tile_choices = [new FloorTile, new WallTile];
                auto tile_chances = [30, 3];
                row ~= tile_choices[dice(tile_chances)];
            }
            this.tiles ~= row;
        }
    }

    Tile getTile(Point p) {
        if (bounds.contains(p)) {
            logError("%s is inside %s", p, bounds);
            return tiles[p.x][p.y];
        } else {
            logError("%s is outside %s", p, bounds);
            return new Tile;
        }
    }

    void render(RenderDepth rd, Display d) {
        if (rd != RenderDepth.BG) return;
        foreach(x; bounds.min.x .. bounds.max.x) {
            foreach(y; bounds.min.y .. bounds.max.y) {
                auto tile = tiles[x][y];
                auto cell = tile.cell;
                d.drawCell(Point(cast(int) x, cast(int) y), cell);
            }
        }
    }
}
