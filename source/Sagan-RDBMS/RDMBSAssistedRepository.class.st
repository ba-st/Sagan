Class {
	#name : #RDMBSAssistedRepository,
	#superclass : #Repository,
	#instVars : [
		'descriptorSystem',
		'modelObjectClass',
		'conflictCheckingStrategy',
		'sessionProvider'
	],
	#category : #'Sagan-RDBMS-Core'
}

{ #category : #'instance creation' }
RDMBSAssistedRepository class >> storingObjectsOfType: aDomainObjectClass checkingConflictsAccordingTo: aConflictCheckingStrategy workingWith: aSessionProvider [

	^ self new
		initializeStoringObjectsOfType: aDomainObjectClass
		checkingConflictsAccordingTo: aConflictCheckingStrategy
		workingWith: aSessionProvider
]

{ #category : #mappings }
RDMBSAssistedRepository >> beAwareOfClassModelDefinedBy: aClassModelDefinition [

	self
		withSessionDo: [ :session | session system addClassModelDefinedBy: aClassModelDefinition ]
]

{ #category : #mappings }
RDMBSAssistedRepository >> beAwareOfDescriptorDefinedBy: aDescriptorDefinition [

	self
		withSessionDo: [ :session | session system addDescriptorDefinedBy: aDescriptorDefinition ]
]

{ #category : #mappings }
RDMBSAssistedRepository >> beAwareOfTableDefinedBy: aTableDefinition [

	self withSessionDo: [ :session | session system addTableDefinedBy: aTableDefinition ]
]

{ #category : #mappings }
RDMBSAssistedRepository >> beAwareOfTypeResolverDefinedBy: aTypeResolverDefinition [

	self
		withSessionDo: [ :session | session system addTypeResolverDefinedBy: aTypeResolverDefinition ]
]

{ #category : #mappings }
RDMBSAssistedRepository >> configureMappingsIn: aBlock [

	aBlock cull: self.
	self withSessionDo: [ :session | session system: session system ]
]

{ #category : #'private - accessing' }
RDMBSAssistedRepository >> conflictCheckingStrategy [

	^ conflictCheckingStrategy
]

{ #category : #querying }
RDMBSAssistedRepository >> countMatching: aCriteriaOrBlock [

	^ self
		withSessionDo: [ :session | self handleReadErrorsDuring: [ session count: modelObjectClass where: ( self asMatchingCriteria: aCriteriaOrBlock ) ] ]
]

{ #category : #'private - accessing' }
RDMBSAssistedRepository >> executeQuery: query [

	^ self withSessionDo: [ :session | self handleReadErrorsDuring: [ session execute: query ] ]
]

{ #category : #querying }
RDMBSAssistedRepository >> findAll [

	^ self withSessionDo: [ :session | self handleReadErrorsDuring: [ session read: modelObjectClass ] ]
]

{ #category : #querying }
RDMBSAssistedRepository >> findAllMatching: aCriteriaOrBlock [

	^ self executeQuery: ( SimpleQuery read: modelObjectClass where: ( self asMatchingCriteria: aCriteriaOrBlock ) )
]

{ #category : #querying }
RDMBSAssistedRepository >> findAllMatching: aCriteriaOrBlock sortedBy: aSortFunction [

	| query |

	query := SimpleQuery read: modelObjectClass where: ( self asMatchingCriteria: aCriteriaOrBlock ).
	aSortFunction asSortFunction asOrderByIn: query.
	^ self executeQuery: query
]

{ #category : #'private - error handling' }
RDMBSAssistedRepository >> handleReadErrorsDuring: aBlock [

	^ aBlock
		on: GlorpDatabaseReadError
		do: [ :error | 
			PersistenceCommandFailed
				signal: 'Cannot perform the action due to some persistence error while reading.'
				dueTo: error
				because: error databaseError asString
			]
]

{ #category : #'private - error handling' }
RDMBSAssistedRepository >> handleWriteErrorsDuring: aBlock [

	^ aBlock
		on: GlorpDatabaseWriteError
		do: [ :error | 
			PersistenceCommandFailed
				signal: 'Cannot perform the action due to some persistence error while writing.'
				dueTo: error
				because: error databaseError asString
			]
]

{ #category : #'private - accessing' }
RDMBSAssistedRepository >> inUnitOfWorkDo: aBlock [

	^ self withSessionDo: [ :session | session inUnitOfWorkDo: aBlock ]
]

{ #category : #initialization }
RDMBSAssistedRepository >> initializeStoringObjectsOfType: aDomainObjectClass
	checkingConflictsAccordingTo: aConflictCheckingStrategy
	workingWith: aSessionProvider [


	modelObjectClass := aDomainObjectClass.
	conflictCheckingStrategy := aConflictCheckingStrategy.
	sessionProvider := aSessionProvider
]

{ #category : #'private - accessing' }
RDMBSAssistedRepository >> matchingCriteriaBuilder [

	^ RDBMSRepositoryMatchingCriteriaBuilder new
]

{ #category : #'private - management' }
RDMBSAssistedRepository >> purgeAfterCheckingConflicts: aDomainObject [

	^ self
		handleWriteErrorsDuring: [ self inUnitOfWorkDo: [ :session | session delete: aDomainObject ].
			aDomainObject
			]
]

{ #category : #management }
RDMBSAssistedRepository >> purgeAllMatching: aCriteriaOrBlock [

	self
		handleWriteErrorsDuring: [ self
				inUnitOfWorkDo:
					[ :session | session delete: modelObjectClass where: ( self asMatchingCriteria: aCriteriaOrBlock ) ]
			]
]

{ #category : #'private - management' }
RDMBSAssistedRepository >> storeAfterCheckingConflicts: aDomainObject [

	^ self
		handleWriteErrorsDuring: [ self inUnitOfWorkDo: [ :session | session register: aDomainObject ].
			aDomainObject
			]
]

{ #category : #management }
RDMBSAssistedRepository >> update: aMutableDomainObject executing: aMonadycBlock [

	^ self
		handleWriteErrorsDuring: [ 
			self
				inUnitOfWorkDo: [ :session | session modify: aMutableDomainObject in: [ aMonadycBlock value: aMutableDomainObject ] ];
				withSessionDo: [ :session | session refresh: aMutableDomainObject ]
			]
]

{ #category : #'private - management' }
RDMBSAssistedRepository >> updateAfterCheckingConflicts: aDomainObject with: anUpdatedDomainObject [

	^self update: aDomainObject executing: [:original | original synchronizeWith: anUpdatedDomainObject]
]

{ #category : #querying }
RDMBSAssistedRepository >> withOneMatching: aCriteriaOrBlock do: foundBlock else: noneBlock [

	| query |

	query := SimpleQuery readOneOf: modelObjectClass where: ( self asMatchingCriteria: aCriteriaOrBlock ).
	^ ( self executeQuery: query ) ifNil: noneBlock ifNotNil: foundBlock
]

{ #category : #querying }
RDMBSAssistedRepository >> withOneMatching: aCriteriaOrBlock sortedBy: aSortFunction do: foundBlock else: noneBlock [

	| query |

	query := SimpleQuery readOneOf: modelObjectClass where: ( self asMatchingCriteria: aCriteriaOrBlock ).
	aSortFunction asSortFunction asOrderByIn: query.
	^ ( self executeQuery: query ) ifNil: noneBlock ifNotNil: foundBlock
]

{ #category : #'private - accessing' }
RDMBSAssistedRepository >> withSessionDo: aBlock [

	^ aBlock value: sessionProvider value
]
