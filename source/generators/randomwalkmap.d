module generators.randomwalkmap;

import std.algorithm;
import std.random;
import std.stdio;
import logger;
import map;
import tile;
import util;

class RandomWalkMapGenerator : MapGenerator {
    void generate(ref Map map) {
        auto curr = Point(1, 1);
        Point[] points;
        while (points.length < map.bounds.width * map.bounds.height) {
            points ~= curr;
            Point[] movementChoices;
            if (map.bounds.min.x + 1 < curr.x)
                movementChoices ~= Point(-1, 0);
            if (curr.x < map.bounds.max.x - 2)
                movementChoices ~= Point(1, 0);
            if (map.bounds.min.y + 1 < curr.y)
                movementChoices ~= Point(0, -1);
            if (curr.y < map.bounds.max.y - 2)
                movementChoices ~= Point(0, 1);
            logDebug("Movement choices: %s", movementChoices);
            auto choiceIndex = uniform(0, movementChoices.length);
            auto choice = movementChoices[choiceIndex];
            logDebug("Choice: %s", choice);
            curr += choice;
        }

        logDebug("Walk Points: %s", points);

        Tile[][] tiles;
        // Fill the map with blank tiles
        foreach (i; 0 .. map.bounds.width + 1) {
            Tile[] row;
            foreach (j; 0 .. map.bounds.height + 1) {
                Tile t;
                t = new Tile;
                row ~= t;
            }
            tiles ~= row;
        }

        // Fill in the walls as anything in the neighborhood of a point on the path
        foreach (point; points) {
            foreach (wall; point.neighborhood()) {
                // The neighborhood function knows nothing about the map bounds, so we need to check them
                if (map.bounds.contains(wall)) {
                    tiles[wall.x][wall.y] = new WallTile;
                }
            }
        }

        // Fill in the path
        foreach (point; points) {
            tiles[point.x][point.y] = new FloorTile;
        }

        map.tiles = tiles;

        // move each entity to a valid position
        foreach (entity; map.world.entities) {
            entity.position = points[uniform(0, points.length)];
        }

    }
}
