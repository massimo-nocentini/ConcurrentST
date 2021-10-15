"
Every object that participate in a ConcurrentST environment depends on a loop.
"
Class {
	#name : #CSTObject,
	#superclass : #Object,
	#instVars : [
		'loop'
	],
	#category : #ConcurrentST
}

{ #category : #accessing }
CSTObject >> loop: aLoop [

	loop := aLoop
]
