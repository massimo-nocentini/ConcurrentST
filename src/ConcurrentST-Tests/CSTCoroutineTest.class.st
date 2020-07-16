"
A CSTCoroutineTest is a test class for testing the behavior of CSTCoroutine
"
Class {
	#name : #CSTCoroutineTest,
	#superclass : #TestCase,
	#category : #'ConcurrentST-Tests'
}

{ #category : #tests }
CSTCoroutineTest >> testSpawn [
	self
		assert: [ :co | co spawn: [ co spawn: [ 4 ] ] ] coroutine
		equals: 4.
	self
		assert: [ :co | 
			co spawn: [ co spawn: [ 4 ] ].
			3 ] coroutine
		equals: 3
]

{ #category : #tests }
CSTCoroutineTest >> testYield [
	self assert: [ :co | co yield: 1 ] coroutine equals: 1.
	self
		assert: [ :co | 
			co
				yield: 1;
				yield: 2 ] coroutine
		equals: 2
]
