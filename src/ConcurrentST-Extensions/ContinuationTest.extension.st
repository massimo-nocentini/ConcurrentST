Extension { #name : #ContinuationTest }

{ #category : #'*ConcurrentST-Extensions' }
ContinuationTest >> testPrependBlock [

	self
		assert: (self callcc: [ :k | 
				 | kk |
				 kk := k prependBlock: [ :v | v + 1 ].
				 2 + (kk value: 3) ])
		equals: 4.
	self
		assert: (self callcc: [ :k | 
				 | kk |
				 kk := k prependBlock: [ :v | v + 1 ].
				 (k value: 2) + (kk value: 3) ])
		equals: 2.
	self
		assert: (self callcc: [ :k | 
				 | kk |
				 kk := k prependBlock: [ :v | v + 1 ].
				 (kk value: 3) + (k value: 2) ])
		equals: 4
]

{ #category : #'*ConcurrentST-Extensions' }
ContinuationTest >> testPrependBlockRaisingException [

	self
		assert: ([ 
			 self callcc: [ :k | 
				 | kk |
				 kk := k prependBlock: [ :v | Error signal ].
				 2 + (kk value: 3) ] ]
				 on: Error
				 do: [ 0 ])
		equals: 0.
	self
		assert: ([ 
			 self callcc: [ :k | 
				 | kk |
				 kk := k prependBlock: [ :v | Error signal ].
				 (k value: 2) + (kk value: 3) ] ]
				 on: Error
				 do: [ 0 ])
		equals: 2
]
