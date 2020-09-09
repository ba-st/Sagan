Class {
	#name : #Mothership,
	#superclass : #SpaceshipBehavior,
	#instVars : [
		'sequentialNumber',
		'name',
		'fleet'
	],
	#category : #'Sagan-Core-Tests'
}

{ #category : #'instance creation' }
Mothership class >> named: aName withAll: aSpaceshipCollection [

	^ self new initializeNamed: aName withAll: aSpaceshipCollection
]

{ #category : #initialization }
Mothership >> fleet [

	^ fleet copy
]

{ #category : #initialization }
Mothership >> initializeNamed: aName withAll: aSpaceshipCollection [

	name := aName.
	fleet := aSpaceshipCollection
]

{ #category : #initialization }
Mothership >> name [

	^ name
]

{ #category : #updating }
Mothership >> synchronizeWith: aMothership [

	name := aMothership name.
	fleet := aMothership fleet
]
