import Testing
@testable import LibSwift

actor CallbackTracker<T: Sendable & Equatable> {
    private(set) var callCount: Int = 0
    private(set) var receivedValues: [T] = []
    
    func record(_ value: T) {
        callCount += 1
        receivedValues.append(value)
    }
    
    func reset() {
        callCount = 0
        receivedValues.removeAll()
    }
}

struct ObserversTests {
    
    @Test
    func subscribeCallsCallbackImmediatelyWithCurrentValue() async {
        let observers = Observers<Int>()
        let tracker = CallbackTracker<Int>()
        
        let token = await observers.subscribe({ value in
            await tracker.record(value)
        }, 42)
        
        let count = await tracker.callCount
        let values = await tracker.receivedValues
        
        #expect(count == 1)
        #expect(values == [42])
        
        _ = token
    }
    
    @Test
    func notifyCallsAllActiveSubscribers() async {
        let observers = Observers<String>()
        let tracker = CallbackTracker<String>()
        
        let token = await observers.subscribe({ value in
            await tracker.record(value)
        }, "initial")
        
        await observers.notify("update")
        
        let count = await tracker.callCount
        let values = await tracker.receivedValues
        
        #expect(count == 2)
        #expect(values == ["initial", "update"])
        
        _ = token
    }
    
    @Test
    func multipleSubscribersReceiveNotifications() async {
        let observers = Observers<Int>()
        let tracker1 = CallbackTracker<Int>()
        let tracker2 = CallbackTracker<Int>()
        let tracker3 = CallbackTracker<Int>()
        
        let token1 = await observers.subscribe({ value in
            await tracker1.record(value)
        }, 0)
        
        let token2 = await observers.subscribe({ value in
            await tracker2.record(value)
        }, 0)
        
        let token3 = await observers.subscribe({ value in
            await tracker3.record(value)
        }, 0)
        
        await observers.notify(10)
        
        let count1 = await tracker1.callCount
        let count2 = await tracker2.callCount
        let count3 = await tracker3.callCount
        
        #expect(count1 == 2)
        #expect(count2 == 2)
        #expect(count3 == 2)
        
        let values1 = await tracker1.receivedValues
        let values2 = await tracker2.receivedValues
        let values3 = await tracker3.receivedValues
        
        #expect(values1 == [0, 10])
        #expect(values2 == [0, 10])
        #expect(values3 == [0, 10])
        
        _ = token1
        _ = token2
        _ = token3
    }
    
    @Test
    func releasedTokenStopsReceivingNotifications() async {
        let observers = Observers<Int>()
        let tracker1 = CallbackTracker<Int>()
        let tracker2 = CallbackTracker<Int>()
        
        var token1: AnySendableObject? = await observers.subscribe({ value in
            await tracker1.record(value)
        }, 0)
        
        let token2 = await observers.subscribe({ value in
            await tracker2.record(value)
        }, 0)
        
        await observers.notify(1)
        
        token1 = nil
        
        await observers.notify(2)
        
        let count1 = await tracker1.callCount
        let count2 = await tracker2.callCount
        
        #expect(count1 == 2)
        #expect(count2 == 3)
        
        let values1 = await tracker1.receivedValues
        let values2 = await tracker2.receivedValues
        
        #expect(values1 == [0, 1])
        #expect(values2 == [0, 1, 2])
        
        _ = token2
    }
    
    @Test
    func notifyWithoutSubscribersDoesNotCrash() async {
        let observers = Observers<String>()
        
        await observers.notify("test")
    }

    @Test
    func allTokensReleasedStopsAllNotifications() async {
        let observers = Observers<Int>()
        let tracker1 = CallbackTracker<Int>()
        let tracker2 = CallbackTracker<Int>()
        
        var token1: AnySendableObject? = await observers.subscribe({ value in
            await tracker1.record(value)
        }, 0)
        
        var token2: AnySendableObject? = await observers.subscribe({ value in
            await tracker2.record(value)
        }, 0)
        
        await observers.notify(1)
        
        token1 = nil
        token2 = nil
        
        await observers.notify(2)
        
        let count1 = await tracker1.callCount
        let count2 = await tracker2.callCount
        
        #expect(count1 == 2)
        #expect(count2 == 2)
        
        let values1 = await tracker1.receivedValues
        let values2 = await tracker2.receivedValues
        
        #expect(values1 == [0, 1])
        #expect(values2 == [0, 1])
    }
    
    @Test
    func subscriptionsAreIndependent() async {
        let observers = Observers<Int>()
        let tracker1 = CallbackTracker<Int>()
        let tracker2 = CallbackTracker<Int>()
        
        let token1 = await observers.subscribe({ value in
            await tracker1.record(value)
        }, 10)
        
        await observers.notify(20)
        
        let token2 = await observers.subscribe({ value in
            await tracker2.record(value)
        }, 30)
        
        await observers.notify(40)
        
        let count1 = await tracker1.callCount
        let count2 = await tracker2.callCount
        
        #expect(count1 == 3)
        #expect(count2 == 2)
        
        let values1 = await tracker1.receivedValues
        let values2 = await tracker2.receivedValues
        
        #expect(values1 == [10, 20, 40])
        #expect(values2 == [30, 40])
        
        _ = token1
        _ = token2
    }
}
