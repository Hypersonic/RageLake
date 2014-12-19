import std.conv;
import std.algorithm;

import item;
import equipment;

class Inventory {
    Item[] items;
    Equipment[] equipment;

    // Try to equip the item
    void equip(Item item) {
        if (item.canEquip && !equipment.canFind(item.to!Equipment)) {
            equipment ~= item.to!Equipment;
        }
    }

    void unequip(Item item) {
        if (item.canEquip && equipment.canFind(item.to!Equipment)) {
            auto index = equipment.length - equipment.find(item).length;
            equipment = equipment.remove(index);
        }
    }
}
