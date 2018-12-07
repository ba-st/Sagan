"
I'm a dummy object used for the persistence tests
"
Class {
	#name : #Extraterrestrial,
	#superclass : #Object,
	#instVars : [
		'sequentialNumber',
		'firstName',
		'lastName'
	],
	#category : #'Sagan-Core-Tests'
}

{ #category : #accessing }
Extraterrestrial class >> namedFirst: aFirstName last: aLastName [  

	^ self new initializeNamedFirst: aFirstName last: aLastName  
]

{ #category : #accessing }
Extraterrestrial >> firstName [

	^ firstName
]

{ #category : #initialization }
Extraterrestrial >> initializeNamedFirst: aFirstName last: aLastName [

	firstName := aFirstName.
	lastName := aLastName
]

{ #category : #accessing }
Extraterrestrial >> lastName [

	^ lastName
]

{ #category : #accessing }
Extraterrestrial >> sequentialNumber [

	^ sequentialNumber
]

{ #category : #updating }
Extraterrestrial >> synchronizeWith: anExtraterrestial [

	firstName := anExtraterrestial firstName.
	lastName := anExtraterrestial lastName
]
