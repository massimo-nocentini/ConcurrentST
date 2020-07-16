Class {
	#name : #CSTThread,
	#superclass : #Object,
	#instVars : [
		'id',
		'continuation'
	],
	#category : #ConcurrentST
}

{ #category : #'as yet unclassified' }
CSTThread >> <= aCSTThread [
	^ aCSTThread greaterThanThread: self
]

{ #category : #accessing }
CSTThread >> continuation [
	^ continuation
]

{ #category : #accessing }
CSTThread >> continuation: anObject [
	continuation := anObject
]

{ #category : #'as yet unclassified' }
CSTThread >> greaterThanThread: aCSTThread [
	^ self id > aCSTThread id
]

{ #category : #accessing }
CSTThread >> id [
	^ id
]

{ #category : #accessing }
CSTThread >> id: anObject [
	id := anObject
]
