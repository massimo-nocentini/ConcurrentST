Class {
	#name : #CSTChannel,
	#superclass : #Object,
	#instVars : [
		'co'
	],
	#category : #'ConcurrentST-Channels'
}

{ #category : #'as yet unclassified' }
CSTChannel class >> asynchronous: co [
	^ CSTChannelAsynchronous basicNew
		  coroutine: co;
		  initialize;
		  yourself
]

{ #category : #'as yet unclassified' }
CSTChannel class >> naturalsFrom: init coroutine: co [
	"Another implementation could be:
	
	channel := co channel.
	co spawn: [ 
		| i |
		i := init.
		[ 
		channel send: i.
		i := i + 1 ] repeat ].
	"

	| channel |
	channel := CSTChannelNaturals new
		           channel: co channel;
		           yourself.
	co spawn: [ channel count: init ].
	^ channel
]

{ #category : #'as yet unclassified' }
CSTChannel >> coroutine: aCoroutine [
	co := aCoroutine
]

{ #category : #'as yet unclassified' }
CSTChannel >> receive [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
CSTChannel >> send: anObject [
	self subclassResponsibility
]
