--importando as bibliotecas
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

--Variaveis do tipo entrada(in) e sai­da(out)
entity Maquina is
	port(
	M05,M1:					in std_logic_vector(3 downto 0); 	--Direcionando as variaveis para os pinos e visores
	OP:						in std_logic_vector(1 downto 0); 	--Endereco do vetor de 2 pinos para escolha
	LED: 		   			out std_logic_vector(1 downto 0); 	--Vetor que mostra o produto adquirido
	DISPLAY: 				out std_logic_vector(34 downto 0) 	--Separa os visores e segmentos
	);
	end Maquina;
	
--Arquitetura dos sinais usados na maquina
	architecture Opcoes of Maquina is
	
	--Tipos de sinais
	signal primeira_entrada              : integer;
	signal segunda_entrada	           	 : integer;
	signal total_dinheiro   	          : integer;

	begin
	process(primeira_entrada,segunda_entrada,total_dinheiro) --Processando as quantidas de moedas
	
	begin
	--Recebendo as moedas de R$0,50
		case(M05) is
		
			when "0001"	=> primeira_entrada <= 2;
			when "0010"	=> primeira_entrada <= 2;
			when "0100"	=> primeira_entrada <= 2;
			when "1000"	=> primeira_entrada <= 2;
			when "0011"	=> primeira_entrada <= 4;
			when "0111"	=> primeira_entrada <= 6;
			when "1111"	=> primeira_entrada <= 8;
			when "1100"	=> primeira_entrada <= 4;
			when "1110"	=> primeira_entrada <= 6;
			when others => primeira_entrada <= 0;
			
		end case;
		
	--Recebendo as moedas de R$1,00
		case(M1) is
		
			when "0001" =>	segunda_entrada <= 1;
			when "0010"	=> segunda_entrada <= 1;
			when "0100"	=> segunda_entrada <= 1;
			when "1000"	=> segunda_entrada <= 1;
			when "0011"	=> segunda_entrada <= 2;
			when "0111"	=> segunda_entrada <= 3;
			when "1111"	=> segunda_entrada <= 4;
			when "1100"	=> segunda_entrada <= 2;
			when "1110"	=> segunda_entrada <= 3;
			when others => segunda_entrada <= 0;
			
		end case;
		
	--Soma dos valores depositados
	total_dinheiro <= primeira_entrada + segunda_entrada;
	
	end process;
	
	process(total_dinheiro, OP) --Processando os valores depositados pelo usuario
		begin
		
		if(total_dinheiro >= 3 and total_dinheiro < 4) then
		
			LED <= "10"; --Liga o led de "AGUA" se existir o valor de compra
			
			case (OP) is --O sinal em binario de escolha exibe cada segmento dos visores
			
				when "01"   =>   DISPLAY <= "11111110001000100000100000100001000"; --Mostra Agua
				when "10" 	=>	  DISPLAY <= "11111111000000100111010011100000110"; --Mostra "erro" caso exista dinheiro para agua
				when "11" 	=>	  DISPLAY <= "11111111000000100111010011100000110"; --Mostra "erro" caso tente comprar agua e refri, pois so pode comprar uma opcao
				when others =>   DISPLAY <= "11111111111111111111111111111111111"; --Mostra o sinal ligado anulando caso nÃƒÂ£o estiver ligado
				
			end case; 
			
		elsif(total_dinheiro >= 4) then
		
			LED <= "11"; --Liga o led de "REFRI" se existir o valor de compra
			
			case (OP) is  --O sinal em binario de escolha exibe cada segmento dos visores
			
				when "01"   =>   DISPLAY <= "11111110001000100000100000100001000";  --Mostra Agua
				when "10"   =>   DISPLAY <= "10011111001110000111000001101001110";  --Mostra Refri
				when "11" 	=>	  DISPLAY <= "11111111000000100111010011100000110";  --Mostra Erro se o usuario levantar ambos os pinos simultaneamentes
				
				when others =>   DISPLAY <= "11111111111111111111111111111111111";  --Mostra o sinal ligado anulando caso nao estiver ligado
				
			end case;
			
			else
			
				LED <= "00";

		end if;
	end process;
end architecture;
