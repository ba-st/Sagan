Class {
	#name : #ReturnSessionToPoolOnFinalize,
	#superclass : #Object,
	#instVars : [
		'pool',
		'pooledObject'
	],
	#category : #'Sagan-RDBMS-Repository'
}

{ #category : #'instance creation' }
ReturnSessionToPoolOnFinalize class >> toReturn: anObject to: anObjectPool [

	^ self new initializeToReturn: anObject to: anObjectPool
]

{ #category : #finalization }
ReturnSessionToPoolOnFinalize >> finalize [

	pooledObject ifNotNil: [ pool return: pooledObject ].
	pooledObject := nil.
	super finalize
]

{ #category : #initialization }
ReturnSessionToPoolOnFinalize >> initializeToReturn: anObject to: anObjectPool [

	pooledObject := anObject.
	pool := anObjectPool
]

{ #category : #initialization }
ReturnSessionToPoolOnFinalize >> pooledObject [

	^ pooledObject
]
