;; G20 Analogical Reasoning - Domain Encoding (P1)
;; Two base-target pairs for Gentner-style Structure Mapping

;; === Type Declarations ===
(: Domain Type)
(: Entity Type)
(: Relation Type)
(: orbits (-> Entity Entity Relation))
(: attracts (-> Entity Entity Relation))
(: more-massive (-> Entity Entity Relation))
(: greater-than (-> Entity Entity Relation))
(: flows-from (-> Entity Entity Relation))
(: causes (-> Relation Relation Relation))
(: domain-of (-> Entity Domain))

;; === Domain Tags ===
(: solar-system Domain)
(: rutherford-atom Domain)
(: water-flow Domain)
(: heat-flow Domain)

;; === Pair 1 BASE: Solar System ===
(: sun Entity)
(: planet Entity)
(domain-of sun solar-system)
(domain-of planet solar-system)
(orbits planet sun)
(attracts sun planet)
(more-massive sun planet)
(causes (attracts sun planet) (orbits planet sun))

;; === Pair 1 TARGET: Rutherford Atom ===
(: nucleus Entity)
(: electron Entity)
(domain-of nucleus rutherford-atom)
(domain-of electron rutherford-atom)
(orbits electron nucleus)
(attracts nucleus electron)
(more-massive nucleus electron)
(causes (attracts nucleus electron) (orbits electron nucleus))

;; === Pair 2 BASE: Water Flow ===
(: beaker1 Entity)
(: beaker2 Entity)
(: pressure1 Entity)
(: pressure2 Entity)
(domain-of beaker1 water-flow)
(domain-of beaker2 water-flow)
(domain-of pressure1 water-flow)
(domain-of pressure2 water-flow)
(flows-from beaker1 beaker2)
(greater-than pressure1 pressure2)
(causes (greater-than pressure1 pressure2) (flows-from beaker1 beaker2))

;; === Pair 2 TARGET: Heat Flow ===
(: coffee Entity)
(: ice-cube Entity)
(: temp-coffee Entity)
(: temp-ice Entity)
(domain-of coffee heat-flow)
(domain-of ice-cube heat-flow)
(domain-of temp-coffee heat-flow)
(domain-of temp-ice heat-flow)
(flows-from coffee ice-cube)
(greater-than temp-coffee temp-ice)
(causes (greater-than temp-coffee temp-ice) (flows-from coffee ice-cube))