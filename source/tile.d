import util;

enum TileType {
    FLOOR_TILE,
    WALL_TILE
}

struct Tile {
    TileType type;
    @property Cell cell() {
        final switch(type) {
            case TileType.FLOOR_TILE:
                return Cell('.', Color.UNIMPORTANT);
            case TileType.WALL_TILE:
                return Cell('#', Color.NORMAL);
        }
    }
}
