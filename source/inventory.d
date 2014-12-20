import std.conv;
import std.algorithm;

import item;
import equipment;

class Inventory {
    Item[] items;
    Equipment[] equipment;

    // Try to equip the item
    void equip(Item item) {
        if (canEquip(item)) {
            equipment ~= item.to!Equipment;
        }
    }

    void unequip(Item item) {
        if (item.canEquip && equipment.canFind(item.to!Equipment)) {
            auto index = equipment.length - equipment.find(item).length;
            equipment = equipment.remove(index);
        }
    }

    bool canEquip(Item item) {
        EquipRegion[] regions;
        foreach (equip; equipment) {
            foreach (region; equip.regions) {
                regions ~= region;
            }
        }
        foreach (region; item.to!Equipment.regions) {
            if (regions.canFind(region)) return false;
        }
        return item.canEquip
            && !equipment.canFind(item.to!Equipment);
    }
}
