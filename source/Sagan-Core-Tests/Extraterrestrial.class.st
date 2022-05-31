"
I'm a dummy object used for the persistence tests
"
Class {
	#name : #Extraterrestrial,
	#superclass : #Object,
	#instVars : [
		'sequentialNumber',
		'firstName',
		'lastName',
		'birthDate'
	],
	#category : #'Sagan-Core-Tests'
}

{ #category : #accessing }
Extraterrestrial class >> namedFirst: aFirstName last: aLastName bornOn: aDate [

	^ self new initializeNamedFirst: aFirstName last: aLastName bornOn: aDate
]

{ #category : #accessing }
Extraterrestrial >> birthDate [

	^ birthDate
]

{ #category : #accessing }
Extraterrestrial >> firstName [

	^ firstName
]

{ #category : #initialization }
Extraterrestrial >> initializeNamedFirst: aFirstName last: aLastName bornOn: aDate [

	firstName := aFirstName.
	lastName := aLastName. 
	birthDate := aDate
]

{ #category : #accessing }
Extraterrestrial >> lastName [

	^ lastName
]

{ #category : #printing }
Extraterrestrial >> printOn: aStream [

	aStream
		nextPutAll: lastName;
		nextPutAll: ', ';
		nextPutAll: firstName
]

{ #category : #accessing }
Extraterrestrial >> sequentialNumber [

	^ sequentialNumber
]

{ #category : #updating }
Extraterrestrial >> synchronizeWith: anExtraterrestial [

	firstName := anExtraterrestial firstName.
	lastName := anExtraterrestial lastName.
	birthDate := anExtraterrestial birthDate
]
