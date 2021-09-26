import module namespace test="http://www.w3.org/2000/01/rdf-schema#" at "C:\Users\Victoria\Documents\Uni\01_Master\Masterarbeit\workspace\Module\xml2rdfs-AIXM-Original.xqm";

import module namespace file = 'http://expath.org/ns/file';

declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace xmi = "http://schema.omg.org/spec/XMI/2.1";
declare namespace uml = "http://schema.omg.org/spec/UML/2.1";
declare namespace rdfs="http://www.w3.org/2000/01/rdf-schema#";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare variable $filePath := "C:\Users\Victoria\Documents\Uni\01_Master\Masterarbeit\workspace\KnowledgeGraph\RDF-Schema-FULL.rdf";

file:write($filePath, rdfs:extractRDFSchema(db:open("AIXM_5.1.1")/xmi:XMI)),
rdfs:extractRDFSchema(db:open("AIXM_5.1.1")/xmi:XMI)