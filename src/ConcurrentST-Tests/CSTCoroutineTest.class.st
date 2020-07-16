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
		assert: [ :co | 
			co
				spawn: [ 3 ];
				spawn: [ 4 ] ] coroutine
		equals: 1
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
