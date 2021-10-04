Extension { #name : #BlockClosure }

{ #category : #'*ConcurrentST-Coroutines' }
BlockClosure >> onCoroutine: aCoroutine [

	^ aCoroutine
		  block: self;
		  yourself
]
