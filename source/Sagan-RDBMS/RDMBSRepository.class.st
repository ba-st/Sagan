Class {
	#name : #RDMBSRepository,
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
RDMBSRepository class >> storingObjectsOfType: aDomainObjectClass checkingConflictsAccordingTo: aConflictCheckingStrategy workingWith: aSessionProvider [

	^ self new
		initializeStoringObjectsOfType: aDomainObjectClass
		checkingConflictsAccordingTo: aConflictCheckingStrategy
		workingWith: aSessionProvider
]

{ #category : #mappings }
RDMBSRepository >> beAwareOfClassModelDefinedBy: aClassModelDefinition [

	self
		withSessionDo: [ :session | session system addClassModelDefinedBy: aClassModelDefinition ]
]

{ #category : #mappings }
RDMBSRepository >> beAwareOfDescriptorDefinedBy: aDescriptorDefinition [

	self
		withSessionDo: [ :session | session system addDescriptorDefinedBy: aDescriptorDefinition ]
]

{ #category : #mappings }
RDMBSRepository >> beAwareOfTableDefinedBy: aTableDefinition [

	self withSessionDo: [ :session | session system addTableDefinedBy: aTableDefinition ]
]

{ #category : #mappings }
RDMBSRepository >> beAwareOfTypeResolverDefinedBy: aTypeResolverDefinition [

	self
		withSessionDo: [ :session | session system addTypeResolverDefinedBy: aTypeResolverDefinition ]
]

{ #category : #mappings }
RDMBSRepository >> configureMappingsIn: aBlock [

	aBlock cull: self.
	self withSessionDo: [ :session | session system: session system ]
]

{ #category : #'private - accessing' }
RDMBSRepository >> conflictCheckingStrategy [

	^ conflictCheckingStrategy
]

{ #category : #querying }
RDMBSRepository >> countMatching: aCriteriaOrBlock [

	^ self
		withReadSessionDo: [ :session | session count: modelObjectClass where: ( self asMatchingCriteria: aCriteriaOrBlock ) ]
]

{ #category : #'private - accessing' }
RDMBSRepository >> executeQuery: query [

	^ self withReadSessionDo: [ :session | session execute: query ]
]

{ #category : #querying }
RDMBSRepository >> findAll [

	^ self withReadSessionDo: [ :session | session read: modelObjectClass ]
]

{ #category : #querying }
RDMBSRepository >> findAllMatching: aCriteriaOrBlock [

	^ self executeQuery: ( SimpleQuery read: modelObjectClass where: ( self asMatchingCriteria: aCriteriaOrBlock ) )
]

{ #category : #querying }
RDMBSRepository >> findAllMatching: aCriteriaOrBlock sortedBy: aSortFunction [

	| query |

	query := SimpleQuery read: modelObjectClass where: ( self asMatchingCriteria: aCriteriaOrBlock ).
	aSortFunction asSortFunction asOrderByIn: query.
	^ self executeQuery: query
]

{ #category : #'private - error handling' }
RDMBSRepository >> handleReadErrorsDuring: aBlock [

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
RDMBSRepository >> handleWriteErrorsDuring: aBlock [

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
RDMBSRepository >> inUnitOfWorkDo: aBlock [

	^ self withSessionDo: [ :session | self handleWriteErrorsDuring: [ session inUnitOfWorkDo: aBlock ] ]
]

{ #category : #initialization }
RDMBSRepository >> initializeStoringObjectsOfType: aDomainObjectClass
	checkingConflictsAccordingTo: aConflictCheckingStrategy
	workingWith: aSessionProvider [

	modelObjectClass := aDomainObjectClass.
	conflictCheckingStrategy := aConflictCheckingStrategy.
	sessionProvider := aSessionProvider
]

{ #category : #'private - accessing' }
RDMBSRepository >> matchingCriteriaBuilder [

	^ RDBMSRepositoryMatchingCriteriaBuilder new
]

{ #category : #'private - management' }
RDMBSRepository >> purgeAfterCheckingInclusion: aDomainObject [

	self inUnitOfWorkDo: [ :session | session delete: aDomainObject ].
	^ aDomainObject
]

{ #category : #management }
RDMBSRepository >> purgeAllMatching: aCriteriaOrBlock [

	self inUnitOfWorkDo: [ :session | session delete: modelObjectClass where: ( self asMatchingCriteria: aCriteriaOrBlock ) ]
]

{ #category : #'private - management' }
RDMBSRepository >> storeAfterCheckingConflicts: aDomainObject [

	self inUnitOfWorkDo: [ :session | session register: aDomainObject ].
	^ aDomainObject
]

{ #category : #management }
RDMBSRepository >> update: aMutableDomainObject executing: aMonadycBlock [

	self inUnitOfWorkDo: [ :session | session modify: aMutableDomainObject in: [ aMonadycBlock value: aMutableDomainObject ] ].
	^ self withReadSessionDo: [ :session | session refresh: aMutableDomainObject ]
]

{ #category : #'private - management' }
RDMBSRepository >> updateAfterCheckingConflicts: aDomainObject with: anUpdatedDomainObject [

	^self update: aDomainObject executing: [:original | original synchronizeWith: anUpdatedDomainObject]
]

{ #category : #querying }
RDMBSRepository >> withOneMatching: aCriteriaOrBlock do: foundBlock else: noneBlock [

	| query |

	query := SimpleQuery readOneOf: modelObjectClass where: ( self asMatchingCriteria: aCriteriaOrBlock ).
	^ ( self executeQuery: query ) ifNil: noneBlock ifNotNil: foundBlock
]

{ #category : #querying }
RDMBSRepository >> withOneMatching: aCriteriaOrBlock sortedBy: aSortFunction do: foundBlock else: noneBlock [

	| query |

	query := SimpleQuery readOneOf: modelObjectClass where: ( self asMatchingCriteria: aCriteriaOrBlock ).
	aSortFunction asSortFunction asOrderByIn: query.
	^ ( self executeQuery: query ) ifNil: noneBlock ifNotNil: foundBlock
]

{ #category : #'private - accessing' }
RDMBSRepository >> withReadSessionDo: aBlock [

	^ self withSessionDo: [ :session | self handleReadErrorsDuring: [ aBlock value: session ] ]
]

{ #category : #'private - accessing' }
RDMBSRepository >> withSessionDo: aBlock [

	^ aBlock value: sessionProvider value
]
