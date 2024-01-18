"
A Repository mediates between the domain and data mapping layers, acting like an in-memory domain object collection. 
Client objects construct query specifications declaratively and submit them to Repository for satisfaction. 
Objects can be added to and removed from the Repository, as they can from a simple collection of objects, and the 
mapping code encapsulated by the Repository will carry out the appropriate operations behind the scenes. 

Conceptually, a Repository encapsulates the set of objects persisted in a data store and the operations performed 
over them, providing a more object-oriented view of the persistence layer. 

Repository also supports the objective of achieving a clean separation and one-way dependency between the domain 
and data mapping layers.

I support two main APIs:
- Management: API to store, purge and update managed objects 
- Querying: API to find and retrieve objects

My concrete subclasses can support a mapping building API in the cases it's needed.
"
Class {
	#name : 'RepositoryBehavior',
	#superclass : 'Object',
	#category : 'Sagan-Core',
	#package : 'Sagan-Core'
}

{ #category : 'private - accessing' }
RepositoryBehavior >> asMatchingCriteria: aBlockOrCriteria [

	^ aBlockOrCriteria asMatchingCriteriaIn: self
]

{ #category : 'private - preconditions' }
RepositoryBehavior >> assertIncludes: inMemoryObject [

	AssertionChecker
		enforce: [ ( self countMatching: [ :objectInRepository :criteria | criteria does: objectInRepository equal: inMemoryObject ] ) strictlyPositive ]
		because: [ '<1p> was not found.' expandMacrosWith: inMemoryObject ]
		raising: ObjectNotFound
]

{ #category : 'private - preconditions' }
RepositoryBehavior >> assertNoConflictsFor: aDomainObject [

	self conflictCheckingStrategy assertNoConflictsFor: aDomainObject in: self
]

{ #category : 'private - preconditions' }
RepositoryBehavior >> assertNoConflictsFor: anUpdatedDomainObject excluding: aDomainObject [

	self conflictCheckingStrategy assertNoConflictsFor: anUpdatedDomainObject in: self excluding: aDomainObject
]

{ #category : 'configuring' }
RepositoryBehavior >> configureWith: aBlock [

	self subclassResponsibility 
]

{ #category : 'private - accessing' }
RepositoryBehavior >> conflictCheckingStrategy [

	^ self subclassResponsibility 
]

{ #category : 'querying' }
RepositoryBehavior >> countMatching: aCriteria [

	self subclassResponsibility
]

{ #category : 'querying' }
RepositoryBehavior >> findAll [ 
	
	self subclassResponsibility 
]

{ #category : 'querying' }
RepositoryBehavior >> findAllMatching: aCriteria [

	self subclassResponsibility
]

{ #category : 'querying' }
RepositoryBehavior >> findAllMatching: aCriteria sortedBy: aSortCriteria [

	self subclassResponsibility
]

{ #category : 'private - accessing' }
RepositoryBehavior >> matchingCriteriaBuilder [

	^ self subclassResponsibility
]

{ #category : 'management' }
RepositoryBehavior >> purge: aDomainObject [

	^ self
		assertIncludes: aDomainObject;
		purgeAfterCheckingInclusion: aDomainObject
]

{ #category : 'private - management' }
RepositoryBehavior >> purgeAfterCheckingInclusion: aDomainObject [

	^ self subclassResponsibility
]

{ #category : 'management' }
RepositoryBehavior >> purgeAllMatching: aCriteria [

	self subclassResponsibility
]

{ #category : 'management' }
RepositoryBehavior >> store: aDomainObject [

	^ self
		assertNoConflictsFor: aDomainObject;
		storeAfterCheckingConflicts: aDomainObject
]

{ #category : 'private - management' }
RepositoryBehavior >> storeAfterCheckingConflicts: aDomainObject [

	^ self subclassResponsibility
]

{ #category : 'management' }
RepositoryBehavior >> transact: aBlock [

	^ self subclassResponsibility
]

{ #category : 'management' }
RepositoryBehavior >> update: aDomainObject executing: aBlock [

	self subclassResponsibility
]

{ #category : 'management' }
RepositoryBehavior >> update: aDomainObject with: anUpdatedDomainObject [

	^ self
		assertIncludes: aDomainObject;
		assertNoConflictsFor: anUpdatedDomainObject excluding: aDomainObject;
		updateAfterCheckingConflicts: aDomainObject with: anUpdatedDomainObject
]

{ #category : 'private - management' }
RepositoryBehavior >> updateAfterCheckingConflicts: aDomainObject with: anUpdatedDomainObject [

	^ self subclassResponsibility
]

{ #category : 'querying' }
RepositoryBehavior >> withOneMatching: aCriteria do: foundBlock else: noneBlock [

	self subclassResponsibility
]

{ #category : 'querying' }
RepositoryBehavior >> withOneMatching: aCriteria sortedBy: aSortCriteria do: foundBlock else: noneBlock [

	self subclassResponsibility
]
