Class {
	#name : 'RDBMSSessionProviderTest',
	#superclass : 'TestCase',
	#category : 'Sagan-RDBMS-Tests',
	#package : 'Sagan-RDBMS-Tests'
}

{ #category : 'private - protocol' }
RDBMSSessionProviderTest class >> failingLogin [

	^ Login new
		  database: self login database;
		  username: 'blabla';
		  password: 'blabla';
		  host: 'localhost';
		  port: 2345;
		  databaseName: 'not-a-database';
		  yourself
]

{ #category : 'private - protocol' }
RDBMSSessionProviderTest class >> login [

	^ SingleSessionRDMBSRepositoryTest login 
]

{ #category : 'tests' }
RDBMSSessionProviderTest >> expectedFailingLoginMessage [

  ^ DatabaseAccessor classForThisPlatform DefaultDriver = SQLite3Driver
      then: [ 'SQLite3CantOpen: unable to open database file' ]
      otherwise: [
          SystemVersion current major >= 12
            then: [ 'ConnectionClosed: Connection aborted to 127.0.0.1:2345' ]
            otherwise: [ 'ConnectionTimedOut: Cannot connect to 127.0.0.1:2345' ]
        ]
]

{ #category : 'tests' }
RDBMSSessionProviderTest >> withLoggingAsserterDo: aOneArgBlock [

	| loggingAsserter |

	loggingAsserter := LoggingAsserter on: self.

	[ aOneArgBlock value: loggingAsserter ] ensure: [ loggingAsserter stopLoggers ]
]
