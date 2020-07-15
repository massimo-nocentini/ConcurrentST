"
I am an updatable storage on top of threads and channels.
"
Class {
	#name : #CSTCell,
	#superclass : #Object,
	#category : #'ConcurrentST-Cells'
}

{ #category : #'as yet unclassified' }
CSTCell class >> requestsReplyChannelsOn: init coroutine: co [
	| cell |
	cell := CSTCellRequestsReplyChannels new
		        requestsChannel: co channel;
		        replyChannel: co channel;
		        yourself.
	co spawn: [ cell loop: init ].
	^ cell
]

{ #category : #'actions api' }
CSTCell >> get [
	self subclassResponsibility
]

{ #category : #'actions api' }
CSTCell >> put: anObject [
	self subclassResponsibility
]
