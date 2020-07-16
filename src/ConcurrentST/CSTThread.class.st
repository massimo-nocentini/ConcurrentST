Class {
	#name : #CSTThread,
	#superclass : #Object,
	#instVars : [
		'id',
		'continuation'
	],
	#category : #ConcurrentST
}

{ #category : #accessing }
CSTThread >> continuation [
	^ continuation
]

{ #category : #accessing }
CSTThread >> continuation: anObject [
	continuation := anObject
]

{ #category : #accessing }
CSTThread >> id [
	^ id
]

{ #category : #accessing }
CSTThread >> id: anObject [
	id := anObject
]
