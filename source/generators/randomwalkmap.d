module generators.randomwalkmap;

import std.algorithm;
import std.random;
import std.stdio;
import std.math;
import std.conv;

import logger;
import map;
import tile;
import util;

class RandomWalkMapGenerator : MapGenerator {
    void generate(ref Map map) {
        auto curr = Point(map.bounds.width / 2, map.bounds.height / 2);
        Point[] points;
        while (points.length < (map.bounds.width * map.bounds.height) / 10) {
            points ~= curr;
            Point[] movementChoices;
            foreach (i; 0 .. abs(curr.x - (map.bounds.min.x + 1)).to!float.log * 2)
                movementChoices ~= Point(-1, 0);
            foreach (i; 0 .. abs(curr.x - (map.bounds.max.x - 2)).to!float.log * 2)
                movementChoices ~= Point(1, 0);
            foreach (i; 0 .. abs(curr.y - (map.bounds.min.y + 1)).to!float.log)
                movementChoices ~= Point(0, -1);
            foreach (i; 0 .. abs(curr.y - (map.bounds.max.y - 2)).to!float.log)
                movementChoices ~= Point(0, 1);
            logDebug("Movement choices: %s", movementChoices);
            auto choiceIndex = uniform(0, movementChoices.length);
            auto choice = movementChoices[choiceIndex];
            logDebug("Choice: %s", choice);
            curr += choice;
        }

        logDebug("Walk Points: %s", points);

        Tile[][] tiles = new Tile[][](map.bounds.width + 1, map.bounds.height + 1);
        // Fill the map with blank tiles
        foreach (i; 0 .. map.bounds.width + 1) {
            foreach (j; 0 .. map.bounds.height + 1) {
                Tile t;
                tiles[i][j] = new Tile;
            }
        }

        // Fill in the walls as anything in the neighborhood of a point on the path
        foreach (point; points) {
            foreach (wall; point.neighborhood) {
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
