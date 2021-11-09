Class {
	#name : #RDBMSMappingConfiguration,
	#superclass : #Object,
	#category : #'Sagan-RDBMS'
}

{ #category : #applying }
RDBMSMappingConfiguration >> applyTo: aRepository [

	self subclassResponsibility 
]
