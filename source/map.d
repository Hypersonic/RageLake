import std.random;
import std.algorithm;
import world;
import tile;
import display;
import util : Point, Bounds;
import logger;

class Map {
    Tile[][] tiles;
    Bounds bounds;
    World world;

    this(World world, MapGenerator generator, int width=400, int height=200) {
        this.bounds = Bounds(Point(0, 0), Point(width, height));
        this.world = world;
        generator.generate(this);
    }

    Tile getTile(Point p) {
        if (bounds.contains(p)) {
            return tiles[p.x][p.y];
        } else {
            return new Tile;
        }
    }

    void render(Display d) {
        foreach(x; bounds.min.x .. bounds.max.x) {
            foreach(y; bounds.min.y .. bounds.max.y) {
                auto tile = tiles[x][y];
                auto cell = tile.cell;
                d.drawCell(Point(cast(int) x, cast(int) y), cell);
            }
        }
    }
}

interface MapGenerator {
    void generate(ref Map map);
}
