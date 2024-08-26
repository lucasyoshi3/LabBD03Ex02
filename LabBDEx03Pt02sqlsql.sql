CREATE DATABASE Banco_Lab03

CREATE TABLE Cliente(
	CPF					CHAR(11)			NOT NULL,
	Nome				VARCHAR(100)		NOT NULL,
	Email				VARCHAR(200)		NOT NULL,
	Limite_de_credito	DECIMAL(7,2)		NOT NULL,
	Dt_Nascimento		DATE				NOT NULL
	PRIMARY KEY(CPF)
)

CREATE PROCEDURE sp_validarCpf (@cpf CHAR(11), @valido BIT OUTPUT)
AS
	DECLARE @naoigual BIT, @valido_Pdigito BIT, @valido_Sdigito BIT
	SET @valido = 0
	EXEC sp_verificarIgualdade @cpf, @naoigual OUTPUT
	IF(@naoigual = 1)
	BEGIN
		EXEC sp_primeiroDigito @cpf, @valido_Pdigito OUTPUT
		EXEC sp_segundoDigito  @cpf, @valido_Sdigito OUTPUT
		IF (@valido_Pdigito = 1 AND @valido_Sdigito = 1)
		BEGIN
			SET @valido = 1
		END
	END

CREATE PROCEDURE sp_verificarIgualdade(@cpf CHAR(11), @valido BIT OUTPUT)
AS
	DECLARE @valor1 CHAR(1), @valor2 CHAR(2), @cta INT = 1
	set @valor2 = SUBSTRING(@cpf, 1, 1)
	WHILE(@cta <=11)
	BEGIN
		SET @valor1 = SUBSTRING(@cpf, @cta, 1)
		IF(@valor1 != @valor2)
		BEGIN
			SET @valido = 1;
			SET @cta = 11;
		END
		SET @valor2 = @valor1;
		SET @cta = @cta + 1;
	END

CREATE PROCEDURE sp_primeiroDigito @cpf CHAR(11), @valido_Pdigito BIT OUTPUT
AS
	DECLARE @cta INT = 1, @soma INT = 0, @resto INT,@verificador CHAR(1), @multiplicador INT = 10
	WHILE(@cta < 10)
	BEGIN
		SET @soma = @soma + (SUBSTRING(@cpf, @cta, 1) * @multiplicador)
		SET @cta = @cta + 1
		SET @multiplicador = @multiplicador - 1;
	END
	
	SET @resto = (@soma %11)
	IF(@resto < 2)
	BEGIN
		SET @verificador = '0';
	END
	ELSE
	BEGIN
		SET @verificador = CAST((11 - @resto) AS CHAR(1))
	END

	IF (@verificador = SUBSTRING(@cpf, 10, 1))
	BEGIN
		SET @valido_Pdigito = 1
	END
	ELSE
	BEGIN
		SET @valido_Pdigito = 0
	END


CREATE PROCEDURE sp_segundoDigito @cpf CHAR(11), @valido_Sdigito BIT OUTPUT
AS
	DECLARE @cta INT = 1, @soma INT = 0, @resto INT,@verificador CHAR(1), @multiplicador INT = 11
	WHILE(@cta < 11)
	BEGIN
		SET @soma = @soma + (SUBSTRING(@cpf, @cta, 1) * @multiplicador)
		SET @cta = @cta + 1
		SET @multiplicador = @multiplicador - 1;
	END
	
	SET @resto = (@soma %11)
	IF(@resto < 2)
	BEGIN
		SET @verificador = '0';
	END
	ELSE
	BEGIN
		SET @verificador = CAST((11 - @resto) AS CHAR(1))
	END

	IF (@verificador = SUBSTRING(@cpf, 11, 1))
	BEGIN
		SET @valido_Sdigito = 1
	END
	ELSE
	BEGIN
		SET @valido_Sdigito = 0
	END

CREATE PROCEDURE sp_inserir (@cpf CHAR(11), @nome VARCHAR(100), @email VARCHAR(200), @limite DECIMAL(7,2), @data DATETIME)
AS 
	DECLARE @valido BIT
	EXEC sp_validarCpf @cpf, @valido OUTPUT
	IF(@valido = 1)
	BEGIN 
		INSERT INTO Cliente VALUES (@cpf, @nome, @email, @limite, @data)
	END

CREATE PROCEDURE sp_atualizar(@cpf CHAR(11), @nome VARCHAR(100), @email VARCHAR(200), @limite DECIMAL(7,2), @data DATETIME)
AS 
	IF(@nome IS NOT NULL)
	BEGIN 
		UPDATE Cliente
		SET Nome = @nome
		WHERE CPF = @cpf
	END

	IF(@email IS NOT NULL)
	BEGIN 
		UPDATE Cliente
		SET Email = @email
		WHERE CPF = @cpf
	END

	IF(@limite IS NOT NULL)
	BEGIN 
		UPDATE Cliente
		SET Limite_de_credito = @limite
		WHERE CPF = @cpf
	END
	
	IF(@data IS NOT NULL)
	BEGIN 
		UPDATE Cliente
		SET Dt_Nascimento = @data
		WHERE CPF = @cpf
	END

CREATE PROCEDURE sp_exluir (@cpf CHAR(11))
AS
	DELETE FROM Cliente WHERE CPF = @cpf