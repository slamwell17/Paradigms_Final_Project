(define (check-solution board actual)
  
  (define (count-occurrences x col)
    (cond ((null? x) 0)
          (else (if (eq? (car x) col) (+ 1 (count-occurrences (cdr x) col)) (+ 0 (count-occurrences (cdr x) col))))))
  
  (define (nth-occur-of-color x index counter)
    (let ((color-at (list-ref board index)))
      (cond ((>= counter index) 0)
            (else
             (cond
               ((eq? color-at (car x)) (+ 1 (nth-occur-of-color (cdr x) index (+ 1 counter))))
               (else (nth-occur-of-color (cdr x) index (+ 1 counter)))) ))))
  (define (number-of-correct col)
    (apply +
           (map (lambda (a b) (if (and (eq? a b) (eq? a col)) 1 0)) board actual)))
  
  (define (check-iter index)
    (cond ((>= index (length actual)) '())
          (else 
           (cond ((eq? (list-ref board index) (list-ref actual index)) (cons 'b (check-iter (+ 1 index))))
                 ((and
                   (not (zero? (count-occurrences actual (list-ref board index))))
                   (<= (+ (nth-occur-of-color board index 0) (number-of-correct (list-ref board index)))  (count-occurrences actual (list-ref board index))))
                  (cons 'w (check-iter (+ 1 index))))
                 (else (cons 'e (check-iter (+ 1 index))))))))
  
  (check-iter 0))



(define colorarray (list 'r 'g 'b 'y 'w 'k 'o 'p))

(define poss (list colorarray colorarray colorarray colorarray))

(define total-guess '(r r b y))
(define total-feedback '(b e b e))

(define (update total-guess total-feedback)
  (define (inner-update poss feedback guess)
    (cond ((eq? feedback 'b) (list guess))
          ((eq? feedback 'w) (remove guess poss))
          ((eq? feedback 'e) (remove guess poss))))
  (list (inner-update (car poss) (car total-feedback) (car total-guess))
        (inner-update (cadr poss) (cadr total-feedback) (cadr total-guess))
        (inner-update (caddr poss) (caddr total-feedback) (caddr total-guess))
        (inner-update (cadddr poss) (cadddr total-feedback) (cadddr total-guess))))