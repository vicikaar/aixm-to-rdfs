# aixm-to-rdfs
Master thesis by Victoria Kaar

Folder “Schema Mapping” → Contains the XQuery module which is used to generate the RDF Schema from AIXM/XML.

Folder “Instanzdaten Mapping” → Contains the XQuery module which is used to generate RML mapping rules in RDF/XML. 

RMLMapper only processes the mapping rules if they are written in RDF/Turtle. Therefore the project KnowledgeGraph is needed. This project turns RDF/XML into RDF/Turtle. 

Link to RMLMapper: https://github.com/RMLio/rmlmapper-java
Link to the schema input data: http://aixm.aero/document/aixm-511-data-model-uml
Link to the input data of the instance data: https://github.com/aixm/donlon
