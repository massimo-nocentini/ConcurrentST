Class {
	#name : #CSTRequest,
	#superclass : #Object,
	#category : #ConcurrentST
}

{ #category : #'actions api' }
CSTRequest class >> get [
	^ CSTRequestGet new
]

{ #category : #'actions api' }
CSTRequest class >> put: anObject [
	^ CSTRequestPut new
		  payload: anObject;
		  yourself
]
