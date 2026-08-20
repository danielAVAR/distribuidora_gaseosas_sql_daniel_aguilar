
DROP FUNCTION IF EXISTS fn_calcular_total_con_iva;

DELIMITER //

CREATE FUNCTION fn_calcular_total_con_iva(p_id_pedido INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total_sin_iva DECIMAL(10,2);

    SELECT SUM(subtotal) INTO v_total_sin_iva
    FROM detalle_pedido
    WHERE id_pedido = p_id_pedido;

    RETURN ROUND(IFNULL(v_total_sin_iva, 0) * 1.19, 2);
END //

DELIMITER ;


DROP FUNCTION IF EXISTS fn_validar_stock;

DELIMITER //

CREATE FUNCTION fn_validar_stock(p_id_producto INT, p_cantidad INT)
RETURNS VARCHAR(150)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_stock_actual INT;
    DECLARE v_nombre VARCHAR(100);

    SELECT stock_actual, nombre INTO v_stock_actual, v_nombre
    FROM productos
    WHERE id_producto = p_id_producto;

    IF v_stock_actual IS NULL THEN
        RETURN 'Producto no encontrado';
    ELSEIF v_stock_actual >= p_cantidad THEN
        RETURN CONCAT('Stock disponible (', v_stock_actual, ' unidades de ', v_nombre, ')');
    ELSE
        RETURN CONCAT('Stock insuficiente. Disponible: ', v_stock_actual, ' unidades de ', v_nombre);
    END IF;
END //

DELIMITER ;

UPDATE pedidos
SET total_sin_iva = (
        SELECT IFNULL(SUM(subtotal), 0)
        FROM detalle_pedido
        WHERE detalle_pedido.id_pedido = pedidos.id_pedido
    ),
    total_con_iva = fn_calcular_total_con_iva(id_pedido);
    
    
    
    
