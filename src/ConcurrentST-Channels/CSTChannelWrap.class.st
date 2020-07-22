Class {
	#name : #CSTChannelWrap,
	#superclass : #CSTChannel,
	#instVars : [
		'channel',
		'block'
	],
	#category : #'ConcurrentST-Channels'
}

{ #category : #accessing }
CSTChannelWrap >> block [
	^ block
]

{ #category : #accessing }
CSTChannelWrap >> block: anObject [
	block := anObject
]

{ #category : #accessing }
CSTChannelWrap >> channel [
	^ channel
]

{ #category : #accessing }
CSTChannelWrap >> channel: anObject [
	channel := anObject
]

{ #category : #removing }
CSTChannelWrap >> remove: choices ids: ids signedMessage: signedMessage [
	| digest |
	digest := signedMessage digest.
	choices with: ids do: [ :aChannelWrap :id | 
		self halt.
		id == digest
			ifTrue: [ aChannelWrap throw: signedMessage msg ]
			ifFalse: [  ] ]
]

{ #category : #'as yet unclassified' }
CSTChannelWrap >> wait: choices ids: ids thread: aThread [
	choices with: ids do: [ :aChannelWrap :id | 
		aChannelWrap channel pushThread: (aThread digest: id) ].
	^ co dispatch: aThread
]

{ #category : #'logical operations' }
CSTChannelWrap >> | aWrapChannel [
	| choices |
	choices := Array with: self with: aWrapChannel.
	^ choices
		  detect: [ :aChannelWrap | 
		  aChannelWrap channel isSendQueueEmpty not ]
		  ifFound: [ :aChannelWrap | aChannelWrap channel popMessage ]
		  ifNone: [ 
			  | ids signedMessage |
			  ids := choices collect: [ :_ | Object new ].
			  signedMessage := co withThreadDo: [ :aThread | 
				                   self wait: choices ids: ids thread: aThread ].
			  self remove: choices ids: ids signedMessage: signedMessage ]
]
