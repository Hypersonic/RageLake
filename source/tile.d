enum TileType {
    FLOOR_TILE,
    WALL_TILE
}

struct Tile {
    TileType type;
    @property char glyph() {
        final switch(type) {
            case TileType.FLOOR_TILE:
                return '.';
            case TileType.WALL_TILE:
                return '#';
        }
    }
}
