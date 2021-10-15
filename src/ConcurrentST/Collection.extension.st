Extension { #name : #Collection }

{ #category : #'*ConcurrentST' }
Collection >> chooseEvent: anEvent [

	self do: [ :each | each addComponentsInEvent: anEvent ].

	^ anEvent
]
