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
	interval := 1 to: 10.
	self
		assert: [ :co | 
			| natsChannel |
			natsChannel := self naturals: s channel: co channel.
			interval collect: [ :_ | natsChannel receive ] ] coroutine
		equals: interval
]
