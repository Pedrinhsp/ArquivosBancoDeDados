use sakila;

delimiter $$
CREATE FUNCTION nome_comp(id_cod int)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
DECLARE nomecomp VARCHAR(70);
SELECT CONCAT(first_name, ' ', last_name) into nomecomp FROM customer WHERE customer_id = id_cod;
RETURN nomecomp;
END$$
DROP FUNCTION nome_comp;
SELECT nome_comp(1) as Nome;

SELECT nome_comp(customer_id) as nome FROM customer;

/*Crie uma função para listas os pagamentos realizados com o valor da comssão de 5% */
SELECT * FROM payment;
DELIMITER $$
CREATE FUNCTION comissao_cincop (id_pag INT)
		RETURNS DECIMAL(9,2)
        DETERMINISTIC
        BEGIN
        DECLARE comissao_cp DECIMAL (5,2);
        SELECT (amount)*0.05 INTO comissao_cp FROM payment WHERE payment_id = id_pag;
        RETURN comissao_cp;
        END$$
        
SELECT comissao_cincop(1);
SELECT *,comissao_cincop(payment_id) FROM payment;

/* Crie uma função para listar os pagametnos com a comissao do gerente, sendo 5% para gerente 1 e 3% para gerente 2 */
DELIMITER $$
CREATE FUNCTION comissao_ger(id_pay INT )
		RETURNS DECIMAL(9,2)
        DETERMINISTIC
        BEGIN
        DECLARE comissao DECIMAL(9,2);
        DECLARE valor DECIMAL(9,2);
        DECLARE gerente INT;
        SELECT staff_id, amount INTO gerente, valor FROM payment WHERE payment_id = id_pay;
        IF gerente = 1 THEN
						SET comissao = valor*0.05;
        ELSE SET comissao = valor *0.03;
        END IF;
        RETURN comissao;
        END$$
        
SELECT *, comissao_ger(payment_id) FROM payment;

/* Crie uma função para listar os pagametnos com a comissao do gerente, sendo 5% para gerente 1 e 3% para gerente 2. O resultado deve sair com o nome do gerente - XXX,XX */
DELIMITER $$
CREATE FUNCTION comissao_ger2(id_pay INT )
		RETURNS VARCHAR(100)
        DETERMINISTIC
        BEGIN
        DECLARE comissao DECIMAL(9,2);
        DECLARE valor DECIMAL(9,2);
        DECLARE gerente INT;
        DECLARE nomeGerente VARCHAR(50);
        SELECT A.staff_id, A.amount, B.first_name INTO gerente, valor, nomeGerente FROM payment A
													INNER JOIN staff B on A.staff_id = B.staff_id
                                                    WHERE payment_id = id_pay;
        IF gerente = 1 THEN
						SET comissao = valor*0.05;
        ELSE 
						SET comissao = valor *0.03;
        END IF;
        RETURN CONCAT(nomeGerente, ' = ', comissao);
        END$$
SELECT *, comissao_ger2(payment_id) FROM payment;

/*Faça uma função para retornar o genero do filme locado pelo cliente*/
SELECT * FROM rental;

DELIMITER $$
CREATE FUNCTION film_gender(id_rental INT )
		RETURNS VARCHAR(100)
        DETERMINISTIC
        BEGIN
        DECLARE genero VARCHAR(30);
        SELECT E.name INTO genero FROM rental A 
						INNER JOIN inventory B on A.inventory_id = B.inventory_id
                        INNER JOIN film C on B.film_id = C.film_id
                        INNER JOIN film_category D on C.film_id = D.film_id
                        INNER JOIN category E on D.category_id = E.category_id
                        WHERE rental_id = id_rental;
		RETURN genero;
END$$

DROP FUNCTION film_gender;

SELECT *,film_gender(rental_id) FROM rental;

-- Crie uma função para calcular um aumento de 20% --
-- Para funcionários acima de 40 anos, caso contrario o aumento será de 10% --


