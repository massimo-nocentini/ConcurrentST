Class {
	#name : #CSTCellGetPutChannelsWithEvents,
	#superclass : #CSTCellRequestsReplyChannels,
	#category : #'ConcurrentST-Cells'
}

{ #category : #'actions api' }
CSTCellGetPutChannelsWithEvents >> get [

	^ requestsChannel receive
]

{ #category : #'actions api' }
CSTCellGetPutChannelsWithEvents >> put: anObject [

	replyChannel send: anObject
]

{ #category : #accessing }
CSTCellGetPutChannelsWithEvents >> value: anObject [

	| current |
	current := anObject.

	[ 
	(loop event choose: { 
			 (requestsChannel event send: current).
			 (replyChannel event receive wrap: [ :v | current := v ]) }) sync ]
		repeat
]
