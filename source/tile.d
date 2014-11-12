import util;

enum TileType {
    NONE,
    FLOOR,
    WALL,
}

class Tile {
    TileType type = TileType.NONE;

    @property Cell cell() {
        return Cell(' ', Color.UNIMPORTANT);
    }
}

class FloorTile : Tile {
    @property this() {
        this.type = TileType.FLOOR;
    }

    override @property Cell cell() {
        return Cell('.', Color.UNIMPORTANT);
    }
}

class WallTile : Tile {
    this() {
        this.type = TileType.WALL;
    }

    override @property Cell cell() {
        return Cell('#', Color.NORMAL);
    }
}
