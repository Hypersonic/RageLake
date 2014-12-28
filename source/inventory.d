import std.conv;
import std.algorithm;

import item;
import equipment;
import entity;

class Inventory {
    Entity owner;
    Item[] items;
    Equipment[] equipment;

    this(Entity owner) {
        this.owner = owner;
    }

    // Try to equip the item
    void equip(Item item) {
        if (canEquip(item)) {
            equipment ~= item.to!Equipment;
        }
    }

    void unequip(Item item) {
        if (cast(Equipment) item !is null && equipment.canFind(item.to!Equipment)) {
            auto index = equipment.length - equipment.find(item).length;
            equipment = equipment.remove(index);
        }
    }

    bool canEquip(Item item) {
        EquipRegion[] regions;
        foreach (region; owner.regions) {
            regions ~= region;
        }
        foreach (equip; equipment) {
            foreach (region; equip.regions) {
                if (regions.canFind(region)) {
                    auto index = regions.length - regions.find(region).length;
                    regions = regions.remove(index);
                }
            }
        }
        foreach (region; item.to!Equipment.regions) {
            if (!regions.canFind(region)) return false;
        }
        return cast(Equipment) item !is null
            && !equipment.canFind(item.to!Equipment);
    }
}
