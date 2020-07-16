"
A CSTChannelTest is a test class for testing the behavior of CSTChannel
"
Class {
	#name : #CSTChannelTest,
	#superclass : #TestCase,
	#category : #'ConcurrentST-Channels-Tests'
}

{ #category : #tests }
CSTChannelTest >> naturals: s channel: channel [
	channel send: s.
	self naturals: s + 1 channel: channel
]

{ #category : #tests }
CSTChannelTest >> testNaturalNumbers [
	| s interval |
	s := 0.
	interval := 0 to: 9.
	self
		assert: [ :co | 
			| natsChannel res |
			res := OrderedCollection new.
			natsChannel := co channel.
			co spawn: [ self naturals: s channel: natsChannel ].
			interval collect: [ :_ | natsChannel receive ] ] coroutine
		equals: interval
]
