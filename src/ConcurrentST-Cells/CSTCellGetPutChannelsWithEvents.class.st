Class {
	#name : #CSTCellGetPutChannelsWithEvents,
	#superclass : #CSTCell,
	#instVars : [
		'getChannel',
		'putChannel'
	],
	#category : #'ConcurrentST-Cells'
}

{ #category : #'actions api' }
CSTCellGetPutChannelsWithEvents >> get [

	^ getChannel receive
]

{ #category : #accessing }
CSTCellGetPutChannelsWithEvents >> getChannel: anObject [

	getChannel := anObject
]

{ #category : #'actions api' }
CSTCellGetPutChannelsWithEvents >> put: anObject [

	putChannel send: anObject
]

{ #category : #accessing }
CSTCellGetPutChannelsWithEvents >> putChannel: anObject [

	putChannel := anObject
]

{ #category : #accessing }
CSTCellGetPutChannelsWithEvents >> value: anObject [

	| current |
	current := anObject.

	[ 
	(loop event choose: { 
			 (getChannel event send: current).
			 (putChannel event receive wrap: [ :v | current := v ]) }) sync ]
		repeat
]
