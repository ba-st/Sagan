Class {
	#name : #PersistentObjectComparer,
	#superclass : #Object,
	#category : #'Sagan-RDBMS-Core'
}

{ #category : #asserting }
PersistentObjectComparer >> hashFor: anObject [ 

	^anObject sequentialNumber hash
]

{ #category : #asserting }
PersistentObjectComparer >> shouldConsider: element asEqualTo: referenceElementOrProxy [

	^element == referenceElementOrProxy or: [| referenceElement |
		" We unproxy the element to avoid problems in the comparing of the classes "
		referenceElement :=
			referenceElementOrProxy isGlorpProxy
				ifTrue: [referenceElementOrProxy getValue]
				ifFalse: [referenceElementOrProxy].
		(referenceElement class = element class) and: [
			element sequentialNumber notNil
				and: [element sequentialNumber = referenceElement sequentialNumber]]]
]
