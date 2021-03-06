library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SL2 is 
	port(
		a:  in STD_LOGIC_VECTOR(31 DOWNTO 0);
		y: out STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end SL2;

architecture Behavioral of SL2 is 
begin
	y <= a(29 DOWNTO 0) & "00";
end Behavioral;
