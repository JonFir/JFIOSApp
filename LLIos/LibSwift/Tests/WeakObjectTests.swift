import Testing
@testable import LibSwift

class TestObject {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

struct WeakObjectTests {
    
    @Test
    func initializesWithObject() {
        let obj = TestObject(name: "test")
        let weakRef = WeakObject(obj)
        
        #expect(weakRef.value != nil)
        #expect(weakRef.value?.name == "test")
    }
    
    @Test
    func holdsWeakReferenceToObject() {
        var obj: TestObject? = TestObject(name: "test")
        let weakRef = WeakObject(obj!)
        
        #expect(weakRef.value != nil)
        
        obj = nil
        
        #expect(weakRef.value == nil)
    }
    
    @Test
    func multipleWeakReferencesToSameObject() {
        var obj: TestObject? = TestObject(name: "shared")
        let weakRef1 = WeakObject(obj!)
        let weakRef2 = WeakObject(obj!)
        let weakRef3 = WeakObject(obj!)
        
        #expect(weakRef1.value != nil)
        #expect(weakRef2.value != nil)
        #expect(weakRef3.value != nil)
        
        #expect(weakRef1.value?.name == "shared")
        #expect(weakRef2.value?.name == "shared")
        #expect(weakRef3.value?.name == "shared")
        
        obj = nil
        
        #expect(weakRef1.value == nil)
        #expect(weakRef2.value == nil)
        #expect(weakRef3.value == nil)
    }
}
