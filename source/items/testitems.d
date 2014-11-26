import item;
import equipment;

class TestSword : Equipment {
    mixin registerItem;
    this() {
        name = "Test Sword";
        shortDescription = "A Test Sword";
        longDescription = "This sword is a test. Go figure.";
    }
}

class TestSpear: Equipment {
    mixin registerItem;
    this() {
        name = "Test Spear";
        shortDescription = "A Test Spear";
        longDescription = "This spear is a test. Go figure.";
    }
}
