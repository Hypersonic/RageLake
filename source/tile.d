import util;

class Tile {
    @property Cell cell() {
        return Cell(' ', Color.UNIMPORTANT);
    }
}

class FloorTile : Tile {
    override @property Cell cell() {
        return Cell('.', Color.UNIMPORTANT);
    }
}

class WallTile : Tile {

    override @property Cell cell() {
        return Cell('#', Color.NORMAL);
    }
}
