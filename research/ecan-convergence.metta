!(import! &self /PeTTa/repos/OmegaClaw-Core/lib_nal.metta)

;; PROJECT V: Multi-Step ECAN with Convergence Detection
;; Oma, 2026-04-27. Extends R (collapse barriers) + T (ECAN+PLN).

;; === ECAN FUNCTIONS ===
(= (update-sti $a $new) (let $old (match &self (sti $a $v) $v) (let $_ (remove-atom &self (sti $a $old)) (add-atom &self (sti $a $new)))))
(= (spread $src $tgt $w) (let $sv (match &self (sti $src $v) $v) (let $transfer (* $sv $w) (let $_ (update-sti $src (- $sv $transfer)) (let $tv (match &self (sti $tgt $u) $u) (let $_ (update-sti $tgt (+ $tv $transfer)) (spread-done $src $tgt $transfer)))))))
(= (spread-all) (let $link (match &self (link $s $t $w) ($s $t $w)) (let ($a $b $c) $link (spread $a $b $c))))
(= (rent $a $tax) (let $old (match &self (sti $a $v) $v) (update-sti $a (- $old $tax))))
(= (rent-all $tax) (let $a (match &self (sti $x $v) $x) (rent $a $tax)))
(= (evict $thresh) (let $x (match &self (sti $a $v) (if (< $v $thresh) $a (empty))) (let $val (match &self (sti $x $w) $w) (let $_ (remove-atom &self (sti $x $val)) (evicted $x)))))
(= (step) (let $_ (collapse (spread-all)) (let $_ (collapse (rent-all 10)) (collapse (evict 15)))))

;; === SNAPSHOT + DELTA (add-atom/remove-atom accumulator) ===
(= (snapshot) (collapse (match &self (sti $x $v) ($x $v))))
(= (abs-val $x) (if (< $x 0) (* $x -1) $x))
(= (max2 $a $b) (if (> $a $b) $a $b))
(= (update-max-delta $name $old-sti)
  (let $new (match &self (sti $name $v) $v)
    (let $d (abs-val (- $new $old-sti))
      (let $cur (match &self (max-delta-val $c) $c)
        (if (> $d $cur)
          (let $_ (remove-atom &self (max-delta-val $cur))
            (add-atom &self (max-delta-val $d)))
          (nop))))))
(= (max-delta $snap)
  (let $_ (add-atom &self (max-delta-val 0))
    (let $_ (collapse (let ($n $v) (superpose $snap) (update-max-delta $n $v)))
      (let $result (match &self (max-delta-val $r) $r)
        (let $_ (remove-atom &self (max-delta-val $result))
          $result)))))

;; === CONVERGENCE LOOP ===
(= (run-until-converged $eps $maxn 0) (timeout-after $maxn))
(= (run-until-converged $eps $maxn $n) (if (> $n 0) (let $snap (snapshot) (let $_ (step) (let $md (max-delta $snap) (if (< $md $eps) (converged-at (- $maxn $n)) (run-until-converged $eps $maxn (- $n 1)))))) (timeout-after $maxn)))

;; === TEST GRAPH ===
!(add-atom &self (sti robin 100))
!(add-atom &self (sti bird 50))
!(add-atom &self (sti feathered 30))
!(add-atom &self (sti flies 25))
!(add-atom &self (sti airborne 15))
!(add-atom &self (sti organism 12))
!(add-atom &self (link robin bird 0.3))
!(add-atom &self (link bird feathered 0.2))
!(add-atom &self (link feathered flies 0.2))
!(add-atom &self (link flies airborne 0.2))
!(add-atom &self (link robin organism 0.1))

;; === RUN ===
!(println! "--- CONVERGENCE RUN ---")
!(run-until-converged 2.0 10 10)
!(println! "--- SURVIVORS ---")
!(match &self (sti $x $y) (survivor $x $y))
