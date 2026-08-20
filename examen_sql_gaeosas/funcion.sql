-- EXAMEN

DELIMITER //

CREATE FUNCTION calcular_descuento_cliente (total_pedido INT, tipo_cliente VARCHAR)
RETURNS INTO
READS SQL DATA 
BEGIN
    DECLARE v_total_sin_iva INT;
    DECLARE v_tipo_cliente VARCHAR;

    SELECT total_sin_iva, tipo_cliente INTO v_total_sin_iva, v_tipo_cliente
    FROM pedidos
    WHERE tipo_cliente = p_total_
END//
DELIMITER;