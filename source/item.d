class Item {
    string name = "Unnamed Item";
    string shortDescription = "Undescribed.";
    string longDescription = "This item is undescribable, as the describer has not described it descriptively.";
}

Item function()[] itemList = []; // This list will contain functions that return each kind of item

// Simple template to add a static constructor that puts the class this is mixed into in the itemList
// Requires that the class is a subclass of Item
mixin template registerItem() {
    static this() { itemList ~= function Item() { return new this(); }; }
}
