module items.testitems;

import std.math;

import entity;
import item;
import equipment;
import action;

class Sword : Equipment {
    mixin registerItem;
    this() {
        name = "Sword";
        shortDescription = "A Sword";
        longDescription = "This steel sword has looks sturdy and strong.";
        maxDurability = 10;
        durability = maxDurability;
        regions = [EquipRegion.RIGHT_ARM];
    }

    override void onAttack(ref Entity equipee, AttackAction attack) {
        double multiplier = 3;
        if (durability > 0) {
            attack.damage = cast(int) ceil(multiplier * attack.damage);
            durability--;
        }
    }
}

class Spear: Equipment {
    mixin registerItem;
    this() {
        name = "Spear";
        shortDescription = "A Spear";
        longDescription = "A long, wooden spear with a point of solid steel.";
        maxDurability = 11;
        durability = maxDurability;
        regions = [EquipRegion.RIGHT_ARM, EquipRegion.LEFT_ARM];
    }

    override void onAttack(ref Entity equipee, AttackAction attack) {
        double multiplier = 5;
        if (durability > 0) {
            attack.damage = cast(int) ceil(multiplier * attack.damage);
            durability--;
        }
    }
}

class Shield : Equipment {
    mixin registerItem;
    this() {
        name = "Shield";
        shortDescription = "A Shield";
        longDescription = "This should protect you. Hopefully.";
        maxDurability = 10;
        durability = maxDurability;
        regions = [EquipRegion.LEFT_ARM];
    }

    override void onDefend(ref Entity equipee, AttackAction attack) {
        double debuff = 1;
        if (durability > 0) {
            attack.damage -= debuff;
            if (attack.damage < 0) attack.damage = 0;
            durability--;
        }
    }
}

class TestItem : Item {
    mixin registerItem;
    this() {
        name = "Test Item";
        shortDescription = "A Test Item";
        longDescription = "This item is a test. Wow.";
    }
}
