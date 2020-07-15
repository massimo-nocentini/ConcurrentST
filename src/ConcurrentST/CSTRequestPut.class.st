Class {
	#name : #CSTRequestPut,
	#superclass : #CSTRequest,
	#instVars : [
		'payload'
	],
	#category : #ConcurrentST
}

{ #category : #accessing }
CSTRequestPut >> payload [
	^ payload
]

{ #category : #accessing }
CSTRequestPut >> payload: anObject [
	payload := anObject
]
