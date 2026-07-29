import SumDiffExponentMain
import SumDiffExponentQuantitative

/-!
Prints the full axiom footprint of the headline theorems.
Run with:  lake env lean scripts/CheckAxioms.lean
A `sorry` anywhere in a proof would surface here as `sorryAx`.
-/

open SumDiffExponent

#print axioms growthExponent_lt_two
#print axioms tendsto_growthExponent_approximatingSet
#print axioms isLUB_admissibleExponents
#print axioms sSup_admissibleExponents
#print axioms supremum_not_attained
#print axioms quantitative_example
