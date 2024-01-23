"
I provide a simple interface to execute transactions, regardless of the nesting level.
"
Class {
	#name : 'GemStoneTransaction',
	#superclass : 'Object',
	#category : 'Sagan-GemStone',
	#package : 'Sagan-GemStone'
}

{ #category : 'processing' }
GemStoneTransaction >> transact: aBlock [

	| result |

	System inTransaction
		ifTrue: [ System beginNestedTransaction ]
		ifFalse: [ System beginTransaction ].
	[
	result := aBlock value.
	System commitTransaction
	] ifCurtailed: [ result := System abortTransaction ].

	^ result
]
