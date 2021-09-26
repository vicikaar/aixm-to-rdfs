module namespace rdfs="http://www.w3.org/2000/01/rdf-schema#";

declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace xmi = "http://schema.omg.org/spec/XMI/2.1";
declare namespace uml = "http://schema.omg.org/spec/UML/2.1";

declare function rdfs:extractRDFSchema(
  $rdfSchema as element()
) as element()+ {
  
  let $allElements := $rdfSchema//ownedMember
  let $allClassElements := $allElements[@xmi:type="uml:Class"]
  let $allDiagrams := $rdfSchema//diagram
  let $allGeneralizations := $rdfSchema//connector
  
  let $elements := rdfs:extractUMLElements($allGeneralizations, $allClassElements, $allElements)
  let $attributes := rdfs:extractUMLAttributes($allClassElements)
  let $associations := rdfs:extractUMLAssociations($allGeneralizations, $allClassElements)
  let $diagrams := rdfs:extractUMLDiagrams($allDiagrams)
  let $diagramElements := rdfs:extractUMLDiagramElements($allElements, $allDiagrams)
  return 
    <rdf:RDF>
      {$elements}
      {$attributes}
      {$associations}
      {$diagrams}
      {$diagramElements}
    </rdf:RDF>
};

declare function rdfs:extractUMLElements(
  $allGeneralizations as element()+, 
  $allClassElements as element()+,
  $allElements as element()+
) as element()+{
  for $element in $allClassElements
  let $elementIRI := "http://aixm.aero/" || "#" ||$element/@name/string()
  return 
    <rdfs:Class rdf:about="{$elementIRI}">
    {
      let $generalizations := $allGeneralizations
      for $generalization in $generalizations
      where $generalization/properties[@ea_type="Generalization"]
        and $generalization/source[@xmi:idref=$element/@xmi:id]
      let $generalizationName := $allElements[@xmi:id = $generalization/target/@xmi:idref]
      let $generalizationIRI := "http://aixm.aero/" || "#" || $generalizationName/@name/string()
      return
        <rdfs:subClassOf rdf:resource="{$generalizationIRI}"/>
    }
    </rdfs:Class>
};

declare function rdfs:extractUMLAttributes(
  $allClassElements as element()+ 
) as element()+{
  for $element in $allClassElements
  let $elementIRI := "http://aixm.aero/" || "#" ||$element/@name/string()
  return 
      let $attributes := $element/ownedAttribute
      for $attribute in $attributes
      let $attributeIRI := "http://aixm.aero/" || "#" || $element/@name/string() || "-" || $attribute/@name/string()
      let $elementName := $allClassElements[@xmi:id = $attribute/type/@xmi:idref]
      let $rangeIRI := "http://aixm.aero/" || "#" || $elementName/@name/string()
      return
        <rdfs:Property rdf:about="{$attributeIRI}">
          <rdfs:domain rdf:resource="{$elementIRI}"/>
          <rdfs:range rdf:resource="{$rangeIRI}"/>
        </rdfs:Property>
};

declare function rdfs:extractUMLAssociations(
  $allGeneralizations as element()+, 
  $allClassElements as element()+
) as element()+{
  for $element in $allClassElements
  let $elementIRI := "http://aixm.aero/" || "#" ||$element/@name/string()
  return 
      let $associations := $allGeneralizations
      for $association in $associations
      where $association/properties[@ea_type="Association"] 
        and ($association/target[@xmi:idref=$element/@xmi:id] 
          or $association/source[@xmi:idref=$element/@xmi:id])
      let $domainIRI := "http://aixm.aero/" || "#" || $association/source/model/@name
      let $rangeIRI := "http://aixm.aero/" || "#" || $association/target/model/@name
      return 
        if($association/properties[@direction="Source -&gt; Destination"]) then
          <rdfs:Property rdf:about="{"http://aixm.aero/" || "#" || $association/source/model/@name  || "-" || $association/labels/@mt}">
            <rdfs:domain rdf:resource="{$domainIRI}"/>
            <rdfs:range rdf:resource="{$rangeIRI}"/>
          </rdfs:Property>
        else
          <rdfs:Property rdf:about="{"http://aixm.aero/" || "#" || $association/target/model/@name || "-" || $association/labels/@mt}">
            <rdfs:domain rdf:resource="{$rangeIRI}"/>
            <rdfs:range rdf:resource="{$domainIRI}"/>
          </rdfs:Property>
};

declare function rdfs:extractUMLDiagrams(
  $allDiagrams as element()+
) as element()+{
  for $diagram in $allDiagrams
  let $diagramIRI := "http://aixm.aero/" || "#" ||fn:replace($diagram/properties/@name/string(), " ", "")
  return 
    <rdfs:Class rdf:about="{$diagramIRI}"/>
};

declare function rdfs:extractUMLDiagramElements(
  $allElements as element()+,
  $allDiagrams as element()+
) as element()+ {
  for $diagram in $allDiagrams
  let $diagramIRI := "http://aixm.aero/" || "#" ||fn:replace($diagram/properties/@name/string(), " ", "")
  return 
      let $elements := $diagram/elements/element
      for $element in $elements
      let $elementName := $allElements[@xmi:id = $element/@subject]
      let $elementIRI := "http://aixm.aero/" || "#" || $elementName/@name/string()
      return
        <rdfs:Property rdf:about="https://aixm.aero/#hasElement">
          <rdfs:domain rdf:resource="{$diagramIRI}"/>
          <rdfs:range rdf:resource="{$elementIRI}"/>
        </rdfs:Property>
};