Class {
	#name : #RDBMSRepository,
	#superclass : #Repository,
	#instVars : [
		'descriptorSystem',
		'modelObjectClass',
		'conflictCheckingStrategy',
		'sessionProvider'
	],
	#category : #'Sagan-RDBMS-Repository'
}

{ #category : #'instance creation' }
RDBMSRepository class >> storingObjectsOfType: aDomainObjectClass checkingConflictsAccordingTo: aConflictCheckingStrategy workingWith: aSessionProvider [

	^ self new
		initializeStoringObjectsOfType: aDomainObjectClass
		checkingConflictsAccordingTo: aConflictCheckingStrategy
		workingWith: aSessionProvider
]

{ #category : #mappings }
RDBMSRepository >> beAwareOfClassModelDefinedBy: aClassModelDefinition [

	sessionProvider
		withConfigurationSessionDo: [ :session | session system addClassModelDefinedBy: aClassModelDefinition ]
]

{ #category : #mappings }
RDBMSRepository >> beAwareOfDescriptorDefinedBy: aDescriptorDefinition [

	sessionProvider
		withConfigurationSessionDo: [ :session | session system addDescriptorDefinedBy: aDescriptorDefinition ]
]

{ #category : #mappings }
RDBMSRepository >> beAwareOfTableDefinedBy: aTableDefinition [

	sessionProvider
		withConfigurationSessionDo: [ :session | session system addTableDefinedBy: aTableDefinition ]
]

{ #category : #mappings }
RDBMSRepository >> beAwareOfTypeResolverDefinedBy: aTypeResolverDefinition [

	sessionProvider
		withConfigurationSessionDo: [ :session | session system addTypeResolverDefinedBy: aTypeResolverDefinition ]
]

{ #category : #mappings }
RDBMSRepository >> configureMappingsIn: aBlock [

	aBlock cull: self
]

{ #category : #'private - accessing' }
RDBMSRepository >> conflictCheckingStrategy [

	^ conflictCheckingStrategy
]

{ #category : #querying }
RDBMSRepository >> countMatching: aCriteriaOrBlock [

	^ self
		withReadSessionDo: [ :session | session count: modelObjectClass where: ( self asMatchingCriteria: aCriteriaOrBlock ) ]
]

{ #category : #'private - accessing' }
RDBMSRepository >> executeQuery: query [

	^ self withReadSessionDo: [ :session | session execute: query ]
]

{ #category : #querying }
RDBMSRepository >> findAll [

	^ self withReadSessionDo: [ :session | session read: modelObjectClass ]
]

{ #category : #querying }
RDBMSRepository >> findAllMatching: aCriteriaOrBlock [

	^ self executeQuery: ( SimpleQuery read: modelObjectClass where: ( self asMatchingCriteria: aCriteriaOrBlock ) )
]

{ #category : #querying }
RDBMSRepository >> findAllMatching: aCriteriaOrBlock sortedBy: aSortFunction [

	| query |

	query := SimpleQuery read: modelObjectClass where: ( self asMatchingCriteria: aCriteriaOrBlock ).
	aSortFunction asSortFunction asOrderByIn: query.
	^ self executeQuery: query
]

{ #category : #'private - error handling' }
RDBMSRepository >> handleReadErrorsDuring: aBlock [

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
RDBMSRepository >> handleWriteErrorsDuring: aBlock [

	^ aBlock
		on: GlorpDatabaseWriteError
		do: [ :error | 
			PersistenceCommandFailed
				signal: 'Cannot perform the action due to some persistence error while writing.'
				dueTo: error
				because: error databaseError asString
			]
]

{ #category : #initialization }
RDBMSRepository >> initializeStoringObjectsOfType: aDomainObjectClass
	checkingConflictsAccordingTo: aConflictCheckingStrategy
	workingWith: aSessionProvider [

	modelObjectClass := aDomainObjectClass.
	conflictCheckingStrategy := aConflictCheckingStrategy.
	sessionProvider := aSessionProvider
]

{ #category : #'private - accessing' }
RDBMSRepository >> matchingCriteriaBuilder [

	^ RDBMSRepositoryMatchingCriteriaBuilder new
]

{ #category : #'private - management' }
RDBMSRepository >> purgeAfterCheckingInclusion: aDomainObject [

	self transact: [ :session | session delete: aDomainObject ].
	^ aDomainObject
]

{ #category : #management }
RDBMSRepository >> purgeAllMatching: aCriteriaOrBlock [

	self transact: [ :session | session delete: modelObjectClass where: ( self asMatchingCriteria: aCriteriaOrBlock ) ]
]

{ #category : #'private - management' }
RDBMSRepository >> storeAfterCheckingConflicts: aDomainObject [

	self transact: [ :session | session register: aDomainObject ].
	^ aDomainObject
]

{ #category : #management }
RDBMSRepository >> transact: aBlock [

	^ sessionProvider
		withSessionDo: [ :session | self handleWriteErrorsDuring: [ session inUnitOfWorkDo: aBlock ] ]
]

{ #category : #management }
RDBMSRepository >> update: aMutableDomainObject executing: aMonadycBlock [

	^ self
		transact: [ :session | 
			| originalObject |

			originalObject := session refresh: aMutableDomainObject.
			session modify: originalObject in: [ aMonadycBlock value: originalObject ]
			]
]

{ #category : #'private - management' }
RDBMSRepository >> updateAfterCheckingConflicts: aDomainObject with: anUpdatedDomainObject [

	^self update: aDomainObject executing: [:original | original synchronizeWith: anUpdatedDomainObject]
]

{ #category : #querying }
RDBMSRepository >> withOneMatching: aCriteriaOrBlock do: foundBlock else: noneBlock [

	| query |

	query := SimpleQuery readOneOf: modelObjectClass where: ( self asMatchingCriteria: aCriteriaOrBlock ).
	^ ( self executeQuery: query ) ifNil: noneBlock ifNotNil: foundBlock
]

{ #category : #querying }
RDBMSRepository >> withOneMatching: aCriteriaOrBlock sortedBy: aSortFunction do: foundBlock else: noneBlock [

	| query |

	query := SimpleQuery readOneOf: modelObjectClass where: ( self asMatchingCriteria: aCriteriaOrBlock ).
	aSortFunction asSortFunction asOrderByIn: query.
	^ ( self executeQuery: query ) ifNil: noneBlock ifNotNil: foundBlock
]

{ #category : #'private - accessing' }
RDBMSRepository >> withReadSessionDo: aBlock [

	^ sessionProvider
		withSessionDo: [ :session | self handleReadErrorsDuring: [ aBlock value: session ] ]
]
