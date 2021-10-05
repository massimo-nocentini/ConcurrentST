Extension { #name : #BlockClosure }

{ #category : #'*ConcurrentST-Extensions' }
BlockClosure >> coroutine [
	^ CSTCoroutine block: self
]
