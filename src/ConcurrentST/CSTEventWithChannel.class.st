Class {
	#name : #CSTEventWithChannel,
	#superclass : #CSTEvent,
	#instVars : [
		'channel'
	],
	#category : #ConcurrentST
}

{ #category : #accessing }
CSTEventWithChannel >> channel: aChannel [

	channel := aChannel
]

{ #category : #instructions }
CSTEventWithChannel >> send: msg [

	^ channel send: msg event: self
]
