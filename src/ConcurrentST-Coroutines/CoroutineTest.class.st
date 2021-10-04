Class {
	#name : #CoroutineTest,
	#superclass : #TestCase,
	#traits : 'TSeasonedSchemerTest',
	#classTraits : 'TSeasonedSchemerTest classTrait',
	#category : #'ConcurrentST-Coroutines'
}

{ #category : #utilities }
CoroutineTest >> callcc: aBlock [

	^ Coroutine currentDo: aBlock
]

{ #category : #test }
CoroutineTest >> coroutineOn: aBlock [

	^ Coroutine on: aBlock
]

{ #category : #test }
CoroutineTest >> testAlphabet [

	"create an alphabet using coroutines"

	| main gen res |
	main := gen := nil.

	main := self coroutineOn: [ :resume :value | 
		        String streamContents: [ :aStream | 
			        (1 to: value) do: [ :i | 
				        aStream nextPut: (resume value: gen value: nil) ] ] ].

	gen := self coroutineOn: [ :resume :value | 
		       | index |
		       index := 10.
		       [ index <= 35 ] whileTrue: [ 
			       | back |
			       back := resume
				               value: main
				               value: (Character digitValue: index).
			       index := index + 1.
			       self assert: back equals: nil ] ].

	res := main value: 26.

	self assert: res equals: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
]

{ #category : #tests }
CoroutineTest >> testIdentity [

	| co |
	co := self coroutineOn: [ :resume :value | value ].

	self assert: (co value: 4) equals: 4
]

{ #category : #tests }
CoroutineTest >> testProduct [

	| co p n |
	p := 1.
	co := self coroutineOn: [ :resume :value | p := p * value ].

	n := 10.
	(1 to: n) do: co.

	self assert: p equals: n factorial
]

{ #category : #tests }
CoroutineTest >> testProductWithZero [

	| co p zeroCo multiplications numbers |
	p := 1.
	multiplications := 0.
	numbers := #( 1 10 2 4 0 3 5 6 8 9 7 ).

	[ :exit | 
	zeroCo := self coroutineOn: [ :resume :value | 
		          p := value.
		          exit value ].

	co := self coroutineOn: [ :resume :aCollection | 
		      aCollection do: [ :each | 
			      each
				      ifZero: [ resume value: zeroCo value: each ]
				      ifNotZero: [ 
					      p := p * each.
					      multiplications := multiplications + 1 ] ] ].

	co value: numbers ] valueWithExit.

	self
		assert: p equals: 0;
		assert: multiplications equals: (numbers indexOf: 0) - 1
]

{ #category : #tests }
CoroutineTest >> testProductWithZeroAllCo [

	| prod p zeroCo multiplications numbers mainCo witness |
	p := 1.
	multiplications := 0.
	numbers := #( 1 10 2 4 0 3 5 6 8 9 7 ).
	witness := Object new.

	zeroCo := self coroutineOn: [ :resume :value | 
		          p := 0.
		          resume value: mainCo value: witness ].

	prod := self coroutineOn: [ :resume :aCollection | 
		        aCollection do: [ :each | 
			        each
				        ifZero: [ resume value: zeroCo value: each ]
				        ifNotZero: [ 
					        p := p * each.
					        multiplications := multiplications + 1 ] ] ].

	mainCo := self coroutineOn: [ :resume :aCollection | 
		          | v |
		          v := resume value: prod value: aCollection.
		          self assert: v equals: witness ].

	mainCo value: numbers.

	self
		assert: p equals: 0;
		assert: multiplications equals: (numbers indexOf: 0) - 1
]

{ #category : #test }
CoroutineTest >> testReset [

	"test the reset function"

	| res a b |
	a := b := nil.
	res := OrderedCollection new.

	a := self coroutineOn: [ :resume | 
		     res add: 'Hi'.
		     res add: (resume value: b value: nil).
		     b reset.
		     res add: (resume value: b value: nil).
		     res add: 'Bye' ].

	b := self coroutineOn: [ :resume | 
		     res add: (resume value: a value: 'Hola').
		     res add: 'Adeu' ].

	a value.

	self assert: res asArray equals: #( Hi Hola Hola Bye )
]

{ #category : #test }
CoroutineTest >> testStableMarriageOne [

	"només una parella"

	| solver res guys gals guyPrefs galPrefs |
	"names"
	guys := #( 'Albert' ).
	gals := #( 'Ema' ).
	"preferences"
	guyPrefs := #( #( 1 ) ).
	galPrefs := #( #( 1 ) ).
	"init solver"
	solver := StableMarriage new
		          test: self;
		          yourself.
	solver guys: guys.
	solver gals: gals.
	solver guyPrefs: guyPrefs.
	solver galPrefs: galPrefs.
	solver trace: true.
	res := solver solve.
	self assert: res equals: #( 1 )
]

{ #category : #test }
CoroutineTest >> testStableMarriagePeanuts [

	"stable marriage problem with the Peanuts characters"

	| solver res guys gals guyPrefs galPrefs |
	"names"
	guys := #( 'Charlie' 'Linus' 'Schroeder' 'Franklin' ).
	gals := #( 'Lucy' 'Peppermint' 'Marcie' 'Sally' ).
	"preferences"
	guyPrefs := #( #( 1 2 3 4 ) #( 3 4 2 1 ) #( 3 1 2 4 ) #( 2 4 3 1 ) ).
	"Charlie" "Lucy" "Peppermint" "Marcie" "Sally"
	"Linus" "Marcie" "Sally" "Peppermint" "Lucy"
	"Schroeder" "Marcie" "Lucy" "Peppermint" "Sally"
	"Franklin" "Peppermint" "Sally" "Marcie" "Lucy"
	galPrefs := #( #( 3 1 4 2 ) #( 1 2 4 3 ) #( 1 4 2 3 ) #( 2 4 3 1 ) ).
	"Lucy" "Schroeder" "Charlie" "Franklin" "Linus"
	"Peppermint" "Charlie" "Linus" "Franklin" "Schroeder"
	"Marcie" "Charlie" "Franklin" "Linus" "Schroeder"
	"Sally" "Linus" "Franklin" "Schroeder" "Charlie"
	"init solver"
	solver := StableMarriage new
		          test: self;
		          yourself.
	solver guys: guys.
	solver gals: gals.
	solver guyPrefs: guyPrefs.
	solver galPrefs: galPrefs.
	solver trace: true.
	res := solver solve.
	self assert: res equals: #( 2 3 1 4 )
]

{ #category : #test }
CoroutineTest >> testStableMarriageStatement [

	"prova l'exemple del PDF 'allison-1983'"

	| solver res guys gals guyPrefs galPrefs |
	"names"
	guys := #( '1' '2' '3' ).
	gals := #( 'A' 'B' 'C' ).
	"preferences"
	guyPrefs := #( #( 1 2 3 ) #( 1 3 2 ) #( 2 3 1 ) ).
	"1" "A" "B" "C"
	"2" "A" "C" "B"
	"3" "B" "C" "A"
	galPrefs := #( #( 2 1 3 ) #( 2 3 1 ) #( 1 2 3 ) ).
	"A" "2" "1" "3"
	"B" "2" "3" "1"
	"C" "1" "2" "3"
	"init solver"
	solver := StableMarriage new
		          test: self;
		          yourself.
	solver guys: guys.
	solver gals: gals.
	solver guyPrefs: guyPrefs.
	solver galPrefs: galPrefs.
	solver trace: true.
	res := solver solve.
	self assert: res equals: #( 3 1 2 )
]

{ #category : #test }
CoroutineTest >> testStatement [

	"test given with the problem statement"

	| res a b c |
	a := b := c := 0.
	res := OrderedCollection new.
	a := self coroutineOn: [ :resume | 
		     res add: 'This is A'.
		     res add: 'Came from ' , (resume value: b value: 'A').
		     res add: 'Back in A'.
		     res add: 'Came from ' , (resume value: c value: 'A') ].
	b := self coroutineOn: [ :resume | 
		     res add: '       This is B'.
		     res add: '       Came from ' , (resume value: c value: 'B').
		     res add: '       Back in B'.
		     res add: '       Came from ' , (resume value: a value: 'B') ].
	c := self coroutineOn: [ :resume | 
		     res add: '           This is C'.
		     res add: '           Came from ' , (resume value: a value: 'C').
		     res add: '           Back in C'.
		     res add: '           Came from ' , (resume value: b value: 'C') ].
	a value.
	res := res joinUsing: Character cr asString.

	self assert: res equals: 'This is A
       This is B
           This is C
Came from C
Back in A
           Came from A
           Back in C
       Came from C
       Back in B
Came from B'
]

{ #category : #test }
CoroutineTest >> testSumOneToN [

	"use coroutines to get  the summation on 1 to n"

	| sum |
	sum := self coroutineOn: [ :resume :value :co | 
		       | x v |
		       v := value.
		       x := 0.
		       [ v > 0 ] whileTrue: [ 
			       x := x + v.
			       v := resume value: co value: v - 1 ].
		       x ].

	self assert: (sum value: 10) equals: (1 to: 10) sum.
	self assert: (sum value: 4) equals: (1 to: 4) sum.
	self assert: (sum value: 3) equals: (1 to: 3) sum
]

{ #category : #test }
CoroutineTest >> testTheForce [

	"join an array of words to get Yoda's famous quote"

	| res a b c words |
	a := b := c := nil.
	res := OrderedCollection new.
	words := OrderedCollection withAll:
		         #( 'fear' 'anger' 'hate' 'suffering' ).
	a := self coroutineOn: [ :resume | 
		     [ words size > 1 ] whileTrue: [ 
			     res
				     add: (resume value: c value: words first);
				     add: Character cr asString ] ].
	b := self coroutineOn: [ :resume | 
		     [ res add: (resume value: a value: words first) ] repeat ].
	c := self coroutineOn: [ :resume :value | 
		     res
			     add: value;
			     add: ' leads to '.
		     [ 
		     words removeFirst.
		     res add: (resume value: b value: ' leads to ') ] repeat ].

	a value.

	res := res joinUsing: ''.

	self assert: res equals: 'fear leads to anger
anger leads to hate
hate leads to suffering
'
]

{ #category : #utilities }
CoroutineTest >> try: tryBlock otherwise: otherwiseBlock [

	^ Coroutine try: tryBlock otherwise: otherwiseBlock
]
