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
CSTThread >> continuation: anObject [
	continuation := anObject
]

{ #category : #accessing }
CSTThread >> digest: aDigest [
	^ CSTThreadWithDigest new
		  id: id;
		  continuation: continuation;
		  digest: aDigest;
		  yourself
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

{ #category : #'as yet unclassified' }
CSTThread >> throw: anObject [
	^ continuation value: anObject
]
