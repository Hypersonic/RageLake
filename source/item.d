import util;

class Item {
    string name = "Unnamed Item";
    string shortDescription = "Undescribed.";
    string longDescription = "This item is undescribable, as the describer has not described it descriptively.";
    Cell cell;
    this() {
        cell = Cell('i', Color.ITEM);
    }

    bool canEquip() {
        return false;    
    }
}

Item function()[] itemList = []; // This list will contain functions that return each kind of item

// Simple template to add a static constructor that puts the class this is mixed into in the itemList
// Requires that the class is a subclass of Item
mixin template registerItem() {
    static if (is(this : Item)) {
        static this() { itemList ~= () => new this(); }
    } else {
        alias T = this; // We need to alias here because using `this` on it's own causes a compilation error (possible compiler bug?)
        static assert(false, "Trying to register a class for the item registry which is not a subclass of Item: " ~ __traits(identifier, T));
    }
}



import entity;
class ItemEntity : Entity {
    this(Item item) {
        super();
        this.inventory.items ~= item;
        cell = item.cell;
        normalColor = Color.ITEM;
    }

    override Action update(World world) {
        this.desiredAction = new Action(this);
        super.update(world);
        return this.desiredAction;
    }

    // HACK: This should really be put in an action, do this later. We shouldn't be taking over the takeHit method for this
    override void takeHit(Entity hitter, int damage) {
        foreach (item; this.inventory.items) {
            hitter.inventory.items ~= item;
        }
        this.inventory.items = [];
        this.normalColor = Color.OPENED;
        this.alive = false;
    }
}
