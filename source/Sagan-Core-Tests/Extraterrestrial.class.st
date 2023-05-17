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
		'birthDate',
		'raceName'
	],
	#category : #'Sagan-Core-Tests'
}

{ #category : #accessing }
Extraterrestrial class >> namedFirst: aFirstName last: aLastName bornOn: aDate as: aRace [

	^ self new initializeNamedFirst: aFirstName
		  last: aLastName
		  bornOn: aDate
		  as: aRace
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
Extraterrestrial >> initializeNamedFirst: aFirstName last: aLastName bornOn: aDate as: aRace [

	firstName := aFirstName.
	lastName := aLastName.
	birthDate := aDate.
	raceName := aRace
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
Extraterrestrial >> raceName [

	^ raceName
]

{ #category : #accessing }
Extraterrestrial >> sequentialNumber [

	^ sequentialNumber
]

{ #category : #updating }
Extraterrestrial >> synchronizeWith: anExtraterrestial [

	AssertionChecker enforce: [ self raceName = anExtraterrestial raceName ]
		because: ( 'Once <1s>, always <1s>' expandMacrosWith: self raceName ).

	firstName := anExtraterrestial firstName.
	lastName := anExtraterrestial lastName.
	birthDate := anExtraterrestial birthDate
]
