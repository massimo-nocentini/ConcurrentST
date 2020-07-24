Extension { #name : #BlockClosure }

{ #category : #'*ConcurrentST-Extensions' }
BlockClosure >> <- anObject [
	^ anObject prependBlock: self
]

{ #category : #'*ConcurrentST-Extensions' }
BlockClosure >> callWithCurrentContinuation [
	^ Continuation currentDo: self
]

{ #category : #'*ConcurrentST-Extensions' }
BlockClosure >> coroutine [
	^ CSTCoroutine block: self
]

{ #category : #'*ConcurrentST-Extensions' }
BlockClosure >> prependBlock: aFullBlockClosure [
	^ [ :v | 
	  | w |
	  w := self value: v.
	  w isCollection
		  ifTrue: [ aFullBlockClosure valueWithArguments: w ]
		  ifFalse: [ aFullBlockClosure value: w ] ]
]
