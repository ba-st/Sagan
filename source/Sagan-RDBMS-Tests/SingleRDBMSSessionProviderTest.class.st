Class {
	#name : 'SingleRDBMSSessionProviderTest',
	#superclass : 'RDBMSSessionProviderTest',
	#category : 'Sagan-RDBMS-Tests',
	#package : 'Sagan-RDBMS-Tests'
}

{ #category : 'tests' }
SingleRDBMSSessionProviderTest >> testHandleFailingLogin [

	| sessionProvider |

	self timeLimit: 30 seconds.
	self withLoggingAsserterDo: [ :asserter | 
		self
			should: [ 
				asserter
					runMemoryLoggerDuring: [ 
						sessionProvider := SingleRDBMSSessionProvider
							                   loginWith: self class failingLogin
							                   configuredBy: [ :options | options at: #logDatabaseEvents put: true ]
						];
					assertLogRecordsMatch: #(  ).

				asserter
					runMemoryLoggerDuring: [ sessionProvider withSessionDo: [ :session |  ] ];
					assertLogRecordsMatch: #(  )
				]
			raise: DatabaseLoginFailed
			withMessageText: self expectedFailingLogingMessage.

		asserter assertLogRecordsMatch: { 
				'[DEBUG] Glorp event received {"detail":"Login"}'.
				( '[WARNING] Failed to connect to database after 1 attempts because <1s>' expandMacrosWith:
					  self expectedFailingLogingMessage ).
				'[DEBUG] Glorp event received {"detail":"Login"}'.
				( '[WARNING] Failed to connect to database after 2 attempts because <1s>' expandMacrosWith:
					  self expectedFailingLogingMessage ).
				'[DEBUG] Glorp event received {"detail":"Login"}'.
				( '[WARNING] Failed to connect to database after 3 attempts because <1s>' expandMacrosWith:
					  self expectedFailingLogingMessage ).
				'[DEBUG] Glorp event received {"detail":"Login"}' }
		]
]

{ #category : 'tests' }
SingleRDBMSSessionProviderTest >> testLogsInWhenReusingSession [

	| sessionProvider |

	sessionProvider := SingleRDBMSSessionProvider
		                   loginWith: self class login
		                   configuredBy: [ :options | options at: #logDatabaseEvents put: true ].

	self withLoggingAsserterDo: [ :asserter | 
		asserter
			runMemoryLoggerDuring: [ sessionProvider withSessionDo: [ :session | session logout ] ];
			assertLogRecordsMatch: #( '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}'
				   '[DEBUG] Glorp event received {"detail":"Logout"}'
				   '[DEBUG] Glorp event received {"detail":"Logout finished"}' ).

		asserter
			runMemoryLoggerDuring: [ sessionProvider withSessionDo: [ :session |  ] ];
			assertLogRecordsMatch: #( '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}'
				   '[DEBUG] Glorp event received {"detail":"Logout"}'
				   '[DEBUG] Glorp event received {"detail":"Logout finished"}'
				   '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}' )
		]
]

{ #category : 'tests' }
SingleRDBMSSessionProviderTest >> testLogsInWhenSessionFirstUsed [

	| sessionProvider |

	self withLoggingAsserterDo: [ :asserter | 
		asserter
			runMemoryLoggerDuring: [ 
				sessionProvider := SingleRDBMSSessionProvider
					                   loginWith: self class login
					                   configuredBy: [ :options | options at: #logDatabaseEvents put: true ]
				];
			assertLogRecordsMatch: #(  ).

		asserter
			runMemoryLoggerDuring: [ sessionProvider withSessionDo: [ :session |  ] ];
			assertLogRecordsMatch: #( '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}' )
		]
]
