module namespace rdfs="http://www.w3.org/2000/01/rdf-schema#";

declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace rr="http://www.w3.org/ns/r2rml#";
declare namespace aixm = "http://www.aixm.aero/schema/5.1.1";
declare namespace rml ="http://semweb.mmlab.be/ns/rml#";

declare function rdfs:generateTriplesMap(
  $rdfSchema as item()+,
  $inputFileName as xs:string,
  $iterator as xs:string, 
  $iriPath as xs:string
) as element()+ {
  let $logicalSource := rdfs:generateLogicalSource($inputFileName, $iterator)
  let $subjectMaps := rdfs:generateSubjectMap($inputFileName, $iriPath)
  let $predicateObjectMaps := rdfs:generatePredicateObjectMaps($inputFileName, $iterator, $iriPath)
  let $predicateObjectMapRules := rdfs:generatePredicateObjectMapsRules($rdfSchema)
  let $predicateObjectMapRelations := rdfs:generatePredicateObjectMapsRelations($rdfSchema, $inputFileName, $iriPath, $iterator)
  return 
    <rdf:RDF>
      <rr:TriplesMap rdf:about="http://example.com/ns#TriplesMapAirportHeliport">
        {$logicalSource}
        {$subjectMaps}
        {$predicateObjectMaps}
        {$predicateObjectMapRules}
        {$predicateObjectMapRelations}
      </rr:TriplesMap>
    </rdf:RDF>
};

declare function rdfs:generateLogicalSource(
  $inputFileName as xs:string,
  $iterator as xs:string
) as element()+{
  let $i := $iterator
  return
    <rml:logicalSource rdf:parseType="Resource">
        <rml:source>{$inputFileName}</rml:source>
        <rml:referenceFormulation rdf:resource="http://semweb.mmlab.be/ns/ql#XPath"/>
        <rml:iterator>{$iterator}</rml:iterator>
    </rml:logicalSource>
};

declare function rdfs:generateSubjectMap(
  $inputFileName as xs:string,
  $iriPath as xs:string
) as element()+{
  let $path := $inputFileName
  return
    <rr:subjectMap rdf:parseType="Resource">
        <rr:template>{concat($iriPath, "/{@id}")}</rr:template>
    </rr:subjectMap>
};

declare function rdfs:generatePredicateObjectMaps(
  $inputFileName as xs:string,
  $iterator as xs:string, 
  $iriPath as xs:string
) as element()+{
  let $i := $inputFileName
  return
  <rr:predicateObjectMap rdf:parseType="Resource">
    <rr:predicate rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#type"/>
    <rr:objectMap rdf:parseType="Resource">
      <rr:constant rdf:resource="http://www.aixm.aero/schema/5.1.1/AirportHeliport"/>
    </rr:objectMap>
  </rr:predicateObjectMap>
};

declare function rdfs:generatePredicateObjectMapsRules(
  $rdfSchema as item()+
) as element()+{
    let $source := $rdfSchema[1]
      let $labels := $source/*
      for $label in $labels
        let $children := $label/*
        let $resource := concat("http://www.aixm.aero/schema/5.1.1/", $label/name())
        return 
          if(fn:not(fn:exists($children))) then
          <rr:predicateObjectMap rdf:parseType="Resource">
            <rr:predicate rdf:resource="{$resource}"/>
            <rr:objectMap rdf:parseType="Resource">
              <rml:reference>{$label/name()}</rml:reference>
            </rr:objectMap>
          </rr:predicateObjectMap>
};

declare function rdfs:generatePredicateObjectMapsRelations(
  $rdfSchema as item()+, 
  $inputFileName as xs:string, 
  $iriPath as xs:string, 
  $iterator as xs:string
) as element ()+{
  let $source := $rdfSchema[1]/*
  let $labels := $source/*
  for $label in $labels
  return 
    if (fn:exists($label)) then 
      rdfs:generateRecursion($label, $iterator, $inputFileName, $iriPath)      
};

declare function rdfs:generateRecursion(
  $label as element()+, 
  $iterator as xs:string,
  $inputFileName as xs:string, 
  $iriPath as xs:string
) as element()+{
  let $children := $label/*
  return 
  (
    if(fn:not(fn:exists($children/*)))then
      let $resource := concat("http://www.aixm.aero/schema/5.1.1/", $label/parent::*/name()) 
      let $iteratorRelation := concat($iterator, "//", $label/name())
      let $parent := "@id"
      let $child := concat($label/parent::*/name(), "/", $label/name(), "/", "@id")
      return
        <rr:predicateObjectMap rdf:parseType="Resource">
          <rr:predicate rdf:resource="{$resource}"/>
          <rr:objectMap rdf:parseType="Resource">
            <rr:parentTriplesMap>
              <rdf:Description rdf:about="{concat("http://example.com/ns#TriplesMap", $label/name(), "-", $label/@id)}">
                <rml:logicalSource rdf:parseType="Resource">
                  <rml:iterator>{$iteratorRelation}</rml:iterator>
                  <rml:referenceFormulation rdf:resource="http://semweb.mmlab.be/ns/ql#XPath"/>
                  <rml:source>{$inputFileName}</rml:source>
                </rml:logicalSource>
                <rr:subjectMap rdf:parseType="Resource">
                  <rr:template>{concat($iriPath, "/", $label/name(), "/{@id}")}</rr:template>
                </rr:subjectMap>
                {
                  let $children := $label/*
                  for $child in $children
                    let $childResource := concat("http://www.aixm.aero/schema/5.1.1/", $child/name())
                    return
                     <rr:predicateObjectMap rdf:parseType="Resource">
                       <rr:predicate rdf:resource="{$childResource}"/>
                       <rr:objectMap rdf:parseType="Resource">
                         <rml:reference>{$child/name()}</rml:reference>
                       </rr:objectMap>
                     </rr:predicateObjectMap>
                }
              </rdf:Description>
            </rr:parentTriplesMap>
            <rr:joinCondition rdf:parseType="Resource">
              <rr:parent>{$parent}</rr:parent>
              <rr:child>{$child}</rr:child>
            </rr:joinCondition>
          </rr:objectMap>
        </rr:predicateObjectMap>
    else
      rdfs:generateRecursion($children, $iterator, $inputFileName, $iriPath)
    )
};