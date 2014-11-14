import std.algorithm;
import std.random;
import std.stdio;
import logger;
import map;
import tile;
import util;

class RandomWalkMapGenerator : MapGenerator {
    void generate(ref Map map) {
        auto curr = Point(0, 0);
        Point[] points;
        while (points.length < map.bounds.width * map.bounds.height) {
            points ~= curr;
            Point[] movementChoices;
            if (map.bounds.min.x + 1 < curr.x)
                movementChoices ~= Point(-1, 0);
            if (curr.x < map.bounds.max.x)
                movementChoices ~= Point(1, 0);
            if (map.bounds.min.y + 1 < curr.y)
                movementChoices ~= Point(0, -1);
            if (curr.y < map.bounds.max.y)
                movementChoices ~= Point(0, 1);
            logDebug("Movement choices: %s", movementChoices);
            auto choiceIndex = uniform(0, movementChoices.length);
            auto choice = movementChoices[choiceIndex];
            logDebug("Choice: %s", choice);
            curr += choice;
        }

        logDebug("Walk Points: %s", points);

        foreach (i; 0 .. map.bounds.width + 1) {
            Tile[] row;
            foreach (j; 0 .. map.bounds.height + 1) {
                Tile t = canFind(points, Point(i, j)) ? new FloorTile : new WallTile;
                row ~= t;
            }
            map.tiles ~= row;
        }
    }
}
