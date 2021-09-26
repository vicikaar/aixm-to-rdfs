import module namespace test="http://www.w3.org/2000/01/rdf-schema#" at "C:\Users\Victoria\Documents\Uni\01_Master\Masterarbeit\workspace\Module\rule-generator.xqm";

import module namespace file = 'http://expath.org/ns/file';

declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace xmi = "http://schema.omg.org/spec/XMI/2.1";
declare namespace uml = "http://schema.omg.org/spec/UML/2.1";
declare namespace rdfs="http://www.w3.org/2000/01/rdf-schema#";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";
declare namespace aixm = "http://www.aixm.aero/schema/5.1.1";

declare variable $outputFilePath := "C:\Users\Victoria\Documents\Uni\01_Master\Masterarbeit\workspace\KnowledgeGraph\RDF-Rules.xml";
declare variable $iriPath := "http://example.org/AirportHeliport";
declare variable $inputFileName := "airport-heliport-simplified.xml";
declare variable $iterator := "/AIXMBasicMessage//AirportHeliport//AirportHeliportTimeSlice";

file:write($outputFilePath, rdfs:generateTriplesMap(xquery:eval('db:open("airport-heliport-simplified")'||$iterator), $inputFileName, $iterator, $iriPath)),
rdfs:generateTriplesMap(xquery:eval('db:open("airport-heliport-simplified")'||$iterator), $inputFileName, $iterator, $iriPath)