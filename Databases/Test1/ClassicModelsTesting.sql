/*VJ Davey 
*/
use classicmodels;

SELECT productCode, buyprice from products where productCode='S10_1678';
CALL removeEmployee('S10_1678', .05);
SELECT productCode, buyprice from products where productCode='S10_1678';


DELIMITER //
DROP PROCEDURE IF EXISTS increasePrice//
CREATE PROCEDURE increasePrice (productNum VARCHAR, percentage INT)
BEGIN
	IF (SELECT COUNT(1) FROM products WHERE productCode = productNum) = 0
    THEN
		UPDATE products
		SET buyPrice=(1+percentage) * buyPrice
		WHERE productCode=productNum; 
	END IF;
END//
DELIMITER ;