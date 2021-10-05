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
		assert: [ :co | co spawn: [ co spawn: [ 4 ] ] ] concurrentST class
		equals: CSTThread.
	self
		assert: [ :co | 
			co spawn: [ co spawn: [ 4 ] ].
			3 ] concurrentST
		equals: 3
]
