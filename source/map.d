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
        foreach (i; 0 .. bounds.width + 1) {
            Tile[] row;
            foreach (j; 0 .. bounds.height + 1) {
                row ~= dice(30, 3) == 0 ? new FloorTile : new WallTile;
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
