Class {
	#name : #CoroutineContTest,
	#superclass : #TestCase,
	#instVars : [
		'statementTestResult',
		'theForceTestResult',
		'alphabetTestResult',
		'sumOneToNTestResult1',
		'sumOneToNTestResult2',
		'sumOneToNTestResult3',
		'resetTestResult'
	],
	#category : #'ConcurrentST-Coroutines'
}

{ #category : #initialization }
CoroutineContTest >> setUp [
	"setup method"
	statementTestResult := 
'This is A
       This is B
           This is C
Came from C
Back in A
           Came from A
           Back in C
       Came from C
       Back in B
Came from B'.
	
	theForceTestResult := 
'fear leads to anger
anger leads to hate
hate leads to suffering
'.
	
	alphabetTestResult := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.
	
	sumOneToNTestResult1 := 55.
	sumOneToNTestResult2 := 10.
	sumOneToNTestResult3 := 6.

	resetTestResult :=
'Hi
Hola
Hola
Bye'.
]

{ #category : #test }
CoroutineContTest >> testAlphabet [
	"create an alphabet using coroutines"
	| main gen res |
	main:= gen := nil.
	main := CoroutineCont on: [  :resume :value |
		| str |
		str := ''.
		(1 to: value) do: [ :i |
			str := str, (resume value: gen value: nil) asString.
		].
		str.
	].
	gen := CoroutineCont on: [  :resume :value |
		| index |
		index := 10.
		[ index <= 35 ] whileTrue: [ 
			resume value: main value: (Character digitValue: index).
			index := index + 1.
		].
	].
	res := main value: 26.
	self assert: alphabetTestResult = res.
]

{ #category : #test }
CoroutineContTest >> testReset [
	"test the reset function"
	| res a b |
	a := b := nil.
	res := OrderedCollection new.
	a := CoroutineCont on: [ :resume :value |
		res add: 'Hi'.
		res add: (resume value: b value: nil).
		b reset.
		res add: (resume value: b value: nil).
		res add: 'Bye'.
	].
	b := CoroutineCont on: [ :resume :value |
		res add: (resume value: a value: 'Hola').
		res add: 'Adeu'.
	].
	a value: nil.
	res := res joinUsing: Character cr asString.
	self assert: resetTestResult = res.
]

{ #category : #test }
CoroutineContTest >> testStatement [
	"test given with the problem statement"
	| res a b c |
	a := b := c := 0.
	res := OrderedCollection new.
	a := CoroutineCont on: [ :resume :value |
		res add: 'This is A'.
		res add: ('Came from ', (resume value: b value: 'A')). 
		res add: 'Back in A'.
		res add: ('Came from ', (resume value: c value: 'A')).  
	].
	b := CoroutineCont on: [ :resume :value |
		res add: '       This is B'.
		res add: ('       Came from ', (resume value: c value: 'B')). 
		res add: '       Back in B'.
		res add: ('       Came from ', (resume value: a value: 'B')).  
	].
	c := CoroutineCont on: [ :resume :value |
		res add: '           This is C'.
		res add: ('           Came from ', (resume value: a value:'C')). 
		res add: '           Back in C'.
		res add: ('           Came from ', (resume value: b value: 'C')).
	].
	a value: nil.	
	res := res joinUsing: Character cr asString.
	self assert: statementTestResult = res.
]

{ #category : #test }
CoroutineContTest >> testSumOneToN [

	"use coroutines to get  the summation on 1 to n"

	| sum res1 res2 res3 |
	sum := nil.
	sum := CoroutineCont on: [ :resume :value | 
		       | x v |
		       v := value.
		       x := 0.
		       [ v > 0 ] whileTrue: [ 
			       x := x + v.
			       v := resume value: sum value: v - 1 ].
		       x ].
	res1 := sum value: 10.
	res2 := sum value: 4.
	res3 := sum value: 3.
	self assert: res1 == sumOneToNTestResult1.
	self assert: res2 == sumOneToNTestResult2.
	self assert: res3 == sumOneToNTestResult3
]

{ #category : #test }
CoroutineContTest >> testTheForce [
	"join an array of words to get Yoda's famous quote"
	| res a b c words |
	a := b := c := nil.
	res := OrderedCollection new.
	words := OrderedCollection withAll: #('fear' 'anger' 'hate' 'suffering').
	a := CoroutineCont on: [ :resume :value |
		[ (words size) > 1 ] whileTrue: [ 
			res add: (resume value: c value: (words first)); add: Character cr asString.
		].
	].
	b := CoroutineCont on: [ :resume :value |
		[ true ] whileTrue: [ 
			res add: (resume value: a value: (words first)).
		].
	].
	c := CoroutineCont on: [ :resume :value |
		res add: value; add: ' leads to '.
		[ true ] whileTrue: [ 
			words removeFirst.
			res add: (resume value: b value: ' leads to ').
		].
	].
	a value: nil.
	res := res joinUsing: ''.
	self assert: theForceTestResult = res.
]
