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
PersistentObjectComparer >> shouldConsider: anObject asEqualTo: anotherObject [

	^anObject == anotherObject or: [| unproxiedObject |
		unproxiedObject :=
			anotherObject isGlorpProxy
				ifTrue: [anotherObject getValue]
				ifFalse: [anotherObject].
		(unproxiedObject class = anObject class) and: [
			anObject sequentialNumber notNil
				and: [anObject sequentialNumber = unproxiedObject sequentialNumber]]]
]
