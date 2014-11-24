import item;

class TestSword : Item {
    mixin registerItem;
    this() {
        name = "Test Sword";
        shortDescription = "A Test Sword";
        longDescription = "This sword is a test. Go figure.";
    }
}
