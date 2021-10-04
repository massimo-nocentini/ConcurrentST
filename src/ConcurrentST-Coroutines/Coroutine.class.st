"
A Coroutine is coroutine.

"
Class {
	#name : #Coroutine,
	#superclass : #Object,
	#instVars : [
		'block',
		'cont'
	],
	#category : #'ConcurrentST-Coroutines'
}

{ #category : #enumerating }
Coroutine class >> currentDo: aBlock [

	| co main |
	main := nil.

	co := self on: [ :resume :useless | 
		      aBlock value: [ :v | resume value: main value: v ] ].

	main := self on: [ :resume :value | resume value: co value: value ].

	^ main value: nil
]

{ #category : #'instance creation' }
Coroutine class >> on: anObject [

	^ anObject onCoroutine: self new
]

{ #category : #'instance creation' }
Coroutine class >> try: tryBlock otherwise: elseBlock [

	^ self currentDo: [ :success | 
		  | localResult |
		  localResult := self currentDo: [ :local | 
			                 success value: (tryBlock value: local) ].
		  elseBlock cull: localResult ]
]

{ #category : #'initailize-release' }
Coroutine >> block: aBlock [

	block := aBlock
]

{ #category : #clearing }
Coroutine >> reset [
	"reset the coroutine so next time it starts at the begining of the block"
	cont := nil.
]

{ #category : #'as yet unclassified' }
Coroutine >> swapContext: aContext [

	| old |
	old := cont.
	cont := aContext.
	^ old
]

{ #category : #accessing }
Coroutine >> value [

	^ self value: nil
]

{ #category : #accessing }
Coroutine >> value: aValue [

	^ cont
		  ifNil: [ 
			  block
				  cull: [ :coroutine :value | 
					  self swapContext: thisContext sender.
					  coroutine value: value ]
				  cull: aValue
				  cull: self ]
		  ifNotNil: [ 
			  | contTmp |
			  contTmp := self swapContext: nil.
			  thisContext swapSender: contTmp.
			  aValue ]
]
