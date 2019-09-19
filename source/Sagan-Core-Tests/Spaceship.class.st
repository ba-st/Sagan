Class {
	#name : #Spaceship,
	#superclass : #Object,
	#instVars : [
		'sequentialNumber',
		'name'
	],
	#category : #'Sagan-Core-Tests'
}

{ #category : #'instance creation' }
Spaceship class >> named: aName [

	^ self new initializeNamed: aName
]

{ #category : #initialization }
Spaceship >> initializeNamed: aName [

	name := aName
]

{ #category : #accessing }
Spaceship >> name [

	^ name
]

{ #category : #accessing }
Spaceship >> sequentialNumber [

	^ sequentialNumber
]

{ #category : #updating }
Spaceship >> synchronizeWith: aSpaceship [

	name := aSpaceship name
]
