USE gaseosas_del_valle;


DROP TRIGGER IF EXISTS tr_actualizar_stock;

DELIMITER //

CREATE TRIGGER tr_actualizar_stock
AFTER INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE productos
    SET stock_actual = stock_actual - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
END //

DELIMITER ;



DROP TRIGGER IF EXISTS tr_auditar_cambio_precio;

DELIMITER //

CREATE TRIGGER tr_auditar_cambio_precio
AFTER UPDATE ON productos
FOR EACH ROW
BEGIN
    IF OLD.precio <> NEW.precio THEN
        INSERT INTO auditoria_precios (id_producto, precio_anterior, precio_nuevo, fecha_cambio)
        VALUES (OLD.id_producto, OLD.precio, NEW.precio, NOW());
    END IF;
END //

DELIMITER ;



DROP TRIGGER IF EXISTS tr_validar_stock_antes_pedido;

DELIMITER //

CREATE TRIGGER tr_validar_stock_antes_pedido
BEFORE INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    DECLARE v_stock_actual INT;

    SELECT stock_actual INTO v_stock_actual
    FROM productos
    WHERE id_producto = NEW.id_producto;

    IF v_stock_actual IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El producto indicado no existe.';
    ELSEIF v_stock_actual < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stock insuficiente para completar el pedido.';
    END IF;
END //

DELIMITER ;