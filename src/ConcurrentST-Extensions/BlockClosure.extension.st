Extension { #name : #BlockClosure }

{ #category : #'*ConcurrentST-Extensions' }
BlockClosure >> <- anObject [
	^ anObject prependBlock: self
]

{ #category : #'*ConcurrentST-Extensions' }
BlockClosure >> coroutine [
	^ CSTCoroutine block: self
]
