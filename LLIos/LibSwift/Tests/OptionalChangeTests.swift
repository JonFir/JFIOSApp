import Testing
@testable import LibSwift

struct OptionalChangeTests {
    
    @Test
    func keepReturnsCurrentValueWhenNonNil() {
        let current = "existing"
        let change = OptionalChange<String>.keep
        
        let result = change.value(current)
        
        #expect(result == current)
    }
    
    @Test
    func keepReturnsNilWhenCurrentIsNil() {
        let current: String? = nil
        let change = OptionalChange<String>.keep
        
        let result = change.value(current)
        
        #expect(result == current)
    }
    
    @Test
    func setReturnsNewValueWhenCurrentIsNonNil() {
        let new = "new"
        let change = OptionalChange<String>.set(new)

        let result = change.value("existing")

        #expect(result == new)
    }
    
    @Test
    func setReturnsNewValueWhenCurrentIsNil() {
        let new = "new"
        let change = OptionalChange<String>.set(new)

        let result = change.value(nil)

        #expect(result == new)
    }
    
    @Test
    func clearReturnsNilWhenCurrentIsNonNil() {
        let change = OptionalChange<String>.clear
        
        let result = change.value("existing")

        #expect(result == nil)
    }
    
    @Test
    func clearReturnsNilWhenCurrentIsNil() {
        let change = OptionalChange<String>.clear
        
        let result = change.value(nil)

        #expect(result == nil)
    }
    
    @Test
    func operatorKeepReturnsCurrentValue() {
        let current = "existing"
        let change = OptionalChange<String>.keep
        
        let result = change ?? current
        
        #expect(result == current)
    }
    
    @Test
    func operatorSetReturnsNewValue() {
        let new = "new"
        let change = OptionalChange<String>.set(new)

        let result = change ?? "existing"

        #expect(result == new)
    }
    
    @Test
    func operatorClearReturnsNil() {
        let change = OptionalChange<String>.clear
        
        let result = change ?? "existing"

        #expect(result == nil)
    }
}

